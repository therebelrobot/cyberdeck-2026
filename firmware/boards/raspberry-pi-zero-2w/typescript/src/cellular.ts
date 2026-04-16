/**
 * Cellular Network Manager Module
 * 
 * Monitors LTE dongle network interface status, handles connection state changes,
 * and exposes network status information.
 */

import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

/**
 * Network status returned by getNetworkStatus()
 */
export interface NetworkStatus {
  connected: boolean;
  signalStrength?: number;  // dBm, typical range -50 to -120
  ip?: string;
  interfaceName?: string;
  carrier?: string;
  technology?: string;  // 4G, 5G, LTE, etc.
}

/**
 * Connection state change handler type
 */
export type StatusChangeHandler = (status: NetworkStatus) => void;

/**
 * Cellular interface monitoring configuration
 */
interface CellularConfig {
  interfaceName: string;  // typically eth1, usb0, wwan0
  checkInterval: number;  // milliseconds between status checks
  signalQualityCommand: string;
}

type Logger = {
  debug: (message: string, meta?: Record<string, unknown>) => void;
  info: (message: string, meta?: Record<string, unknown>) => void;
  warn: (message: string, meta?: Record<string, unknown>) => void;
  error: (message: string, meta?: Record<string, unknown>) => void;
};

/**
 * Default configuration for cellular interfaces
 */
const DEFAULT_CONFIG: CellularConfig = {
  interfaceName: 'eth1',
  checkInterval: 30000,  // 30 seconds
  signalQualityCommand: 'mmcli -m 0 --signal-quality',
};

/**
 * CellularManager - Monitors and manages LTE cellular network connection
 */
export class CellularManager {
  private config: CellularConfig;
  private logger: Logger;
  private statusHandlers: StatusChangeHandler[] = [];
  private monitorTimer: ReturnType<typeof setInterval> | null = null;
  private lastStatus: NetworkStatus = { connected: false };
  private isMonitoring: boolean = false;

  constructor(interfaceName: string, logger: Logger) {
    this.logger = logger;
    this.config = {
      ...DEFAULT_CONFIG,
      interfaceName,
    };
  }

  /**
   * Initialize the cellular manager
   */
  async initialize(): Promise<void> {
    this.logger.info('Initializing Cellular manager', {
      interface: this.config.interfaceName,
    });

    try {
      // Check if the interface exists
      const interfaceExists = await this.checkInterfaceExists();
      if (!interfaceExists) {
        this.logger.warn('Cellular interface not found, may not be connected yet', {
          interface: this.config.interfaceName,
        });
      }

      // Get initial status
      const initialStatus = await this.getNetworkStatus();
      this.lastStatus = initialStatus;

      this.logger.info('Cellular manager initialized', { status: initialStatus });
    } catch (error) {
      this.logger.error('Failed to initialize cellular manager', {
        error: error instanceof Error ? error.message : String(error),
      });
      throw error;
    }
  }

  /**
   * Check if the cellular network interface exists
   */
  private async checkInterfaceExists(): Promise<boolean> {
    try {
      const { stdout } = await execAsync(`ip link show ${this.config.interfaceName}`);
      return stdout.includes(this.config.interfaceName);
    } catch {
      return false;
    }
  }

  /**
   * Get network status by checking interface and querying ModemManager
   */
  async getNetworkStatus(): Promise<NetworkStatus> {
    const status: NetworkStatus = {
      connected: false,
      interfaceName: this.config.interfaceName,
    };

    try {
      // Check if interface has an IP address (active connection)
      const ipAddress = await this.getInterfaceIP();
      if (ipAddress) {
        status.connected = true;
        status.ip = ipAddress;
      }

      // Get signal strength from ModemManager
      const signalInfo = await this.getSignalStrength();
      if (signalInfo) {
        status.signalStrength = signalInfo.signal;
        status.carrier = signalInfo.operator;
        status.technology = signalInfo.tech;
      }

      return status;
    } catch (error) {
      this.logger.debug('Error getting network status', {
        error: error instanceof Error ? error.message : String(error),
      });
      return status;
    }
  }

  /**
   * Get IP address assigned to the cellular interface
   */
  private async getInterfaceIP(): Promise<string | null> {
    try {
      const { stdout } = await execAsync(
        `ip -4 addr show ${this.config.interfaceName} | grep "inet " | awk '{print $2}' | cut -d'/' -f1`
      );
      const ip = stdout.trim();
      return ip || null;
    } catch {
      return null;
    }
  }

  /**
   * Get signal strength and carrier info from ModemManager
   */
  private async getSignalStrength(): Promise<{ signal: number; operator?: string; tech?: string } | null> {
    try {
      // Try ModemManager for signal quality
      const { stdout } = await execAsync('mmcli -m 0 --signal-quality 2>/dev/null');

      // Parse signal quality (returns value 0-100)
      const qualityMatch = stdout.match(/quality:\s*'(\d+)'/);
      if (qualityMatch) {
        // Convert quality percentage to approximate dBm
        // Quality 100% ≈ -50 dBm, Quality 0% ≈ -120 dBm
        const quality = parseInt(qualityMatch[1], 10);
        const signal = Math.round(-120 + (quality / 100) * 70);

        return { signal };
      }
    } catch {
      // ModemManager not available or no modem
    }

    // Try alternative: check network registration status
    try {
      const { stdout } = await execAsync('mmcli -m 0 --location 2>/dev/null');
      const operatorMatch = stdout.match(/operator:\s*'([^']+)'/);
      const techMatch = stdout.match(/network\.technology:\s*'([^']+)'/);

      if (operatorMatch || techMatch) {
        return {
          signal: -80, // Default value when we can't get actual signal
          operator: operatorMatch?.[1],
          tech: techMatch?.[1],
        };
      }
    } catch {
      // Not registered on network
    }

    return null;
  }

  /**
   * Start periodic network monitoring
   */
  startMonitoring(): void {
    if (this.isMonitoring) {
      this.logger.warn('Monitoring already started');
      return;
    }

    this.isMonitoring = true;
    this.logger.info('Starting cellular network monitoring', {
      interval: this.config.checkInterval,
    });

    // Initial check
    this.checkAndNotify();

    // Set up periodic checks
    this.monitorTimer = setInterval(() => {
      this.checkAndNotify();
    }, this.config.checkInterval);
  }

  /**
   * Check status and notify handlers if changed
   */
  private async checkAndNotify(): Promise<void> {
    if (!this.isMonitoring) return;

    try {
      const currentStatus = await this.getNetworkStatus();

      // Check if status has changed
      const hasChanged =
        currentStatus.connected !== this.lastStatus.connected ||
        currentStatus.ip !== this.lastStatus.ip ||
        currentStatus.signalStrength !== this.lastStatus.signalStrength;

      if (hasChanged) {
        this.logger.info('Cellular status changed', {
          old: this.lastStatus,
          new: currentStatus,
        });

        this.lastStatus = currentStatus;
        this.notifyHandlers(currentStatus);
      }
    } catch (error) {
      this.logger.error('Error during status check', {
        error: error instanceof Error ? error.message : String(error),
      });
    }
  }

  /**
   * Notify all registered handlers of status change
   */
  private notifyHandlers(status: NetworkStatus): void {
    for (const handler of this.statusHandlers) {
      try {
        handler(status);
      } catch (error) {
        this.logger.error('Error in status change handler', {
          error: error instanceof Error ? error.message : String(error),
        });
      }
    }
  }

  /**
   * Register a handler for connection state changes
   */
  onStatusChange(handler: StatusChangeHandler): void {
    this.statusHandlers.push(handler);
  }

  /**
   * Remove a status change handler
   */
  offStatusChange(handler: StatusChangeHandler): void {
    const index = this.statusHandlers.indexOf(handler);
    if (index > -1) {
      this.statusHandlers.splice(index, 1);
    }
  }

  /**
   * Get current cached network status
   */
  getCachedStatus(): { connected: boolean; signalStrength?: number; ip?: string } {
    return this.lastStatus;
  }

  /**
   * Force a status check and return immediately
   */
  async forceCheck(): Promise<NetworkStatus> {
    const status = await this.getNetworkStatus();
    this.lastStatus = status;
    return status;
  }

  /**
   * Stop network monitoring
   */
  stopMonitoring(): void {
    if (this.monitorTimer) {
      clearInterval(this.monitorTimer);
      this.monitorTimer = null;
    }
    this.isMonitoring = false;
    this.logger.info('Cellular network monitoring stopped');
  }

  /**
   * Shutdown the cellular manager
   */
  async shutdown(): Promise<void> {
    this.logger.info('Shutting down Cellular manager');

    this.stopMonitoring();
    this.statusHandlers = [];

    this.logger.info('Cellular manager shutdown complete');
  }
}