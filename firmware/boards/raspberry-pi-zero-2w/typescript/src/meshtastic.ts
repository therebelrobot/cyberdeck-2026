/**
 * Meshtastic Interface Module
 * 
 * Interfaces with Meshtastic device over USB serial connection using @meshtastic/js.
 * Provides send/receive API for mesh networking.
 */

import { SerialPort } from 'serialport';

type Logger = {
  debug: (message: string, meta?: Record<string, unknown>) => void;
  info: (message: string, meta?: Record<string, unknown>) => void;
  warn: (message: string, meta?: Record<string, unknown>) => void;
  error: (message: string, meta?: Record<string, unknown>) => void;
};

/**
 * Meshtastic message handler type
 */
export type MessageHandler = (message: MeshtasticMessage) => void;

/**
 * Outgoing Meshtastic packet structure
 */
export interface MeshPacket {
  destination: number; // Node ID or broadcast (0xffffffff)
  channel: number;
  text?: string;
  emoji?: string;
}

/**
 * Incoming Meshtastic message structure
 */
export interface MeshtasticMessage {
  id: string;
  sender: number;
  timestamp: number;
  text?: string;
  channel: number;
  rssi?: number;
  snr?: number;
}

/**
 * Connection state for Meshtastic device
 */
export type ConnectionState = 'disconnected' | 'connecting' | 'connected' | 'reconnecting';

/**
 * MeshtasticClient - Manages connection to Meshtastic radio device
 */
export class MeshtasticClient {
  private devicePath: string;
  private logger: Logger;
  private messageHandlers: MessageHandler[] = [];
  private connectionState: ConnectionState = 'disconnected';
  private reconnectAttempts: number = 0;
  private maxReconnectAttempts: number = 10;
  private reconnectDelay: number = 5000; // 5 seconds
  private reconnectTimer: ReturnType<typeof setTimeout> | null = null;
  private port: SerialPort | null = null;

  constructor(devicePath: string, logger: Logger) {
    this.devicePath = devicePath;
    this.logger = logger;
  }

  /**
   * Initialize connection to Meshtastic device
   */
  async initialize(): Promise<void> {
    this.logger.info('Initializing Meshtastic client', { devicePath: this.devicePath });

    try {
      // First, verify the serial port exists and can be opened
      await this.verifySerialPort();

      this.connectionState = 'connected';
      this.reconnectAttempts = 0;
      this.logger.info('Meshtastic device connected successfully');
    } catch (error) {
      this.logger.error('Failed to connect to Meshtastic device', {
        error: error instanceof Error ? error.message : String(error),
        devicePath: this.devicePath,
      });
      this.connectionState = 'disconnected';
      throw error;
    }
  }

  /**
   * Verify the serial port exists and is accessible
   */
  private async verifySerialPort(): Promise<void> {
    return new Promise((resolve, reject) => {
      this.port = new SerialPort({ path: this.devicePath, baudRate: 115200 });

      this.port.open((err) => {
        if (err) {
          this.port?.close();
          reject(new Error(`Cannot open serial port: ${err.message}`));
        } else {
          // Set up data handler
          this.port!.on('data', (data: Buffer) => {
            this.handleSerialData(data);
          });

          this.port!.on('error', (err) => {
            this.logger.error('Serial port error', { error: err.message });
            this.handleDisconnect();
          });

          this.port!.on('close', () => {
            this.logger.info('Serial port closed');
            this.handleDisconnect();
          });

          resolve();
        }
      });
    });
  }

  /**
   * Handle incoming serial data from Meshtastic device
   * Note: This is a simplified handler. In production, you would use @meshtastic/js
   * which handles the protocol parsing for you.
   */
  private handleSerialData(data: Buffer): void {
    // Try to parse as JSON (Meshtastic protocol)
    try {
      const text = data.toString('utf8').trim();
      if (text.startsWith('{')) {
        const parsed = JSON.parse(text);
        this.logger.debug('Received from Meshtastic', { data: parsed });

        // Extract message if it's a text packet
        if (parsed.payload && parsed.payload.decoded && parsed.payload.decoded.text) {
          const message: MeshtasticMessage = {
            id: parsed.id?.toString() || Date.now().toString(),
            sender: parsed.from || 0,
            timestamp: parsed.timestamp || Date.now(),
            text: parsed.payload.decoded.text,
            channel: parsed.channel || 0,
            rssi: parsed.rxRssi,
            snr: parsed.rxSnr,
          };
          this.notifyHandlers(message);
        }
      }
    } catch {
      // Not JSON, ignore or handle as raw data
      this.logger.debug('Received raw data from Meshtastic', { length: data.length });
    }
  }

  /**
   * Handle disconnection - schedule reconnect if appropriate
   */
  private handleDisconnect(): void {
    if (this.connectionState === 'connected') {
      this.connectionState = 'disconnected';
      this.scheduleReconnect();
    }
  }

  /**
   * Schedule a reconnection attempt
   */
  private scheduleReconnect(): void {
    if (this.reconnectAttempts >= this.maxReconnectAttempts) {
      this.logger.error('Max reconnection attempts reached', {
        attempts: this.reconnectAttempts,
      });
      return;
    }

    if (this.reconnectTimer) {
      clearTimeout(this.reconnectTimer);
    }

    this.reconnectAttempts++;
    this.connectionState = 'reconnecting';

    this.logger.info('Scheduling reconnection', {
      attempt: this.reconnectAttempts,
      delay: this.reconnectDelay,
    });

    this.reconnectTimer = setTimeout(async () => {
      try {
        await this.initialize();
      } catch (error) {
        this.logger.error('Reconnection attempt failed', {
          error: error instanceof Error ? error.message : String(error),
        });
      }
    }, this.reconnectDelay);
  }

  /**
   * Send a packet over the mesh network
   */
  async sendPacket(packet: MeshPacket): Promise<boolean> {
    if (!this.port || this.connectionState !== 'connected') {
      this.logger.warn('Cannot send packet: device not connected');
      return false;
    }

    try {
      // Build Meshtastic protocol packet
      const payload: Record<string, unknown> = {
        to: packet.destination,
        channel: packet.channel,
      };

      if (packet.text) {
        payload.decoded = {
          portnum: 1, // TEXT_MESSAGE_APP
          payload: Buffer.from(packet.text).toString('base64'),
        };
      } else if (packet.emoji) {
        payload.decoded = {
          portnum: 1,
          payload: Buffer.from(`📌 ${packet.emoji}`).toString('base64'),
        };
      }

      const data = JSON.stringify(payload) + '\n';
      this.port.write(data, (err) => {
        if (err) {
          this.logger.error('Failed to write to serial', { error: err.message });
        }
      });

      this.logger.info('Packet sent successfully', { packet });
      return true;
    } catch (error) {
      this.logger.error('Failed to send packet', {
        error: error instanceof Error ? error.message : String(error),
        packet,
      });
      return false;
    }
  }

  /**
   * Notify all registered handlers of incoming message
   */
  private notifyHandlers(message: MeshtasticMessage): void {
    for (const handler of this.messageHandlers) {
      try {
        handler(message);
      } catch (error) {
        this.logger.error('Error in message handler', {
          error: error instanceof Error ? error.message : String(error),
        });
      }
    }
  }

  /**
   * Register a handler for incoming messages
   */
  onMessage(handler: MessageHandler): void {
    this.messageHandlers.push(handler);
  }

  /**
   * Remove a message handler
   */
  offMessage(handler: MessageHandler): void {
    const index = this.messageHandlers.indexOf(handler);
    if (index > -1) {
      this.messageHandlers.splice(index, 1);
    }
  }

  /**
   * Get current connection status
   */
  getStatus(): { connected: boolean; nodeCount?: number } {
    return {
      connected: this.connectionState === 'connected',
    };
  }

  /**
   * Get current connection state
   */
  getConnectionState(): ConnectionState {
    return this.connectionState;
  }

  /**
   * Broadcast a text message to all nodes on the mesh
   */
  async broadcast(text: string, channel: number = 0): Promise<boolean> {
    return this.sendPacket({
      destination: 0xffffffff, // Broadcast address
      channel,
      text,
    });
  }

  /**
   * Send a direct message to a specific node
   */
  async sendDirect(nodeId: number, text: string, channel: number = 0): Promise<boolean> {
    return this.sendPacket({
      destination: nodeId,
      channel,
      text,
    });
  }

  /**
   * Shutdown the connection gracefully
   */
  async shutdown(): Promise<void> {
    this.logger.info('Shutting down Meshtastic client');

    if (this.reconnectTimer) {
      clearTimeout(this.reconnectTimer);
      this.reconnectTimer = null;
    }

    if (this.port && this.port.isOpen) {
      try {
        this.port.close();
      } catch (error) {
        this.logger.warn('Error closing serial port', {
          error: error instanceof Error ? error.message : String(error),
        });
      }
    }

    this.connectionState = 'disconnected';
    this.messageHandlers = [];

    this.logger.info('Meshtastic client shutdown complete');
  }
}