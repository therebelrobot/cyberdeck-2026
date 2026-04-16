---
name: xiao-mg24-arduino
description: >
  Provides comprehensive pinout reference, board specifications, and Arduino C++ development guide
  for the Seeed Studio XIAO MG24 microcontroller. Use when writing Arduino firmware for the
  XIAO MG24, wiring peripherals, or configuring pins. Keywords: XIAO, MG24, EFR32MG24, Arduino,
  Silicon Labs, ARM Cortex-M33, Zigbee, Thread, Matter, BLE 5.3, pinout, GPIO, I2C, SPI, UART,
  analog, digital, PWM, battery, deep sleep, 802.15.4.
---

# XIAO MG24 — Arduino Development Guide

Provides comprehensive reference for developing Arduino C++ firmware for the Seeed Studio XIAO MG24.

## When to Use

- Writing Arduino C++ firmware targeting the XIAO MG24
- Looking up XIAO MG24 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO MG24 and need GPIO reference
- Configuring I2C, SPI, UART, Zigbee, Thread, Matter, or BLE on the XIAO MG24 in Arduino

## When NOT to Use

- For TinyGo development on the XIAO MG24 → use the `XIAO-MG24-TinyGo` skill
- For the XIAO MG24 Sense (with IMU/microphone) → use the `XIAO-MG24-Sense-Arduino` skill
- For other XIAO boards → use the corresponding board skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Silicon Labs EFR32MG24 |
| **Architecture** | ARM Cortex-M33, 32-bit RISC |
| **Clock Speed** | 78 MHz |
| **Flash** | 1536 KB (on-chip) + 4 MB (onboard) |
| **RAM** | 256 KB |
| **AI/ML** | Built-in AI/ML hardware accelerator (MVP) |
| **ADC** | 12-bit, 1 Msps |
| **Wireless** | BLE 5.3, Zigbee, Thread, Matter, 802.15.4 |
| **USB** | USB Type-C (via SAMD11 serial bridge) |
| **Operating Voltage** | 3.3V logic / 5V USB input |
| **Supply Voltage** | 5V (USB) or 3.7V (battery) |
| **Dimensions** | 21 × 17.8 mm |
| **Working Temp** | -20°C to 70°C |
| **GPIO Count** | 22 (all PWM-capable) |
| **Analog Pins** | 19 |
| **Low Power** | 1.95 μA (typical) |
| **Normal** | 6.71 mA (typical) |
| **Sleep** | 1.91 mA (typical) |
| **Antenna** | 2.4 GHz ceramic antenna (4.97 dBi) + U.FL connector |
| **Battery** | Supports LiPo charge/discharge (3.7V BAT input) |
| **TX Power** | Up to +19.5 dBm |
| **RX Sensitivity** | -105.4 dBm (250 kbps DSSS) |

---

## Pinout Diagram

```
                XIAO MG24 (Top View)
                ┌─────────────────┐
                │    [USB-C]      │
       D0/A0 ──┤ PC00      PC07 ├── D7/A7 (RX0)
       D1/A1 ──┤ PC01      PC06 ├── D6/A6 (TX0)
       D2/A2 ──┤ PC02      PC05 ├── D5/A5 (SCL)
       D3/A3 ──┤ PC03      PC04 ├── D4/A4 (SDA)
         GND ──┤                 ├── D10/A10 (MOSI0)
          5V ──┤                 ├── D9/A9 (MISO0)
         3V3 ──┤                 ├── D8/A8 (SCK0)
                └─────────────────┘
  Bottom pads: D11-D18 (accessible via soldering)
  Ceramic antenna + U.FL connector on top edge
```

---

## Pin Reference Table

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|--------|-----|-----|-----|------|-------|
| D0  | PC00     | ✓       | ADC    | ✓   | —   | —   | —    | — |
| D1  | PC01     | ✓       | ADC    | ✓   | —   | —   | —    | — |
| D2  | PC02     | ✓       | ADC    | ✓   | —   | —   | —    | — |
| D3  | PC03     | ✓       | ADC    | ✓   | —   | **SPI** | — | — |
| D4  | PC04     | ✓       | ADC    | ✓   | **SDA** | — | — | — |
| D5  | PC05     | ✓       | ADC    | ✓   | **SCL** | — | — | — |
| D6  | PC06     | ✓       | ADC    | ✓   | —   | —   | **TX0** | — |
| D7  | PC07     | ✓       | ADC    | ✓   | —   | —   | **RX0** | — |
| D8  | PA03     | ✓       | ADC    | ✓   | —   | **SCK0** | — | — |
| D9  | PA04     | ✓       | ADC    | ✓   | —   | **MISO0** | — | — |
| D10 | PA05     | ✓       | ADC    | ✓   | —   | **MOSI0** | — | — |
| D11 | PA09     | ✓       | ADC    | ✓   | —   | —   | RX1 | SAMD11_TX |
| D12 | PA08     | ✓       | ADC    | ✓   | —   | —   | TX1 | SAMD11_RX |
| D13 | PB02     | ✓       | ADC    | ✓   | SCL1 | — | — | — |
| D14 | PB03     | ✓       | ADC    | ✓   | SDA1 | — | — | — |
| D15 | PB00     | ✓       | ADC    | ✓   | —   | **MOSI1** | — | — |
| D16 | PB01     | ✓       | ADC    | ✓   | —   | **MISO1** | — | — |
| D17 | PA00     | ✓       | ADC    | ✓   | —   | **SCK1** | — | — |
| D18 | PD02     | ✓       | ADC    | ✓   | —   | —   | — | Csn |

### Internal / Special Pins

| Name | Chip Pin | Description |
|------|----------|-------------|
| USER_LED | PA07 | User LED (Yellow) |
| CHARGE_LED | VBUS | Charge LED (Red) |
| ADC_BAT | PD04 | Read battery voltage |
| RF Switch Port | PB04 | Switch onboard/UFL antenna |
| RF Switch Power | PB05 | RF power control |
| Reset | RESET | Reset button |

---

## Arduino Setup

### Board Manager URL

```
https://siliconlabs.github.io/arduino/package_arduinosilabs_index.json
```

### Installation

1. Open Arduino IDE → **File** → **Preferences**
2. Add the URL above to **Additional Board Manager URLs**
3. Open **Tools** → **Board** → **Board Manager**
4. Search for **"Silicon Labs"** and install the **Silicon Labs** boards package
5. Select **Tools** → **Board** → **Silicon Labs** → **XIAO MG24**

### Arduino CLI Setup

```bash
# Add board index
arduino-cli config add board_manager.additional_urls \
  https://siliconlabs.github.io/arduino/package_arduinosilabs_index.json

# Update index and install core
arduino-cli core update-index
arduino-cli core install SiliconLabs:silabs

# Compile
arduino-cli compile --fqbn SiliconLabs:silabs:xiao_mg24 ./sketch

# Upload (replace /dev/ttyACM0 with your port)
arduino-cli upload --fqbn SiliconLabs:silabs:xiao_mg24 -p /dev/ttyACM0 ./sketch
```

### Board FQBN

```
SiliconLabs:silabs:xiao_mg24
```

### Example: Blink LED (Arduino)

```cpp
// Built-in User LED is on PA07 (Yellow)
// LED_BUILTIN should be defined in the board package

void setup() {
    pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
    digitalWrite(LED_BUILTIN, HIGH);
    delay(500);
    digitalWrite(LED_BUILTIN, LOW);
    delay(500);
}
```

### Example: Analog Read

```cpp
void setup() {
    Serial.begin(115200);
    analogReadResolution(12); // 12-bit ADC (0-4095)
}

void loop() {
    int value = analogRead(A0); // D0 / PC00
    Serial.print("ADC Value: ");
    Serial.println(value);
    delay(100);
}
```

### Example: BLE Peripheral

```cpp
#include <ArduinoBLE.h>

BLEService ledService("19b10000-e8f2-537e-4f6c-d104768a1214");
BLEByteCharacteristic switchCharacteristic("19b10001-e8f2-537e-4f6c-d104768a1214",
    BLERead | BLEWrite);

void setup() {
    Serial.begin(115200);
    pinMode(LED_BUILTIN, OUTPUT);

    if (!BLE.begin()) {
        Serial.println("BLE init failed!");
        while (1);
    }

    BLE.setLocalName("XIAO-MG24");
    BLE.setAdvertisedService(ledService);
    ledService.addCharacteristic(switchCharacteristic);
    BLE.addService(ledService);
    switchCharacteristic.writeValue(0);
    BLE.advertise();

    Serial.println("BLE advertising started");
}

void loop() {
    BLEDevice central = BLE.central();
    if (central) {
        while (central.connected()) {
            if (switchCharacteristic.written()) {
                if (switchCharacteristic.value()) {
                    digitalWrite(LED_BUILTIN, HIGH);
                } else {
                    digitalWrite(LED_BUILTIN, LOW);
                }
            }
        }
    }
}
```

---

## Communication Protocols

### I2C

- **SDA:** D4 (PC04)
- **SCL:** D5 (PC05)
- **Secondary — SDA:** D14 (PB03), **SCL:** D13 (PB02)
- **Arduino object:** `Wire`

```cpp
#include <Wire.h>

void setup() {
    Wire.begin(); // Uses default SDA=D4, SCL=D5
    // Wire.setClock(400000); // Optional: 400 kHz fast mode
}

void loop() {
    Wire.beginTransmission(0x3C);
    Wire.write(0x00);
    Wire.endTransmission();

    Wire.requestFrom(0x3C, 1);
    if (Wire.available()) {
        uint8_t data = Wire.read();
    }
}
```

### SPI

- **SCK:** D8 (PA03)
- **MISO:** D9 (PA04)
- **MOSI:** D10 (PA05)
- **CS:** Any GPIO (user-defined)
- **Secondary — SCK:** D17 (PA00), **MISO:** D16 (PB01), **MOSI:** D15 (PB00)
- **Arduino object:** `SPI`

```cpp
#include <SPI.h>

const int CS_PIN = D0; // Use any available GPIO

void setup() {
    pinMode(CS_PIN, OUTPUT);
    digitalWrite(CS_PIN, HIGH);
    SPI.begin();
}

void loop() {
    SPI.beginTransaction(SPISettings(4000000, MSBFIRST, SPI_MODE0));
    digitalWrite(CS_PIN, LOW);
    uint8_t result = SPI.transfer(0x00);
    digitalWrite(CS_PIN, HIGH);
    SPI.endTransaction();
}
```

### UART

- **TX:** D6 (PC06)
- **RX:** D7 (PC07)
- **Secondary — TX:** D12 (PA08), **RX:** D11 (PA09)
- **USB Serial:** `Serial` (via SAMD11 bridge)
- **Hardware UART:** `Serial1`

```cpp
void setup() {
    Serial.begin(115200);    // USB serial (via SAMD11 bridge)
    Serial1.begin(9600);     // Hardware UART on D6(TX)/D7(RX)
}

void loop() {
    if (Serial1.available()) {
        char c = Serial1.read();
        Serial.print(c);
    }
}
```

### Zigbee / Thread / Matter

The XIAO MG24 supports Zigbee, Thread, and Matter protocols at the hardware level. These require the Silicon Labs Gecko SDK or compatible Arduino libraries:

```cpp
// Zigbee, Thread, and Matter support requires the Silicon Labs
// Arduino core with the appropriate protocol stack.
// Refer to the Silicon Labs Arduino documentation for examples:
// https://github.com/SiliconLabs/arduino

// Basic Matter example structure:
// #include <Matter.h>
// MatterOnOffLight myLight;
// void setup() {
//     Matter.begin();
//     myLight.begin();
// }
```

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **5V output:** From USB VBUS
- **Max per-pin current:** Refer to EFR32MG24 datasheet (typically 20 mA per GPIO)
- **Normal operation:** ~6.71 mA
- **Sleep:** ~1.91 mA
- **Low power:** ~1.95 μA

### Battery Support

- **Battery pad:** Solder LiPo battery to BAT+ and BAT- pads on the bottom
- **Charge LED:** Red LED indicates charging status
- **Input:** 3.7V LiPo battery
- **Battery voltage:** Read via ADC_BAT (PD04)

```cpp
// Read battery voltage
void setup() {
    Serial.begin(115200);
}

void loop() {
    int raw = analogRead(ADC_BAT); // PD04
    float voltage = raw * (3.3 / 4095.0) * 2.0; // Voltage divider factor
    Serial.print("Battery: ");
    Serial.print(voltage);
    Serial.println("V");
    delay(1000);
}
```

### Deep Sleep

⚠ **WARNING: Deep sleep can brick the XIAO MG24!**

Entering deep sleep mode (EM4) on the EFR32MG24 can make the board unresponsive. The SAMD11 serial bridge cannot wake the main MCU from EM4.

**Recovery procedure (double-tap reset):**
1. Press RESET quickly twice within 500ms
2. This enters the bootloader mode
3. Re-flash firmware to recover

```cpp
// ⚠ Use EM2 (sleep) instead of EM4 (deep sleep) to avoid bricking
// EM2 preserves RAM and allows wake-up from peripherals

#include <Arduino.h>

void setup() {
    Serial.begin(115200);
    Serial.println("Going to EM2 sleep...");
    delay(1000);

    // Use EM2 sleep mode (safe)
    // Refer to Silicon Labs Arduino core documentation
    // for proper sleep mode API
}

void loop() {
    // Application code
}
```

---

## Special Features

### AI/ML Hardware Accelerator (MVP)

The EFR32MG24 includes a Matrix Vector Processor (MVP) for on-device AI/ML inference. Access through the Silicon Labs TensorFlow Lite Micro integration:

```cpp
// AI/ML inference using the MVP accelerator
// Requires Silicon Labs TFLite Micro library
// See: https://github.com/SiliconLabs/tflite-micro
```

### All 22 GPIOs Support PWM

Every GPIO pin on the XIAO MG24 supports PWM output:

```cpp
void setup() {
    // PWM on any pin
    analogWrite(D0, 128); // 50% duty cycle
}
```

### 19 Analog Input Pins

The XIAO MG24 has 19 analog-capable pins with 12-bit ADC resolution at 1 Msps — the most analog pins of any XIAO board.

### Dual Antenna Support

- Onboard 2.4 GHz ceramic antenna (4.97 dBi)
- U.FL connector for external antenna
- Software-switchable via RF Switch (PB04/PB05)

### Security Features

- Hardware Cryptographic Acceleration
- True Random Number Generator
- ARM TrustZone
- Secure Boot
- Secure Vault (Secure Debug Unlock)

---

## Common Gotchas / Notes

1. **Deep sleep bricks the board** — EM4 deep sleep makes the board unresponsive; use EM2 instead; double-tap reset to recover
2. **No BOOT button** — Recovery uses escape pin (PC1 pulled LOW) instead of a boot button
3. **SAMD11 serial bridge** — USB is handled by a SAMD11 chip, not native USB on the EFR32MG24
4. **All pins are analog** — 19 of 22 GPIO pins support ADC (12-bit, 1 Msps)
5. **All pins support PWM** — All 22 GPIO pins can output PWM
6. **Bottom pads D11-D18** — 8 additional pins accessible only via soldering on the bottom of the board
7. **D11/D12 shared with SAMD11** — These UART pins are shared with the USB serial bridge
8. **3.3V logic only** — Do NOT connect 5V signals directly to GPIO pins
9. **Dual SPI buses** — SPI0 (D8-D10) and SPI1 (D15-D17) available
10. **Dual UART buses** — UART0 (D6/D7) and UART1 (D11/D12, shared with SAMD11)
11. **Silicon Labs Arduino core** — Uses a different board package than ESP32 or SAMD boards

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/xiao_mg24_getting_started/
- **Board package (Silicon Labs):** https://github.com/SiliconLabs/arduino
- **EFR32MG24 Datasheet:** https://www.silabs.com/documents/public/data-sheets/efr32mg24-datasheet.pdf
- **Gecko SDK:** https://github.com/SiliconLabs/gecko_sdk
- **Arduino-SiLabs docs:** https://siliconlabs.github.io/arduino/
- **Schematic:** https://files.seeedstudio.com/wiki/XIAO_MG24/res/XIAO_MG24_Schematic.pdf
