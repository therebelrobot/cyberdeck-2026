---
name: xiao-nrf52840-arduino
description: >
  Provides comprehensive pinout reference, board specifications, and Arduino C++ development guide
  for the Seeed Studio XIAO nRF52840 microcontroller. Use when writing Arduino firmware for the
  XIAO nRF52840, wiring peripherals, or configuring pins. Keywords: XIAO, nRF52840, Arduino,
  Nordic, Cortex-M4, BLE, Bluetooth, NFC, pinout, GPIO, I2C, SPI, UART, analog, digital, PWM, battery.
---

# XIAO nRF52840 — Arduino Development Guide

Provides comprehensive reference for developing Arduino C++ firmware for the Seeed Studio XIAO nRF52840.

## When to Use

- Writing Arduino C++ firmware targeting the XIAO nRF52840
- Looking up XIAO nRF52840 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO nRF52840 and need GPIO reference
- Configuring I2C, SPI, UART, BLE, or analog I/O on the XIAO nRF52840 in Arduino

## When NOT to Use

- For TinyGo development on the XIAO nRF52840 → use the `XIAO-nRF52840-TinyGo` skill
- For the XIAO nRF52840 **Sense** variant (with IMU + microphone) → use the `XIAO-nRF52840-Sense-Arduino` skill
- For other XIAO boards (SAMD21, RP2040, ESP32-C3) → use the corresponding board skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Nordic nRF52840 |
| **Architecture** | ARM Cortex-M4 32-bit with FPU |
| **Clock Speed** | 64 MHz |
| **Flash** | 1 MB internal + 2 MB onboard |
| **RAM** | 256 KB |
| **Wireless** | Bluetooth Low Energy 5.4, Bluetooth Mesh, NFC |
| **USB** | USB Type-C |
| **Operating Voltage** | 3.3V MCU / 5V input |
| **Dimensions** | 21 × 17.8 mm |
| **GPIO Count** | 14 pads (11 digital/PWM, 6 analog/ADC) |
| **Onboard** | 3-in-one RGB LED, Charge LED, Reset Button |
| **Battery** | BQ25101 charge chip, supports LiPo charge/discharge |
| **Standby Power** | < 5 μA |

---

## Pinout Diagram

```
                      [USB-C]
                ┌───────────────┐
      D0/A0   ──┤ 1          14 ├── 5V
      D1/A1   ──┤ 2          13 ├── GND
      D2/A2   ──┤ 3          12 ├── 3V3
      D3/A3   ──┤ 4          11 ├── D10/MOSI
   D4/A4/SDA  ──┤ 5          10 ├── D9/MISO
   D5/A5/SCL  ──┤ 6           9 ├── D8/SCK
     D6/TX    ──┤ 7           8 ├── D7/RX
                └───────────────┘
         Bottom pads: GND, RST, NFC1, NFC2, 3V3, BAT
```

---

## Pin Reference Table

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|--------|-----|-----|-----|------|-------|
| D0  | P0.02    | ✓       | AIN0   | ✓   | —   | —   | —    | — |
| D1  | P0.03    | ✓       | AIN1   | ✓   | —   | —   | —    | — |
| D2  | P0.28    | ✓       | AIN4   | ✓   | —   | —   | —    | — |
| D3  | P0.29    | ✓       | AIN5   | ✓   | —   | —   | —    | — |
| D4  | P0.04    | ✓       | AIN2   | ✓   | **SDA** | — | —  | — |
| D5  | P0.05    | ✓       | AIN3   | ✓   | **SCL** | — | —  | — |
| D6  | P1.11    | ✓       | —      | ✓   | —   | —   | **TX** | — |
| D7  | P1.12    | ✓       | —      | ✓   | —   | —   | **RX** | — |
| D8  | P1.13    | ✓       | —      | ✓   | —   | **SCK** | — | — |
| D9  | P1.14    | ✓       | —      | ✓   | —   | **MISO** | — | — |
| D10 | P1.15    | ✓       | —      | ✓   | —   | **MOSI** | — | — |

### Internal / LED / Special Pins

| Name | Chip Pin | Arduino Constant | Description |
|------|----------|------------------|-------------|
| USER_LED_R | P0.26 | `LED_RED` / `LEDR` | Red RGB LED — active LOW |
| USER_LED_G | P0.30 | `LED_GREEN` / `LEDG` | Green RGB LED — active LOW |
| USER_LED_B | P0.06 | `LED_BLUE` / `LEDB` / `LED_BUILTIN` | Blue RGB LED — active LOW |
| CHARGE_LED | P0.17 | — | Charge indicator (Red) |
| NFC1 | P0.09 | — | NFC antenna pad (bottom) |
| NFC2 | P0.10 | — | NFC antenna pad (bottom) |
| ADC_BAT | P0.14 | `PIN_VBAT` | Battery voltage sense |
| CHG_RATE | P0.13 | — | Charge rate: HIGH=50mA, LOW=100mA |

---

## Arduino Setup

### Board Manager URL

```
https://files.seeedstudio.com/arduino/package_seeeduino_boards_index.json
```

### Installation — Two Library Options

Seeed provides **two** Arduino board packages for the nRF52840:

| Package | Use Case | BLE | Low Power | IMU/PDM |
|---------|----------|-----|-----------|---------|
| **Seeed nRF52 Boards** | BLE apps, low power | ✓ (Adafruit BLE) | ✓ | ❌ |
| **Seeed nRF52 mbed-enabled Boards** | ML, IMU, PDM mic | ✓ (ArduinoBLE) | Limited | ✓ |

**For the non-Sense variant, use "Seeed nRF52 Boards"** (better BLE and low-power support):

1. Open Arduino IDE → **File** → **Preferences**
2. Add the URL above to **Additional Board Manager URLs**
3. Open **Tools** → **Board** → **Board Manager**
4. Search for **"Seeed nRF52"** and install **"Seeed nRF52 Boards"**
5. Select **Tools** → **Board** → **Seeed nRF52 Boards** → **Seeed XIAO nRF52840**

### Arduino CLI Setup

```bash
# Add board index
arduino-cli config add board_manager.additional_urls \
  https://files.seeedstudio.com/arduino/package_seeeduino_boards_index.json

# Update index and install core
arduino-cli core update-index
arduino-cli core install Seeeduino:nrf52

# Compile
arduino-cli compile --fqbn Seeeduino:nrf52:xiaonRF52840 ./sketch

# Upload (replace /dev/ttyACM0 with your port)
arduino-cli upload --fqbn Seeeduino:nrf52:xiaonRF52840 -p /dev/ttyACM0 ./sketch
```

### Board FQBN

```
Seeeduino:nrf52:xiaonRF52840
```

### Example: Blink (Arduino)

```cpp
void setup() {
    pinMode(LED_BUILTIN, OUTPUT); // P0.06 — blue LED
}

void loop() {
    digitalWrite(LED_BUILTIN, LOW);  // LED on (active LOW)
    delay(500);
    digitalWrite(LED_BUILTIN, HIGH); // LED off
    delay(500);
}
```

### Example: RGB LED

```cpp
void setup() {
    pinMode(LEDR, OUTPUT); // P0.26
    pinMode(LEDG, OUTPUT); // P0.30
    pinMode(LEDB, OUTPUT); // P0.06

    // All off
    digitalWrite(LEDR, HIGH);
    digitalWrite(LEDG, HIGH);
    digitalWrite(LEDB, HIGH);
}

void loop() {
    digitalWrite(LEDR, LOW);  delay(500); digitalWrite(LEDR, HIGH);
    digitalWrite(LEDG, LOW);  delay(500); digitalWrite(LEDG, HIGH);
    digitalWrite(LEDB, LOW);  delay(500); digitalWrite(LEDB, HIGH);
}
```

### Example: BLE Peripheral (Adafruit BLE — "Seeed nRF52 Boards" package)

```cpp
#include <bluefruit.h>

BLEUart bleuart;

void setup() {
    Serial.begin(115200);

    Bluefruit.begin();
    Bluefruit.setName("XIAO-nRF52840");
    Bluefruit.setTxPower(4);

    bleuart.begin();

    // Start advertising
    Bluefruit.Advertising.addFlags(BLE_GAP_ADV_FLAGS_LE_ONLY_GENERAL_DISC_MODE);
    Bluefruit.Advertising.addTxPower();
    Bluefruit.Advertising.addService(bleuart);
    Bluefruit.Advertising.addName();
    Bluefruit.Advertising.start(0);
}

void loop() {
    if (bleuart.available()) {
        char c = bleuart.read();
        Serial.print(c);
    }
}
```

---

## Communication Protocols

### I2C

- **SDA:** D4 (P0.04)
- **SCL:** D5 (P0.05)
- **Arduino object:** `Wire`

```cpp
#include <Wire.h>

void setup() {
    Wire.begin();
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

- **SCK:** D8 (P1.13)
- **MISO:** D9 (P1.14)
- **MOSI:** D10 (P1.15)
- **CS:** Any GPIO (user-defined)
- **Arduino object:** `SPI`

```cpp
#include <SPI.h>

const int CS_PIN = 7; // D7

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

- **TX:** D6 (P1.11)
- **RX:** D7 (P1.12)
- **Arduino object:** `Serial1` (hardware UART on D6/D7)
- **USB Serial:** `Serial` (USB CDC — for Serial Monitor)

```cpp
void setup() {
    Serial.begin(115200);   // USB serial (Serial Monitor)
    Serial1.begin(9600);    // Hardware UART on D6(TX)/D7(RX)
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
    analogReadResolution(12); // 12-bit resolution (0–4095)
    Serial.begin(115200);
}

void loop() {
    int value = analogRead(A0); // D0 / P0.02
    Serial.println(value);
    delay(100);
}
```

> **Note:** 6 analog pins available: D0–D5 (AIN0–AIN5).

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **5V output:** From USB VBUS
- **3.3V output:** Regulated from onboard LDO
- **Standby power:** < 5 μA

### Battery Support

The XIAO nRF52840 has a built-in BQ25101 charge chip:

- **Battery pad:** Solder LiPo battery to BAT+ and BAT- pads on the bottom
- **Charge rate:** 50 mA (P0.13 HIGH) or 100 mA (P0.13 LOW, default)
- **Charge LED:** Red LED (P0.17) indicates charging status

```cpp
// Read battery voltage
void setup() {
    analogReadResolution(12);
    pinMode(PIN_VBAT, INPUT);
    Serial.begin(115200);
}

void loop() {
    int rawValue = analogRead(PIN_VBAT);
    float voltage = rawValue * 3.3 / 4095.0 * 2.0; // Voltage divider factor
    Serial.print("Battery: ");
    Serial.print(voltage);
    Serial.println("V");
    delay(1000);
}
```

### Deep Sleep (Seeed nRF52 Boards package)

```cpp
#include <Adafruit_TinyUSB.h> // Required for proper USB handling

void setup() {
    pinMode(LED_BUILTIN, OUTPUT);
    digitalWrite(LED_BUILTIN, HIGH); // LED off
}

void loop() {
    // Do work...

    // Enter System OFF mode (< 5 μA)
    // Wake via reset pin or NFC field
    NRF_POWER->SYSTEMOFF = 1;

    // Or use timed sleep with RTC:
    // delay() already uses low-power idle on nRF52
    delay(10000);
}
```

> **Note:** `NRF_POWER->SYSTEMOFF` puts the chip in deepest sleep. Only reset or NFC can wake it. For GPIO wake, use `NRF_GPIO->PIN_CNF[pin]` with SENSE configured before entering System OFF.

---

## Common Gotchas / Notes

1. **6 analog pins** — D0–D5 all have ADC (AIN0–AIN5); D6–D10 are digital only
2. **LEDs are active LOW** — `digitalWrite(pin, LOW)` turns the LED ON
3. **Two board packages** — "Seeed nRF52 Boards" (recommended for BLE/low power) vs "Seeed nRF52 mbed-enabled Boards" (for ML/IMU/PDM)
4. **NFC pads on bottom** — P0.09 and P0.10 are NFC antenna pads; not exposed as GPIO on side pads
5. **Battery charging** — Default charge rate is 100 mA; set P0.13 HIGH for 50 mA
6. **Bootloader mode** — Double-tap the reset pad; board appears as "XIAO-SENSE" USB drive
7. **Serial vs Serial1** — `Serial` is USB CDC (Serial Monitor); `Serial1` is hardware UART on D6/D7
8. **No WiFi** — This board has BLE only; use ESP32-C3 for WiFi
9. **This is NOT the Sense variant** — No IMU or microphone; for those features use the XIAO nRF52840 Sense

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/XIAO_BLE/
- **Board package:** https://files.seeedstudio.com/arduino/package_seeeduino_boards_index.json
- **nRF52840 datasheet:** https://infocenter.nordicsemi.com/pdf/nRF52840_PS_v1.1.pdf
- **Adafruit nRF52 BLE library:** https://github.com/adafruit/Adafruit_nRF52_Arduino
- **Schematic:** https://files.seeedstudio.com/wiki/XIAO-BLE/Seeed-Studio-XIAO-nRF52840-Sense-v1.1.pdf
