package main

import (
	"machine"
	"time"
)

// HID Key codes for keyboard events
const (
	KeyNone       = 0x00
	KeyErrorRoll  = 0x01
	KeyA         = 0x04
	KeyB         = 0x05
	KeyC         = 0x06
	KeyD         = 0x07
	KeyE         = 0x08
	KeyF         = 0x09
	KeyG         = 0x0A
	KeyH         = 0x0B
	KeyI         = 0x0C
	KeyJ         = 0x0D
	KeyK         = 0x0E
	KeyL         = 0x0F
	KeyM         = 0x10
	KeyN         = 0x11
	KeyO         = 0x12
	KeyP         = 0x13
	KeyQ         = 0x14
	KeyR         = 0x15
	KeyS         = 0x16
	KeyT         = 0x17
	KeyU         = 0x18
	KeyV         = 0x19
	KeyW         = 0x1A
	KeyX         = 0x1B
	KeyY         = 0x1C
	KeyZ         = 0x1D
	Key1         = 0x1E
	Key2         = 0x1F
	Key3         = 0x20
	Key4         = 0x21
	Key5         = 0x22
	Key6         = 0x23
	Key7         = 0x24
	Key8         = 0x25
	Key9         = 0x26
	Key0         = 0x27
	KeyEnter     = 0x28
	KeyEscape    = 0x29
	KeyBackspace = 0x2A
	KeyTab       = 0x2B
	KeySpace     = 0x2C
	KeyMinus     = 0x2D
	KeyEqual     = 0x2E
	KeyLeftBrace = 0x2F
	KeyRightBrace= 0x30
	KeyBackslash = 0x31
	KeySemicolon = 0x33
	KeyQuote     = 0x34
	KeyTilde     = 0x35
	KeyComma     = 0x36
	KeyPeriod    = 0x37
	KeySlash     = 0x38
	KeyCapsLock  = 0x39
	KeyF1        = 0x3A
	KeyF2        = 0x3B
	KeyF3        = 0x3C
	KeyF4        = 0x3D
	KeyF5        = 0x3E
	KeyF6        = 0x3F
	KeyF7        = 0x40
	KeyF8        = 0x41
	KeyF9        = 0x42
	KeyF10       = 0x43
	KeyF11       = 0x44
	KeyF12       = 0x45
	KeyPrintScreen= 0x46
	KeyScrollLock= 0x47
	KeyPause     = 0x48
	KeyInsert    = 0x49
	KeyHome      = 0x4A
	KeyPageUp    = 0x4B
	KeyDelete    = 0x4C
	KeyEnd       = 0x4D
	KeyPageDown  = 0x4E
	KeyRight     = 0x4F
	KeyLeft      = 0x50
	KeyDown      = 0x51
	KeyUp        = 0x52
	KeyNumLock   = 0x53
)

const (
	// LED pins (built-in)
	LED = machine.LED
	
	// I2C pins for external communication
	SDA = machine.PA22
	SCL = machine.PA23
	
	// UART pins for debug
	UART_TX = machine.PA01
	UART_RX = machine.PA00
	
	// SPI pins (reserved for future)
	SPI_MISO = machine.PA22 // shared with SDA
	SPI_MOSI = machine.PA23 // shared with SCL
	SPI_SCK  = machine.PA24
)

// HID modifier keys
const (
	ModifierNone     = 0x00
	ModifierLeftCtrl = 0x01
	ModifierLeftShift= 0x02
	ModifierLeftAlt  = 0x04
	ModifierLeftMeta = 0x08
	ModifierRightCtrl= 0x10
	ModifierRightShift=0x20
	ModifierRightAlt = 0x40
	ModifierRightMeta= 0x80
)

// Keyboard report buffer for HID
type KeyboardReport struct {
	Modifiers   uint8
	Reserved    uint8
	Keycodes    [6]uint8
}

// Mouse report buffer for HID
type MouseReport struct {
	Buttons    uint8
	X          int8
	Y          int8
	Wheel      int8
	Pan        int8
}

var (
	// HID state
	lastReport KeyboardReport
	reportChanged bool
	
	// System state
	ledState bool
	blinkInterval time.Duration = 500 * time.Millisecond
)

// init initializes the board peripherals
func init() {
	// Configure LED
	machine.LED.Configure(machine.PinConfig{Mode: machine.PinOutput})
	
	// Configure UART for debugging
	uart := machine.UART0
	uart.Configure(machine.UARTConfig{
		TX: UART_TX,
		RX: UART_RX,
		Baud: 115200,
	})
	
	// Configure I2C for communication with host
	machine.I2C0.Configure(machine.I2CConfig{
		SDA: SDA,
		SCL: SCL,
		Frequency: 400000,
	})
	
	// Initialize keyboard report
	lastReport = KeyboardReport{}
}

// main is the entry point for the TinyGo program
func main() {
	println("Cyberdeck XIAO SAMD21 HID Bridge starting...")
	
	// Start with LED blink to indicate boot
	go ledBlinkTask()
	
	// Main loop - handle HID events
	for {
		// Process keyboard matrix scan
		scanKeyboard()
		
		// Small delay to debounce
		time.Sleep(10 * time.Millisecond)
	}
}

// ledBlinkTask blinks the LED to indicate the device is running
func ledBlinkTask() {
	for {
		machine.LED.Set(!ledState)
		ledState = !ledState
		time.Sleep(blinkInterval)
	}
}

// scanKeyboard scans the keyboard matrix and generates HID reports
// This is a basic implementation - in production you would connect
// a keyboard matrix or use one of the XIAO's analog inputs
func scanKeyboard() {
	// Placeholder for keyboard matrix scanning
	// In a real implementation, you would:
	// 1. Set up rows as outputs and columns as inputs with pull-ups
	// 2. Scan each row by setting it low and reading columns
	// 3. Generate appropriate HID reports
	
	// For now, we just check if keys are pressed (placeholder)
	// A real implementation would need external keyboard matrix hardware
}

// sendKeyboardReport sends a keyboard report over USB
func sendKeyboardReport(report KeyboardReport) {
	// In TinyUSB HID implementation, you would use:
	// tud_hid_report(REPORT_ID_KEYBOARD, &report, sizeof(report))
}

// sendMouseReport sends a mouse report over USB
func sendMouseReport(report MouseReport) {
	// In TinyUSB HID implementation, you would use:
	// tud_hid_report(REPORT_ID_MOUSE, &report, sizeof(report))
}

// handleHostCommand processes commands from the host via I2C
func handleHostCommand(cmd byte, data []byte) {
	switch cmd {
	case 0x01: // Get status
		// Return device status
		respondStatus()
	case 0x02: // Set LED
		if len(data) > 0 {
			if data[0] == 0 {
				blinkInterval = 0 // LED off
			} else if data[0] == 1 {
				blinkInterval = 500 * time.Millisecond
			} else {
				blinkInterval = time.Duration(data[0]) * 10 * time.Millisecond
			}
		}
	case 0x03: // Get report
		// Return current keyboard report
	default:
		// Unknown command
	}
}

// respondStatus sends device status over I2C
func respondStatus() {
	status := []byte{
		0x01, // Device type: keyboard
		0x00, // Firmware version major
		0x01, // Firmware version minor
		0x00, // Reserved
	}
	
	// I2C write would be handled by TinyGo's I2C peripheral
	// machine.I2C0.Write(status)
}

// TODO: Implement TinyUSB HID device functions
// The actual HID implementation requires TinyUSB library integration
// which is done automatically when using TinyGo with the correct board target

// +build ignore

/*
Implementation Notes:

1. Keyboard Matrix:
   - The SAMD21 has limited GPIOs, so for a full keyboard you'd need
     an external matrix scanner or use shift registers/IO expanders
   - Alternative: connect to the XIAO ESP32-S3 via UART/I2C for key scanning

2. HID Implementation:
   - TinyGo has built-in support for TinyUSB HID
   - Use `tinygo.org/x/tinyusb` for HID device implementation
   - Define report descriptors for keyboard and mouse

3. I2C Communication with Host:
   - XIAO SAMD21 acts as I2C slave (address: 0x5A)
   - Host can query key states or register for callbacks

4. UART Debug:
   - UART0 is used for debug output at 115200 baud
   - TX=PA01, RX=PA00 (serial console)

5. LED Indication:
   - Built-in LED shows device status
   - Slow blink = running
   - Fast blink = error

Example TinyUSB HID Report Descriptor:

const hidReportDescriptor = []byte{
	0x05, 0x01,        // Usage Page (Generic Desktop)
	0x09, 0x06,        // Usage (Keyboard)
	0xA1, 0x01,        // Collection (Application)
	0x05, 0x07,        //   Usage Page (Key Codes)
	0x19, 0xE0,        //   Usage Minimum (224) - Control
	0x29, 0xE7,        //   Usage Maximum (231) - Right Control, etc.
	0x15, 0x00,        //   Logical Minimum (0)
	0x25, 0x01,        //   Logical Maximum (1)
	0x75, 0x01,        //   Report Size (1)
	0x95, 0x08,        //   Report Count (8)
	0x81, 0x02,        //   Input (Data, Variable, Absolute)
	0x95, 0x01,        //   Report Count (1)
	0x75, 0x08,        //   Report Size (8)
	0x81, 0x01,        //   Input (Constant)
	0x95, 0x05,        //   Report Count (5)
	0x75, 0x01,        //   Report Size (1)
	0x05, 0x08,        //   Usage Page (LEDs)
	0x19, 0x01,        //   Usage Minimum (1)
	0x29, 0x05,        //   Usage Maximum (5)
	0x91, 0x02,        //   Output (Data, Variable, Absolute)
	0x95, 0x01,        //   Report Count (1)
	0x75, 0x03,        //   Report Size (3)
	0x91, 0x01,        //   Output (Constant)
	0x95, 0x06,        //   Report Count (6)
	0x75, 0x08,        //   Report Size (8)
	0x15, 0x00,        //   Logical Minimum (0)
	0x25, 0x65,        //   Logical Maximum (101)
	0x05, 0x07,        //   Usage Page (Key Codes)
	0x19, 0x00,        //   Usage Minimum (0)
	0x29, 101,         //   Usage Maximum (101)
	0x81, 0x00,        //   Input
	0xC0,              // End Collection
}
*/