/**
 * CellularService
 * 
 * Per docs/KIOSK.md:
 * - Monitors LTE dongle connection state
 * - Triggers VaultSyncService on connect/disconnect
 * - Exposes toggle(), getStatus(), getSignal()
 */

export interface CellularStatus {
  connected: boolean;
  signal: number | null;
  operator: string | null;
}

class CellularService {
  private enabled = false;
  private status: CellularStatus = {
    connected: false,
    signal: null,
    operator: null,
  };

  /**
   * Toggle cellular on/off
   */
  async toggle(): Promise<boolean> {
    this.enabled = !this.enabled;
    // Placeholder - in production, use ModemManager or AT commands
    console.log(`Cellular ${this.enabled ? 'enabled' : 'disabled'}`);
    return this.enabled;
  }

  /**
   * Get connection status
   */
  getStatus(): CellularStatus {
    return { ...this.status };
  }

  /**
   * Get signal strength (0-100)
   */
  getSignal(): number | null {
    return this.status.signal;
  }
}

// Singleton instance
export const cellularService = new CellularService();
