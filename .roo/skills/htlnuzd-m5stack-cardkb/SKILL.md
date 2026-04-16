---
name: htlnuzd-m5stack-cardkb
description: >
  Provides comprehensive reference for using the HTLNUZD M5Stack CardKB V1.1 Mini 50-Key QWERTY
  Keyboard Unit with microcontrollers. Covers I2C communication, key scanning, key mapping,
  and keyboard input handling. Includes Arduino and TinyGo setup, wiring, pin usage, and code
  examples. Use when integrating compact keyboard input for handheld projects, data entry,
  hotkey configuration, or text input on microcontroller-based systems. Keywords: HTLNUZD,
  M5Stack, CardKB, keyboard, QWERTY, 50-key, I2C, Grove, key input, text input, hotkeys,
  keypad, USB-C, compact keyboard.
---

# HTLNUZD M5Stack CardKB V1.1 Mini 50-Key QWERTY Keyboard Unit — Accessory Guide

Provides comprehensive reference for using the HTLNUZD M5Stack CardKB V1.1 Mini 50-Key QWERTY Keyboard Unit with microcontrollers.

## When to Use

- Integrating compact keyboard input for handheld projects
- Adding text input capability to microcontroller systems
- Implementing hotkey functionality for control applications
- Creating data entry interfaces for embedded systems
- Looking up CardKB I2C communication details
- Writing Arduino/TinyGo firmware for keyboard input
- Checking pin usage and I2C address conflicts

## When NOT to Use

- For other input devices (rotary encoders, buttons) → use corresponding skill
- For display output → use corresponding display skill
- For standalone microcontroller board pinouts → use the corresponding board skill

---

## Accessory Overview

| Parameter | Value |
|---|---|
| **Type** | Mini QWERTY Keyboard Unit |
| **Key Count** | 50 keys |
| **Key Layout** | QWERTY (standard layout) |
| **Operating Voltage** | 3.3V |
| **Communication** | I2C |
| **I2C Address** | 0x5F |
| **Interface** | Grove I2C (4-pin) |
| **Dimensions** | Compact mini form factor |
| **Key Type** | Soft-touch membrane keys |

### Compatible Microcontrollers

| Board | Status | Notes |
|-------|--------|-------|
| XIAO SAMD21 | ✅ | Full I2C support via Grove |
| XIAO RP2040 | ✅ | Full I2C support via Grove |
| XIAO nRF52840 | ✅ | Full I2C support via Grove |
| XIAO ESP32-C3 | ✅ | Full I2C support via Grove |
| XIAO ESP32-S3 | ✅ | Full I2C support via Grove |
| XIAO ESP32-C6 | ✅ | Full I2C support via Grove |
| XIAO RA4M1 | ✅ | Full I2C support via Grove |
| XIAO nRF52840 Sense | ✅ | Full I2C support via Grove |
| Arduino Uno R3 | ✅ | Use with Grove Shield or I2C wires |
| Arduino Nano | ✅ | Use with Grove Shield or I2C wires |
| Raspberry Pi Pico | ✅ | Full I2C support |
| M5Stack Core | ✅ | Native Grove compatibility |

---

## Pin Usage Diagram

### Standard Grove I2C Connection (XIAO Boards)

```
CardKB Pin | Function         | XIAO Pin  | Protocol
----------|------------------|-----------|----------
VCC       | Power (3.3V)     | 3V3       | Power
GND       | Ground           | GND       | Ground
SDA       | I2C Data         | SDA       | I2C
SCL       | I2C Clock        | SCL       | I2C
```

### Standard XIAO I2C Pin Mapping

```
XIAO Pin  | CardKB Function
----------|------------------
3V3       | VCC
GND       | GND
SDA       | SDA (I2C Data)
SCL       | SCL (I2C Clock)
```

### Board-Specific I2C Pins

```
Board              | SDA Pin | SCL Pin
--------------------|---------|--------
XIAO SAMD21        | A4/SDA  | A5/SCL
XIAO RP2040        | D4/SDA  | D5/SCL
XIAO nRF52840      | D4/SDA  | D5/SCL
XIAO ESP32-C3      | D5/SDA  | D6/SCL
XIAO ESP32-S3      | D5/SDA  | D6/SCL
XIAO ESP32-C6      | D5/SDA  | D6/SCL
XIAO RA4M1         | D5/SDA  | D6/SCL
Arduino Uno R3     | A4/SDA  | A5/SCL
Arduino Nano       | A4/SDA  | A5/SCL
M5Stack Core       | GPIO21  | GPIO22
```

---

## Pin Conflict Warning

### Pins USED by CardKB
- **SDA** — I2C Data (shared with other I2C devices)
- **SCL** — I2C Clock (shared with other I2C devices)

### Conflicts with other accessories
- **OLED Display** — conflicts on I2C bus (SDA/SCL) ❌
- **RTC Module** — conflicts on I2C bus (SDA/SCL) ❌
- **Sensor modules** — conflicts on I2C bus (SDA/SCL) ❌
- ** Grove Vision AI** — conflicts on I2C bus (SDA/SCL) ❌

> **Note:** Multiple I2C devices can share the same bus with different addresses. CardKB uses address `0x5F`.

---

## Power Requirements

| Parameter | Value |
|-----------|-------|
| Power Source | 3.3V |
| Typical Current | ~5-10mA (active scanning) |
| Sleep Current | ~10μA (approximate) |

> **Warning:** Do not power with 5V — the CardKB operates at 3.3V. Use level shifters if connecting to 5V boards.

---

## I2C Communication

### Key Parameters

| Parameter | Value |
|-----------|-------|
| I2C Address | 0x5F (decimal 95) |
| Protocol | Standard I2C |
| Speed | 100kHz (Standard) / 400kHz (Fast) |
| Register Map | Single byte keycode on read |

### Reading Key Presses

The CardKB returns a single byte keycode when a key is pressed:

```
// Pseudocode for reading keypress
i2c_start();
i2c_write(0x5F << 1);      // Write address (0xBE)
i2c_write(0x00);           // Register/command (optional)
i2c_stop();

i2c_start();
i2c_write(0x5F << 1 | 1); // Read address (0xBF)
keycode = i2c_read();      // Read keycode byte
i2c_stop();
```

---

## Key Mapping

### Modifier Keys

| Key | Keycode | Notes |
|-----|---------|-------|
| FN (Function) | 0x87 | Hold with other keys for alternate functions |

### Main Key Layout (Standard ASCII)

The CardKB returns standard ASCII keycodes for alphanumeric keys:

```
Row 1:  1  2  3  4  5  6  7  8  9  0  -  =
Row 2:  Q  W  E  R  T  Y  U  I  O  P  [  ]
Row 3:  A  S  D  F  G  H  J  K  L  ;  '  \
Row 4:  Z  X  C  V  B  N  M  ,  .  /  SHIFT
Row 5:  FN   (space bar)              ENTER
```

### Function Key Combinations (FN + Key)

| FN + Key | Function |
|----------|----------|
| FN + 1 | F1 |
| FN + 2 | F2 |
| FN + 3 | F3 |
| FN + 4 | F4 |
| FN + 5 | F5 |
| FN + 6 | F6 |
| FN + 7 | F7 |
| FN + 8 | F8 |
| FN + 9 | F9 |
| FN + 0 | F10 |
| FN + - | F11 |
| FN + = | F12 |
| FN + P | Print Screen |
| FN + [ | Scroll Lock |
| FN + ] | Pause |
| FN + A | Home |
| FN + D | Delete |
| FN + E | End |
| FN + G | Page Down |
| FN + I | Insert |
| FN + O | Page Up |
| FN + U | Up Arrow |
| FN + J | Down Arrow |
| FN + K | Left Arrow |
| FN + L | Right Arrow |

---

## Arduino Setup & Usage

### Required Libraries

```bash
# CardKB Library:
# Use M5Stack's CardKB library or generic I2C key scanning
# Available via Arduino Library Manager: search "M5Stack"
# Or use the generic approach with Wire.h
```

### Wire.h Approach (Recommended)

```cpp
#include <Arduino.h>
#include <Wire.h>

// CardKB I2C Address
#define CARDKB_ADDR 0x5F

void setup() {
  Serial.begin(115200);
  Wire.begin(); // Initialize I2C
  
  Serial.println("CardKB Keyboard Ready");
}

void loop() {
  Wire.requestFrom(CARDKB_ADDR, 1);
  
  if (Wire.available()) {
    char key = Wire.read();
    
    if (key != 0) {
      Serial.print("Key pressed: ");
      Serial.println(key);
    }
  }
  
  delay(10);
}
```

### Polling-Based Key Detection with Modifier Support

```cpp
#include <Arduino.h>
#include <Wire.h>

#define CARDKB_ADDR 0x5F
#define FN_KEY     0x87

bool isFnPressed() {
  Wire.requestFrom(CARDKB_ADDR, 1);
  if (Wire.available()) {
    if (Wire.read() == FN_KEY) {
      return true;
    }
  }
  return false;
}

void setup() {
  Serial.begin(115200);
  Wire.begin();
}

void loop() {
  // Check for function key
  if (isFnPressed()) {
    // Read next key for function combinations
    delay(50); // Small debounce delay
    
    Wire.requestFrom(CARDKB_ADDR, 1);
    if (Wire.available()) {
      char key = Wire.read();
      
      if (key >= '1' && key <= '9') {
        Serial.print("F");
        Serial.println(key - '1' + 1);
      } else if (key == '0') {
        Serial.println("F10");
      }
    }
  }
  
  delay(10);
}
```

### Complete Keyboard Input Example

```cpp
#include <Arduino.h>
#include <Wire.h>

#define CARDKB_ADDR 0x5F

// Function keycode definitions
#define KEY_FN     0x87
#define KEY_ENTER  0x0D
#define KEY_SPACE  0x20
#define KEY_ESC    0x1B
#define KEY_TAB    0x09
#define KEY_BACKSP 0x08

void setup() {
  Serial.begin(115200);
  Wire.begin();
  
  Serial.println("=== CardKB Keyboard Test ===");
  Serial.println("Press keys to see keycodes...");
}

void loop() {
  Wire.requestFrom(CARDKB_ADDR, 1);
  
  if (Wire.available()) {
    uint8_t keycode = Wire.read();
    
    if (keycode != 0) {
      Serial.print("Keycode: 0x");
      Serial.print(keycode, HEX);
      Serial.print(" (");
      
      // Print character if printable
      if (keycode >= 32 && keycode <= 126) {
        Serial.print((char)keycode);
      } else {
        // Print key name for special keys
        switch (keycode) {
          case KEY_ENTER:  Serial.print("ENTER"); break;
          case KEY_SPACE:  Serial.print("SPACE"); break;
          case KEY_ESC:    Serial.print("ESC"); break;
          case KEY_TAB:    Serial.print("TAB"); break;
          case KEY_BACKSP: Serial.print("BACKSPACE"); break;
          case KEY_FN:     Serial.print("FN"); break;
          default:         Serial.print("?"); break;
        }
      }
      
      Serial.println(")");
    }
  }
  
  delay(10);
}
```

---

## TinyGo Setup & Usage

### I2C Keyboard Input

```go
package main

import (
	"fmt"
	"machine"
	"time"
)

const (
	cardKBAddress = 0x5F
	fnKeyCode     = 0x87
)

func main() {
	// Configure I2C
	machine.I2C0.Configure(machine.I2CConfig{
		Frequency: 100 * machine.KHz,
	})

	fmt.Println("CardKB Keyboard Ready")

	for {
		// Request single byte from keyboard
		data := make([]byte, 1)
		err := machine.I2C0.ReadRegister(cardKBAddress, 0, data)
		
		if err == nil && data[0] != 0 {
			fmt.Printf("Key: 0x%02X", data[0])
			
			// Check if printable ASCII
			if data[0] >= 32 && data[0] <= 126 {
				fmt.Printf(" ('%c')", rune(data[0]))
			}
			fmt.Println()
		}
		
		time.Sleep(10 * time.Millisecond)
	}
}
```

### Non-Blocking Keyboard Reader

```go
package main

import (
	"fmt"
	"machine"
	"time"
)

const cardKBAddress = 0x5F

var fnPressed bool

func main() {
	machine.I2C0.Configure(machine.I2CConfig{
		Frequency: 100 * machine.KHz,
	})

	fmt.Println("CardKB Keyboard - FN + Key Test")
	fmt.Println("Hold FN and press number keys for F1-F12")
	
	for {
		if key := readKey(); key != 0 {
			if key == 0x87 {
				fnPressed = true
			} else if fnPressed {
				handleFunctionKey(key)
				fnPressed = false
			} else {
				handleNormalKey(key)
			}
		} else {
			fnPressed = false
		}
		
		time.Sleep(10 * time.Millisecond)
	}
}

func readKey() byte {
	data := make([]byte, 1)
	err := machine.I2C0.ReadRegister(cardKBAddress, 0, data)
	if err != nil {
		return 0
	}
	return data[0]
}

func handleFunctionKey(key byte) {
	switch {
	case key >= '1' && key <= '9':
		fmt.Printf("F%d pressed\n", key-'1'+1)
	case key == '0':
		fmt.Println("F10 pressed")
	case key == '-':
		fmt.Println("F11 pressed")
	case key == '=':
		fmt.Println("F12 pressed")
	default:
		fmt.Printf("FN+%c pressed\n", rune(key))
	}
}

func handleNormalKey(key byte) {
	if key >= 32 && key <= 126 {
		fmt.Printf("Key: %c\n", rune(key))
	}
}
```

---

## Use Cases

### 1. Handheld Data Entry Terminal
```
Application: Create a portable data entry device
- Connect CardKB to XIAO ESP32-S3
- Add OLED display for visual feedback
- Implement text input for configuration or commands
```

### 2. Hotkey Controller
```
Application: Control software or hardware with keyboard shortcuts
- Map function keys (F1-F12) to specific actions
- Control robot movements, lighting, or other peripherals
- Create custom keyboard shortcuts for frequently used functions
```

### 3. Configuration Interface
```
Application: Set parameters for embedded systems
- Use number keys for value input
- Use letter keys for menu selection
- Implement ENTER/ESC for confirm/cancel
```

### 4. Password or Code Entry
```
Application: Secure input for access control
- Accept alphanumeric passwords
- Mask display of entered characters
- Debounce and validate input
```

### 5. Debug Console Input
```
Application: Command-line interface for debugging
- Accept text commands via keyboard
- Parse and execute commands
- Display output on connected display
```

---

## Troubleshooting

### No Response from CardKB

1. Check I2C address is correct (0x5F)
2. Verify power supply is 3.3V
3. Check SDA/SCL connections
4. Run I2C scanner to find device:
   ```cpp
   #include <Wire.h>
   
   void setup() {
     Serial.begin(115200);
     Wire.begin();
     
     Serial.println("Scanning I2C devices...");
     
     for (byte address = 1; address < 127; address++) {
       Wire.beginTransmission(address);
       if (Wire.endTransmission() == 0) {
         Serial.print("Found device at 0x");
         Serial.println(address, HEX);
       }
     }
     Serial.println("Scan complete");
   }
   
   void loop() {}
   ```

### Stuck Keys or Multiple Keypresses

1. Implement software debounce
2. Check for proper GND connection
3. Verify I2C pull-up resistors (internal to most boards)
4. Add delay between reads

### FN Key Not Working

1. Read FN key first to set flag
2. Small delay before reading actual key
3. Reset FN flag after reading key or timeout

---

## References

- M5Stack Official Documentation
- CardKB Library: https://github.com/m5stack/M5CardKB
- I2C Protocol Specification
