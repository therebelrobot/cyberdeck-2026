/**
 * Cyberdeck Pi - Main Entry Point
 * 
 * Primary SBC running Linux. Hosts display, receives HID input via USB,
 * interfaces with Meshtastic node via @meshtastic/js over USB serial,
 * and manages LTE network interface.
 */

import { MeshtasticClient } from './meshtastic.js';
import { CellularManager } from './cellular.js';
import { InputManager } from './input.js';
import { DisplayManager } from './display.js';
import type { MeshtasticMessage } from './meshtastic.js';
import type { NetworkStatus } from './cellular.js';

/**
 * Application configuration from environment variables
 */
interface AppConfig {
  meshtasticDevice: string;
  cellularInterface: string;
  inputDevice: string;
  logLevel: 'debug' | 'info' | 'warn' | 'error';
}

function getConfig(): AppConfig {
  return {
    meshtasticDevice: process.env.MESHTASTIC_DEVICE || '/dev/serial/by-id/usb-Meshtastic_Meshtastic_12345678-if00',
    cellularInterface: process.env.CELLULAR_INTERFACE || 'eth1',
    inputDevice: process.env.INPUT_DEVICE || '/dev/input/event0',
    logLevel: (process.env.LOG_LEVEL as AppConfig['logLevel']) || 'info',
  };
}

/**
 * Logging utility with level-based filtering
 */
class Logger {
  private level: AppConfig['logLevel'];
  private levelPriority = { debug: 0, info: 1, warn: 2, error: 3 };

  constructor(level: AppConfig['logLevel']) {
    this.level = level;
  }

  private log(level: AppConfig['logLevel'], message: string, meta?: Record<string, unknown>): void {
    if (this.levelPriority[level] >= this.levelPriority[this.level]) {
      const timestamp = new Date().toISOString();
      const metaStr = meta ? ` ${JSON.stringify(meta)}` : '';
      console.log(`[${timestamp}] [${level.toUpperCase()}] ${message}${metaStr}`);
    }
  }

  debug(message: string, meta?: Record<string, unknown>): void {
    this.log('debug', message, meta);
  }

  info(message: string, meta?: Record<string, unknown>): void {
    this.log('info', message, meta);
  }

  warn(message: string, meta?: Record<string, unknown>): void {
    this.log('warn', message, meta);
  }

  error(message: string, meta?: Record<string, unknown>): void {
    this.log('error', message, meta);
  }
}

/**
 * Main Application Class
 * Manages all subsystem modules and orchestrates startup/shutdown
 */
export class App {
  private logger: Logger;
  private config: AppConfig;
  private meshtastic: MeshtasticClient;
  private cellular: CellularManager;
  private input: InputManager;
  private display: DisplayManager;
  private running: boolean = false;

  constructor(config: AppConfig) {
    this.config = config;
    this.logger = new Logger(config.logLevel);
    this.meshtastic = new MeshtasticClient(config.meshtasticDevice, this.logger);
    this.cellular = new CellularManager(config.cellularInterface, this.logger);
    this.input = new InputManager(config.inputDevice, this.logger);
    this.display = new DisplayManager(this.logger);
  }

  /**
   * Initialize all subsystem modules
   */
  async initialize(): Promise<void> {
    this.logger.info('Initializing Cyberdeck Pi application', {
      meshtasticDevice: this.config.meshtasticDevice,
      cellularInterface: this.config.cellularInterface,
      inputDevice: this.config.inputDevice,
    });

    try {
      // Initialize display first (headless mode if unavailable)
      await this.display.initialize();
      this.logger.info('Display subsystem initialized');

      // Initialize cellular network monitoring
      await this.cellular.initialize();
      this.logger.info('Cellular subsystem initialized');

      // Initialize HID input handling
      await this.input.initialize();
      this.logger.info('Input subsystem initialized');

      // Initialize Meshtastic communication (connect to radio)
      await this.meshtastic.initialize();
      this.logger.info('Meshtastic subsystem initialized');

      this.running = true;
      this.logger.info('All subsystems initialized successfully');
    } catch (error) {
      this.logger.error('Failed to initialize application', {
        error: error instanceof Error ? error.message : String(error),
      });
      throw error;
    }
  }

  /**
   * Start the application and begin normal operation
   */
  async start(): Promise<void> {
    this.logger.info('Starting Cyberdeck Pi application');

    // Set up event handlers for cross-subsystem communication
    this.setupEventHandlers();

    // Start monitoring loops for each subsystem
    this.cellular.startMonitoring();
    this.input.startListening();

    this.logger.info('Application started successfully');
  }

  /**
   * Set up event handlers for cross-subsystem communication
   */
  private setupEventHandlers(): void {
    // Forward Meshtastic messages to display
    this.meshtastic.onMessage((message: MeshtasticMessage) => {
      this.logger.debug('Meshtastic message received', { message });
      this.display.showNotification(`Mesh: ${message.text || 'message'}`);
    });

    // Forward cellular status changes to display
    this.cellular.onStatusChange((status: NetworkStatus) => {
      this.logger.debug('Cellular status changed', { status });
      if (status.connected) {
        this.display.showNotification(`Cellular: Connected (${status.ip})`);
      } else {
        this.display.showNotification('Cellular: Disconnected');
      }
    });

    // Forward input events for display timeout management
    this.input.onActivity(() => {
      this.display.resetIdleTimeout();
    });
  }

  /**
   * Handle graceful shutdown on SIGTERM/SIGINT
   */
  async shutdown(): Promise<void> {
    this.logger.info('Shutting down Cyberdeck Pi application');
    this.running = false;

    try {
      // Shutdown in reverse order of initialization
      await this.meshtastic.shutdown();
      this.logger.info('Meshtastic subsystem shut down');

      await this.input.shutdown();
      this.logger.info('Input subsystem shut down');

      await this.cellular.shutdown();
      this.logger.info('Cellular subsystem shut down');

      await this.display.shutdown();
      this.logger.info('Display subsystem shut down');

      this.logger.info('Application shutdown complete');
    } catch (error) {
      this.logger.error('Error during shutdown', {
        error: error instanceof Error ? error.message : String(error),
      });
    }
  }

  /**
   * Check if application is running
   */
  isRunning(): boolean {
    return this.running;
  }

  /**
   * Get current network status (cellular + Meshtastic link)
   */
  getNetworkStatus(): {
    cellular: { connected: boolean; signalStrength?: number; ip?: string };
    meshtastic: { connected: boolean; nodeCount?: number };
  } {
    return {
      cellular: this.cellular.getCachedStatus(),
      meshtastic: this.meshtastic.getStatus(),
    };
  }
}

/**
 * Bootstrap and start the application
 */
async function main(): Promise<void> {
  const config = getConfig();
  const app = new App(config);

  // Set up signal handlers for graceful shutdown
  const shutdown = async (signal: string): Promise<void> => {
    console.log(`\nReceived ${signal}, shutting down gracefully...`);
    await app.shutdown();
    process.exit(0);
  };

  process.on('SIGTERM', () => shutdown('SIGTERM'));
  process.on('SIGINT', () => shutdown('SIGINT'));

  try {
    await app.initialize();
    await app.start();

    // Keep the process running
    console.log('Application running, press Ctrl+C to stop');
  } catch (error) {
    console.error('Failed to start application:', error);
    process.exit(1);
  }
}

// Export for testing
export { getConfig, Logger };

// Run if this is the main module
main().catch((error) => {
  console.error('Unhandled error:', error);
  process.exit(1);
});