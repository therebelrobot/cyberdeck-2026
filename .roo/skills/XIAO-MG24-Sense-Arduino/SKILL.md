---
name: xiao-mg24-sense-arduino
description: >
  Provides comprehensive pinout reference, board specifications, and Arduino C++ development guide
  for the Seeed Studio XIAO MG24 Sense microcontroller. Use when writing Arduino firmware for the
  XIAO MG24 Sense, wiring peripherals, or configuring pins. Keywords: XIAO, MG24, Sense, EFR32MG24,
  Arduino, Silicon Labs, ARM Cortex-M33, Zigbee, Thread, Matter, BLE 5.3, IMU, microphone, pinout,
  GPIO, I2C, SPI, UART, analog, digital, PWM, battery, deep sleep, 802.15.4.
---

# XIAO MG24 Sense — Arduino Development Guide

Provides comprehensive reference for developing Arduino C++ firmware for the Seeed Studio XIAO MG24 Sense.

## When to Use

- Writing Arduino C++ firmware targeting the XIAO MG24 Sense
- Looking up XIAO MG24 Sense pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO MG24 Sense and need GPIO reference
- Working with the onboard IMU or analog microphone on the MG24 Sense in Arduino

## When NOT to Use

- For TinyGo development on the XIAO MG24 Sense → use the `XIAO-MG24-Sense-TinyGo` skill
- For the XIAO MG24 (without sensors) → use the `XIAO-MG24-Arduino` skill
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
| **Microphone** | 1× Onboard Analog Microphone |
| **IMU** | 1× Onboard 6-Axis IMU (Accelerometer + Gyroscope) |

---

## Pinout Diagram

```
            XIAO MG24 Sense (Top View)
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
  Onboard: Analog Microphone + 6-Axis IMU
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

> **Note:** The MG24 and MG24 Sense share the same board selection in Arduino IDE.

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

### Example: Read IMU Data

```cpp
#include <Wire.h>

// 6-Axis IMU is connected via I2C
// Check the specific IMU model's I2C address and register map

void setup() {
    Serial.begin(115200);
    Wire.begin(); // SDA=D4, SCL=D5

    // Initialize IMU
    // Refer to the IMU datasheet for register configuration
    Serial.println("IMU initialized");
}

void loop() {
    // Read accelerometer and gyroscope data
    // Implementation depends on the specific IMU driver library
    delay(100);
}
```

### Example: Read Analog Microphone

```cpp
void setup() {
    Serial.begin(115200);
    analogReadResolution(12); // 12-bit ADC
}

void loop() {
    // Read the analog microphone output
    // The microphone pin mapping depends on the board package
    // Refer to the Silicon Labs Arduino core documentation
    int micValue = analogRead(A0); // Replace with actual mic pin
    Serial.println(micValue);
    delay(10);
}
```

### Example: BLE Peripheral

```cpp
#include <ArduinoBLE.h>

BLEService sensorService("19b10000-e8f2-537e-4f6c-d104768a1214");
BLEIntCharacteristic imuCharacteristic("19b10001-e8f2-537e-4f6c-d104768a1214",
    BLERead | BLENotify);

void setup() {
    Serial.begin(115200);

    if (!BLE.begin()) {
        Serial.println("BLE init failed!");
        while (1);
    }

    BLE.setLocalName("XIAO-MG24-Sense");
    BLE.setAdvertisedService(sensorService);
    sensorService.addCharacteristic(imuCharacteristic);
    BLE.addService(sensorService);
    BLE.advertise();

    Serial.println("BLE advertising started");
}

void loop() {
    BLEDevice central = BLE.central();
    if (central) {
        while (central.connected()) {
            // Read IMU and send via BLE
            // imuCharacteristic.writeValue(imuData);
            delay(100);
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
- **Note:** The onboard IMU uses the I2C bus

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

const int CS_PIN = D0;

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

The XIAO MG24 Sense supports Zigbee, Thread, and Matter protocols at the hardware level:

```cpp
// Zigbee, Thread, and Matter support requires the Silicon Labs
// Arduino core with the appropriate protocol stack.
// Refer to the Silicon Labs Arduino documentation for examples:
// https://github.com/SiliconLabs/arduino
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
void setup() {
    Serial.begin(115200);
}

void loop() {
    int raw = analogRead(ADC_BAT); // PD04
    float voltage = raw * (3.3 / 4095.0) * 2.0;
    Serial.print("Battery: ");
    Serial.print(voltage);
    Serial.println("V");
    delay(1000);
}
```

### Deep Sleep

⚠ **WARNING: Deep sleep can brick the XIAO MG24 Sense!**

Entering deep sleep mode (EM4) on the EFR32MG24 can make the board unresponsive. The SAMD11 serial bridge cannot wake the main MCU from EM4.

**Recovery procedure (double-tap reset):**
1. Press RESET quickly twice within 500ms
2. This enters the bootloader mode
3. Re-flash firmware to recover

```cpp
// ⚠ Use EM2 (sleep) instead of EM4 (deep sleep) to avoid bricking
// EM2 preserves RAM and allows wake-up from peripherals
```

---

## Special Features (Sense Variant)

### Onboard Analog Microphone

The XIAO MG24 Sense includes an onboard analog microphone for audio capture, sound detection, and voice-triggered applications. Combined with the MVP AI/ML accelerator, it enables on-device audio classification.

### Onboard 6-Axis IMU

The Sense variant includes a 6-axis IMU (accelerometer + gyroscope) connected via I2C. Useful for motion detection, gesture recognition, and orientation tracking.

### AI/ML Hardware Accelerator (MVP)

The EFR32MG24 includes a Matrix Vector Processor (MVP) for on-device AI/ML inference — ideal for processing IMU and microphone data locally:

```cpp
// AI/ML inference using the MVP accelerator
// Requires Silicon Labs TFLite Micro library
// See: https://github.com/SiliconLabs/tflite-micro
```

### All 22 GPIOs Support PWM

Every GPIO pin supports PWM output:

```cpp
void setup() {
    analogWrite(D0, 128); // 50% duty cycle on any pin
}
```

### 19 Analog Input Pins

19 analog-capable pins with 12-bit ADC resolution at 1 Msps.

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
4. **Same board selection as MG24** — The Sense variant uses the same FQBN as the base MG24
5. **IMU on I2C bus** — The onboard IMU uses the I2C bus; be aware of address conflicts with external I2C devices
6. **Analog microphone** — The microphone output is analog; read via ADC
7. **All pins are analog** — 19 of 22 GPIO pins support ADC (12-bit, 1 Msps)
8. **All pins support PWM** — All 22 GPIO pins can output PWM
9. **Bottom pads D11-D18** — 8 additional pins accessible only via soldering
10. **D11/D12 shared with SAMD11** — These UART pins are shared with the USB serial bridge
11. **3.3V logic only** — Do NOT connect 5V signals directly to GPIO pins

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/xiao_mg24_getting_started/
- **Board package (Silicon Labs):** https://github.com/SiliconLabs/arduino
- **EFR32MG24 Datasheet:** https://www.silabs.com/documents/public/data-sheets/efr32mg24-datasheet.pdf
- **Gecko SDK:** https://github.com/SiliconLabs/gecko_sdk
- **Arduino-SiLabs docs:** https://siliconlabs.github.io/arduino/
- **Schematic:** https://files.seeedstudio.com/wiki/XIAO_MG24/res/XIAO_MG24_Schematic.pdf
