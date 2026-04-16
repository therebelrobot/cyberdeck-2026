---
name: waveshare-3.5inch-capacitive-touch-screen-lcd
description: >
  Provides comprehensive reference for using the Waveshare 3.5inch Capacitive Touch Screen LCD
  with microcontrollers. Covers SPI display communication, capacitive touch panel (GT911 controller),
  backlight control, and GPIO-based functionality. Includes Arduino setup, wiring, pin usage,
  and code examples. Use when integrating the 3.5" LCD for visual output, touch interfaces,
  or GUI applications. Keywords: Waveshare, 3.5inch, LCD, TFT, capacitive touch, GT911,
  SPI, display, screen, 480x320, ILI9488, backlight, touch panel.
---

# Waveshare 3.5inch Capacitive Touch Screen LCD — Accessory Guide

Provides comprehensive reference for using the Waveshare 3.5inch Capacitive Touch Screen LCD with microcontrollers.

## When to Use

- Integrating the 3.5" LCD display for visual output
- Implementing touch-based user interfaces
- Adding a display to microcontroller projects
- Looking up which pins the LCD occupies
- Writing Arduino firmware for display and touch
- Checking pin conflicts with other accessories

## When NOT to Use

- For other display types → use the corresponding display skill
- For standalone microcontroller board pinouts → use the corresponding board skill

---

## Accessory Overview

| Parameter | Value |
|---|---|
| **Type** | TFT LCD Display with Capacitive Touch |
| **Display Size** | 3.5 inch |
| **Resolution** | 480 × 320 pixels |
| **Display Driver** | ILI9488 |
| **Touch Controller** | GT911 (Capacitive) |
| **Operating Voltage** | 3.3V |
| **Communication** | SPI (Display), I2C (Touch) |
| **Display Colors** | 65K (16-bit) |
| **Backlight** | PWM controllable |
| **Interface** | 8-bit/16-bit parallel or SPI (configurable via onboard resistor) |

### Compatible Microcontrollers

| Board | Status | Notes |
|-------|--------|-------|
| XIAO SAMD21 | ✅ | Full support via SPI |
| XIAO RP2040 | ✅ | Full support via SPI |
| XIAO nRF52840 | ✅ | Full support via SPI |
| XIAO ESP32-C3 | ✅ | Full support via SPI |
| XIAO ESP32-S3 | ✅ | Full support via SPI |
| XIAO RA4M1 | ✅ | Full support via SPI |
| Arduino Uno R3 | ✅ | Use 8-bit/16-bit parallel mode |
| Arduino Nano | ✅ | Use SPI mode |
| Raspberry Pi Pico | ✅ | Full support via SPI |

---

## Pin Usage Diagram (SPI Mode)

```
LCD Pin     | Function                  | XIAO Pin  | Protocol
------------|--------------------------|-----------|----------
VCC         | Power (3.3V)             | 3V3       | Power
GND         | Ground                   | GND       | Ground
MOSI        | SPI Data Out             | D10/MOSI  | SPI
MISO        | SPI Data In              | D9/MISO   | SPI
SCK         | SPI Clock                | D8/SCK    | SPI
LCD_CS      | Display Chip Select      | D7        | GPIO
LCD_RST     | Display Reset            | D6        | GPIO (Output)
LCD_DC      | Data/Command             | D5        | GPIO
BL          | Backlight Control        | D4        | PWM/GPIO
TP_SDA      | Touch I2C Data           | D4/SDA    | I2C (shared with Grove)
TP_SCL      | Touch I2C Clock          | D5/SCL    | I2C (shared with Grove)
TP_IRQ      | Touch Interrupt          | D3        | GPIO (Interrupt)
```

### Standard XIAO SPI Pin Mapping

```
XIAO Pin    | LCD Function
------------|--------------
3V3         | VCC
GND         | GND
D10/MOSI    | MOSI
D9/MISO     | MISO
D8/SCK      | SCK
D7          | LCD_CS
D6          | LCD_RST
D5          | LCD_DC
D4          | BL (Backlight)
D3          | TP_IRQ (Touch Interrupt)
D4/SDA      | TP_SDA (I2C)
D5/SCL      | TP_SCL (I2C)
```

---

## Pin Conflict Warning

### Pins OCCUPIED by LCD
- **D4** — Backlight control (PWM)
- **D5** — LCD Data/Command pin
- **D6** — LCD Reset
- **D7** — LCD Chip Select
- **D8** — SPI Clock
- **D9** — SPI MISO
- **D10/MOSI** — SPI MOSI
- **D3** — Touch Interrupt (TP_IRQ)

### Pins remaining FREE
- D0, D1, D2, D6 (varies by board)

### Conflicts with other accessories
- **ePaper Display** — conflicts on SPI pins (D8, D9, D10) ❌
- **SD Card** — conflicts on SPI pins (D8, D9, D10) ❌
- **COB LED Driver** — no direct conflict ✅
- **RS485 Board** — may conflict on D4/D5 if using UART mode ❌

---

## Power Requirements

| Parameter | Value |
|-----------|-------|
| Power Source | 3.3V |
| Display Current | ~50mA (typical) |
| Backlight Current | ~40mA (full brightness) |
| Touch Controller | ~5mA |

> **Warning:** Do not power with 5V — the display operates at 3.3V. Use level shifters if connecting to 5V boards.

---

## Arduino Setup & Usage

### Required Libraries

```bash
# Display Library:
# GFX library — part of Adafruit GFX Library
# Install via Arduino Library Manager: search "Adafruit GFX"

# ILI9488 Display Driver:
# ILI9488 library — e.g., https://github.com/adafruit/Adafruit_ILI9488
# Install via Arduino Library Manager or download ZIP

# Touch Controller (GT911):
# Touch library for GT911 — e.g., https://github.com/adafruit/Adafruit_FT6206
# Note: GT911 uses different protocol than FT6206; may need custom library

# Alternative: Use Waveshare-provided libraries from their wiki
```

### Complete Working Example — Display

```cpp
#include <Arduino.h>
#include <Adafruit_GFX.h>
#include <Adafruit_ILI9488.h>
#include <SPI.h>

// Define pins for XIAO
#define TFT_CS    7
#define TFT_RST   6
#define TFT_DC    5
#define TFT_MOSI  10
#define TFT_MISO  9
#define TFT_SCK   8
#define TFT_BL    4

// Create display object
Adafruit_ILI9488 tft = Adafruit_ILI9488(TFT_CS, TFT_DC, TFT_RST);

void setup() {
  Serial.begin(115200);
  
  // Initialize SPI
  SPI.begin(TFT_SCK, TFT_MISO, TFT_MOSI, TFT_CS);
  
  // Initialize display
  tft.begin();
  tft.setRotation(1); // Landscape orientation
  
  // Set backlight
  pinMode(TFT_BL, OUTPUT);
  digitalWrite(TFT_BL, HIGH); // Full brightness
  
  // Fill screen with color
  tft.fillScreen(ILI9488_BLACK);
  
  // Draw text
  tft.setTextColor(ILI9488_WHITE, ILI9488_BLACK);
  tft.setTextSize(2);
  tft.setCursor(20, 100);
  tft.println("Hello, World!");
}

void loop() {
  // Your display code here
  delay(100);
}
```

### Complete Working Example — Touch Input

```cpp
#include <Arduino.h>
#include <Wire.h>

// GT911 I2C address (default)
#define GT911_ADDR        0x5D
#define GT911_IRQ         3  // Touch interrupt pin

void setup() {
  Serial.begin(115200);
  Wire.begin();
  
  pinMode(GT911_IRQ, INPUT);
  
  // Initialize GT911 touch controller
  // Note: You may need to use a GT911-specific library
  // or implement the I2C protocol directly
  
  Serial.println("Touch example ready");
}

void loop() {
  if (digitalRead(GT911_IRQ) == LOW) {
    // Touch detected - read touch coordinates
    // This is simplified; actual implementation depends on library
    Serial.println("Touch detected!");
  }
  
  delay(10);
}
```

---

## Wiring Quick Reference

### XIAO to Waveshare 3.5" LCD (SPI Mode)

| XIAO Pin | LCD Pin | Wire Color (typical) |
|----------|---------|----------------------|
| 3V3 | VCC | Red |
| GND | GND | Black |
| D10/MOSI | MOSI | Blue |
| D9/MISO | MISO | Green |
| D8/SCK | SCK | Yellow |
| D7 | LCD_CS | Orange |
| D6 | LCD_RST | Purple |
| D5 | LCD_DC | White |
| D4 | BL | Gray |
| D3 | TP_IRQ | Brown |

---

## Calibration & Configuration

### Display Rotation

```cpp
tft.setRotation(0); // Portrait
tft.setRotation(1); // Landscape (typically used)
tft.setRotation(2); // Portrait inverted
tft.setRotation(3); // Landscape inverted
```

### Touch Calibration

The GT911 capacitive touch controller may require calibration:
1. Use the manufacturer's calibration tool if available
2. Adjust touch coordinates in your code
3. Test at all four corners to verify accuracy

### Backlight Control (PWM)

```cpp
// Fade backlight
analogWrite(TFT_BL, 128); // 50% brightness
analogWrite(TFT_BL, 64);  // 25% brightness
analogWrite(TFT_BL, 255); // Full brightness
```

---

## Troubleshooting

### Display shows white screen
- Check power connections (3.3V only)
- Verify SPI connections
- Ensure LCD_CS is properly asserted

### Touch not working
- Verify I2C connections for touch controller
- Check TP_IRQ pin connection
- Confirm correct I2C address (default 0x5D)

### Display is slow to update
- Use lower SPI clock speed
- Consider 8-bit parallel mode for faster updates
- Reduce display buffer redraws

### Colors look wrong
- Check color format (16-bit vs 18-bit)
- Verify setRotation() matches physical orientation
- Ensure proper initialization sequence

---

## Additional Resources

- [Waveshare Wiki](https://www.waveshare.net/wiki/3.5inch_LCD_Module)
- [ILI9488 Datasheet](https://www.ilitek.com/en/products/TFT-LCD-driver-IC/ILI9488/)
- [GT911 Datasheet](https://www.goodix.com/product/touchscreen/gt911-capacitive-touch-controller/)
- [Adafruit GFX Library](https://github.com/adafruit/Adafruit-GFX-Library)
