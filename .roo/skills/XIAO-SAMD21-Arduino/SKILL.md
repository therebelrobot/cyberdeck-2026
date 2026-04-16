---
name: xiao-samd21-arduino
description: >
  Provides comprehensive pinout reference, board specifications, and Arduino C++ development guide
  for the Seeed Studio XIAO SAMD21 microcontroller. Use when writing Arduino firmware for the
  XIAO SAMD21, wiring peripherals, or configuring pins. Keywords: XIAO, SAMD21, Arduino,
  ATSAMD21G18, Cortex-M0+, pinout, GPIO, I2C, SPI, UART, DAC, analog, digital, PWM.
---

# XIAO SAMD21 — Arduino Development Guide

Provides comprehensive reference for developing Arduino C++ firmware for the Seeed Studio XIAO SAMD21.

## When to Use

- Writing Arduino C++ firmware targeting the XIAO SAMD21
- Looking up XIAO SAMD21 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO SAMD21 and need GPIO reference
- Configuring I2C, SPI, UART, or analog I/O on the XIAO SAMD21 in Arduino

## When NOT to Use

- For TinyGo development on the XIAO SAMD21 → use the `XIAO-SAMD21-TinyGo` skill
- For other XIAO boards (RP2040, nRF52840, ESP32-C3) → use the corresponding board skill
- For non-XIAO SAMD21 boards (e.g., Arduino MKR, Adafruit Feather M0)

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Microchip ATSAMD21G18A-MU |
| **Architecture** | ARM Cortex-M0+ 32-bit |
| **Clock Speed** | Up to 48 MHz |
| **Flash** | 256 KB |
| **RAM** | 32 KB SRAM |
| **Wireless** | None |
| **USB** | USB Type-C |
| **Operating Voltage** | 3.3V MCU / 5V input |
| **Max Output** | 5V @ 500mA, 3.3V @ 200mA |
| **Dimensions** | 21 × 17.8 mm |
| **Working Temp** | -40°C to 85°C |
| **GPIO Count** | 14 total (11 digital, 11 analog, 10 PWM) |
| **Special** | 1× DAC output (D0/A0), QTouch support |

---

## Pinout Diagram

```
                      [USB-C]
                ┌───────────────┐
   D0/A0/DAC  ──┤ 1          14 ├── 5V
      D1/A1   ──┤ 2          13 ├── GND
      D2/A2   ──┤ 3          12 ├── 3V3
      D3/A3   ──┤ 4          11 ├── D10/A10/MOSI
   D4/A4/SDA  ──┤ 5          10 ├── D9/A9/MISO
   D5/A5/SCL  ──┤ 6           9 ├── D8/A8/SCK
    D6/A6/TX  ──┤ 7           8 ├── D7/A7/RX
                └───────────────┘
```

---

## Pin Reference Table

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|--------|-----|-----|-----|------|-------|
| D0  | PA02     | ✓       | A0     | —   | —   | —   | —    | **DAC** |
| D1  | PA04     | ✓       | A1     | ✓   | —   | —   | —    | — |
| D2  | PA10     | ✓       | A2     | ✓   | —   | —   | —    | — |
| D3  | PA11     | ✓       | A3     | ✓   | —   | —   | —    | — |
| D4  | PA08     | ✓       | A4     | ✓   | **SDA** | — | —  | — |
| D5  | PA09     | ✓       | A5     | ✓   | **SCL** | — | —  | — |
| D6  | PB08     | ✓       | A6     | ✓   | —   | —   | **TX** | — |
| D7  | PB09     | ✓       | A7     | ✓   | —   | —   | **RX** | — |
| D8  | PA07     | ✓       | A8     | ✓   | —   | **SCK** | — | — |
| D9  | PA05     | ✓       | A9     | ✓   | —   | **MISO** | — | — |
| D10 | PA06     | ✓       | A10    | ✓   | —   | **MOSI** | — | — |

### Internal / LED Pins

| Name | Chip Pin | Arduino Constant | Description |
|------|----------|------------------|-------------|
| USER_LED | PA17 | `LED_BUILTIN` (13) | User LED (Yellow) — active LOW |
| TX_LED   | PA19 | `PIN_LED_TXL` | TX indicator LED |
| RX_LED   | PA18 | `PIN_LED_RXL` | RX indicator LED |

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
4. Search for **"Seeed SAMD"** and install **"Seeed SAMD Boards"**
5. Select **Tools** → **Board** → **Seeed SAMD** → **Seeeduino XIAO**

### Arduino CLI Setup

```bash
# Add board index
arduino-cli config add board_manager.additional_urls \
  https://files.seeedstudio.com/arduino/package_seeeduino_boards_index.json

# Update index and install core
arduino-cli core update-index
arduino-cli core install Seeeduino:samd

# Compile
arduino-cli compile --fqbn Seeeduino:samd:seeed_XIAO_m0 ./sketch

# Upload (replace /dev/ttyACM0 with your port)
arduino-cli upload --fqbn Seeeduino:samd:seeed_XIAO_m0 -p /dev/ttyACM0 ./sketch
```

### Board FQBN

```
Seeeduino:samd:seeed_XIAO_m0
```

### Example: Blink (Arduino)

```cpp
void setup() {
    pinMode(LED_BUILTIN, OUTPUT); // PA17 — onboard yellow LED
}

void loop() {
    digitalWrite(LED_BUILTIN, LOW);  // LED on (active LOW)
    delay(500);
    digitalWrite(LED_BUILTIN, HIGH); // LED off
    delay(500);
}
```

---

## Communication Protocols

### I2C

- **SDA:** D4 (PA08)
- **SCL:** D5 (PA09)
- **Arduino object:** `Wire`

```cpp
#include <Wire.h>

void setup() {
    Wire.begin(); // Join I2C bus as controller
    // Wire.setClock(400000); // Optional: 400 kHz fast mode
}

void loop() {
    Wire.beginTransmission(0x3C); // Address of I2C device
    Wire.write(0x00);             // Register or data
    Wire.endTransmission();

    Wire.requestFrom(0x3C, 1);   // Request 1 byte
    if (Wire.available()) {
        uint8_t data = Wire.read();
    }
}
```

### SPI

- **SCK:** D8 (PA07)
- **MISO:** D9 (PA05)
- **MOSI:** D10 (PA06)
- **CS:** Any GPIO (user-defined)
- **Arduino object:** `SPI`

```cpp
#include <SPI.h>

const int CS_PIN = 7; // Example: use D7 as chip select

void setup() {
    pinMode(CS_PIN, OUTPUT);
    digitalWrite(CS_PIN, HIGH); // Deselect
    SPI.begin();
}

void loop() {
    SPI.beginTransaction(SPISettings(4000000, MSBFIRST, SPI_MODE0));
    digitalWrite(CS_PIN, LOW);   // Select device
    uint8_t result = SPI.transfer(0x00); // Send/receive
    digitalWrite(CS_PIN, HIGH);  // Deselect
    SPI.endTransaction();
}
```

### UART

- **TX:** D6 (PB08)
- **RX:** D7 (PB09)
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
        Serial.print(c); // Echo UART data to USB serial
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
    int value = analogRead(A0); // Read D0/PA02
    Serial.println(value);
    delay(100);
}
```

### DAC Output

```cpp
void setup() {
    analogWriteResolution(10); // 10-bit DAC (0–1023)
}

void loop() {
    analogWrite(A0, 512); // Output ~1.65V on D0/PA02 (DAC)
    delay(1000);
}
```

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **Max current per pin:** ~7 mA (recommended), absolute max varies by pin
- **5V output:** Up to 500 mA (from USB)
- **3.3V output:** Up to 200 mA

### Deep Sleep

The SAMD21 supports standby sleep mode via the Arduino Low Power library:

```cpp
#include <ArduinoLowPower.h>

void setup() {
    pinMode(LED_BUILTIN, OUTPUT);
    digitalWrite(LED_BUILTIN, HIGH); // LED off
}

void loop() {
    // Do work...

    // Sleep for 10 seconds
    LowPower.sleep(10000);

    // Or sleep until external interrupt on D2
    // LowPower.attachInterruptWakeup(digitalPinToInterrupt(2), wakeUpCallback, RISING);
    // LowPower.sleep();
}

void wakeUpCallback() {
    // Runs on wake-up
}
```

> Install the **ArduinoLowPower** library via Library Manager.

### Battery

- No built-in battery charging circuit on the XIAO SAMD21
- Power via USB-C (5V) or 5V/3V3 pads

---

## Common Gotchas / Notes

1. **DAC only on D0/A0** — `analogWrite(A0, value)` outputs true analog; on other pins it outputs PWM
2. **PWM not on D0** — D0 (PA02) does not support PWM; D1–D10 do
3. **Interrupt conflict** — D5 and D7 cannot be used simultaneously for interrupts
4. **LED is active LOW** — `digitalWrite(LED_BUILTIN, LOW)` turns the LED ON
5. **Bootloader mode** — Double-tap the reset pad quickly; the board appears as a USB drive named "Arduino"
6. **Serial vs Serial1** — `Serial` is USB CDC (Serial Monitor); `Serial1` is hardware UART on D6/D7
7. **3.3V logic** — Do NOT connect 5V signals directly to GPIO pins
8. **No wireless** — This board has no WiFi or Bluetooth; use ESP32-C3 or nRF52840 variants for wireless
9. **analogRead resolution** — Default is 10-bit; call `analogReadResolution(12)` for full 12-bit ADC

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/Seeeduino-XIAO/
- **Board package:** https://files.seeedstudio.com/arduino/package_seeeduino_boards_index.json
- **SAMD21 datasheet:** https://www.microchip.com/en-us/product/ATSAMD21G18A
- **Schematic:** https://files.seeedstudio.com/wiki/Seeeduino-XIAO/res/Seeeduino-XIAO-v1.0-SCH-191112.pdf
- **Arduino SAMD core:** https://github.com/Seeed-Studio/ArduinoCore-samd
