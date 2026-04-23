/**
 * PiSugarService
 * 
 * Per docs/KIOSK.md:
 * - Polls PiSugar 3 Plus via I2C (address 0x57) every 30 seconds
 * - Maintains in-memory ring buffer of last 30 minutes of readings
 * - Exposes getStatus() (current) and getHistory() (sparkline data)
 * - Controls backlight PWM for screensaver dim/wake
 */

export interface PiSugarStatus {
  batteryLevel: number;
  voltage: number;
  current: number;
  runtime: string;
  charging: boolean;
}

export interface PiSugarReading {
  timestamp: number;
  level: number;
}

class PiSugarService {
  private history: PiSugarReading[] = [];
  private readonly maxHistoryLength = 60; // 30 min at 30s intervals
  private readonly pollInterval = 30000; // 30 seconds
  private intervalId: NodeJS.Timeout | null = null;

  /**
   * Start polling PiSugar for battery status
   */
  startPolling(): void {
    if (this.intervalId) return;

    this.intervalId = setInterval(() => {
      this.poll();
    }, this.pollInterval);

    // Initial poll
    this.poll();
  }

  /**
   * Stop polling
   */
  stopPolling(): void {
    if (this.intervalId) {
      clearInterval(this.intervalId);
      this.intervalId = null;
    }
  }

  /**
   * Poll PiSugar for current status
   */
  private async poll(): Promise<void> {
    // Placeholder - in production, use i2c-bus to read from 0x57
    const reading: PiSugarReading = {
      timestamp: Date.now(),
      level: 75, // Placeholder
    };

    this.history.push(reading);

    // Trim history to max length
    if (this.history.length > this.maxHistoryLength) {
      this.history = this.history.slice(-this.maxHistoryLength);
    }
  }

  /**
   * Get current status
   */
  getStatus(): PiSugarStatus {
    // Placeholder - return mock data
    return {
      batteryLevel: 75,
      voltage: 4.2,
      current: 0.5,
      runtime: '~6.2hrs',
      charging: false,
    };
  }

  /**
   * Get history for sparkline display
   */
  getHistory(): PiSugarReading[] {
    return [...this.history];
  }

  /**
   * Set backlight level (0-100)
   */
  async setBacklight(level: number): Promise<void> {
    // Placeholder - in production, write PWM value via I2C
    console.log(`Backlight set to ${level}%`);
  }
}

// Singleton instance
export const piSugarService = new PiSugarService();
