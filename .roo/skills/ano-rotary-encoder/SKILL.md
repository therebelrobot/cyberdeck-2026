---
name: ano-rotary-encoder
description: >
  Provides comprehensive reference for using the Adafruit ANO Rotary Encoder (I2C QT Rotary Encoder
  with NeoPixel or ANO Rotary Encoder to I2C Adapter) with Seeed Studio XIAO microcontrollers.
  Covers I2C communication, seesaw firmware usage, rotary encoder position reading, NeoPixel control,
  and interrupt-based detection. Includes Arduino C++ and CircuitPython/Python examples.
  Use when integrating rotary encoders for user input, menu navigation, or parameter adjustment
  in XIAO-based projects. Keywords: ANO, rotary, encoder, I2C, seesaw, NeoPixel, encoder position,
  QT Py, STEMMA QT, Adafruit, XIAO, SAMD21, RP2040, ESP32C6, interrupt, user input.
---

# Adafruit ANO Rotary Encoder — XIAO Accessory Guide

Provides comprehensive reference for using the Adafruit ANO Rotary Encoder with Seeed Studio XIAO microcontrollers.

## When to Use

- Integrating a rotary encoder for user input, menu navigation, or parameter adjustment
- Reading encoder position and direction via I2C
- Controlling the embedded NeoPixel RGB LED
- Setting up interrupt-based encoder change detection
- Configuring I2C address for multiple encoders

## When NOT to Use

- For standalone XIAO board pinouts → use the corresponding board skill
- For GPIO-based rotary encoders (no I2C) → different wiring required
- For other XIAO accessories → use the corresponding accessory skill

---

## Accessory Overview

The ANO Rotary Encoder comes in two Adafruit products relevant to this project:

### Product 4991: I2C QT Rotary Encoder with NeoPixel

| Parameter | Value |
|---|---|
| **Type** | I2C rotary encoder with RGB LED |
| **I2C Address** | 0x49 (default), configurable 0x49–0x51 |
| **Encoder** | 12-step detent |
| **LED** | Single NeoPixel (WS2812-style) |
| **Voltage** | 3.3V–5V compatible |
| **Interface** | I2C (SDA/SCL) + Interrupt pin |
| **Library** | Adafruit seesaw (Arduino), adafruit_seesaw (Python) |

### Product 5740: ANO Rotary Encoder to I2C Adapter

| Parameter | Value |
|---|---|
| **Type** | I2C adapter for standard rotary encoder |
| **I2C Address** | 0x49 (default), configurable 0x49–0x51 |
| **Firmware** | Seesaw firmware preloaded |
| **Voltage** | 3.3V–5V compatible |
| **Interface** | I2C (SDA/SCL) + Interrupt pin |
| **Requires** | External rotary encoder (not included) |

### Compatible XIAO Boards

| Board | Status | I2C Pins | Notes |
|-------|--------|----------|-------|
| XIAO SAMD21 | ✅ | D4 (SDA), D5 (SCL) | Standard I2C |
| XIAO RP2040 | ✅ | D4 (SDA), D5 (SCL) | Standard I2C |
| XIAO ESP32C6 | ✅ | D1 (SDA), D0 (SCL) | Different pins |
| XIAO nRF52840 | ✅ | D4 (SDA), D5 (SCL) | Standard I2C |
| XIAO ESP32S3 | ✅ | D4 (SDA), D5 (SCL) | Standard I2C |

---

## Pinout and Wiring

### ANO Rotary Encoder Pinout

```
    ┌─────────────────┐
    │  ANO Rotary      │
    │  Encoder         │
    │                 │
    │  +------------+  │
    │  |  +---+
    │  +---+   |
    │      |   |
    +------+   +-----+
    │ GND  │ 3V3  │
    │ SDA  │ SCL  │
    │ INT  │ NEO  │
    └──────────────┘
```

### Pin Description

| Pin | Function | Description |
|-----|----------|-------------|
| GND | Ground | Connect to XIAO GND |
| 3V3 | Power | Connect to XIAO 3V3 (or 5V if available) |
| SDA | I2C Data | Connect to XIAO SDA pin |
| SCL | I2C Clock | Connect to XIAO SCL pin |
| INT | Interrupt | Optional: connect to any GPIO for interrupts |
| NEO | NeoPixel | Internal NeoPixel (on product 4991) |

### Wiring Diagrams by XIAO Board

#### XIAO SAMD21 / RP2040 / nRF52840 / ESP32S3

```
XIAO                  ANO Rotary Encoder
────                  ──────────────────
D4  (SDA)     ────   SDA
D5  (SCL)     ────   SCL
3V3           ────   3V3
GND           ────   GND
(optional)
Any GPIO      ────   INT
```

#### XIAO ESP32C6

```
XIAO                  ANO Rotary Encoder
────                  ──────────────────
D1  (SDA)     ────   SDA
D0  (SCL)     ────   SCL
3V3           ────   3V3
GND           ────   GND
(optional)
Any GPIO      ────   INT
```

---

## Library Installation

### Arduino (Adafruit Seesaw)

1. Open Arduino IDE
2. Go to **Sketch** → **Include Library** → **Manage Libraries**
3. Search for **"Adafruit seesaw"** and install
4. The library includes examples for encoder reading

### CircuitPython / Python

```bash
# Using pip
pip install adafruit_seesaw

# Or for a specific board
pip install adafruit-circuitpython-seesaw
```

---

## Arduino C++ Examples

### Basic Encoder Reading

```cpp
#include <Wire.h>
#include "Adafruit_seesaw.h"

Adafruit_seesaw ss;

void setup() {
    Serial.begin(115200);
    
    if (!ss.begin(0x49)) {  // Default I2C address
        Serial.println("Seesaw not found!");
        while (1) delay(10);
    }
    Serial.println("Seesaw started!");
}

void loop() {
    int32_t encoderPosition = ss.getEncoderPosition();
    Serial.print("Encoder position: ");
    Serial.println(encoderPosition);
    
    delay(100);
}
```

### Encoder with LED Control (Product 4991)

```cpp
#include <Wire.h>
#include "Adafruit_seesaw.h"
#include "Adafruit_NeoPixel.h"

#define SEESAW_ADDR 0x49
#define NEO_PIN 6  // NeoPixel pin on seesaw

Adafruit_seesaw ss;
Adafruit_NeoPixel pixels(1, NEO_PIN + 18, NEO_GRB + NEO_KHZ800);

void setup() {
    Serial.begin(115200);
    
    if (!ss.begin(SEESAW_ADDR)) {
        Serial.println("Seesaw not found!");
        while (1) delay(10);
    }
    
    pixels.begin();
    pixels.setBrightness(50);
    pixels.show();
    
    Serial.println("ANO Rotary Encoder ready!");
}

void loop() {
    int32_t encoderPosition = ss.getEncoderPosition();
    Serial.print("Position: ");
    Serial.println(encoderPosition);
    
    // Color based on position
    uint32_t color;
    switch (encoderPosition % 3) {
        case 0: color = pixels.Color(255, 0, 0); break;   // Red
        case 1: color = pixels.Color(0, 255, 0); break;   // Green
        case 2: color = pixels.Color(0, 0, 255); break;   // Blue
    }
    pixels.fill(color);
    pixels.show();
    
    delay(100);
}
```

### Interrupt-Based Reading

```cpp
#include <Wire.h>
#include "Adafruit_seesaw.h"

#define SEESAW_ADDR 0x49
#define INT_PIN 2  // Connect INT to GPIO2

Adafruit_seesaw ss;
volatile int32_t encoderPosition = 0;

void setup() {
    Serial.begin(115200);
    
    if (!ss.begin(SEESAW_ADDR)) {
        Serial.println("Seesaw not found!");
        while (1) delay(10);
    }
    
    // Enable encoder interrupts on seesaw
    ss.enableEncoderInterrupt();
    
    // Set up interrupt pin
    pinMode(INT_PIN, INPUT_PULLUP);
    attachInterrupt(digitalPinToInterrupt(INT_PIN), encoderISR, FALLING);
    
    Serial.println("Interrupt-based encoder ready!");
}

void loop() {
    static int32_t lastPosition = 0;
    
    // Read position only when changed (via polling fallback)
    int32_t newPosition = ss.getEncoderPosition();
    if (newPosition != lastPosition) {
        Serial.print("Position: ");
        Serial.println(newPosition);
        lastPosition = newPosition;
    }
    
    delay(10);
}

void encoderISR() {
    // This fires when seesaw triggers interrupt
    // Read actual position in loop to avoid I2C in ISR
}
```

### Multi-Encoder with Different Addresses

```cpp
#include <Wire.h>
#include "Adafruit_seesaw.h"

#define ADDR_ENCODER1 0x49
#define ADDR_ENCODER2 0x4A

Adafruit_seesaw encoder1;
Adafruit_seesaw encoder2;

void setup() {
    Serial.begin(115200);
    
    if (!encoder1.begin(ADDR_ENCODER1)) {
        Serial.println("Encoder 1 not found!");
        while (1) delay(10);
    }
    
    if (!encoder2.begin(ADDR_ENCODER2)) {
        Serial.println("Encoder 2 not found!");
        while (1) delay(10);
    }
    
    Serial.println("Both encoders ready!");
}

void loop() {
    int32_t pos1 = encoder1.getEncoderPosition();
    int32_t pos2 = encoder2.getEncoderPosition();
    
    Serial.print("Encoder 1: ");
    Serial.print(pos1);
    Serial.print(" | Encoder 2: ");
    Serial.println(pos2);
    
    delay(100);
}
```

---

## CircuitPython / Python Examples

### Basic Reading

```python
import board
import busio
from adafruit_seesaw.seesaw import Seesaw

# Initialize I2C
i2c = busio.I2C(board.SCL, board.SDA)

# Create seesaw instance
ss = Seesaw(i2c, addr=0x49)

# Read encoder position
while True:
    pos = ss.encoder_position
    print("Position:", pos)
```

### With NeoPixel LED

```python
import board
import busio
from adafruit_seesaw.seesaw import Seesaw
from adafruit_seesaw.neopixel import NeoPixel

# Initialize I2C
i2c = busio.I2C(board.SCL, board.SDA)
ss = Seesaw(i2c, addr=0x49)

# Create NeoPixel object
pixel = NeoPixel(ss, 6, brightness=0.3)  # Pin 6 on seesaw

# Color cycling based on position
color_index = 0
colors = [(255, 0, 0), (0, 255, 0), (0, 0, 255)]

while True:
    pos = ss.encoder_position
    print("Position:", pos)
    
    # Update LED color
    pixel.fill(colors[pos % 3])
```

### Interrupt-Based Reading

```python
import board
import busio
import digitalio
from adafruit_seesaw.seesaw import Seesaw

# Initialize I2C
i2c = busio.I2C(board.SCL, board.SDA)
ss = Seesaw(i2c, addr=0x49)

# Enable encoder interrupts
ss.enable_encoder_interrupt()

# Interrupt pin setup
int_pin = digitalio.DigitalInOut(board.D2)
int_pin.direction = digitalio.Direction.INPUT
int_pin.pull = digitalio.Pull.UP

last_position = 0

while True:
    # Check interrupt pin
    if not int_pin.value:  # Active low
        current_position = ss.encoder_position
        if current_position != last_position:
            print("Position:", current_position)
            last_position = current_position
```

---

## TinyGo Examples

TinyGo support for the Adafruit seesaw library is limited. For TinyGo development, direct I2C register access is recommended.

### Direct I2C Register Access (TinyGo)

```go
package main

import (
	"fmt"
	"machine"
	"time"

	"tinygo.org/x/drivers/seesaw"
)

func main() {
	// I2C configuration for XIAO SAMD21/RP2040
	machine.I2C0.Config.SCL = machine.D5
	machine.I2C0.Config.SDA = machine.D4
	
	err := machine.I2C0.Enable()
	if err != nil {
		fmt.Println("I2C init failed:", err)
		return
	}
	
	// Create seesaw driver
	ss := seesaw.New(machine.I2C0)
	ss.Address = 0x49  // Default address
	
	for {
		// Read encoder position (SEESAW_ENCODER_POS = 0x10)
		pos, err := ss.ReadEncoderPosition()
		if err != nil {
			fmt.Println("Read error:", err)
		} else {
			fmt.Printf("Position: %d\n", pos)
		}
		
		time.Sleep(100 * time.Millisecond)
	}
}
```

---

## Troubleshooting

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| "Seesaw not found!" | I2C wiring or address wrong | Check SDA/SCL connections; verify I2C address (default 0x49) |
| Position always 0 | Encoder not properly connected | Ensure encoder module is fully seated on header |
| Erratic position readings | Loose wiring or I2C noise | Use short cables; add 4.7kΩ pull-up resistors on SDA/SCL if needed |
| LED not working | Wrong pin number | NeoPixel pin is 18+6=24 on some configurations; check library docs |
| Interrupt not firing | Pull-up not enabled | Enable internal pull-up on INT pin; check interrupt configuration |

### I2C Address Configuration

The seesaw firmware allows address changes. To scan for devices:

```cpp
// Arduino I2C scanner
#include <Wire.h>

void setup() {
    Serial.begin(115200);
    Wire.begin();
    
    Serial.println("Scanning for I2C devices...");
    for (byte address = 0x49; address <= 0x51; address++) {
        Wire.beginTransmission(address);
        if (Wire.endTransmission() == 0) {
            Serial.print("Found device at 0x");
            Serial.println(address, HEX);
        }
    }
}
```

### Resetting Seesaw

If the encoder behaves erratically, try resetting:

```cpp
ss.softwareReset();
ss.begin();  // Reinitialize
```

---

## Reference Links

- **Adafruit Product 4991:** https://www.adafruit.com/product/4991
- **Adafruit Product 5740:** https://www.adafruit.com/product/5740
- **Adafruit Seesaw Arduino Library:** https://github.com/adafruit/Adafruit_Seesaw
- **Adafruit Seesaw Python Library:** https://github.com/adafruit/Adafruit_CircuitPython_seesaw
- **Seesaw Firmware Documentation:** https://cdn-learn.adafruit.com/downloads/pdf/adafruit-seesaw-external-irq-neopixel-no-keypad-external-breakout.pdf
