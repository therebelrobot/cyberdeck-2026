/**
 * MeshtasticService
 * 
 * Per docs/KIOSK.md:
 * - Maintains @meshtastic/js serial connection to XIAO ESP32-S3
 * - Emits events consumed by WebSocket handler
 * - Writes incoming messages to ~/mesh-log/YYYY-MM-DD.md
 * - Exposes send(message) and getHistory(limit) methods
 */

import type { MeshMessage } from './types';

class MeshtasticService {
  private connected = false;
  private messageHandler: ((msg: MeshMessage) => void) | null = null;

  /**
   * Connect to Meshtastic device via serial
   */
  async connect(): Promise<void> {
    // Placeholder - in production, use @meshtastic/js
    this.connected = true;
    console.log('Meshtastic connected');
  }

  /**
   * Disconnect from Meshtastic device
   */
  disconnect(): void {
    this.connected = false;
    console.log('Meshtastic disconnected');
  }

  /**
   * Check if connected
   */
  isConnected(): boolean {
    return this.connected;
  }

  /**
   * Send a message
   */
  async send(text: string, channel = 'base'): Promise<void> {
    if (!this.connected) {
      throw new Error('Not connected to Meshtastic');
    }
    // Placeholder - in production, use @meshtastic/js sendText()
    console.log(`Sending to ${channel}: ${text}`);
  }

  /**
   * Get message history
   */
  async getHistory(limit = 50): Promise<MeshMessage[]> {
    // Placeholder - in production, read from service state
    return [];
  }

  /**
   * Get connected nodes
   */
  async getNodes(): Promise<Array<{
    id: string;
    name: string;
    signal: number;
    lat?: number;
    lon?: number;
  }>> {
    // Placeholder - in production, query @meshtastic/js
    return [];
  }

  /**
   * Set message handler for incoming messages
   */
  onMessage(handler: (msg: MeshMessage) => void): void {
    this.messageHandler = handler;
  }

  /**
   * Remove message handler
   */
  offMessage(): void {
    this.messageHandler = null;
  }
}

// Singleton instance
export const meshtasticService = new MeshtasticService();
