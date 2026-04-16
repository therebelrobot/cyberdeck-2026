---
name: xiao-accessory-expansionboard
description: >
  Provides comprehensive reference for using the Seeed Studio Expansion Board Base with XIAO
  microcontrollers. Covers onboard OLED display (SSD1306 128×64 I2C), RTC (PCF8563), MicroSD
  card slot (SPI), passive buzzer, user button, Grove connectors (I2C×2, UART×1, A0/D0×1),
  battery charging, and 5V servo connector. Includes Arduino and TinyGo setup, wiring, pin
  usage, and code examples. Use when prototyping with the multi-function XIAO expansion board.
  Keywords: XIAO, expansion board, base, OLED, SSD1306, RTC, PCF8563, MicroSD, SD card, buzzer,
  button, Grove, I2C, SPI, servo, battery, prototyping, dashboard.
---

# Expansion Board Base — XIAO Accessory Guide

Provides comprehensive reference for using the Seeed Studio Expansion Board Base with XIAO microcontrollers.

## When to Use

- Integrating the Expansion Board Base for rapid prototyping
- Using the onboard OLED display, RTC, SD card, buzzer, or button
- Looking up which XIAO pins the Expansion Board occupies
- Writing Arduino or TinyGo firmware for onboard peripherals
- Connecting Grove sensors via the expansion board
- Checking pin conflicts with other XIAO accessories

## When NOT to Use

- For standalone XIAO board pinouts → use the corresponding board skill
- For other XIAO accessories → use the corresponding accessory skill

---

## Accessory Overview

| Parameter | Value |
|---|---|
| **Type** | Multi-function expansion board |
| **Operating Voltage** | 5V / 3.7V Lithium Battery |
| **Charging Current** | 460mA (Max) |
| **RTC Timer Precision** | ± 1.5S/DAY (25°C) |
| **RTC Battery** | CR1220 |
| **Display** | 0.96" OLED (SSD1306, 128×64, I2C) |
| **Expandable Memory** | MicroSD card slot |
| **Grove Interfaces** | I2C ×2, UART ×1, A0/D0 ×1 |
| **Other** | Passive buzzer, user button, 5V servo connector |
| **Size** | ~Half Raspberry Pi 4 size |

### Compatible XIAO Boards

| Board | Status | Notes |
|-------|--------|-------|
| XIAO SAMD21 | ✅ | Full support |
| XIAO RP2040 | ✅ | Full support |
| XIAO nRF52840 | ✅ | Use SdFat library for SD card |
| XIAO ESP32-C3 | ✅ | Full support |
| XIAO ESP32-S3 | ✅ | Full support |
| XIAO nRF54L15 | ❌ | Different SWD pins — not compatible |
| XIAO MG24 | ❌ | Different SWD pins — not compatible |

---

## Pin Usage Diagram

```
XIAO Pin    | Accessory Function       | Protocol
------------|--------------------------|----------
D0 / A0     | Grove A0/D0 connector    | Analog/Digital
D1          | User Button              | GPIO (INPUT_PULLUP)
D2          | SD Card Chip Select (CS) | SPI
D3 / A3     | Passive Buzzer           | GPIO (can be cut via trace)
D4 / SDA    | I2C Data                 | I2C (OLED, RTC, Grove I2C)
D5 / SCL    | I2C Clock                | I2C (OLED, RTC, Grove I2C)
D8          | SPI Clock (SCK)          | SPI (MicroSD)
D9          | SPI Data In (MISO)       | SPI (MicroSD)
D10         | SPI Data Out (MOSI)      | SPI (MicroSD)
TX          | Grove UART TX            | UART
RX          | Grove UART RX            | UART
```

---

## Pin Conflict Warning

### Pins OCCUPIED by Expansion Board
- **D0/A0** — Grove A0/D0 connector
- **D1** — User button (INPUT_PULLUP)
- **D2** — SD card CS
- **D3/A3** — Passive buzzer (can be disconnected by cutting trace)
- **D4/SDA** — I2C bus (OLED, RTC, Grove I2C)
- **D5/SCL** — I2C bus (OLED, RTC, Grove I2C)
- **D8** — SPI SCK (MicroSD)
- **D9** — SPI MISO (MicroSD)
- **D10** — SPI MOSI (MicroSD)
- **TX/RX** — Grove UART connector

### Pins remaining FREE
- D6, D7

### Conflicts with other accessories
- **COB LED Driver** — conflicts on D0, D1, D2, D3, D8, D9 ❌
- **ePaper Driver Board** — conflicts on D0, D1, D2, D3, D8, D10 ❌
- **RS485 Board** — conflicts on D2 (SD CS vs enable), D4/D5 (I2C vs UART) ❌
- **CAN Bus Board** — conflicts on D8, D9, D10 (SPI) ❌
- **Grove Vision AI V2** — can share I2C bus ✅ (uses SDA/SCL)

> **Note:** The Expansion Board uses nearly all XIAO pins. It is designed as a standalone prototyping platform, not for stacking with other GPIO-heavy accessories.

---

## Power Requirements

| Parameter | Value |
|-----------|-------|
| Power Source | 5V via USB-C |
| Battery | 3.7V Li-Po (JST 2.0mm connector) |
| Charging Current | 460mA max |
| RTC Backup | CR1220 coin cell |
| Battery LED | Flashing = not charging/no battery; Solid = charging |

---

## Arduino Setup & Usage

### Required Libraries

```bash
# OLED Display:
# U8g2 library — https://github.com/olikraus/U8g2_Arduino
# Install via Arduino Library Manager: search "U8g2"

# RTC Clock:
# PCF8563 library — https://github.com/Bill2462/PCF8563-Arduino-Library
# Install via Arduino Library Manager or download ZIP

# MicroSD Card (SAMD21, RP2040, ESP32):
# SD library (built-in) — no installation needed

# MicroSD Card (nRF52840):
# SdFat library — https://github.com/greiman/SdFat
# Install via Arduino Library Manager: search "SdFat"
```

### Complete Working Example — OLED Display

```cpp
#include <Arduino.h>
#include <U8x8lib.h>
#include <Wire.h>

U8X8_SSD1306_128X64_NONAME_HW_I2C u8x8(U8X8_PIN_NONE, SCL, SDA);

void setup() {
    u8x8.begin();
    u8x8.setFlipMode(1);
}

void loop() {
    u8x8.setFont(u8x8_font_chroma48medium8_r);
    u8x8.setCursor(0, 0);
    u8x8.print("Hello World!");
}
```

### Complete Working Example — RTC Clock with OLED

```cpp
#include <Arduino.h>
#include <U8x8lib.h>
#include <PCF8563.h>
#include <Wire.h>

PCF8563 pcf;
U8X8_SSD1306_128X64_NONAME_HW_I2C u8x8(U8X8_PIN_NONE, SCL, SDA);

void setup() {
    u8x8.begin();
    u8x8.setFlipMode(1);

    Wire.begin();
    pcf.init();
    pcf.stopClock();

    // Set initial time
    pcf.setYear(20);
    pcf.setMonth(10);
    pcf.setDay(23);
    pcf.setHour(17);
    pcf.setMinut(33);
    pcf.setSecond(0);

    pcf.startClock();
}

void loop() {
    Time nowTime = pcf.getTime();

    u8x8.setFont(u8x8_font_chroma48medium8_r);
    u8x8.setCursor(0, 0);

    u8x8.print(nowTime.day);
    u8x8.print("/");
    u8x8.print(nowTime.month);
    u8x8.print("/");
    u8x8.print(nowTime.year);

    u8x8.setCursor(0, 1);
    u8x8.print(nowTime.hour);
    u8x8.print(":");
    u8x8.print(nowTime.minute);
    u8x8.print(":");
    u8x8.print(nowTime.second);

    delay(1000);
}
```

### Complete Working Example — MicroSD Card

```cpp
#include <SPI.h>
#include <SD.h>

#define SD_CS_PIN D2

void setup() {
    Serial.begin(115200);
    while (!Serial) delay(100);

    pinMode(SD_CS_PIN, OUTPUT);

    if (!SD.begin(SD_CS_PIN)) {
        Serial.println("SD card initialization failed!");
        return;
    }
    Serial.println("SD card initialized.");

    // Write a file
    File myFile = SD.open("test.txt", FILE_WRITE);
    if (myFile) {
        myFile.println("Hello from XIAO Expansion Board!");
        myFile.close();
        Serial.println("File written.");
    }

    // Read the file
    myFile = SD.open("test.txt");
    if (myFile) {
        Serial.println("File contents:");
        while (myFile.available()) {
            Serial.write(myFile.read());
        }
        myFile.close();
    }
}

void loop() {}
```

### Complete Working Example — User Button

```cpp
const int buttonPin = D1;

void setup() {
    pinMode(LED_BUILTIN, OUTPUT);
    pinMode(buttonPin, INPUT_PULLUP);
}

void loop() {
    if (digitalRead(buttonPin) == HIGH) {
        digitalWrite(LED_BUILTIN, HIGH);
    } else {
        digitalWrite(LED_BUILTIN, LOW);
    }
}
```

### Complete Working Example — Buzzer

```cpp
int speakerPin = D3;  // A3

void setup() {
    pinMode(speakerPin, OUTPUT);
}

void loop() {
    // Simple tone
    tone(speakerPin, 1000, 200);  // 1kHz for 200ms
    delay(500);
    tone(speakerPin, 1500, 200);  // 1.5kHz for 200ms
    delay(500);
}
```

---

## TinyGo Setup & Usage

### TinyGo OLED Display Example

```go
package main

import (
    "machine"
    "image/color"

    "tinygo.org/x/drivers/ssd1306"
)

func main() {
    machine.I2C0.Configure(machine.I2CConfig{
        SDA:       machine.SDA_PIN,
        SCL:       machine.SCL_PIN,
        Frequency: 400000,
    })

    display := ssd1306.NewI2C(machine.I2C0)
    display.Configure(ssd1306.Config{
        Address: 0x3C,
        Width:   128,
        Height:  64,
    })

    display.ClearDisplay()

    // Draw a pixel pattern
    for x := int16(0); x < 128; x += 4 {
        for y := int16(0); y < 64; y += 4 {
            display.SetPixel(x, y, color.RGBA{R: 255})
        }
    }
    display.Display()

    println("OLED initialized (TinyGo)")
    select {} // Block forever
}
```

### TinyGo User Button Example

```go
package main

import (
    "machine"
    "time"
)

func main() {
    button := machine.D1
    button.Configure(machine.PinConfig{Mode: machine.PinInputPullup})

    led := machine.LED
    led.Configure(machine.PinConfig{Mode: machine.PinOutput})

    for {
        if button.Get() {
            led.High()
        } else {
            led.Low()
        }
        time.Sleep(10 * time.Millisecond)
    }
}
```

### TinyGo Buzzer Example

```go
package main

import (
    "machine"
    "time"
)

func main() {
    buzzer := machine.D3
    buzzer.Configure(machine.PinConfig{Mode: machine.PinOutput})

    // Simple beep pattern using manual toggling
    for {
        // 1kHz tone for 200ms (toggle every 500µs)
        for i := 0; i < 200; i++ {
            buzzer.High()
            time.Sleep(500 * time.Microsecond)
            buzzer.Low()
            time.Sleep(500 * time.Microsecond)
        }
        time.Sleep(500 * time.Millisecond)
    }
}
```

> **Note:** For TinyGo SD card access, check `tinygo.org/x/drivers` for available SPI SD card drivers. The PCF8563 RTC may require a custom I2C driver in TinyGo.

---

## Communication Protocol Details

### I2C Bus (OLED + RTC + Grove)

| Parameter | Value |
|-----------|-------|
| SDA Pin | D4 |
| SCL Pin | D5 |
| OLED Address | 0x3C (SSD1306) |
| RTC Address | 0x51 (PCF8563) |
| Speed | Up to 400kHz |

### SPI Bus (MicroSD)

| Parameter | Value |
|-----------|-------|
| CS Pin | D2 |
| SCK Pin | D8 |
| MISO Pin | D9 |
| MOSI Pin | D10 |

### Grove Connectors

| Connector | Type | XIAO Pins |
|-----------|------|-----------|
| Grove I2C ×2 | I2C | SDA (D4), SCL (D5) |
| Grove UART ×1 | UART | TX, RX |
| Grove A0/D0 ×1 | Analog/Digital | A0/D0 |

---

## Common Gotchas / Notes

1. **⚠️ Plug XIAO into the middle of the two female header connectors** — Incorrect placement will damage both boards.
2. **⚠️ Plug XIAO first, then connect USB-C cable.**
3. **Buzzer on D3/A3** — Connected by default. Can be disconnected by cutting a trace on the board if D3 is needed for other purposes.
4. **SD card CS is D2** — This is a common conflict point with other accessories.
5. **OLED and RTC share I2C** — Both are on the same I2C bus (SDA/SCL). No address conflict (OLED=0x3C, RTC=0x51).
6. **nRF52840 SD card** — Use the SdFat library instead of the built-in SD library for nRF52840.
7. **Battery charging LED** — Flashing = not charging or no battery; Solid = charging.
8. **CircuitPython support** — The board supports CircuitPython with MicroSD for library storage.
9. **5V servo connector** — Available for direct servo connection without external power.
10. **SWD debug pins** — Broken out as male headers for debugging.
11. **Not compatible with nRF54L15 or MG24** — These boards have different SWD pin layouts.

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/Seeeduino-XIAO-Expansion-Board/
- **Product Page:** https://www.seeedstudio.com/Seeeduino-XIAO-Expansion-board-p-4746.html
- **U8g2 Library:** https://github.com/olikraus/U8g2_Arduino
- **PCF8563 Library:** https://github.com/Bill2462/PCF8563-Arduino-Library
- **SdFat Library:** https://github.com/greiman/SdFat
