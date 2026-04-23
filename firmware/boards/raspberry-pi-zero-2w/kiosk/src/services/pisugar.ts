/**
 * PiSugarService — POWER-ONLY MODE
 * 
 * The PiSugar 3 Plus is connected via pogo pins for power delivery only.
 * I2C communication (0x57 battery, 0x68 RTC) is unavailable because the
 * Waveshare DPI display overlay claims GPIO2/GPIO3 for display data lines,
 * and the PiSugar's pogo pins hard-wire I2C to those same GPIOs.
 * 
 * What works:
 * - 5V power delivery to the Pi
 * - USB-C charging passthrough
 * - Physical power button
 * 
 * What does NOT work (without hardware mod):
 * - Battery level / voltage / current readings
 * - Charging status detection
 * - RTC (0x68)
 * 
 * To restore full I2C functionality:
 * Solder jumper wires from PiSugar SDA/SCL pads to GPIO10 (pin 19) /
 * GPIO11 (pin 23) — the bit-banged I2C bus created by the DPI overlay.
 * Then set powerOnly = false below.
 * 
 * Backlight Notes:
 * - The DPI overlay registers GPIO18 as a kernel gpio-backlight device
 *   (on/off only, NOT PWM). Control via /sys/class/backlight/ sysfs.
 * - For screensaver: write "0" to brightness to turn off, write
 *   max_brightness value to turn on.
 * - Do NOT use wiringPi or direct GPIO PWM on GPIO18.
 */

export interface PiSugarStatus {
  batteryLevel: number;
  voltage: number;
  current: number;
  runtime: string;
  charging: boolean;
  powerOnly: boolean;
}

export interface PiSugarReading {
  timestamp: number;
  level: number;
}

class PiSugarService {
  private history: PiSugarReading[] = [];
  private readonly maxHistoryLength = 60; // 30 min at 30s intervals
  private readonly pollInterval = 30000; // 30 seconds
  private intervalId: ReturnType<typeof setInterval> | null = null;

  /**
   * Power-only mode flag. When true, I2C polling is disabled and
   * getStatus() returns unknown values. Set to false after wiring
   * PiSugar I2C to GPIO10/GPIO11.
   */
  private readonly powerOnly = true;

  /**
   * Start polling PiSugar for battery status.
   * No-op in power-only mode.
   */
  startPolling(): void {
    if (this.powerOnly) {
      console.log('[PiSugar] Power-only mode — I2C polling disabled');
      return;
    }

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
    if (this.powerOnly) return;

    // TODO: When I2C is wired to GPIO10/11, use i2c-bus to read from 0x57
    // on the bit-banged bus (auto-detect bus number from /dev/i2c-*)
    const reading: PiSugarReading = {
      timestamp: Date.now(),
      level: -1,
    };

    this.history.push(reading);

    if (this.history.length > this.maxHistoryLength) {
      this.history = this.history.slice(-this.maxHistoryLength);
    }
  }

  /**
   * Get current status.
   * Returns unknown values (-1) in power-only mode.
   */
  getStatus(): PiSugarStatus {
    return {
      batteryLevel: -1,
      voltage: -1,
      current: -1,
      runtime: 'unknown',
      charging: false,
      powerOnly: this.powerOnly,
    };
  }

  /**
   * Get history for sparkline display.
   * Empty in power-only mode.
   */
  getHistory(): PiSugarReading[] {
    return [...this.history];
  }

  /**
   * Set backlight on/off.
   * 
   * The DPI overlay registers GPIO18 as a gpio-backlight device (on/off only).
   * Control via sysfs: /sys/class/backlight/<device>/brightness
   *   - Write "0" to turn off
   *   - Write max_brightness value to turn on
   * 
   * Note: This is binary on/off, NOT dimmable PWM. Any level > 0 = on.
   */
  async setBacklight(level: number): Promise<void> {
    // Placeholder - in production:
    // import { readFileSync, writeFileSync, readdirSync } from 'fs';
    // const blPath = '/sys/class/backlight';
    // const device = readdirSync(blPath)[0];
    // const brightness = level > 0 ? readFileSync(`${blPath}/${device}/max_brightness`, 'utf8').trim() : '0';
    // writeFileSync(`${blPath}/${device}/brightness`, brightness);
    console.log(`[PiSugar] Backlight ${level > 0 ? 'on' : 'off'} (requested: ${level}%)`);
  }
}

// Singleton instance
export const piSugarService = new PiSugarService();
