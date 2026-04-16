---
name: xiao-accessory-epaperdriver
description: >
  Provides comprehensive reference for using the ePaper Driver Board with Seeed Studio XIAO
  microcontrollers. Covers SPI communication, 24-pin FPC connector, support for 11 ePaper display
  sizes (1.54" to 7.5"), battery charging, and Seeed_Arduino_LCD library usage. Includes Arduino
  and TinyGo setup, wiring, pin usage, and code examples. Use when building e-ink display projects
  such as digital photo frames, dashboards, or low-power displays on any XIAO board.
  Keywords: XIAO, ePaper, e-ink, eink, display, SPI, SSD1680, driver board, FPC, low-power,
  dashboard, photo frame, monochrome, tri-color, seven-color.
---

# ePaper Driver Board — XIAO Accessory Guide

Provides comprehensive reference for using the ePaper Driver Board with Seeed Studio XIAO microcontrollers.

## When to Use

- Integrating the ePaper Driver Board for e-ink display projects
- Looking up which XIAO pins the ePaper driver occupies
- Writing Arduino or TinyGo firmware to drive ePaper displays via SPI
- Selecting a compatible ePaper display size
- Checking pin conflicts with other XIAO accessories

## When NOT to Use

- For standalone XIAO board pinouts → use the corresponding board skill
- For other XIAO accessories → use the corresponding accessory skill

---

## Accessory Overview

| Parameter | Value |
|---|---|
| **Type** | ePaper display driver board |
| **Display Connector** | 24-pin FPC |
| **Interface** | SPI |
| **Battery Charging** | Built-in charging IC |
| **Battery Connector** | JST 2-pin BAT with switch |
| **Extension IO Port** | Available for additional sensors |

### Supported ePaper Displays

| Display | Resolution | Notes |
|---------|-----------|-------|
| 1.54" Monochrome | 200×200 | May flicker with dynamic effects |
| 2.13" Flexible Monochrome | 212×104 | |
| 2.13" Quadruple Color | 212×104 | |
| 2.9" Monochrome | 128×296 | May flicker with dynamic effects |
| 2.9" Quadruple Color | 128×296 | |
| 4.2" Monochrome | 400×300 | |
| 4.26" Monochrome | 800×480 | Requires >SAMD21 RAM |
| 5.65" Seven-Color | 600×480 | No flickering |
| 5.83" Monochrome | 648×480 | No flickering |
| 7.5" Monochrome | 800×480 | No flickering |
| 7.5" Tri-Color | 800×480 | No flickering |

### Compatible XIAO Boards

| Board | Small Displays (≤4.2") | Large Displays (≥4.26") |
|-------|----------------------|----------------------|
| XIAO SAMD21 | ✅ | ❌ RAM overflow |
| XIAO RP2040 | ✅ | ✅ |
| XIAO nRF52840 | ✅ | ✅ |
| XIAO ESP32-C3 | ✅ | ✅ |
| XIAO ESP32-S3 | ✅ | ✅ |

---

## Pin Usage Diagram

```
XIAO Pin    | Accessory Function       | Protocol
------------|--------------------------|----------
D0          | Display Reset (RST)      | SPI
D1          | Chip Select (CS)         | SPI
D2          | Busy Signal (BUSY)       | SPI
D3          | Data/Command (DC)        | SPI
D8          | SPI Clock (SCK)          | SPI
D10         | SPI Data Out (MOSI)      | SPI
3V3         | Power                    | Power
GND         | Ground                   | Power
```

---

## Pin Conflict Warning

### Pins OCCUPIED by ePaper Driver
- **D0** — Display Reset (RST)
- **D1** — Chip Select (CS)
- **D2** — Busy Signal (BUSY)
- **D3** — Data/Command (DC)
- **D8** — SPI Clock (SCK)
- **D10** — SPI Data Out (MOSI)

### Pins remaining FREE
- D4, D5, D6, D7, D9, A0

### Conflicts with other accessories
- **COB LED Driver** — conflicts on D0, D1, D2, D3, D8 ❌
- **Expansion Board Base** — conflicts on D1 (button), D2 (SD CS), D3 (buzzer), D8 (SPI SCK), D10 (SPI MOSI) ❌
- **RS485 Board** — conflicts on D2 (enable) ❌
- **CAN Bus Board** — conflicts on D8, D10 (SPI) ❌
- **Grove Vision AI V2** — no conflict ✅ (uses I2C SDA/SCL only)

> **Note:** This board uses 6 XIAO pins — significant pin usage. Plan carefully when combining with other peripherals.

---

## Power Requirements

| Parameter | Value |
|-----------|-------|
| Power Source | 3.3V via XIAO |
| Battery | Optional 3.7V Li-Po via JST connector |
| Battery Charging | Built-in charging IC |

---

## Arduino Setup & Usage

### Required Libraries

```bash
# Install Seeed_Arduino_LCD (Seeed GFX Library):
# https://github.com/Seeed-Studio/Seeed_Arduino_LCD
#
# ⚠️ Uninstall other display libraries first (TFT_eSPI, Adafruit_GFX, etc.)
# to avoid conflicts.
#
# In Arduino IDE:
# Sketch → Include Library → Add .ZIP Library → select downloaded ZIP
```

### Initialization — Create `driver.h`

Create a file named `driver.h` in your sketch folder with the display configuration:

```cpp
// driver.h — Display configuration
// Change BOARD_SCREEN_COMBO for your display:
//   504 = 2.9" monochrome (SSD1680)
//   (see Seeed_Arduino_LCD docs for other display codes)

#define BOARD_SCREEN_COMBO 504
#define USE_XIAO_EPAPER_BREAKOUT_BOARD
```

### Complete Working Example — Display Text

```cpp
#include "driver.h"
#include <SPI.h>

// Pin definitions (ePaper Driver Board for XIAO)
#define EPD_RST   D0
#define EPD_CS    D1
#define EPD_BUSY  D2
#define EPD_DC    D3
#define EPD_SCK   D8
#define EPD_MOSI  D10

void setup() {
    Serial.begin(115200);
    Serial.println("ePaper Driver Board init...");

    // The Seeed_Arduino_LCD library handles initialization
    // via the BOARD_SCREEN_COMBO and USE_XIAO_EPAPER_BREAKOUT_BOARD
    // defines in driver.h

    // Use built-in examples from the library:
    // File → Examples → Seeed_Arduino_LCD → ePaper → Shape
    // File → Examples → Seeed_Arduino_LCD → ePaper → Bitmap
    // File → Examples → Seeed_Arduino_LCD → ePaper → Clock
    // File → Examples → Seeed_Arduino_LCD → ePaper → Clock_digital
}

void loop() {
    // ePaper displays retain image without power
    // Only update when content changes
}
```

### Built-in Examples

| Example | Description |
|---------|-------------|
| `Bitmap` | Display a bitmap image |
| `Clock` | Display an analog clock |
| `Clock_digital` | Display a digital clock |
| `Shape` | Display shapes and text |

---

## TinyGo Setup & Usage

### TinyGo ePaper Support

TinyGo has limited ePaper driver support. Check the TinyGo drivers repository for available e-ink drivers:

```bash
# Check for available ePaper drivers:
go get tinygo.org/x/drivers
```

### TinyGo SPI Configuration

```go
package main

import (
    "machine"
)

func main() {
    // Configure SPI for ePaper
    spi := machine.SPI0
    spi.Configure(machine.SPIConfig{
        SCK:       machine.D8,
        SDO:       machine.D10, // MOSI
        SDI:       machine.NoPin, // MISO not used by ePaper
        Frequency: 4000000,      // 4MHz
        Mode:      0,
    })

    // Control pins
    rst := machine.D0
    cs := machine.D1
    busy := machine.D2
    dc := machine.D3

    rst.Configure(machine.PinConfig{Mode: machine.PinOutput})
    cs.Configure(machine.PinConfig{Mode: machine.PinOutput})
    busy.Configure(machine.PinConfig{Mode: machine.PinInput})
    dc.Configure(machine.PinConfig{Mode: machine.PinOutput})

    cs.High() // Deselect

    // Use a TinyGo ePaper driver (e.g., waveshare-epd)
    // if available for your specific display model.
    // The Seeed_Arduino_LCD library is Arduino-only.

    println("ePaper SPI configured (TinyGo)")
}
```

> **Note:** The Seeed_Arduino_LCD library is Arduino-only. For TinyGo, use compatible ePaper drivers from `tinygo.org/x/drivers` (e.g., `waveshare-epd` for SSD1680-based displays). Not all display sizes may be supported.

---

## Communication Protocol Details

### SPI Configuration (XIAO ↔ ePaper)

| Parameter | Value |
|-----------|-------|
| SPI Mode | Mode 0 (CPOL=0, CPHA=0) |
| Clock Speed | Up to 4MHz typical |
| RST Pin | D0 |
| CS Pin | D1 |
| BUSY Pin | D2 (input) |
| DC Pin | D3 |
| SCK Pin | D8 |
| MOSI Pin | D10 |
| MISO | Not used |
| Byte Order | MSB first |

### ePaper Update Cycle

1. Assert RST LOW → wait → HIGH (hardware reset)
2. Send initialization commands via SPI (DC=LOW for commands)
3. Send image data via SPI (DC=HIGH for data)
4. Send display refresh command
5. Wait for BUSY pin to go LOW (refresh complete)
6. Display retains image without power

---

## Common Gotchas / Notes

1. **Display NOT included** — The ePaper display must be purchased separately.
2. **Library conflicts** — Uninstall other display libraries (TFT_eSPI, Adafruit_GFX) before installing Seeed_Arduino_LCD.
3. **SAMD21 RAM limitation** — XIAO SAMD21 cannot drive displays ≥4.26" due to RAM overflow.
4. **Image resolution must match** — Bitmap images must exactly match the screen resolution.
5. **Flickering on small displays** — 1.54" and 2.9" screens may flicker with dynamic effects (driver chip limitation). 5.83" and 7.5" screens do not have this issue.
6. **6 pins consumed** — D0, D1, D2, D3, D8, D10 are all used. Plan pin allocation carefully.
7. **driver.h required** — The `BOARD_SCREEN_COMBO` and `USE_XIAO_EPAPER_BREAKOUT_BOARD` defines must be in a `driver.h` file in your sketch folder.
8. **Pre-Soldering Version compatible** — Works with Pre-Soldering Version XIAO boards.
9. **Battery switch** — The JST battery connector has a switch for on/off control.

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/xiao_eink_expansion_board_v2/
- **Product Page:** https://www.seeedstudio.com/ePaper-breakout-Board-for-XIAO-V2-p-6374.html
- **Seeed_Arduino_LCD Library:** https://github.com/Seeed-Studio/Seeed_Arduino_LCD
