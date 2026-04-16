---
name: xiao-rp2350-arduino
description: >
  Provides comprehensive pinout reference, board specifications, and Arduino C++ development guide
  for the Seeed Studio XIAO RP2350 microcontroller. Use when writing Arduino firmware for the
  XIAO RP2350, wiring peripherals, or configuring pins. Keywords: XIAO, RP2350, Arduino,
  Raspberry Pi, dual-core, Cortex-M33, FPU, TrustZone, PIO, pinout, GPIO, I2C, SPI, UART,
  analog, digital, PWM, RGB LED, NeoPixel, back pads, 19 GPIO, battery.
---

# XIAO RP2350 — Arduino Development Guide

Provides comprehensive reference for developing Arduino C++ firmware for the Seeed Studio XIAO RP2350.

## When to Use

- Writing Arduino C++ firmware targeting the XIAO RP2350
- Looking up XIAO RP2350 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO RP2350 and need GPIO reference
- Configuring I2C, SPI, UART, or analog I/O on the XIAO RP2350 in Arduino

## When NOT to Use

- For TinyGo development on the XIAO RP2350 → use the `XIAO-RP2350-TinyGo` skill
- For the XIAO RP2040 (previous generation) → use the `XIAO-RP2040-Arduino` skill
- For other XIAO boards → use the corresponding board skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Raspberry Pi RP2350 |
| **Architecture** | Dual ARM Cortex-M33 with FPU |
| **Clock Speed** | Up to 150 MHz |
| **Flash** | 2 MB |
| **RAM** | 520 KB SRAM |
| **Wireless** | None |
| **USB** | USB Type-C |
| **Operating Voltage** | 3.3V logic |
| **Dimensions** | 21 × 17.8 mm |
| **Working Temp** | -20°C to 70°C |
| **GPIO Count** | 19 total (11 edge + 8 back pads), all PWM capable |
| **ADC Channels** | 3 (D0–D2) |
| **Deep Sleep** | ~50 μA |
| **Onboard** | User LED (Yellow, GPIO25), RGB LED (GPIO22), Power LED, Reset & Boot buttons |
| **Security** | OTP, Secure Boot, Arm TrustZone |

---

## Pinout Diagram

```
                      [USB-C]
                ┌───────────────┐
      D0/A0   ──┤ 1          14 ├── 5V
      D1/A1   ──┤ 2          13 ├── GND
      D2/A2   ──┤ 3          12 ├── 3V3
    D3/SPI_CS ──┤ 4          11 ├── D10/MOSI
    D4/SDA1   ──┤ 5          10 ├── D9/MISO
    D5/SCL1   ──┤ 6           9 ├── D8/SCK
     D6/TX0   ──┤ 7           8 ├── D7/RX0
                └───────────────┘
         Bottom pads: BAT+, BAT-
    Back pads (8 additional IOs):
      D11/RX1  D12/TX1  D13/SCL0  D14/SDA0
      D15/MOSI1  D16/MISO1  D17/SCK1  D18/CS1
```

---

## Pin Reference Table

### Edge Pins (11 GPIOs)

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|--------|-----|-----|-----|------|-------|
| D0  | GPIO26   | ✓       | ADC    | ✓   | —   | —   | —    | — |
| D1  | GPIO27   | ✓       | ADC    | ✓   | —   | —   | —    | — |
| D2  | GPIO28   | ✓       | ADC    | ✓   | —   | —   | —    | — |
| D3  | GPIO5    | ✓       | —      | ✓   | —   | **CS0** | — | SPI0_CSn |
| D4  | GPIO6    | ✓       | —      | ✓   | **SDA1** | — | — | — |
| D5  | GPIO7    | ✓       | —      | ✓   | **SCL1** | — | — | — |
| D6  | GPIO0    | ✓       | —      | ✓   | —   | —   | **TX0** | — |
| D7  | GPIO1    | ✓       | —      | ✓   | —   | —   | **RX0** | — |
| D8  | GPIO2    | ✓       | —      | ✓   | —   | **SCK0** | — | SPI0_SCK |
| D9  | GPIO4    | ✓       | —      | ✓   | —   | **MISO0** | — | SPI0_MISO |
| D10 | GPIO3    | ✓       | —      | ✓   | —   | **MOSI0** | — | SPI0_MOSI |

### Back Pads (8 additional GPIOs)

| Pin | Chip Pin | Digital | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|-----|-----|-----|------|-------|
| D11 | GPIO21   | ✓       | ✓   | —   | —   | **RX1** | — |
| D12 | GPIO20   | ✓       | ✓   | —   | —   | **TX1** | — |
| D13 | GPIO17   | ✓       | ✓   | **SCL0** | — | — | — |
| D14 | GPIO16   | ✓       | ✓   | **SDA0** | — | — | — |
| D15 | GPIO11   | ✓       | ✓   | —   | **MOSI1** | — | SPI1_MOSI |
| D16 | GPIO12   | ✓       | ✓   | —   | **MISO1** | — | SPI1_MISO |
| D17 | GPIO10   | ✓       | ✓   | —   | **SCK1** | — | SPI1_SCK |
| D18 | GPIO9    | ✓       | ✓   | —   | **CS1** | — | SPI1_CSn |

### Internal / Special Pins

| Name | Chip Pin | Description |
|------|----------|-------------|
| USER_LED | GPIO25 | Yellow user LED |
| RGB LED | GPIO22 | Addressable RGB LED (WS2812/NeoPixel) |
| ADC_BAT | GPIO29 | Battery voltage reading (internal) |
| Reset | RUN | Reset |
| Boot | RP2040_BOOT | Enter bootloader (UF2 mode) |
| CHARGE_LED | NCHG | Red charge indicator |

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
4. Search for **"Raspberry Pi Pico/RP2040/RP2350"** by Earle F. Philhower, III and install it
5. Select **Tools** → **Board** → **Raspberry Pi RP2040/RP2350** → **Seeed XIAO RP2350**

### Arduino CLI Setup

```bash
# Add board index
arduino-cli config add board_manager.additional_urls \
  https://github.com/earlephilhower/arduino-pico/releases/download/global/package_rp2040_index.json

# Update index and install core
arduino-cli core update-index
arduino-cli core install rp2040:rp2040

# Compile
arduino-cli compile --fqbn rp2040:rp2040:seeed_xiao_rp2350 ./sketch

# Upload (board must be in bootloader mode, or use serial port)
arduino-cli upload --fqbn rp2040:rp2040:seeed_xiao_rp2350 -p /dev/ttyACM0 ./sketch
```

### Board FQBN

```
rp2040:rp2040:seeed_xiao_rp2350
```

### Example: Blink (Arduino)

```cpp
const int LED_PIN = 25; // GPIO25 — Yellow user LED

void setup() {
    pinMode(LED_PIN, OUTPUT);
}

void loop() {
    digitalWrite(LED_PIN, HIGH);
    delay(500);
    digitalWrite(LED_PIN, LOW);
    delay(500);
}
```

### Example: RGB LED (NeoPixel)

```cpp
#include <Adafruit_NeoPixel.h>

#define RGB_PIN 22  // GPIO22
#define NUM_LEDS 1

Adafruit_NeoPixel pixel(NUM_LEDS, RGB_PIN, NEO_GRB + NEO_KHZ800);

void setup() {
    pixel.begin();
    pixel.setBrightness(50);
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

---

## Communication Protocols

### I2C (Two Buses)

**Wire1 (edge pins — primary):**
- **SDA:** D4 (GPIO6)
- **SCL:** D5 (GPIO7)
- **Arduino object:** `Wire1`

**Wire (back pads):**
- **SDA:** D14 (GPIO16)
- **SCL:** D13 (GPIO17)
- **Arduino object:** `Wire`

```cpp
#include <Wire.h>

void setup() {
    // Primary I2C on edge pins
    Wire1.setSDA(D4); // GPIO6
    Wire1.setSCL(D5); // GPIO7
    Wire1.begin();
    Wire1.setClock(400000); // 400 kHz

    // Secondary I2C on back pads
    Wire.setSDA(16); // D14 / GPIO16
    Wire.setSCL(17); // D13 / GPIO17
    Wire.begin();
}

void loop() {
    Wire1.beginTransmission(0x3C);
    Wire1.write(0x00);
    Wire1.endTransmission();

    Wire1.requestFrom(0x3C, 1);
    if (Wire1.available()) {
        uint8_t data = Wire1.read();
    }
}
```

### SPI (Two Buses)

**SPI (edge pins — primary):**
- **SCK:** D8 (GPIO2)
- **MISO:** D9 (GPIO4)
- **MOSI:** D10 (GPIO3)
- **CS:** D3 (GPIO5) or any GPIO
- **Arduino object:** `SPI`

**SPI1 (back pads):**
- **SCK:** D17 (GPIO10)
- **MISO:** D16 (GPIO12)
- **MOSI:** D15 (GPIO11)
- **CS:** D18 (GPIO9)
- **Arduino object:** `SPI1`

```cpp
#include <SPI.h>

const int CS_PIN = D3; // GPIO5

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

### UART (Two Buses)

**Serial1 (edge pins — primary):**
- **TX:** D6 (GPIO0)
- **RX:** D7 (GPIO1)
- **Arduino object:** `Serial1`

**Serial2 (back pads):**
- **TX:** D12 (GPIO20)
- **RX:** D11 (GPIO21)
- **Arduino object:** `Serial2`

**USB Serial:** `Serial` (USB CDC — for Serial Monitor)

```cpp
void setup() {
    Serial.begin(115200);     // USB serial (Serial Monitor)
    Serial1.begin(9600);      // Hardware UART on D6/D7
    Serial2.setTX(20);        // D12 / GPIO20
    Serial2.setRX(21);        // D11 / GPIO21
    Serial2.begin(9600);      // Second UART on back pads
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

> **Note:** Only D0–D2 (GPIO26–28) support analog input. All other pins are digital only.

### Battery Voltage Reading

```cpp
void setup() {
    Serial.begin(115200);
    analogReadResolution(12);
}

void loop() {
    int raw = analogRead(29); // Internal ADC_BAT (GPIO29)
    float voltage = raw * 3.3 / 4095.0 * 2.0; // Voltage divider
    Serial.printf("Battery: %.2fV\n", voltage);
    delay(1000);
}
```

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **5V output:** From USB VBUS
- **3.3V output:** Regulated from onboard LDO
- **Deep sleep:** ~50 μA

### Battery Support

- **Battery pads:** Solder LiPo battery to BAT+ and BAT- pads on the bottom
- **Charge LED:** Red LED indicates charging status
- **Battery voltage:** Readable via internal ADC_BAT (GPIO29)
- **Input:** 3.7V LiPo battery

### Deep Sleep

```cpp
#include "pico/stdlib.h"
#include "hardware/dormant.h"

void setup() {
    Serial.begin(115200);
    Serial.println("Going to sleep...");
    delay(1000);

    // Configure wake-up pin
    // dormant_until_pin(D0, true, true); // Wake on D0 rising edge

    // Or use the Arduino-pico sleep API:
    // rp2040.sleep(); // Light sleep
}

void loop() {}
```

> **Note:** Full dormant mode support depends on the Arduino-pico core version. Check the Earle Philhower core documentation for the latest sleep/dormant APIs.

---

## Special Features

### Expanded GPIO (19 Total)

The XIAO RP2350 has 8 additional GPIO pads on the back (D11–D18), providing:
- 2nd UART (TX1/RX1 on D12/D11)
- 2nd I2C (SDA0/SCL0 on D14/D13)
- 2nd SPI (full bus with CS on D15–D18)

This gives 19 total GPIOs — significantly more than other XIAO boards with 11.

### Dual Cortex-M33 with FPU

The RP2350 has dual ARM Cortex-M33 cores with hardware floating-point unit. Use the Arduino-pico multicore API:

```cpp
void setup() {
    Serial.begin(115200);
}

void setup1() {
    // Runs on core 1
}

void loop() {
    Serial.println("Core 0");
    delay(1000);
}

void loop1() {
    // Runs on core 1
    Serial.println("Core 1");
    delay(1000);
}
```

### PIO (Programmable I/O)

The RP2350 includes PIO state machines for custom I/O protocols. The Arduino-pico core supports PIO:

```cpp
// PIO is used internally by NeoPixel, Servo, and other libraries
// For custom PIO programs, see the arduino-pico PIO documentation
```

### RGB LED (NeoPixel/WS2812)

Addressable RGB LED on GPIO22. See the RGB LED example above. Requires the `Adafruit_NeoPixel` library.

### Arm TrustZone

Hardware-based security isolation for secure and non-secure worlds. Available through the RP2350 SDK but not directly exposed in the Arduino framework.

### OTP (One-Time Programmable) Memory

Secure storage for boot keys and configuration. Not accessible from Arduino.

---

## Common Gotchas / Notes

1. **Only 3 analog pins** — D0–D2 (GPIO26–28) have ADC; all other pins are digital only
2. **19 GPIOs total** — 11 on edge + 8 on back pads (D11–D18); back pads require soldering
3. **Two of each bus** — 2× I2C, 2× SPI, 2× UART available (edge + back pads)
4. **No wireless** — No WiFi or Bluetooth; use ESP32 variants for wireless
5. **Boot mode** — Hold BOOT, press RESET, release BOOT; board appears as "RP2350" USB drive
6. **User LED on GPIO25** — Yellow LED, active HIGH
7. **RGB LED on GPIO22** — WS2812/NeoPixel; requires `Adafruit_NeoPixel` library
8. **Battery voltage** — Readable via internal GPIO29 ADC
9. **Dual-core supported** — Use `setup1()`/`loop1()` for core 1 code
10. **3.3V logic only** — Do NOT connect 5V signals directly to GPIO pins
11. **Earle Philhower core** — Uses the community Arduino-pico core, not the official Arduino Mbed core
12. **Boot pin label** — Wiki labels it "RP2040_BOOT" (documentation artifact from predecessor)

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/xiao_rp2350_arduino/
- **Arduino-pico core:** https://github.com/earlephilhower/arduino-pico
- **Arduino-pico docs:** https://arduino-pico.readthedocs.io/
- **RP2350 datasheet:** https://datasheets.raspberrypi.com/rp2350/rp2350-datasheet.pdf
- **Schematic:** https://files.seeedstudio.com/wiki/XIAO-RP2350/res/XIAO_RP2350_v1.0_SCH.pdf
