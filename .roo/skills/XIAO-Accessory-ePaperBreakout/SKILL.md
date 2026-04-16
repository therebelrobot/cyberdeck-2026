---
name: xiao-accessory-epaperbreakout
description: >
  Provides comprehensive reference for using the ePaper Breakout Board with Seeed Studio XIAO
  microcontrollers. Covers SPI display communication, supported eInk display sizes (1.54" to 7.5"),
  FPC connector, driver code generation, and display initialization. Includes Arduino and TinyGo
  setup, wiring, pin usage, and code examples. Use when integrating eInk/ePaper displays for
  low-power visual output, signage, dashboards, or e-reader applications on any XIAO board.
  Keywords: XIAO, ePaper, eInk, e-paper, e-ink, display, SPI, breakout, FPC, monochrome,
  tri-color, seven-color, GFX, screen, low power, Seeed.
---

# ePaper Breakout Board — XIAO Accessory Guide

Provides comprehensive reference for using the ePaper Breakout Board with Seeed Studio XIAO microcontrollers.

## When to Use

- Integrating the ePaper Breakout Board with eInk displays
- Looking up which XIAO pins the ePaper board occupies
- Writing Arduino or TinyGo firmware to drive eInk displays
- Selecting a compatible eInk display size and type
- Checking pin conflicts with other XIAO accessories

## When NOT to Use

- For standalone XIAO board pinouts → use the corresponding board skill
- For other XIAO accessories → use the corresponding accessory skill

---

## Accessory Overview

| Parameter | Value |
|---|---|
| **Type** | eInk/ePaper display breakout board |
| **Interface** | SPI |
| **FPC Connector** | 24-pin (for eInk displays) |
| **Alt Header** | 8-pin 2.54mm (for non-XIAO microcontrollers) |
| **Display** | NOT included — must be purchased separately |
| **Power** | Via XIAO USB or XIAO power supply |

### Supported eInk Displays

| Display | Resolution | Type |
|---------|------------|------|
| 1.54-inch Dotmatrix | 200 × 200 | Monochrome |
| 2.13-inch Flexible | 212 × 104 | Monochrome |
| 2.13-inch Quadruple | 212 × 104 | 4-color |
| 2.9-inch Monocolor | 128 × 296 | Monochrome |
| 2.9-inch Quadruple | 128 × 296 | 4-color |
| 4.2-inch Monocolor | 400 × 300 | Monochrome |
| 4.26-inch Monocolor | 800 × 480 | Monochrome |
| 5.65-inch Sevencolor | 600 × 480 | 7-color |
| 5.83-inch Monocolor | 648 × 480 | Monochrome |
| 7.5-inch Monocolor | 800 × 480 | Monochrome |
| 7.5-inch Tri-Color | 800 × 480 | 3-color |

### Compatible XIAO Boards

| XIAO Board | Status |
|------------|--------|
| XIAO SAMD21 | ✅ |
| XIAO RP2040 | ✅ |
| XIAO nRF52840 (Sense) | ✅ |
| XIAO ESP32C3 | ✅ |
| XIAO ESP32S3 (Sense) | ✅ |

---

## Pin Usage Diagram

```
XIAO Pin    | Accessory Function       | Protocol
------------|--------------------------|----------
D0          | Display Reset (RST)      | GPIO
D1          | Chip Select (CS)         | SPI
D3          | Data/Command (DC)        | GPIO
D5          | Busy Signal (BUSY)       | GPIO (input)
D8          | SPI Clock (SCK)          | SPI
D10         | SPI Data Out (MOSI)      | SPI
```

> **Note:** This accessory uses 6 XIAO pins — heavy pin usage compared to most accessories.

---

## Pin Conflict Warning

### Pins OCCUPIED by ePaper Breakout
- **D0** — Display reset (RST)
- **D1** — Chip select (CS)
- **D3** — Data/Command select (DC)
- **D5** — Busy signal (BUSY, input)
- **D8** — SPI clock (SCK)
- **D10** — SPI data out (MOSI)

### Pins remaining FREE
- D2, D4, D6, D7, D9, A0

### Conflicts with other accessories
- **Logger HAT** — conflicts on D1 (EN) and D5 (SCL) ❌
- **mmWave 24GHz** — conflicts on D3 (RX) ❌
- **CAN Bus** — conflicts on D8 (SCK) and D10 (MOSI) ❌
- **L76K GNSS** — no conflict ✅ (uses D6/D7)
- **reSpeaker Lite** — no conflict ✅ (separate board)

---

## Power Requirements

| Parameter | Value |
|-----------|-------|
| Power Source | Via XIAO USB or XIAO power supply |
| Display Power | Provided through breakout board |

> **Note:** ePaper displays consume power only during refresh. Once an image is displayed, the screen retains it with zero power consumption.

---

## Arduino Setup & Usage

### Required Libraries

```bash
# Install Seeed GFX Library from GitHub:
# https://github.com/Seeed-Studio/Seeed_Arduino_LCD
#
# Download ZIP and install via:
# Arduino IDE → Sketch → Include Library → Add .ZIP Library
#
# ⚠ IMPORTANT: Uninstall the TFT library first!
# The Seeed GFX Library is INCOMPATIBLE with the TFT library.
# Having both installed will cause compilation errors.
```

### Driver Code Generation

Each eInk display requires a specific driver. Use the online tool to generate driver code:

1. Visit the Seeed Wiki ePaper page
2. Select your display type and size
3. Generate the driver code
4. Save as `driver.h` in your sketch folder

### Initialization (Generic Pattern)

```cpp
#include <SPI.h>
#include "driver.h" // Generated driver for your specific display

// Pin definitions matching the breakout board
#define EPD_RST   D0
#define EPD_CS    D1
#define EPD_DC    D3
#define EPD_BUSY  D5
// SCK = D8, MOSI = D10 (handled by SPI library)

void setup() {
    Serial.begin(115200);

    // Initialize SPI
    SPI.begin();

    // Initialize display pins
    pinMode(EPD_RST, OUTPUT);
    pinMode(EPD_CS, OUTPUT);
    pinMode(EPD_DC, OUTPUT);
    pinMode(EPD_BUSY, INPUT);

    // Reset display
    digitalWrite(EPD_RST, HIGH);
    delay(20);
    digitalWrite(EPD_RST, LOW);
    delay(2);
    digitalWrite(EPD_RST, HIGH);
    delay(20);

    Serial.println("ePaper display initialized");
}
```

### Complete Working Example — 2.9-inch Monochrome

```cpp
#include <SPI.h>
#include "driver.h" // Generated for 2.9-inch monochrome (128×296)

#define EPD_RST   D0
#define EPD_CS    D1
#define EPD_DC    D3
#define EPD_BUSY  D5

#define EPD_WIDTH  128
#define EPD_HEIGHT 296

// Frame buffer (1 bit per pixel)
uint8_t frameBuffer[EPD_WIDTH * EPD_HEIGHT / 8];

void sendCommand(uint8_t cmd) {
    digitalWrite(EPD_DC, LOW);
    digitalWrite(EPD_CS, LOW);
    SPI.transfer(cmd);
    digitalWrite(EPD_CS, HIGH);
}

void sendData(uint8_t data) {
    digitalWrite(EPD_DC, HIGH);
    digitalWrite(EPD_CS, LOW);
    SPI.transfer(data);
    digitalWrite(EPD_CS, HIGH);
}

void waitBusy() {
    while (digitalRead(EPD_BUSY) == HIGH) {
        delay(10);
    }
}

void resetDisplay() {
    digitalWrite(EPD_RST, HIGH);
    delay(20);
    digitalWrite(EPD_RST, LOW);
    delay(2);
    digitalWrite(EPD_RST, HIGH);
    delay(20);
}

void clearDisplay() {
    // Fill frame buffer with white (0xFF)
    memset(frameBuffer, 0xFF, sizeof(frameBuffer));
}

void setPixel(int x, int y, bool black) {
    if (x < 0 || x >= EPD_WIDTH || y < 0 || y >= EPD_HEIGHT) return;

    int byteIndex = (y * EPD_WIDTH + x) / 8;
    int bitIndex = 7 - (x % 8);

    if (black) {
        frameBuffer[byteIndex] &= ~(1 << bitIndex);
    } else {
        frameBuffer[byteIndex] |= (1 << bitIndex);
    }
}

void updateDisplay() {
    // Send frame buffer to display
    // (Exact commands depend on display driver chip — use generated driver.h)
    sendCommand(0x24); // Write RAM
    for (int i = 0; i < sizeof(frameBuffer); i++) {
        sendData(frameBuffer[i]);
    }
    sendCommand(0x20); // Display update
    waitBusy();
}

void setup() {
    Serial.begin(115200);
    SPI.begin();

    pinMode(EPD_RST, OUTPUT);
    pinMode(EPD_CS, OUTPUT);
    pinMode(EPD_DC, OUTPUT);
    pinMode(EPD_BUSY, INPUT);

    resetDisplay();

    // Initialize display (commands from generated driver.h)
    // ... display-specific init sequence ...

    clearDisplay();

    // Draw a simple pattern
    for (int x = 10; x < 118; x++) {
        setPixel(x, 10, true);   // Top line
        setPixel(x, 50, true);   // Bottom line
    }
    for (int y = 10; y < 50; y++) {
        setPixel(10, y, true);   // Left line
        setPixel(117, y, true);  // Right line
    }

    updateDisplay();
    Serial.println("Display updated");
}

void loop() {
    // ePaper retains image without power
    delay(60000);
}
```

### Using Seeed GFX Library (Recommended)

```cpp
#include "Seeed_Eink.h" // From Seeed GFX Library

// The Seeed GFX library provides high-level drawing functions:
// - drawPixel(x, y, color)
// - drawLine(x0, y0, x1, y1, color)
// - drawRect(x, y, w, h, color)
// - fillRect(x, y, w, h, color)
// - drawCircle(x, y, r, color)
// - drawChar(x, y, c, color, bg, size)
// - print() / println()
// - drawBitmap(x, y, bitmap, w, h, color)

// Refer to the Seeed GFX Library examples for your specific display:
// - Bitmap example
// - Clock example
// - Shape example
```

### Display-Specific Initialization Sizes

| Display | Width | Height | Notes |
|---------|-------|--------|-------|
| 1.54" | 200 | 200 | May flicker with dynamic effects |
| 2.13" | 212 | 104 | Flexible version available |
| 2.9" | 128 | 296 | May flicker with dynamic effects |
| 4.2" | 400 | 300 | Good balance of size and resolution |
| 4.26" | 800 | 480 | High resolution |
| 5.65" | 600 | 480 | 7-color, no flicker |
| 5.83" | 648 | 480 | No flicker |
| 7.5" | 800 | 480 | No flicker, largest supported |

---

## TinyGo Setup & Usage

### TinyGo ePaper Drivers

TinyGo has drivers for several ePaper display controllers:

```bash
# Waveshare-compatible ePaper drivers
go get tinygo.org/x/drivers/waveshare-epd

# Specific drivers available:
# - waveshare-epd/epd2in13x (2.13-inch)
# - waveshare-epd/epd2in9 (2.9-inch)
# - waveshare-epd/epd4in2 (4.2-inch)
```

### TinyGo Example — 2.9-inch Display

```go
package main

import (
    "image/color"
    "machine"
    "time"

    "tinygo.org/x/drivers/waveshare-epd/epd2in9"
)

func main() {
    // Configure SPI
    spi := machine.SPI0
    spi.Configure(machine.SPIConfig{
        SCK:       machine.D8,
        SDO:       machine.D10, // MOSI
        Frequency: 4000000,     // 4MHz
        Mode:      0,
    })

    // Configure control pins
    cs := machine.D1
    dc := machine.D3
    rst := machine.D0
    busy := machine.D5

    cs.Configure(machine.PinConfig{Mode: machine.PinOutput})
    dc.Configure(machine.PinConfig{Mode: machine.PinOutput})
    rst.Configure(machine.PinConfig{Mode: machine.PinOutput})
    busy.Configure(machine.PinConfig{Mode: machine.PinInput})

    // Initialize display
    display := epd2in9.New(spi, cs, dc, rst, busy)
    display.Configure(epd2in9.Config{})

    println("ePaper display initialized (TinyGo)")

    // Clear display
    display.ClearBuffer()
    display.Display()
    display.WaitUntilIdle()

    // Draw pixels
    black := color.RGBA{0, 0, 0, 255}
    for x := 10; x < 118; x++ {
        display.SetPixel(int16(x), 10, black)
        display.SetPixel(int16(x), 50, black)
    }
    for y := 10; y < 50; y++ {
        display.SetPixel(10, int16(y), black)
        display.SetPixel(117, int16(y), black)
    }

    display.Display()
    display.WaitUntilIdle()

    println("Display updated")

    // ePaper retains image without power
    for {
        time.Sleep(time.Minute)
    }
}
```

> **Note:** TinyGo ePaper drivers use Waveshare-compatible protocols. Verify compatibility with the specific Seeed eInk display you are using. The SPI command set may differ slightly between manufacturers.

---

## Communication Protocol Details

### SPI Configuration

| Parameter | Value |
|-----------|-------|
| SPI Mode | Mode 0 (CPOL=0, CPHA=0) |
| Clock Speed | Up to 4MHz (typical) |
| Byte Order | MSB first |
| CS Pin | D1 |
| SCK Pin | D8 |
| MOSI Pin | D10 |
| MISO | Not used (display is write-only) |

### Control Pins

| Pin | Function | Direction | Description |
|-----|----------|-----------|-------------|
| D0 (RST) | Reset | Output | Active LOW reset pulse |
| D1 (CS) | Chip Select | Output | Active LOW during SPI transfer |
| D3 (DC) | Data/Command | Output | LOW = command, HIGH = data |
| D5 (BUSY) | Busy | Input | HIGH = busy, LOW = ready |

### Display Update Sequence

```
1. Reset display (RST LOW → HIGH)
2. Send initialization commands (DC=LOW)
3. Send image data (DC=HIGH)
4. Send display update command
5. Wait for BUSY pin to go LOW
6. Display shows new image
```

### Typical Refresh Times

| Display Size | Full Refresh | Partial Refresh |
|-------------|-------------|-----------------|
| 1.54" | ~2s | ~0.3s (if supported) |
| 2.9" | ~2s | ~0.3s (if supported) |
| 4.2" | ~4s | N/A |
| 7.5" | ~6s | N/A |

---

## Common Gotchas / Notes

1. **Display NOT included** — The breakout board does NOT come with an eInk display; purchase separately
2. **Seeed GFX Library conflicts** — The Seeed GFX Library is INCOMPATIBLE with the Arduino TFT library. Uninstall TFT library before installing Seeed GFX
3. **Driver code generation** — Each display type requires specific driver code generated via the online tool; using the wrong driver will not work
4. **Small screen flicker** — 1.54-inch and 2.9-inch screens may flicker with dynamic effects (driver chip limitation); 5.83" and 7.5" screens do not flicker
5. **No dynamic effects on small screens** — Not recommended to run dynamic/animated effects for extended periods on small screens
6. **Heavy pin usage** — Uses 6 XIAO pins (D0, D1, D3, D5, D8, D10); plan pin allocation carefully
7. **Zero standby power** — ePaper displays retain their image with zero power consumption; ideal for battery-powered applications
8. **Refresh rate** — ePaper displays have slow refresh rates (2–6 seconds); not suitable for real-time or animated content
9. **8-pin header** — The breakout board includes an 8-pin 2.54mm header for use with non-XIAO microcontrollers
10. **Temperature sensitivity** — ePaper displays may have slower refresh times in cold temperatures
11. **Strapping pins** — On ESP32-C3, D0 (GPIO2) and D8 (GPIO8) are strapping pins; ensure the display does not interfere with boot

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/XIAO-eInk-Expansion-Board/
- **Seeed GFX Library:** https://github.com/Seeed-Studio/Seeed_Arduino_LCD
- **TinyGo Waveshare EPD Drivers:** https://pkg.go.dev/tinygo.org/x/drivers/waveshare-epd
- **Seeed Product Page:** https://www.seeedstudio.com/ePaper-Breakout-Board-p-5804.html
