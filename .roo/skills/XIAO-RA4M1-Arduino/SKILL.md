---
name: xiao-ra4m1-arduino
description: >
  Provides comprehensive pinout reference, board specifications, and Arduino C++ development guide
  for the Seeed Studio XIAO RA4M1 microcontroller. Use when writing Arduino firmware for the
  XIAO RA4M1, wiring peripherals, or configuring pins. Keywords: XIAO, RA4M1, Arduino, Renesas,
  Cortex-M4, FPU, CAN bus, DAC, 14-bit ADC, EEPROM, Arduino Uno R4, pinout, GPIO, I2C, SPI,
  UART, analog, digital, PWM, RGB LED, NeoPixel, back pads, 19 GPIO, battery, AES encryption.
---

# XIAO RA4M1 — Arduino Development Guide

Provides comprehensive reference for developing Arduino C++ firmware for the Seeed Studio XIAO RA4M1.

## When to Use

- Writing Arduino C++ firmware targeting the XIAO RA4M1
- Looking up XIAO RA4M1 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO RA4M1 and need GPIO reference
- Configuring I2C, SPI, UART, CAN bus, DAC, or analog I/O on the XIAO RA4M1 in Arduino

## When NOT to Use

- For TinyGo development on the XIAO RA4M1 → use the `XIAO-RA4M1-TinyGo` skill
- For other XIAO boards → use the corresponding board skill
- For the Arduino Uno R4 (same MCU, different board) → check Arduino Uno R4 resources

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Renesas RA4M1 (R7FA4M1AB3CNE) |
| **Architecture** | 32-bit ARM Cortex-M4 with FPU |
| **Clock Speed** | Up to 48 MHz |
| **Flash** | 256 KB |
| **RAM** | 32 KB SRAM |
| **EEPROM** | 8 KB built-in |
| **Wireless** | None |
| **USB** | USB 2.0 (Type-C connector) |
| **Operating Voltage** | 3.3V logic |
| **Dimensions** | 21 × 17.8 mm |
| **Working Temp** | -20°C to 70°C |
| **GPIO Count** | 19 total (11 edge + 8 back pads) |
| **ADC Channels** | 6 (14-bit resolution) |
| **DAC** | 1 (12-bit) |
| **CAN Bus** | 1 (CRX0/CTX0 on D9/D10) |
| **Deep Sleep** | ~42.6 μA @ 3.7V |
| **Onboard** | User LED (Yellow, P011), RGB LED (P112, enable via P500) |
| **Security** | AES128/256 hardware encryption |

---

## Pinout Diagram

```
                      [USB-C]
                ┌───────────────┐
      D0/A0   ──┤ 1          14 ├── 5V
      D1/A1   ──┤ 2          13 ├── GND
      D2/A2   ──┤ 3          12 ├── 3V3
      D3/A3   ──┤ 4          11 ├── D10/MOSI/CTX0
    D4/SDA1   ──┤ 5          10 ├── D9/MISO/CRX0
    D5/SCL1/A4──┤ 6           9 ├── D8/SCK
    D6/TX/SDA2──┤ 7           8 ├── D7/RX/SCL2
                └───────────────┘
         Bottom pads: BAT+, BAT-
    Back pads (8 additional IOs):
      D11/RX9  D12/TX9  D13  D14
      D15/TX0/SDA0  D16/RX0/SCL0  D17/CRX0  D18/CTX0
```

---

## Pin Reference Table

### Edge Pins (11 GPIOs)

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other | Arduino # |
|-----|----------|---------|--------|-----|-----|-----|------|-------|-----------|
| D0  | P014     | ✓       | AN009 (14-bit) | ✓ | — | — | — | — | 0 |
| D1  | P000     | ✓       | AN000 (14-bit) | ✓ | — | — | — | — | 1 |
| D2  | P001     | ✓       | AN001 (14-bit) | ✓ | — | — | — | — | 2 |
| D3  | P002     | ✓       | AN002 (14-bit) | ✓ | — | — | — | — | 3 |
| D4  | P206     | ✓       | —      | ✓   | **SDA1** | — | — | — | 4 |
| D5  | P100     | ✓       | ADC    | ✓   | **SCL1** | — | — | — | 5 |
| D6  | P302     | ✓       | —      | ✓   | **SDA2** | — | **TX2** | — | 6 |
| D7  | P301     | ✓       | —      | ✓   | **SCL2** | — | **RX2** | — | 7 |
| D8  | P111     | ✓       | —      | ✓   | —   | **SCK1** | — | — | 8 |
| D9  | P110     | ✓       | —      | ✓   | —   | **MISO1** | — | **CRX0** (CAN RX) | 9 |
| D10 | P109     | ✓       | —      | ✓   | —   | **MOSI1** | — | **CTX0** (CAN TX) | 10 |

### Back Pads (8 additional GPIOs)

| Pin | Chip Pin | Digital | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|-----|-----|-----|------|-------|
| D11 | P408     | ✓       | ✓   | —   | —   | **RX9** | — |
| D12 | P409     | ✓       | ✓   | —   | —   | **TX9** | — |
| D13 | P013     | ✓       | ✓   | —   | —   | — | — |
| D14 | P012     | ✓       | ✓   | —   | —   | — | — |
| D15 | P101     | ✓       | ✓   | **SDA0** | **MOSI0** | **TX0** | AN021 (ADC) |
| D16 | P104     | ✓       | ✓   | **SCL0** | **MISO0** | **RX0** | — |
| D17 | P102     | ✓       | ✓   | —   | **SCK0** | — | AN020 (ADC), CRX0 |
| D18 | P103     | ✓       | ✓   | —   | — | — | AN019 (ADC), CTX0 |

### Internal / Special Pins

| Name | Chip Pin | Description | Arduino # |
|------|----------|-------------|-----------|
| USER_LED | P011 | Yellow user LED | 19 |
| RGB LED | P112 | RGB LED data | 20 |
| RGB LED EN | P500 | RGB LED enable (set HIGH) | 21 |
| ADC_BAT | P400 | Battery voltage reading | — |
| Reset | RES | Reset | — |
| Boot | P201 | Enter bootloader | — |
| CHARGE_LED | VBUS | Red charge indicator | — |

---

## Arduino Setup

### Board Manager URL

```
https://files.seeedstudio.com/arduino/package_renesas_ports_index.json
```

### Installation

1. Open Arduino IDE → **File** → **Preferences**
2. Add the URL above to **Additional Board Manager URLs**
3. Open **Tools** → **Board** → **Board Manager**
4. Search for **"Seeed Renesas"** and install the **Seeed Renesas Boards** package
5. Select **Tools** → **Board** → **Seeed Renesas Boards** → **XIAO RA4M1**

> **Note:** The XIAO RA4M1 uses the same MCU as the Arduino Uno R4. The official Arduino Renesas core also works, but the Seeed package includes board-specific pin definitions.

### Arduino CLI Setup

```bash
# Add board index
arduino-cli config add board_manager.additional_urls \
  https://files.seeedstudio.com/arduino/package_renesas_ports_index.json

# Update index and install core
arduino-cli core update-index
arduino-cli core install Seeeduino:renesas

# Compile
arduino-cli compile --fqbn Seeeduino:renesas:XIAO_RA4M1 ./sketch

# Upload (replace /dev/ttyACM0 with your port)
arduino-cli upload --fqbn Seeeduino:renesas:XIAO_RA4M1 -p /dev/ttyACM0 ./sketch
```

### Board FQBN

```
Seeeduino:renesas:XIAO_RA4M1
```

### Example: Blink (Arduino)

```cpp
const int LED_PIN = 19; // P011 — Yellow user LED (Arduino pin 19)

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

#define RGB_PIN    20  // P112 — RGB LED data (Arduino pin 20)
#define RGB_EN_PIN 21  // P500 — RGB LED enable (Arduino pin 21)
#define NUM_LEDS   1

Adafruit_NeoPixel pixel(NUM_LEDS, RGB_PIN, NEO_GRB + NEO_KHZ800);

void setup() {
    // Enable RGB LED power
    pinMode(RGB_EN_PIN, OUTPUT);
    digitalWrite(RGB_EN_PIN, HIGH);

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

### I2C (Three Buses)

**Wire1 (edge pins — primary):**
- **SDA:** D4 (P206)
- **SCL:** D5 (P100)
- **Arduino object:** `Wire1`

**Wire2 (edge pins — alternate on D6/D7):**
- **SDA:** D6 (P302)
- **SCL:** D7 (P301)

**Wire (back pads):**
- **SDA:** D15 (P101)
- **SCL:** D16 (P104)
- **Arduino object:** `Wire`

```cpp
#include <Wire.h>

void setup() {
    // Primary I2C on edge pins
    Wire1.begin();
    Wire1.setClock(400000); // 400 kHz
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

> **Note:** D6/D7 have alternate I2C functions (SDA2/SCL2), giving this board effectively 3 I2C buses.

### SPI

**SPI1 (edge pins — primary):**
- **SCK:** D8 (P111)
- **MISO:** D9 (P110)
- **MOSI:** D10 (P109)
- **CS:** Any GPIO (user-defined)
- **Arduino object:** `SPI`

**SPI0 (back pads):**
- **SCK:** D17 (P102)
- **MISO:** D16 (P104)
- **MOSI:** D15 (P101)

```cpp
#include <SPI.h>

const int CS_PIN = D3; // P002

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

> **⚠ Warning:** D9 (MISO) and D10 (MOSI) are shared with CAN bus (CRX0/CTX0). Do not use SPI1 and CAN bus simultaneously.

### UART

**Serial1 (edge pins — primary):**
- **TX:** D6 (P302)
- **RX:** D7 (P301)
- **Arduino object:** `Serial1`

**USB Serial:** `Serial` (USB CDC — for Serial Monitor)

```cpp
void setup() {
    Serial.begin(115200);    // USB serial (Serial Monitor)
    Serial1.begin(9600);     // Hardware UART on D6/D7
}

void loop() {
    if (Serial1.available()) {
        char c = Serial1.read();
        Serial.print(c);
    }
}
```

### Analog Read (ADC — 14-bit)

```cpp
void setup() {
    analogReadResolution(14); // 14-bit resolution (0–16383)
    Serial.begin(115200);
}

void loop() {
    int value = analogRead(A0); // D0 / P014
    Serial.println(value);
    delay(100);
}
```

> **Note:** 6 ADC channels on edge pins: D0–D3 (14-bit) and D5. Additional ADC on back pads D15, D17, D18. The RA4M1 has 14-bit ADC — higher resolution than most microcontrollers.

### DAC (12-bit Analog Output)

```cpp
void setup() {
    analogWriteResolution(12); // 12-bit DAC (0–4095)
    Serial.begin(115200);
}

void loop() {
    // Output a sine wave on the DAC pin
    for (int i = 0; i < 360; i++) {
        float rad = i * PI / 180.0;
        int value = (int)(2047.5 + 2047.5 * sin(rad));
        analogWrite(DAC, value);
        delayMicroseconds(100);
    }
}
```

### CAN Bus

The RA4M1 has a built-in CAN bus controller:
- **CRX0 (CAN RX):** D9 (P110) — shared with SPI1 MISO
- **CTX0 (CAN TX):** D10 (P109) — shared with SPI1 MOSI

```cpp
#include <Arduino_CAN.h>

void setup() {
    Serial.begin(115200);

    // Initialize CAN at 500 kbps
    if (!CAN.begin(CanBitRate::BR_500k)) {
        Serial.println("CAN init failed!");
        while (1);
    }
    Serial.println("CAN initialized!");
}

void loop() {
    // Send a CAN message
    uint8_t data[] = {0x01, 0x02, 0x03, 0x04};
    CanMsg msg(CanStandardId(0x100), sizeof(data), data);
    CAN.write(msg);

    // Receive CAN messages
    if (CAN.available()) {
        CanMsg rxMsg = CAN.read();
        Serial.printf("ID: 0x%X, Len: %d\n", rxMsg.id, rxMsg.data_length);
    }

    delay(100);
}
```

> **⚠ Pin conflict:** CAN bus shares D9/D10 with SPI1. Cannot use both simultaneously. CAN bus requires an external CAN transceiver (e.g., MCP2551 or SN65HVD230).

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **5V output:** From USB VBUS
- **3.3V output:** Regulated from onboard LDO
- **Deep sleep:** ~42.6 μA @ 3.7V

### Battery Support

- **Battery pads:** Solder LiPo battery to BAT+ and BAT- pads on the bottom
- **Charge LED:** Red LED indicates charging status
- **Battery voltage:** Readable via internal ADC_BAT (P400)
- **Input:** 3.7V LiPo battery

### Battery Voltage Reading

```cpp
void setup() {
    Serial.begin(115200);
    analogReadResolution(14);
}

void loop() {
    // Read battery voltage via internal ADC
    // P400 is connected to battery through voltage divider
    // Check schematic for exact divider ratio
    Serial.println("Battery monitoring available via P400");
    delay(1000);
}
```

### Deep Sleep

```cpp
#include "r_lpm.h"

void setup() {
    Serial.begin(115200);
    Serial.println("Going to sleep...");
    delay(1000);

    // Configure low-power mode
    // The Renesas RA4M1 supports multiple low-power modes:
    // - Sleep mode
    // - Deep sleep mode (Software Standby)
    // - Snooze mode

    // Basic approach using Arduino API:
    // Configure wake-up source (e.g., pin interrupt)
    attachInterrupt(digitalPinToInterrupt(D0), wakeUp, RISING);

    // Enter low-power mode
    __WFI(); // Wait For Interrupt
}

void wakeUp() {
    // Wake-up ISR
}

void loop() {}
```

---

## Special Features

### Same MCU as Arduino Uno R4

The XIAO RA4M1 uses the identical Renesas R7FA4M1AB3CNE MCU as the Arduino Uno R4. Benefits:
- Native Arduino IDE compatibility
- Arduino Uno R4 libraries and examples work with minor pin adjustments
- Same peripheral capabilities in the compact XIAO form factor (21 × 17.8 mm)

### CAN Bus

Built-in CAN controller — see the CAN Bus section above. Requires external transceiver.

### 12-bit DAC

True analog output via the built-in 12-bit DAC. See the DAC section above.

### 14-bit ADC

Higher resolution analog input (14-bit, 0–16383) compared to the typical 12-bit ADC on other boards. 6 channels on edge pins.

### 8 KB EEPROM

Built-in non-volatile storage:

```cpp
#include <EEPROM.h>

void setup() {
    Serial.begin(115200);

    // Write a value
    EEPROM.write(0, 42);

    // Read it back
    uint8_t value = EEPROM.read(0);
    Serial.printf("EEPROM value: %d\n", value);

    // Use put/get for larger types
    float temperature = 23.5;
    EEPROM.put(1, temperature);

    float readTemp;
    EEPROM.get(1, readTemp);
    Serial.printf("Temperature: %.1f\n", readTemp);
}

void loop() {}
```

### Hardware Encryption (AES128/256)

The RA4M1 includes hardware AES encryption for secure data processing. Access through the Renesas FSP (Flexible Software Package) crypto APIs.

### Expanded GPIO (19 Total)

8 additional GPIO pads on the back (D11–D18), providing extra UART, I2C, and SPI buses. Effectively 3 I2C buses available (D4/D5, D6/D7, D15/D16).

---

## Common Gotchas / Notes

1. **CAN/SPI pin conflict** — D9/D10 are shared between SPI1 and CAN bus; cannot use both simultaneously
2. **CAN requires transceiver** — The built-in CAN controller needs an external CAN transceiver IC
3. **D6/D7 dual function** — These pins serve as UART TX/RX AND I2C SDA2/SCL2; avoid using both simultaneously
4. **14-bit ADC** — Set `analogReadResolution(14)` to use full 14-bit resolution
5. **RGB LED requires enable** — Set pin 21 (P500) HIGH before using RGB LED on pin 20 (P112)
6. **Boot mode** — Double-tap RESET button quickly to enter bootloader
7. **3.3V logic only** — Do NOT connect 5V signals directly to GPIO pins
8. **Same MCU as Uno R4** — Many Arduino Uno R4 resources and libraries apply
9. **19 GPIOs total** — 11 on edge + 8 on back pads; back pads require soldering
10. **Lower clock speed** — 48 MHz is slower than ESP32 variants; adequate for most embedded tasks
11. **Seeed board package** — Use the Seeed Renesas package for correct pin definitions
12. **Serial vs Serial1** — `Serial` is USB CDC (Serial Monitor); `Serial1` is hardware UART on D6/D7

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/getting_started_xiao_ra4m1/
- **Board package (Seeed):** https://files.seeedstudio.com/arduino/package_renesas_ports_index.json
- **RA4M1 datasheet:** https://www.renesas.com/us/en/document/dst/ra4m1-group-datasheet
- **RA4M1 user manual:** https://www.renesas.com/us/en/document/man/ra4m1-group-users-manual-hardware
- **Arduino CAN library:** https://github.com/arduino/ArduinoCore-renesas
- **Schematic:** https://files.seeedstudio.com/wiki/XIAO-RA4M1/res/XIAO_RA4M1_v1.0_SCH.pdf
