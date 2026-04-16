---
name: xiao-rp2040-arduino
description: >
  Provides comprehensive pinout reference, board specifications, and Arduino C++ development guide
  for the Seeed Studio XIAO RP2040 microcontroller. Use when writing Arduino firmware for the
  XIAO RP2040, wiring peripherals, or configuring pins. Keywords: XIAO, RP2040, Arduino,
  Raspberry Pi, dual-core, Cortex-M0+, pinout, GPIO, I2C, SPI, UART, WS2812, RGB LED, PWM, NeoPixel.
---

# XIAO RP2040 — Arduino Development Guide

Provides comprehensive reference for developing Arduino C++ firmware for the Seeed Studio XIAO RP2040.

## When to Use

- Writing Arduino C++ firmware targeting the XIAO RP2040
- Looking up XIAO RP2040 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO RP2040 and need GPIO reference
- Configuring I2C, SPI, UART, or analog I/O on the XIAO RP2040 in Arduino

## When NOT to Use

- For TinyGo development on the XIAO RP2040 → use the `XIAO-RP2040-TinyGo` skill
- For other XIAO boards (SAMD21, nRF52840, ESP32-C3) → use the corresponding board skill
- For the Raspberry Pi Pico (different board, same MCU)

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Raspberry Pi RP2040 |
| **Architecture** | Dual-core ARM Cortex-M0+ |
| **Clock Speed** | Up to 133 MHz |
| **Flash** | 2 MB onboard |
| **RAM** | 264 KB SRAM |
| **Wireless** | None |
| **USB** | USB Type-C |
| **Operating Voltage** | 3.3V MCU / 5V input |
| **Dimensions** | 21 × 17.8 mm |
| **Working Temp** | -20°C to 70°C |
| **GPIO Count** | 14 total (11 digital, 4 analog, 11 PWM) |
| **Onboard** | RGB LED (WS2812), 3-color user LED, Power LED, Reset & Boot buttons |

---

## Pinout Diagram

```
                      [USB-C]
                ┌───────────────┐
      D0/A0   ──┤ 1          14 ├── 5V
      D1/A1   ──┤ 2          13 ├── GND
      D2/A2   ──┤ 3          12 ├── 3V3
      D3/A3   ──┤ 4          11 ├── D10/MOSI
    D4/SDA    ──┤ 5          10 ├── D9/MISO
    D5/SCL    ──┤ 6           9 ├── D8/SCK
     D6/TX    ──┤ 7           8 ├── D7/RX/CSn
                └───────────────┘
```

---

## Pin Reference Table

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|--------|-----|-----|-----|------|-------|
| D0  | GPIO26   | ✓       | A0     | ✓   | —   | —   | —    | — |
| D1  | GPIO27   | ✓       | A1     | ✓   | —   | —   | —    | — |
| D2  | GPIO28   | ✓       | A2     | ✓   | —   | —   | —    | — |
| D3  | GPIO29   | ✓       | A3     | ✓   | —   | —   | —    | — |
| D4  | GPIO6    | ✓       | —      | ✓   | **SDA** | — | —  | — |
| D5  | GPIO7    | ✓       | —      | ✓   | **SCL** | — | —  | — |
| D6  | GPIO0    | ✓       | —      | ✓   | —   | —   | **TX** | — |
| D7  | GPIO1    | ✓       | —      | ✓   | —   | **CSn** | **RX** | — |
| D8  | GPIO2    | ✓       | —      | ✓   | —   | **SCK** | — | — |
| D9  | GPIO4    | ✓       | —      | ✓   | —   | **MISO** | — | — |
| D10 | GPIO3    | ✓       | —      | ✓   | —   | **MOSI** | — | — |

### Internal / LED Pins

| Name | Chip Pin | Arduino Constant | Description |
|------|----------|------------------|-------------|
| RGB LED (WS2812) | GPIO12 | `12` | Addressable RGB LED (NeoPixel) |
| USER_LED_R | GPIO17 | `17` | Red user LED — active LOW |
| USER_LED_G | GPIO16 | `16` | Green user LED — active LOW |
| USER_LED_B | GPIO25 | `LED_BUILTIN` / `25` | Blue user LED — active LOW |

---

## Arduino Setup

### Board Manager URL

```
https://github.com/earlephilhower/arduino-pico/releases/download/global/package_rp2040_index.json
```

### Installation

1. Open Arduino IDE → **File** → **Preferences**
2. Add the URL above to **Additional Board Manager URLs**
3. Open **Tools** → **Board** → **Board Manager**
4. Search for **"Raspberry Pi Pico/RP2040"** by Earle F. Philhower and install it
5. Select **Tools** → **Board** → **Raspberry Pi RP2040 Boards** → **Seeed XIAO RP2040**

### Arduino CLI Setup

```bash
# Add board index
arduino-cli config add board_manager.additional_urls \
  https://github.com/earlephilhower/arduino-pico/releases/download/global/package_rp2040_index.json

# Update index and install core
arduino-cli core update-index
arduino-cli core install rp2040:rp2040

# Compile
arduino-cli compile --fqbn rp2040:rp2040:seeed_xiao_rp2040 ./sketch

# Upload (replace /dev/ttyACM0 with your port)
arduino-cli upload --fqbn rp2040:rp2040:seeed_xiao_rp2040 -p /dev/ttyACM0 ./sketch
```

### Board FQBN

```
rp2040:rp2040:seeed_xiao_rp2040
```

### Example: Blink (Arduino)

```cpp
void setup() {
    pinMode(LED_BUILTIN, OUTPUT); // GPIO25 — blue user LED
}

void loop() {
    digitalWrite(LED_BUILTIN, LOW);  // LED on (active LOW)
    delay(500);
    digitalWrite(LED_BUILTIN, HIGH); // LED off
    delay(500);
}
```

### Example: RGB LED (WS2812 / NeoPixel)

```cpp
#include <Adafruit_NeoPixel.h>

#define NEOPIXEL_PIN 12  // GPIO12 — onboard WS2812
#define NUM_PIXELS   1

Adafruit_NeoPixel pixel(NUM_PIXELS, NEOPIXEL_PIN, NEO_GRB + NEO_KHZ800);

void setup() {
    pixel.begin();
    pixel.setBrightness(50); // 0–255
}

void loop() {
    pixel.setPixelColor(0, pixel.Color(255, 0, 0)); // Red
    pixel.show();
    delay(500);

    pixel.setPixelColor(0, pixel.Color(0, 255, 0)); // Green
    pixel.show();
    delay(500);

    pixel.setPixelColor(0, pixel.Color(0, 0, 255)); // Blue
    pixel.show();
    delay(500);
}
```

> Install the **Adafruit NeoPixel** library via Library Manager.

---

## Communication Protocols

### I2C

- **SDA:** D4 (GPIO6)
- **SCL:** D5 (GPIO7)
- **Arduino object:** `Wire`

```cpp
#include <Wire.h>

void setup() {
    Wire.begin(); // Join I2C bus as controller
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

> The RP2040 has two I2C peripherals. `Wire` uses I2C0 (D4/D5). `Wire1` can be configured on other pins.

### SPI

- **SCK:** D8 (GPIO2)
- **MISO:** D9 (GPIO4)
- **MOSI:** D10 (GPIO3)
- **CS:** D7 (GPIO1) or any GPIO
- **Arduino object:** `SPI`

```cpp
#include <SPI.h>

const int CS_PIN = 7; // D7 / GPIO1

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

- **TX:** D6 (GPIO0)
- **RX:** D7 (GPIO1)
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
    int value = analogRead(A0); // D0 / GPIO26
    Serial.println(value);
    delay(100);
}
```

> **Note:** Only D0–D3 (A0–A3) support analog input. D4–D10 are digital only.

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **5V output:** From USB VBUS
- **3.3V output:** Regulated from onboard LDO

### Deep Sleep

The RP2040 supports dormant and sleep modes:

```cpp
#include <pico/sleep.h>

void enterDeepSleep() {
    // Configure wake source (e.g., GPIO interrupt)
    // Then enter dormant mode
    sleep_goto_dormant_until_pin(D0, true, false); // Wake on D0 rising edge
}
```

> **Note:** Deep sleep support depends on the Arduino core version. The Earle Philhower core provides access to the Pico SDK sleep functions.

### Battery

- No built-in battery charging circuit on the XIAO RP2040
- Power via USB-C (5V) or 5V/3V3 pads

---

## Common Gotchas / Notes

1. **Only 4 analog pins** — D0–D3 (GPIO26–29) have ADC; D4–D10 are digital only
2. **LEDs are active LOW** — `digitalWrite(pin, LOW)` turns the LED ON
3. **WS2812 RGB LED on GPIO12** — Requires NeoPixel library; not a standard LED
4. **Boot mode** — Hold BOOT button, press RESET, release BOOT; board appears as "RPI-RP2" USB drive
5. **D7 dual function** — D7 (GPIO1) serves as both UART RX and SPI CSn; avoid using both simultaneously
6. **No DAC** — Unlike the SAMD21, the RP2040 has no DAC output; use `analogWrite()` for PWM
7. **No wireless** — This board has no WiFi or Bluetooth; use ESP32-C3 or nRF52840 variants for wireless
8. **Serial vs Serial1** — `Serial` is USB CDC (Serial Monitor); `Serial1` is hardware UART on D6/D7
9. **Dual-core** — The RP2040 has two cores; use `setup1()`/`loop1()` in the Philhower core for the second core

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/XIAO-RP2040/
- **Board package (Philhower):** https://github.com/earlephilhower/arduino-pico
- **RP2040 datasheet:** https://datasheets.raspberrypi.com/rp2040/rp2040-datasheet.pdf
- **Schematic:** https://files.seeedstudio.com/wiki/XIAO-RP2040/res/Seeed-Studio-XIAO-RP2040-v1.3.pdf
- **Adafruit NeoPixel library:** https://github.com/adafruit/Adafruit_NeoPixel
