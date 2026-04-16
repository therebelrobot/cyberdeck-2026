---
name: xiao-accessory-loggerhat
description: >
  Provides comprehensive reference for using the XIAO Logger HAT with Seeed Studio XIAO
  microcontrollers. Covers I2C sensors (SHT40 temperature/humidity, BH1750 light, PCF8563 RTC),
  battery voltage ADC monitoring, and GPIO-powered sensor enable. Includes Arduino and TinyGo
  setup, wiring, pin usage, and code examples. Use when integrating the Logger HAT for
  environmental data logging, RTC timekeeping, or battery monitoring on any XIAO board.
  Keywords: XIAO, Logger HAT, SHT40, BH1750, PCF8563, RTC, temperature, humidity, light,
  I2C, ADC, battery, data logging, sensor, environmental.
---

# XIAO Logger HAT — XIAO Accessory Guide

Provides comprehensive reference for using the XIAO Logger HAT with Seeed Studio XIAO microcontrollers.

## When to Use

- Integrating the XIAO Logger HAT for temperature, humidity, light, or RTC functionality
- Looking up which XIAO pins the Logger HAT occupies
- Writing Arduino or TinyGo firmware to read SHT40, BH1750, or PCF8563 sensors
- Configuring battery voltage monitoring via ADC
- Checking pin conflicts with other XIAO accessories

## When NOT to Use

- For standalone XIAO board pinouts → use the corresponding board skill (e.g., `XIAO-ESP32C3-Arduino`)
- For other XIAO accessories → use the corresponding accessory skill

---

## Accessory Overview

| Parameter | Value |
|---|---|
| **Type** | Environmental sensor HAT (temperature, humidity, light, RTC) |
| **SKU** | 114993446 |
| **Interface** | I2C (sensors) + ADC (battery) + GPIO (enable) |
| **Sensors** | SHT40 (temp/humidity), BH1750 (light), PCF8563 (RTC) |
| **Dimensions** | 21 × 17.8 mm |
| **Operating Voltage** | 2.4V–3.6V |
| **Active Current** | ~500µA |
| **Idle Current** | ~0.25µA (GPIO-powered sensors allow near-zero sleep) |
| **Operating Temperature** | -40°C to 85°C |
| **Battery** | Compatible with EEMB 3.7V 500mAh LiPo (not included) |

### Sensor Specifications

| Sensor | Parameter | Value |
|--------|-----------|-------|
| SHT40 | Temperature accuracy | ±0.2°C |
| SHT40 | Humidity accuracy | ±1.8%RH |
| SHT40 | Read time | ~2ms |
| BH1750 | Read time | ~120ms |
| PCF8563 | Current consumption | <1µA |
| PCF8563 | Drift | ~7 minutes/year |

### Compatible XIAO Boards

| XIAO Board | I2C | INT | ADC | EN | Battery |
|------------|-----|-----|-----|-----|---------|
| XIAO SAMD21 | ✅ | ✅ | ✅ | ✅ | ❌ |
| XIAO nRF52840 (Sense) | ✅ | ✅ | ✅ | ✅ | ✅ |
| XIAO RP2040 | ✅ | ✅ | ✅ | ✅ | ❌ |
| XIAO RP2350 | ✅ | ✅ | ✅ | ✅ | ⚠️ not aligned |
| XIAO ESP32C3 | ✅ | ✅ | ✅ | ✅ | ✅ |
| XIAO ESP32S3 (Sense) | ✅ | ✅ | ✅ | ✅ | ✅ |
| XIAO ESP32C6 | ✅ | ✅ | ✅ | ✅ | ⚠️ not aligned |
| XIAO RA4M1 | ✅ | ✅ | ✅ | ✅ | ⚠️ not aligned |
| XIAO MG24 (Sense) | ✅ | ✅ | ✅ | ✅ | ⚠️ not aligned |
| XIAO nRF54L15 | ❌ | ❌ | ❌ | ❌ | ❌ (Arduino not supported) |

---

## Pin Usage Diagram

```
XIAO Pin    | Accessory Function       | Protocol
------------|--------------------------|----------
D4 (SDA)    | I2C Data                 | I2C
D5 (SCL)    | I2C Clock                | I2C
D2          | RTC Interrupt (wakeup)   | GPIO (INT)
A0          | Battery Voltage Monitor  | ADC
D1          | Sensor Enable            | GPIO (EN)
```

---

## Pin Conflict Warning

### Pins OCCUPIED by Logger HAT
- **D1** — Sensor enable (GPIO)
- **D2** — RTC interrupt
- **D4 (SDA)** — I2C data
- **D5 (SCL)** — I2C clock
- **A0** — Battery ADC

### Pins remaining FREE
- D0, D3, D6, D7, D8, D9, D10

### Conflicts with other accessories
- **ePaper Breakout** — conflicts on D1 and D5 ❌
- **mmWave 24GHz Sensor** — conflicts on D2 ❌
- **L76K GNSS** — no conflict ✅ (uses D6/D7)
- **CAN Bus** — no conflict ✅ (uses D7–D10)
- **reSpeaker Lite** — no conflict ✅ (separate board)

> **Note:** Other I2C devices CAN share the D4/D5 bus — I2C supports multiple devices on the same bus as long as addresses don't conflict.

---

## Arduino Setup & Usage

### Required Libraries

```bash
# Via Arduino Library Manager:
# - Search "Sensirion SHT4x" → install
# - Search "BH1750" → install (by Christopher Laws)
# - Search "PCF8563" → install (or use RTClib)
```

### I2C Addresses

| Sensor | I2C Address |
|--------|-------------|
| SHT40 | 0x44 |
| BH1750 | 0x23 (ADDR LOW) or 0x5C (ADDR HIGH) |
| PCF8563 | 0x51 |

### Initialization

```cpp
#include <Wire.h>
#include <SensirionI2CSht4x.h>
#include <BH1750.h>

// Sensor enable pin
const int EN_PIN = D1;

SensirionI2CSht4x sht4x;
BH1750 lightMeter;

void setup() {
    Serial.begin(115200);

    // Enable sensors via GPIO
    pinMode(EN_PIN, OUTPUT);
    digitalWrite(EN_PIN, HIGH);
    delay(10); // Allow sensors to power up

    Wire.begin();

    // Initialize SHT40
    sht4x.begin(Wire);

    // Initialize BH1750
    lightMeter.begin(BH1750::CONTINUOUS_HIGH_RES_MODE);
}
```

### Complete Working Example

```cpp
#include <Wire.h>
#include <SensirionI2CSht4x.h>
#include <BH1750.h>

const int EN_PIN = D1;

SensirionI2CSht4x sht4x;
BH1750 lightMeter;

void setup() {
    Serial.begin(115200);
    while (!Serial) delay(100);

    // Enable sensors
    pinMode(EN_PIN, OUTPUT);
    digitalWrite(EN_PIN, HIGH);
    delay(10);

    Wire.begin();
    sht4x.begin(Wire);
    lightMeter.begin(BH1750::CONTINUOUS_HIGH_RES_MODE);

    Serial.println("Logger HAT initialized");
}

void loop() {
    // Read temperature and humidity
    float temperature, humidity;
    uint16_t error = sht4x.measureHighPrecision(temperature, humidity);
    if (error == 0) {
        Serial.print("Temp: ");
        Serial.print(temperature);
        Serial.print("°C  Humidity: ");
        Serial.print(humidity);
        Serial.println("%RH");
    }

    // Read light level
    float lux = lightMeter.readLightLevel();
    Serial.print("Light: ");
    Serial.print(lux);
    Serial.println(" lx");

    // Read battery voltage (if supported)
    int adcValue = analogRead(A0);
    float voltage = adcValue * (3.3 / 4095.0) * 2; // Voltage divider factor
    Serial.print("Battery: ");
    Serial.print(voltage);
    Serial.println("V");

    Serial.println("---");
    delay(2000);
}
```

### RTC Deep Sleep Wakeup Example

```cpp
#include <Wire.h>
#include <PCF8563.h>

const int INT_PIN = D2;

PCF8563 rtc;

void setup() {
    Serial.begin(115200);
    Wire.begin();

    rtc.init();

    // Set alarm for 60 seconds from now
    // Configure RTC interrupt on D2 for deep sleep wakeup
    pinMode(INT_PIN, INPUT_PULLUP);

    Serial.println("RTC configured for wakeup");
}
```

---

## TinyGo Setup & Usage

### Available Drivers

TinyGo has community drivers for all three sensors:

```bash
# SHT4x driver
go get tinygo.org/x/drivers/sht4x

# BH1750 driver
go get tinygo.org/x/drivers/bh1750

# PCF8563 — use generic I2C; no dedicated TinyGo driver yet
```

### TinyGo Example

```go
package main

import (
    "fmt"
    "machine"
    "time"

    "tinygo.org/x/drivers/bh1750"
    "tinygo.org/x/drivers/sht4x"
)

func main() {
    // Enable sensors
    en := machine.D1
    en.Configure(machine.PinConfig{Mode: machine.PinOutput})
    en.High()
    time.Sleep(10 * time.Millisecond)

    // Configure I2C
    i2c := machine.I2C0
    i2c.Configure(machine.I2CConfig{
        SDA:       machine.SDA_PIN, // D4
        SCL:       machine.SCL_PIN, // D5
        Frequency: 400000,
    })

    // Initialize SHT40
    sht := sht4x.New(i2c)
    sht.Configure()

    // Initialize BH1750
    light := bh1750.New(i2c)
    light.Configure()

    for {
        temp, hum, err := sht.ReadTemperatureHumidity()
        if err == nil {
            fmt.Printf("Temp: %.1f°C  Humidity: %.1f%%RH\n",
                float32(temp)/1000.0, float32(hum)/1000.0)
        }

        lux := light.Illuminance()
        fmt.Printf("Light: %d lx\n", lux)

        time.Sleep(2 * time.Second)
    }
}
```

> **Note:** PCF8563 RTC does not have a dedicated TinyGo driver. Use raw I2C reads to address `0x51` for RTC functionality in TinyGo.

---

## Communication Protocol Details

### I2C Bus Configuration

- **Bus:** I2C0 (default Wire)
- **SDA:** D4
- **SCL:** D5
- **Speed:** 100kHz (standard) or 400kHz (fast mode)
- **Pull-ups:** Provided on the Logger HAT PCB

### I2C Device Addresses

| Device | Address | R/W |
|--------|---------|-----|
| SHT40 | 0x44 | Temperature & humidity |
| BH1750 | 0x23 | Ambient light (default ADDR LOW) |
| PCF8563 | 0x51 | Real-time clock |

### ADC Battery Monitoring

- **Pin:** A0
- **Voltage divider:** Enabled via GPIO (check schematic)
- **Formula:** `V_battery = ADC_reading × (3.3 / ADC_MAX) × 2`
- **ADC resolution:** Board-dependent (12-bit on ESP32, 10-bit on SAMD21)

---

## Common Gotchas / Notes

1. **Limited documentation** — No wiki page; documentation is on the product page and GitHub repo only
2. **Battery compatibility varies by board:**
   - SAMD21 and RP2040 do NOT support battery charging — do not use battery monitoring
   - nRF52840, ESP32C3, ESP32S3 fully support battery monitoring with 2-pin header
   - RP2350, ESP32C6, RA4M1, MG24 support charging but need additional wiring (not aligned)
3. **Sensor enable pin (D1)** — Sensors are GPIO-powered; set D1 HIGH to enable, LOW to disable for ultra-low-power sleep
4. **I2C bus sharing** — Other I2C devices can share D4/D5 as long as addresses don't conflict with 0x44, 0x23, or 0x51
5. **RTC drift** — PCF8563 drifts ~7 minutes/year; re-sync periodically if precision matters
6. **nRF54L15** — Not compatible (Arduino not supported for this board)

---

## Reference Links

- **Product Page:** https://www.seeedstudio.com/XIAO-LOG-p-6341.html
- **GitHub Repository:** Linked from product page
- **SHT40 Datasheet:** https://sensirion.com/products/catalog/SHT40
- **BH1750 Datasheet:** https://www.mouser.com/datasheet/2/348/bh1750fvi-e-186247.pdf
- **PCF8563 Datasheet:** https://www.nxp.com/docs/en/data-sheet/PCF8563.pdf
