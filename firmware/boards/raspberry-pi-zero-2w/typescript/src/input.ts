/**
 * Input Manager Module
 * 
 * Listens for HID events from XIAO SAMD21 HID bridge connected via USB.
 * Parses keyboard and mouse events for cyberdeck control.
 */

import { EventEmitter } from 'events';
import { spawn } from 'child_process';

type Logger = {
  debug: (message: string, meta?: Record<string, unknown>) => void;
  info: (message: string, meta?: Record<string, unknown>) => void;
  warn: (message: string, meta?: Record<string, unknown>) => void;
  error: (message: string, meta?: Record<string, unknown>) => void;
};

/**
 * HID event types
 */
export enum InputEventType {
  KEY_DOWN = 'key_down',
  KEY_UP = 'key_up',
  MOUSE_MOVE = 'mouse_move',
  MOUSE_BUTTON_DOWN = 'mouse_button_down',
  MOUSE_BUTTON_UP = 'mouse_button_up',
  MOUSE_WHEEL = 'mouse_wheel',
}

/**
 * Keyboard event
 */
export interface KeyEvent {
  type: InputEventType.KEY_DOWN | InputEventType.KEY_UP;
  code: number;      // Raw HID key code
  key?: string;      // Interpreted key name
  modifiers: {
    ctrl: boolean;
    alt: boolean;
    shift: boolean;
    meta: boolean;
  };
  timestamp: number;
}

/**
 * Mouse move event
 */
export interface MouseMoveEvent {
  type: InputEventType.MOUSE_MOVE;
  x: number;
  y: number;
  timestamp: number;
}

/**
 * Mouse button event
 */
export interface MouseButtonEvent {
  type: InputEventType.MOUSE_BUTTON_DOWN | InputEventType.MOUSE_BUTTON_UP;
  button: number;    // 0=left, 1=middle, 2=right
  pressed: boolean;
  timestamp: number;
}

/**
 * Mouse wheel event
 */
export interface MouseWheelEvent {
  type: InputEventType.MOUSE_WHEEL;
  deltaX: number;
  deltaY: number;
  timestamp: number;
}

/**
 * Union type for all input events
 */
export type InputEvent = KeyEvent | MouseMoveEvent | MouseButtonEvent | MouseWheelEvent;

/**
 * Activity handler type (called on any input)
 */
export type ActivityHandler = () => void;

/**
 * Input event handler type
 */
export type InputEventHandler = (event: InputEvent) => void;

/**
 * EVDEV event type constants (from linux/input.h)
 */
const EVDEV_EV_KEY = 0x01;
const EVDEV_EV_REL = 0x02;

/**
 * EVDEV key codes for common keys
 */
const EVDEV_KEY = {
  KEY_ENTER: 28,
  KEY_ESC: 1,
  KEY_BACKSPACE: 14,
  KEY_TAB: 15,
  KEY_SPACE: 57,
  KEY_LEFTCTRL: 29,
  KEY_LEFTSHIFT: 42,
  KEY_LEFTALT: 56,
  KEY_LEFTMETA: 125,
  KEY_RIGHTCTRL: 97,
  KEY_RIGHTSHIFT: 54,
  KEY_RIGHTALT: 100,
  KEY_RIGHTMETA: 126,
  KEY_UP: 103,
  KEY_DOWN: 108,
  KEY_LEFT: 105,
  KEY_RIGHT: 106,
  KEY_HOME: 102,
  KEY_END: 107,
  KEY_PAGEUP: 104,
  KEY_PAGEDOWN: 109,
  // Function keys
  KEY_F1: 59,
  KEY_F2: 60,
  KEY_F3: 61,
  KEY_F4: 62,
  KEY_F5: 63,
  KEY_F6: 64,
  KEY_F7: 65,
  KEY_F8: 66,
  KEY_F9: 67,
  KEY_F10: 68,
  KEY_F11: 87,
  KEY_F12: 88,
};

/**
 * Key code to string mapping
 */
const KEY_NAMES: Record<number, string> = {
  [EVDEV_KEY.KEY_ENTER]: 'Enter',
  [EVDEV_KEY.KEY_ESC]: 'Escape',
  [EVDEV_KEY.KEY_BACKSPACE]: 'Backspace',
  [EVDEV_KEY.KEY_TAB]: 'Tab',
  [EVDEV_KEY.KEY_SPACE]: 'Space',
  [EVDEV_KEY.KEY_UP]: 'ArrowUp',
  [EVDEV_KEY.KEY_DOWN]: 'ArrowDown',
  [EVDEV_KEY.KEY_LEFT]: 'ArrowLeft',
  [EVDEV_KEY.KEY_RIGHT]: 'ArrowRight',
  [EVDEV_KEY.KEY_HOME]: 'Home',
  [EVDEV_KEY.KEY_END]: 'End',
  [EVDEV_KEY.KEY_PAGEUP]: 'PageUp',
  [EVDEV_KEY.KEY_PAGEDOWN]: 'PageDown',
};

/**
 * Input device configuration
 */
interface InputConfig {
  devicePath: string;
  enableKeyboard: boolean;
  enableMouse: boolean;
  mouseSensitivity: number;
}

/**
 * InputManager - Handles HID input events from connected devices
 */
export class InputManager extends EventEmitter {
  private config: InputConfig;
  private logger: Logger;
  private inputHandlers: InputEventHandler[] = [];
  private activityHandlers: ActivityHandler[] = [];
  private isListening: boolean = false;
  private evtestProcess: ReturnType<typeof spawn> | null = null;

  // State for tracking modifier keys
  private modifierState = {
    ctrl: false,
    alt: false,
    shift: false,
    meta: false,
  };

  // Mouse state
  private mouseState = {
    x: 0,
    y: 0,
    buttons: 0,
  };

  constructor(devicePath: string, logger: Logger) {
    super();
    this.logger = logger;
    this.config = {
      devicePath,
      enableKeyboard: true,
      enableMouse: true,
      mouseSensitivity: 1.0,
    };
  }

  /**
   * Initialize the input manager
   */
  async initialize(): Promise<void> {
    this.logger.info('Initializing Input manager', {
      devicePath: this.config.devicePath,
    });

    try {
      // Check if input device exists
      const deviceExists = await this.checkDeviceExists();
      if (!deviceExists) {
        this.logger.warn('Input device not found', {
          devicePath: this.config.devicePath,
        });
        // Don't throw - device may appear later
      }

      this.logger.info('Input manager initialized');
    } catch (error) {
      this.logger.error('Failed to initialize input manager', {
        error: error instanceof Error ? error.message : String(error),
      });
      throw error;
    }
  }

  /**
   * Check if the input device exists
   */
  private async checkDeviceExists(): Promise<boolean> {
    const fs = await import('fs');
    try {
      await fs.promises.access(this.config.devicePath);
      return true;
    } catch {
      return false;
    }
  }

  /**
   * Start listening for HID events
   */
  startListening(): void {
    if (this.isListening) {
      this.logger.warn('Already listening for input events');
      return;
    }

    this.isListening = true;
    this.logger.info('Starting input event listening');

    // Start reading from input device using evtest
    this.startEvtestProcess();
  }

  /**
   * Start evtest process to read input events
   */
  private startEvtestProcess(): void {
    try {
      this.evtestProcess = spawn('evtest', [this.config.devicePath], {
        stdio: ['ignore', 'pipe', 'pipe'],
      });

      this.evtestProcess.stdout?.on('data', (data: Buffer) => {
        this.parseEvtestOutput(data.toString());
      });

      this.evtestProcess.stderr?.on('data', (data: Buffer) => {
        this.logger.debug('evtest stderr', { output: data.toString() });
      });

      this.evtestProcess.on('error', (error: Error) => {
        this.logger.error('evtest process error', {
          error: error.message,
        });
        // Fall back to polling method
        this.startEventFilePolling();
      });

      this.evtestProcess.on('close', (code: number | null) => {
        if (code !== 0 && this.isListening) {
          this.logger.warn('evtest exited, attempting restart');
          setTimeout(() => this.startEvtestProcess(), 5000);
        }
      });
    } catch (error) {
      this.logger.error('Failed to start evtest', {
        error: error instanceof Error ? error.message : String(error),
      });
      // Fall back to polling
      this.startEventFilePolling();
    }
  }

  /**
   * Poll the event file directly as fallback
   */
  private async startEventFilePolling(): Promise<void> {
    const fs = await import('fs');

    try {
      let fd: number | null = null;

      const pollEvents = async (): Promise<void> => {
        try {
          if (fd === null) {
            fd = fs.openSync(this.config.devicePath, 'r');
          }

          const eventSize = 24; // struct input_event size
          const buffer = Buffer.alloc(eventSize);
          const bytesRead = fs.readSync(fd, buffer, 0, eventSize, null);

          if (bytesRead === eventSize) {
            this.parseEventPacket(buffer);
          }
        } catch (err) {
          this.logger.debug('Event read error', {
            error: err instanceof Error ? err.message : String(err),
          });
        }
      };

      // Poll every 10ms
      setInterval(pollEvents, 10);
    } catch (error) {
      this.logger.error('Failed to start event file polling', {
        error: error instanceof Error ? error.message : String(error),
      });
    }
  }

  /**
   * Parse evtest-style output
   */
  private parseEvtestOutput(output: string): void {
    const lines = output.split('\n');

    for (const line of lines) {
      // Parse [timestamp] event-type event-code value format
      const match = line.match(/\[\s*([\d.]+)\]\s*(\w+)\s+(\w+)\s+:\s*(\d+)/);
      if (!match) continue;

      const [, timestamp, typeStr, codeStr, valueStr] = match;
      const type = parseInt(typeStr);
      const code = parseInt(codeStr);
      const value = parseInt(valueStr);

      // Skip sync events
      if (type === 0) continue;

      const timestampMs = parseFloat(timestamp) * 1000;

      if (type === EVDEV_EV_KEY) {
        const event: KeyEvent = {
          type: value === 1 ? InputEventType.KEY_DOWN : InputEventType.KEY_UP,
          code,
          key: KEY_NAMES[code] || `Key${code}`,
          modifiers: { ...this.modifierState },
          timestamp: timestampMs,
        };
        this.handleKeyEvent(code, value, event);
      } else if (type === EVDEV_EV_REL) {
        const event: MouseMoveEvent = {
          type: InputEventType.MOUSE_MOVE,
          x: code === 0 ? value * this.config.mouseSensitivity : this.mouseState.x,
          y: code === 1 ? value * this.config.mouseSensitivity : this.mouseState.y,
          timestamp: timestampMs,
        };
        this.handleMouseEvent(code, value, event);
      }
    }
  }

  /**
   * Parse a binary event packet
   */
  private parseEventPacket(buffer: Buffer): void {
    // struct input_event {
    //   struct timeval time;  // 8 bytes (2 x 32-bit)
    //   __u16 type;          // 2 bytes
    //   __u16 code;          // 2 bytes
    //   __s32 value;         // 4 bytes
    // };

    const tvSec = buffer.readUInt32LE(0);
    const tvUsec = buffer.readUInt32LE(8);
    const type = buffer.readUInt16LE(16);
    const code = buffer.readUInt16LE(18);
    const value = buffer.readInt32LE(20);

    const timestamp = tvSec * 1000 + tvUsec / 1000;

    if (type === EVDEV_EV_KEY) {
      const event: KeyEvent = {
        type: value === 1 ? InputEventType.KEY_DOWN : InputEventType.KEY_UP,
        code,
        key: KEY_NAMES[code] || `Key${code}`,
        modifiers: { ...this.modifierState },
        timestamp,
      };
      this.handleKeyEvent(code, value, event);
    } else if (type === EVDEV_EV_REL) {
      // Update mouse position
      if (code === 0) { // REL_X
        this.mouseState.x += value * this.config.mouseSensitivity;
      } else if (code === 1) { // REL_Y
        this.mouseState.y += value * this.config.mouseSensitivity;
      }

      const event: MouseMoveEvent = {
        type: InputEventType.MOUSE_MOVE,
        x: this.mouseState.x,
        y: this.mouseState.y,
        timestamp,
      };
      this.handleMouseEvent(code, value, event);
    }
  }

  /**
   * Handle keyboard events
   */
  private handleKeyEvent(code: number, value: number, event: KeyEvent): void {
    // Update modifier state
    switch (code) {
      case EVDEV_KEY.KEY_LEFTCTRL:
      case EVDEV_KEY.KEY_RIGHTCTRL:
        this.modifierState.ctrl = value === 1;
        break;
      case EVDEV_KEY.KEY_LEFTSHIFT:
      case EVDEV_KEY.KEY_RIGHTSHIFT:
        this.modifierState.shift = value === 1;
        break;
      case EVDEV_KEY.KEY_LEFTALT:
      case EVDEV_KEY.KEY_RIGHTALT:
        this.modifierState.alt = value === 1;
        break;
      case EVDEV_KEY.KEY_LEFTMETA:
      case EVDEV_KEY.KEY_RIGHTMETA:
        this.modifierState.meta = value === 1;
        break;
    }

    // Notify activity
    if (value === 1) {
      this.notifyActivity();
    }

    // Update event with current modifier state
    event.modifiers = { ...this.modifierState };

    // Notify event handlers
    for (const handler of this.inputHandlers) {
      try {
        handler(event);
      } catch (error) {
        this.logger.error('Error in input handler', {
          error: error instanceof Error ? error.message : String(error),
        });
      }
    }
  }

  /**
   * Handle mouse events
   */
  private handleMouseEvent(code: number, value: number, event: MouseMoveEvent): void {
    // Notify activity
    this.notifyActivity();

    // Notify event handlers
    for (const handler of this.inputHandlers) {
      try {
        handler(event);
      } catch (error) {
        this.logger.error('Error in mouse handler', {
          error: error instanceof Error ? error.message : String(error),
        });
      }
    }
  }

  /**
   * Notify all activity handlers
   */
  private notifyActivity(): void {
    for (const handler of this.activityHandlers) {
      try {
        handler();
      } catch (error) {
        this.logger.error('Error in activity handler', {
          error: error instanceof Error ? error.message : String(error),
        });
      }
    }
  }

  /**
   * Register handler for input events
   */
  onInput(handler: InputEventHandler): void {
    this.inputHandlers.push(handler);
  }

  /**
   * Remove input event handler
   */
  offInput(handler: InputEventHandler): void {
    const index = this.inputHandlers.indexOf(handler);
    if (index > -1) {
      this.inputHandlers.splice(index, 1);
    }
  }

  /**
   * Register handler for any input activity
   */
  onActivity(handler: ActivityHandler): void {
    this.activityHandlers.push(handler);
  }

  /**
   * Remove activity handler
   */
  offActivity(handler: ActivityHandler): void {
    const index = this.activityHandlers.indexOf(handler);
    if (index > -1) {
      this.activityHandlers.splice(index, 1);
    }
  }

  /**
   * Stop listening for input events
   */
  stopListening(): void {
    if (this.evtestProcess) {
      this.evtestProcess.kill();
      this.evtestProcess = null;
    }
    this.isListening = false;
    this.logger.info('Input event listening stopped');
  }

  /**
   * Shutdown the input manager
   */
  async shutdown(): Promise<void> {
    this.logger.info('Shutting down Input manager');

    this.stopListening();
    this.inputHandlers = [];
    this.activityHandlers = [];
    this.removeAllListeners();

    this.logger.info('Input manager shutdown complete');
  }
}