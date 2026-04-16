---
name: arduino-unor4wifi-arduino
description: >
  Provides comprehensive pinout reference, board specifications, and Arduino C++ development guide
  for the Arduino Uno R4 WiFi (Renesas RA4M1 + ESP32-S3) microcontroller. Use when writing Arduino
  firmware for the Arduino Uno R4 WiFi, wiring peripherals, or configuring pins. Keywords: Arduino,
  Uno, R4, WiFi, RA4M1, ESP32-S3, Renesas, Cortex-M4, C++, pinout, GPIO, I2C, SPI, UART, DAC,
  CAN, WiFi, BLE, Bluetooth, LED matrix, Qwiic, analog, digital, PWM, 5V, 32-bit, USB-C, arduino-cli.
---

# Arduino Uno R4 WiFi — Arduino Development Guide

Provides comprehensive reference for developing Arduino C++ firmware for the Arduino Uno R4 WiFi (Renesas RA4M1 + ESP32-S3).

## When to Use

- Writing Arduino C++ firmware targeting the Arduino Uno R4 WiFi
- Looking up Arduino Uno R4 WiFi pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the Arduino Uno R4 WiFi and need GPIO reference
- Configuring I2C, SPI, UART, WiFi, BLE, LED matrix, DAC, or CAN in Arduino

## When NOT to Use

- For TinyGo development on the Uno R4 WiFi → use the `Arduino-UnoR4WiFi-TinyGo` skill
- For Arduino Uno R4 Minima → use the `Arduino-UnoR4Minima-Arduino` skill
- For Arduino Uno R3 → use the `Arduino-UnoR3-Arduino` skill
- For Arduino Nano → use the `Arduino-Nano-Arduino` skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **Main MCU** | Renesas RA4M1 (Arm Cortex-M4) |
| **Radio Module** | ESP32-S3-MINI-1-N8 |
| **Architecture** | 32-bit Arm Cortex-M4 (RA4M1) + Xtensa LX7 (ESP32-S3) |
| **Clock Speed** | 48 MHz (RA4M1) / up to 240 MHz (ESP32-S3) |
| **RA4M1 Flash** | 256 kB |
| **RA4M1 SRAM** | 32 kB |
| **ESP32-S3 ROM** | 384 kB |
| **ESP32-S3 SRAM** | 512 kB |
| **USB** | USB-C (native USB) |
| **Operating Voltage** | 5V (RA4M1) / 3.3V (ESP32-S3) |
| **Input Voltage (VIN)** | 6–24V |
| **DC Current per I/O Pin** | 8 mA |
| **WiFi** | 802.11 b/g/n (2.4 GHz) via ESP32-S3 |
| **Bluetooth** | BLE 5.0 via ESP32-S3 |
| **LED Matrix** | 12×8 (96 LEDs) built-in |
| **Dimensions** | 68.85 × 53.34 mm |
| **Digital I/O** | 14 (D0–D13) |
| **PWM Outputs** | 6 (D3, D5, D6, D9, D10, D11) |
| **Analog Inputs** | 6 (A0–A5, up to 14-bit ADC) |
| **DAC Output** | 1 (A0) |
| **CAN Bus** | 1 (requires external transceiver) |
| **Qwiic/STEMMA QT** | 1 (secondary I2C, 3.3V) |
| **Built-in LED** | D13 |

---

## Pinout Diagram

```
                              [USB-C]         [Barrel Jack]
                    ┌──────────────────────────────┐
                    │  RESET  IOREF  5V  GND  VIN  │ ← Power Header
                    │  3.3V   AREF   GND            │
                    ├──────────────────────────────┤
          SCL/A5 ──┤ A5                        D13 ├── SCK / Built-in LED
          SDA/A4 ──┤ A4                        D12 ├── CIPO (MISO)
              A3 ──┤ A3                       ~D11 ├── COPI (MOSI) / PWM
              A2 ──┤ A2                       ~D10 ├── CS (SS) / PWM
              A1 ──┤ A1                        ~D9 ├── PWM
          DAC/A0 ──┤ A0                         D8 ├──
                    │                               │
                    │  [RA4M1]    [12×8 LED Matrix] │
                    │  [ESP32-S3]   [Qwiic I2C]    │
                    │                               │
                    │                          D7 ├──
                    │                         ~D6 ├── PWM
                    │                         ~D5 ├── PWM
                    │                          D4 ├──
                    │                         ~D3 ├── PWM / INT1
                    │                          D2 ├── INT0
           TX ─────┤ D1                        D1 ├── TX
           RX ─────┤ D0                        D0 ├── RX
                    ├──────────────────────────────┤
                    │    [ICSP]    [ESP32 Header]   │
                    └──────────────────────────────┘

  ~ = PWM capable    INT = External interrupt
  CAN TX/RX on dedicated header    Qwiic = secondary I2C (3.3V)
  ⚠ ESP32 header near USB-C is 3.3V only
```

---

## Pin Reference Table

| Pin | Digital | Analog | PWM | Interrupt | SPI | I2C | UART | Other |
|-----|---------|--------|-----|-----------|-----|-----|------|-------|
| D0  | ✓       | —      | —   | —         | —   | —   | **RX** | — |
| D1  | ✓       | —      | —   | —         | —   | —   | **TX** | — |
| D2  | ✓       | —      | —   | **INT0**  | —   | —   | —    | — |
| D3  | ✓       | —      | ✓   | **INT1**  | —   | —   | —    | — |
| D4  | ✓       | —      | —   | —         | —   | —   | —    | — |
| D5  | ✓       | —      | ✓   | —         | —   | —   | —    | — |
| D6  | ✓       | —      | ✓   | —         | —   | —   | —    | — |
| D7  | ✓       | —      | —   | —         | —   | —   | —    | — |
| D8  | ✓       | —      | —   | —         | —   | —   | —    | — |
| D9  | ✓       | —      | ✓   | —         | —   | —   | —    | — |
| D10 | ✓       | —      | ✓   | —         | **CS** | — | —  | — |
| D11 | ✓       | —      | ✓   | —         | **COPI** | — | — | — |
| D12 | ✓       | —      | —   | —         | **CIPO** | — | — | — |
| D13 | ✓       | —      | —   | —         | **SCK** | — | —  | Built-in LED |
| A0  | ✓       | ADC0   | —   | —         | —   | —   | —    | **DAC** |
| A1  | ✓       | ADC1   | —   | —         | —   | —   | —    | — |
| A2  | ✓       | ADC2   | —   | —         | —   | —   | —    | — |
| A3  | ✓       | ADC3   | —   | —         | —   | —   | —    | — |
| A4  | ✓       | ADC4   | —   | —         | —   | **SDA** | — | — |
| A5  | ✓       | ADC5   | —   | —         | —   | **SCL** | — | — |

### Additional Interfaces

| Interface | Pins / Notes |
|-----------|-------------|
| Qwiic I2C | Secondary I2C bus (IIC0) — **3.3V only** — use `Wire1` |
| CAN Bus | CAN TX/RX on dedicated header (requires external transceiver) |
| LED Matrix | 12×8 (96 LEDs) — use `Arduino_LED_Matrix` library |
| ESP32-S3 Header | Near USB-C — **3.3V only, do NOT connect 5V** |

### Power Pins

| Pin | Function |
|-----|----------|
| VIN | Input voltage (6–24V) |
| 5V  | Regulated 5V output |
| 3.3V | Regulated 3.3V output |
| GND | Ground |
| AREF | Analog reference voltage |
| IOREF | I/O reference voltage |
| RESET | Reset (active LOW) |

---

## Arduino Setup

### Board Manager

The Arduino Uno R4 WiFi requires the **Arduino UNO R4 Boards** core (`arduino:renesas_uno`).

### Board FQBN

```
arduino:renesas_uno:unor4wifi
```

### Arduino CLI Setup

```bash
# Update index and install the Renesas UNO R4 core
arduino-cli core update-index
arduino-cli core install arduino:renesas_uno

# Compile
arduino-cli compile --fqbn arduino:renesas_uno:unor4wifi ./sketch

# Upload (replace /dev/ttyACM0 with your port)
arduino-cli upload --fqbn arduino:renesas_uno:unor4wifi -p /dev/ttyACM0 ./sketch

# Monitor serial output
arduino-cli monitor -p /dev/ttyACM0 --config baudrate=9600
```

### Example: Blink (Arduino)

```cpp
void setup() {
    pinMode(LED_BUILTIN, OUTPUT); // D13
}

void loop() {
    digitalWrite(LED_BUILTIN, HIGH);
    delay(500);
    digitalWrite(LED_BUILTIN, LOW);
    delay(500);
}
```

---

## Communication Protocols

### I2C (Main Bus)

- **SDA:** A4
- **SCL:** A5
- **Arduino object:** `Wire`

```cpp
#include <Wire.h>

void setup() {
    Wire.begin();
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

### I2C (Qwiic — Secondary Bus)

- **Qwiic connector:** Secondary I2C bus at **3.3V only**
- **Arduino object:** `Wire1`

```cpp
#include <Wire.h>

void setup() {
    Wire1.begin(); // Qwiic / secondary I2C bus (3.3V)
}

void loop() {
    Wire1.beginTransmission(0x48); // Qwiic sensor address
    Wire1.write(0x00);
    Wire1.endTransmission();

    Wire1.requestFrom(0x48, 2);
    if (Wire1.available() >= 2) {
        uint8_t msb = Wire1.read();
        uint8_t lsb = Wire1.read();
    }
}
```

> **⚠ Warning:** The Qwiic connector operates at **3.3V**. Do NOT connect 5V I2C devices to the Qwiic port.

### SPI

- **SCK:** D13
- **CIPO (MISO):** D12
- **COPI (MOSI):** D11
- **CS:** D10 (or any GPIO)
- **Arduino object:** `SPI`

```cpp
#include <SPI.h>

const int CS_PIN = 10;

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

- **TX:** D1
- **RX:** D0
- **Arduino object:** `Serial` (USB CDC) and `Serial1` (hardware UART on D0/D1)

```cpp
void setup() {
    Serial.begin(9600);   // USB serial (native USB CDC)
    Serial1.begin(9600);  // Hardware UART on D0/D1
}

void loop() {
    if (Serial1.available()) {
        char c = Serial1.read();
        Serial.print(c);
    }
}
```

### Analog Read (ADC) — 14-bit Resolution

```cpp
void setup() {
    Serial.begin(9600);
    analogReadResolution(14); // 14-bit: 0–16383
}

void loop() {
    int value = analogRead(A0);
    float voltage = value * (5.0 / 16383.0);
    Serial.print("A0: ");
    Serial.print(value);
    Serial.print(" (");
    Serial.print(voltage, 4);
    Serial.println("V)");
    delay(100);
}
```

### DAC Output (12-bit)

```cpp
void setup() {
    analogWriteResolution(12); // 12-bit DAC: 0–4095
}

void loop() {
    for (int i = 0; i < 360; i++) {
        float rad = i * 3.14159 / 180.0;
        int dacValue = (int)(2047.5 + 2047.5 * sin(rad));
        analogWrite(A0, dacValue);
        delayMicroseconds(100);
    }
}
```

### WiFi Station

```cpp
#include <WiFiS3.h>

const char* ssid = "YOUR_SSID";
const char* password = "YOUR_PASSWORD";

void setup() {
    Serial.begin(9600);

    WiFi.begin(ssid, password);
    Serial.print("Connecting to WiFi");
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.println();
    Serial.print("Connected! IP: ");
    Serial.println(WiFi.localIP());
}

void loop() {
    delay(1000);
}
```

> **Note:** Use `WiFiS3.h` (not `WiFi.h`) for the Uno R4 WiFi. The WiFi is handled by the ESP32-S3 co-processor.

### WiFi Access Point

```cpp
#include <WiFiS3.h>

const char* ap_ssid = "UnoR4WiFi-AP";
const char* ap_password = "12345678";

void setup() {
    Serial.begin(9600);

    WiFi.beginAP(ap_ssid, ap_password);
    Serial.print("AP IP: ");
    Serial.println(WiFi.localIP());
}

void loop() {
    delay(1000);
}
```

### BLE Peripheral

```cpp
#include <ArduinoBLE.h>

BLEService ledService("19b10000-e8f2-537e-4f6c-d104768a1214");
BLEByteCharacteristic switchChar("19b10001-e8f2-537e-4f6c-d104768a1214",
                                  BLERead | BLEWrite);

void setup() {
    Serial.begin(9600);
    pinMode(LED_BUILTIN, OUTPUT);

    if (!BLE.begin()) {
        Serial.println("BLE init failed!");
        while (1);
    }

    BLE.setLocalName("UnoR4WiFi");
    BLE.setAdvertisedService(ledService);
    ledService.addCharacteristic(switchChar);
    BLE.addService(ledService);
    switchChar.writeValue(0);
    BLE.advertise();

    Serial.println("BLE advertising started");
}

void loop() {
    BLEDevice central = BLE.central();
    if (central) {
        while (central.connected()) {
            if (switchChar.written()) {
                digitalWrite(LED_BUILTIN, switchChar.value() ? HIGH : LOW);
            }
        }
    }
}
```

### LED Matrix (12×8)

```cpp
#include "Arduino_LED_Matrix.h"

ArduinoLEDMatrix matrix;

// Define a frame (12 columns × 8 rows)
// Each row is 12 bits; use uint32_t array of 3 elements (96 bits total)
const uint32_t heart[] = {
    0x3184a444,
    0x44042081,
    0x100a0040
};

void setup() {
    matrix.begin();
    matrix.loadFrame(heart);
}

void loop() {
    // Matrix stays on
    delay(1000);
}
```

> **Tip:** Use the [Arduino LED Matrix Editor](https://ledmatrix-editor.arduino.cc/) to design frames visually and export the `uint32_t` arrays.

### CAN Bus

```cpp
#include <Arduino_CAN.h>

void setup() {
    Serial.begin(9600);

    if (!CAN.begin(CanBitRate::BR_500k)) {
        Serial.println("CAN init failed!");
        while (1);
    }
    Serial.println("CAN initialized");
}

void loop() {
    uint8_t data[] = {0x01, 0x02, 0x03, 0x04};
    CanMsg msg(CanStandardId(0x100), sizeof(data), data);
    CAN.write(msg);

    if (CAN.available()) {
        CanMsg rxMsg = CAN.read();
        Serial.print("ID: 0x");
        Serial.println(rxMsg.id, HEX);
    }

    delay(100);
}
```

> **⚠ CAN requires an external transceiver** (e.g., MCP2551, SN65HVD230).

### RTC (Real-Time Clock)

```cpp
#include <RTC.h>

void setup() {
    Serial.begin(9600);
    RTC.begin();

    RTCTime startTime(22, Month::MARCH, 2026, 12, 0, 0,
                      DayOfWeek::SUNDAY, SaveLight::SAVING_TIME_INACTIVE);
    RTC.setTime(startTime);
}

void loop() {
    RTCTime currentTime;
    RTC.getTime(currentTime);

    Serial.print(currentTime.getHour());
    Serial.print(":");
    Serial.print(currentTime.getMinutes());
    Serial.print(":");
    Serial.println(currentTime.getSeconds());

    delay(1000);
}
```

### HID (Keyboard/Mouse)

```cpp
#include <Keyboard.h>

void setup() {
    pinMode(2, INPUT_PULLUP);
    Keyboard.begin();
}

void loop() {
    if (digitalRead(2) == LOW) {
        Keyboard.println("Hello from Uno R4 WiFi!");
        delay(500);
    }
}
```

---

## Power Management

### Voltage and Current

- **Logic level:** 5V on RA4M1 GPIO pins; **3.3V on ESP32-S3 and Qwiic**
- **Max current per pin:** 8 mA
- **5V output:** From USB-C or regulated from VIN
- **3.3V output:** From onboard regulator
- **VIN range:** 6–24V

### ⚠ Mixed Voltage Warning

The Uno R4 WiFi has **two voltage domains**:

- **5V:** All standard Arduino header pins (D0–D13, A0–A5)
- **3.3V:** ESP32-S3 header near USB-C and Qwiic connector

**Do NOT connect 5V signals to the ESP32-S3 header or Qwiic connector.**

### ⚠ Lower Current per Pin

Maximum of **8 mA per GPIO pin**:

- Use current-limiting resistors for LEDs (470Ω–1kΩ)
- Use transistor/MOSFET drivers for motors and relays

---

## Special Features

- **WiFi 802.11 b/g/n** — Via ESP32-S3 using `WiFiS3.h` library
- **BLE 5.0** — Via ESP32-S3 using `ArduinoBLE` library
- **12×8 LED Matrix** — 96 programmable LEDs using `Arduino_LED_Matrix` library
- **Qwiic/STEMMA QT connector** — Secondary I2C at 3.3V (`Wire1`)
- **14-bit ADC** — Configurable via `analogReadResolution(14)`
- **12-bit DAC on A0** — True analog output
- **CAN Bus** — Hardware CAN with `Arduino_CAN` library
- **RTC** — Built-in real-time clock with `RTC` library
- **HID support** — Native USB keyboard/mouse emulation
- **USB-C** — Modern connector with native USB
- **Uno R3 shield compatible** — Same header layout
- **OTA updates** — Over-the-air firmware updates via WiFi

---

## Common Gotchas / Notes

1. **Use WiFiS3.h** — Not `WiFi.h`; the R4 WiFi uses a different WiFi library than ESP32 boards
2. **5V logic on headers** — Standard pins are 5V; use level shifters for 3.3V devices
3. **3.3V on Qwiic/ESP32 header** — Do NOT connect 5V to these interfaces
4. **8 mA per pin** — Lower than Uno R3; use drivers for loads
5. **Serial vs Serial1** — `Serial` is USB CDC; `Serial1` is hardware UART on D0/D1
6. **D13 LED flickers during SPI** — Built-in LED shares SPI SCK
7. **CAN needs transceiver** — CAN bus requires an external transceiver IC
8. **DAC only on A0** — Only one DAC output pin
9. **LED Matrix editor** — Use https://ledmatrix-editor.arduino.cc/ to design frames
10. **Double-tap reset for bootloader** — If upload fails, double-tap reset
11. **USB-C cable matters** — Use a data-capable cable
12. **ESP32-S3 firmware** — The ESP32-S3 runs its own firmware; update it via Arduino IDE if WiFi/BLE issues occur

---

## Reference Links

- **Arduino Uno R4 WiFi docs:** https://docs.arduino.cc/hardware/uno-r4-wifi/
- **Arduino UNO R4 core:** https://github.com/arduino/ArduinoCore-renesas
- **WiFiS3 library:** https://www.arduino.cc/reference/en/libraries/wifis3/
- **ArduinoBLE library:** https://www.arduino.cc/reference/en/libraries/arduinoble/
- **LED Matrix library:** https://www.arduino.cc/reference/en/libraries/arduino_led_matrix/
- **LED Matrix Editor:** https://ledmatrix-editor.arduino.cc/
- **Renesas RA4M1 datasheet:** https://www.renesas.com/us/en/document/dst/ra4m1-group-datasheet
- **Pinout PDF:** https://docs.arduino.cc/resources/pinouts/ABX00087-full-pinout.pdf
- **Datasheet:** https://docs.arduino.cc/resources/datasheets/ABX00087-datasheet.pdf
