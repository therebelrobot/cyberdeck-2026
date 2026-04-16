---
name: xiao-nrf54l15-arduino
description: >
  Provides comprehensive pinout reference, board specifications, and Arduino C++ development guide
  for the Seeed Studio XIAO nRF54L15 microcontroller. Use when writing Arduino firmware for the
  XIAO nRF54L15, wiring peripherals, or configuring pins. Keywords: XIAO, nRF54L15, Arduino,
  Nordic, ARM Cortex-M33, RISC-V, BLE 6.0, Channel Sounding, NFC, Thread, Zigbee, Matter,
  Amazon Sidewalk, pinout, GPIO, I2C, SPI, UART, analog, digital, PWM, battery, deep sleep.
---

# XIAO nRF54L15 — Arduino Development Guide

Provides comprehensive reference for developing Arduino C++ firmware for the Seeed Studio XIAO nRF54L15.

## When to Use

- Writing Arduino C++ firmware targeting the XIAO nRF54L15
- Looking up XIAO nRF54L15 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO nRF54L15 and need GPIO reference
- Configuring I2C, SPI, UART, BLE, NFC, or Thread on the XIAO nRF54L15 in Arduino

## When NOT to Use

- For TinyGo development on the XIAO nRF54L15 → use the `XIAO-nRF54L15-TinyGo` skill
- For the XIAO nRF54L15 Sense (with IMU/microphone) → use the `XIAO-nRF54L15-Sense-Arduino` skill
- For the XIAO nRF52840 (older Nordic board) → use the corresponding board skill
- For other XIAO boards → use the corresponding board skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Nordic nRF54L15 |
| **Architecture** | ARM Cortex-M33 @ 128 MHz + RISC-V coprocessor @ 128 MHz (FLPR) |
| **Flash (NVM)** | 1.5 MB |
| **RAM** | 256 KB |
| **ADC** | 14-bit |
| **Wireless** | BLE 6.0 (Channel Sounding), NFC, Thread, Zigbee, Matter, Amazon Sidewalk, 802.15.4-2020 |
| **USB** | USB Type-C (via SAMD11 serial bridge) |
| **Operating Voltage** | 3.3V logic |
| **Supply Voltage** | 3.7V to 5V |
| **Dimensions** | 21 × 17.8 mm |
| **Working Temp** | -40°C to 105°C |
| **GPIO Count** | 16 |
| **Analog Pins** | 4 (D0-D3) |
| **TX Power** | +8 dBm |
| **RX Sensitivity** | -96 dBm |
| **Antenna** | Ceramic antenna + U.FL connector (switchable) |
| **Battery** | Built-in Li-ion battery management (internal PMIC) |
| **Buttons** | 1× RESET, 1× User Key (P0.00) |

---

## Pinout Diagram

```
            XIAO nRF54L15 (Top View)
                ┌─────────────────┐
                │    [USB-C]      │
       D0/A0 ──┤ P1.04    P2.07 ├── D7 (RX)
       D1/A1 ──┤ P1.05    P2.08 ├── D6 (TX)
       D2/A2 ──┤ P1.06    P1.11 ├── D5 (SCL)
       D3/A3 ──┤ P1.07    P1.10 ├── D4 (SDA)
         GND ──┤                 ├── D10 (MOSI)
          5V ──┤                 ├── D9 (MISO)
         3V3 ──┤                 ├── D8 (SCK)
                └─────────────────┘
  Bottom pads: D11-D15, NFC1, NFC2, JTAG
  Ceramic antenna + U.FL connector on top edge
```

---

## Pin Reference Table

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|--------|-----|-----|-----|------|-------|
| D0  | P1.04    | ✓       | ADC    | ✓   | —   | —   | —    | — |
| D1  | P1.05    | ✓       | ADC    | ✓   | —   | —   | —    | — |
| D2  | P1.06    | ✓       | ADC    | ✓   | —   | —   | —    | — |
| D3  | P1.07    | ✓       | ADC    | ✓   | —   | —   | —    | — |
| D4  | P1.10    | ✓       | —      | ✓   | **SDA-0** | — | — | — |
| D5  | P1.11    | ✓       | —      | ✓   | **SCL-0** | — | — | — |
| D6  | P2.08    | ✓       | —      | ✓   | —   | —   | **TX** | — |
| D7  | P2.07    | ✓       | —      | ✓   | —   | —   | **RX** | — |
| D8  | P2.01    | ✓       | —      | ✓   | —   | **SCK** | — | — |
| D9  | P2.04    | ✓       | —      | ✓   | —   | **MISO** | — | — |
| D10 | P2.02    | ✓       | —      | ✓   | —   | **MOSI** | — | — |
| D11 | P0.03    | ✓       | —      | ✓   | **SCL-1** | — | — | Bottom pad |
| D12 | P0.04    | ✓       | —      | ✓   | **SDA-1** | — | — | Bottom pad |
| D13 | P2.10    | ✓       | —      | ✓   | —   | —   | — | Bottom pad |
| D14 | P2.09    | ✓       | —      | ✓   | —   | —   | — | Bottom pad |
| D15 | P2.06    | ✓       | —      | ✓   | —   | —   | — | Bottom pad |

### Internal / Special Pins

| Name | Chip Pin | Description |
|------|----------|-------------|
| USER_LED | P2.00 | User LED (Green) |
| CHARGE_LED | charge_LED | Charge LED (Red) |
| USER KEY | P0.00 | User button |
| NFC1 | P1.02 | NFC antenna pin 1 |
| NFC2 | P1.03 | NFC antenna pin 2 |
| AIN7_VBAT | P1.14 | Read battery voltage |
| RF Switch Port | P2.05 | Switch onboard antenna |
| RF Switch Power | P2.03 | RF power control |
| nRF54L15_SWCLK | SWDCLK | JTAG debug clock |
| nRF54L15_SWD-IO | SWDIO | JTAG debug data |
| nRF54L15_RST | RST | JTAG reset |

---

## Arduino Setup

### Board Manager URL

```
https://files.seeedstudio.com/arduino/package_seeeduino_boards_index.json
```

### Installation

1. Open Arduino IDE → **File** → **Preferences**
2. Add the URL above to **Additional Board Manager URLs**
3. Open **Tools** → **Board** → **Board Manager**
4. Search for **"Seeed nRF52"** (or **"Seeed nRF"**) and install the boards package
5. Select **Tools** → **Board** → **Seeed nRF Boards** → **XIAO nRF54L15**

> **Note:** Arduino support for the nRF54L15 may also be available through Nordic's Arduino core. Check the Seeed Wiki for the latest recommended package.

### Arduino CLI Setup

```bash
# Add board index
arduino-cli config add board_manager.additional_urls \
  https://files.seeedstudio.com/arduino/package_seeeduino_boards_index.json

# Update index and install core
arduino-cli core update-index
arduino-cli core install Seeeduino:nrf52

# Compile
arduino-cli compile --fqbn Seeeduino:nrf52:xiaonRF54L15 ./sketch

# Upload (replace /dev/ttyACM0 with your port)
arduino-cli upload --fqbn Seeeduino:nrf52:xiaonRF54L15 -p /dev/ttyACM0 ./sketch
```

### Board FQBN

```
Seeeduino:nrf52:xiaonRF54L15
```

> **Note:** The exact FQBN may vary depending on the board package version. Use `arduino-cli board listall` to find the correct identifier.

### Example: Blink LED (Arduino)

```cpp
// Built-in User LED is on P2.00 (Green)

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

### Example: User Button

```cpp
const int USER_BUTTON = D0; // P0.00 — check board package for exact define

void setup() {
    Serial.begin(115200);
    pinMode(LED_BUILTIN, OUTPUT);
    pinMode(USER_BUTTON, INPUT_PULLUP);
}

void loop() {
    if (digitalRead(USER_BUTTON) == LOW) { // Active LOW
        digitalWrite(LED_BUILTIN, HIGH);
        Serial.println("Button pressed!");
    } else {
        digitalWrite(LED_BUILTIN, LOW);
    }
    delay(10);
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

    BLE.setLocalName("XIAO-nRF54L15");
    BLE.setAdvertisedService(ledService);
    ledService.addCharacteristic(switchCharacteristic);
    BLE.addService(ledService);
    switchCharacteristic.writeValue(0);
    BLE.advertise();

    Serial.println("BLE 6.0 advertising started");
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

- **I2C0 — SDA:** D4 (P1.10), **SCL:** D5 (P1.11)
- **I2C1 — SDA:** D12 (P0.04), **SCL:** D11 (P0.03) — bottom pads
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

- **SCK:** D8 (P2.01)
- **MISO:** D9 (P2.04)
- **MOSI:** D10 (P2.02)
- **CS:** Any GPIO (user-defined)
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

- **TX:** D6 (P2.08)
- **RX:** D7 (P2.07)
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

### Analog Read (ADC)

```cpp
void setup() {
    Serial.begin(115200);
    analogReadResolution(14); // 14-bit ADC (0-16383)
}

void loop() {
    int value = analogRead(A0); // D0 / P1.04
    Serial.println(value);
    delay(100);
}
```

> **Note:** Only D0-D3 support analog input. The nRF54L15 has a 14-bit ADC for higher precision.

### BLE 6.0 / NFC / Thread / Zigbee / Matter

The XIAO nRF54L15 supports BLE 6.0 (with Channel Sounding), NFC, Thread, Zigbee, Matter, and Amazon Sidewalk. Full protocol stack support depends on the Arduino core version:

```cpp
// BLE 6.0 with Channel Sounding enables centimeter-level
// distance measurement between BLE devices.
// Refer to the Nordic/Seeed Arduino core documentation
// for Channel Sounding API availability.

// NFC requires connecting an NFC antenna to NFC1 (P1.02)
// and NFC2 (P1.03) on the bottom pads.
```

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **Supply voltage:** 3.7V to 5V
- **TX power:** +8 dBm
- **Built-in PMIC:** Internal Li-ion battery management

### Battery Support

- **Built-in PMIC:** Internal power management IC for Li-ion battery charging
- **Battery voltage:** Read via AIN7_VBAT (P1.14)
- **Charge LED:** Red LED indicates charging status
- **Input:** 3.7V Li-ion battery

```cpp
void setup() {
    Serial.begin(115200);
    analogReadResolution(14);
}

void loop() {
    // Read battery voltage via AIN7_VBAT (P1.14)
    // Check board package for the correct pin define
    int raw = analogRead(P1_14); // or equivalent define
    float voltage = raw * (3.3 / 16383.0) * 2.0;
    Serial.print("Battery: ");
    Serial.print(voltage);
    Serial.println("V");
    delay(1000);
}
```

### Deep Sleep

The nRF54L15 supports System OFF mode with Global RTC available even in deep sleep:

```cpp
#include <Arduino.h>

void setup() {
    Serial.begin(115200);
    Serial.println("Going to System OFF...");
    delay(1000);

    // System OFF mode — deepest sleep
    // Wake-up via RESET button or configured GPIO
    // Refer to the board package documentation for
    // the correct sleep API
}

void loop() {
    // This runs after wake-up (setup() runs again)
}
```

> **Note:** There are known battery boot issues — the board may not boot reliably from battery power alone in some configurations. Ensure firmware handles power-on reset properly.

---

## Special Features

### Dual-Core Architecture

The nRF54L15 features a unique dual-core design:
- **ARM Cortex-M33 @ 128 MHz** — Main application processor
- **RISC-V coprocessor @ 128 MHz (FLPR)** — Fast Lightweight Peripheral Processor for real-time tasks

### BLE 6.0 with Channel Sounding

Bluetooth LE 6.0 with Channel Sounding enables centimeter-level distance measurement between BLE devices — useful for indoor positioning, asset tracking, and proximity detection.

### NFC Support

Built-in NFC support with dedicated NFC antenna pins (NFC1/P1.02, NFC2/P1.03) on the bottom pads. Requires an external NFC antenna connected to these pads.

### 14-bit ADC

Higher resolution ADC (14-bit) compared to most XIAO boards (typically 12-bit), providing finer analog measurements on D0-D3.

### Global RTC

Real-time counter available even in System OFF mode, enabling timed wake-ups from the deepest sleep state.

### User Button

Dedicated user button on P0.00 (in addition to RESET), useful for user interaction without external components.

### Security Features

- ARM TrustZone isolation
- Tamper detectors
- Channel leakage protection on encryption engine
- Cryptographic engine protection

---

## Common Gotchas / Notes

1. **Battery boot issues** — The board may not boot reliably from battery power alone in some configurations
2. **JTAG pin restrictions** — JTAG pins on bottom pads; avoid conflicts during debugging
3. **Only 4 analog pins** — D0-D3 have ADC (14-bit); D4-D15 are digital only
4. **SAMD11 serial bridge** — USB is handled by a SAMD11 chip, not native USB on the nRF54L15
5. **Dual I2C buses** — I2C0 (D4/D5) and I2C1 (D11/D12 on bottom pads)
6. **NFC pins on bottom** — NFC1 (P1.02) and NFC2 (P1.03) are on bottom pads, require soldering
7. **User button** — P0.00 is a dedicated user button (active LOW with pull-up)
8. **Board package evolving** — The Arduino core for nRF54L15 is newer; check for updates frequently
9. **3.3V logic only** — Do NOT connect 5V signals directly to GPIO pins
10. **Wide temperature range** — Operates from -40°C to 105°C
11. **Channel Sounding** — BLE 6.0 Channel Sounding API may require specific firmware/SDK versions

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/xiao_nrf54l15_sense_getting_started/
- **Nordic nRF54L15 Product Page:** https://www.nordicsemi.com/Products/nRF54L15
- **Seeed Arduino nRF boards:** https://github.com/Seeed-Studio/Adafruit_nRF52_Arduino
- **nRF Connect SDK:** https://developer.nordicsemi.com/nRF_Connect_SDK/doc/latest/nrf/index.html
- **Arduino-nRF docs:** https://wiki.seeedstudio.com/XIAO-nRF54L15-Arduino/
- **Schematic:** https://files.seeedstudio.com/wiki/XIAO-nRF54L15/res/XIAO_nRF54L15_Schematic.pdf
