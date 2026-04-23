/**
 * ScreensaverService
 * 
 * Per docs/KIOSK.md:
 * - Tracks last input timestamp
 * - Fires screensaver activate/deactivate events
 * - Configurable idle timeout (default 5 minutes)
 * - Interfaces with PiSugarService for backlight control
 */

type ScreensaverHandler = (active: boolean) => void;

class ScreensaverService {
  private lastInput = Date.now();
  private timeoutMs = 5 * 60 * 1000; // 5 minutes default
  private intervalId: NodeJS.Timeout | null = null;
  private handler: ScreensaverHandler | null = null;
  private active = false;

  /**
   * Start screensaver monitoring
   */
  start(): void {
    if (this.intervalId) return;

    this.intervalId = setInterval(() => {
      this.check();
    }, 1000);
  }

  /**
   * Stop screensaver monitoring
   */
  stop(): void {
    if (this.intervalId) {
      clearInterval(this.intervalId);
      this.intervalId = null;
    }
  }

  /**
   * Record user input (resets idle timer)
   */
  recordInput(): void {
    this.lastInput = Date.now();

    if (this.active) {
      this.active = false;
      this.handler?.(false);
    }
  }

  /**
   * Set idle timeout
   */
  setTimeout(ms: number): void {
    this.timeoutMs = ms;
  }

  /**
   * Set handler for screensaver state changes
   */
  onStateChange(handler: ScreensaverHandler): void {
    this.handler = handler;
  }

  /**
   * Check if screensaver should activate
   */
  private check(): void {
    const elapsed = Date.now() - this.lastInput;

    if (!this.active && elapsed >= this.timeoutMs) {
      this.active = true;
      this.handler?.(true);
    }
  }

  /**
   * Check if screensaver is currently active
   */
  isActive(): boolean {
    return this.active;
  }
}

// Singleton instance
export const screensaverService = new ScreensaverService();
