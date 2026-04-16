---
name: arduino-unor4minima-arduino
description: >
  Provides comprehensive pinout reference, board specifications, and Arduino C++ development guide
  for the Arduino Uno R4 Minima (Renesas RA4M1) microcontroller. Use when writing Arduino firmware
  for the Arduino Uno R4 Minima, wiring peripherals, or configuring pins. Keywords: Arduino, Uno,
  R4, Minima, RA4M1, Renesas, Cortex-M4, C++, pinout, GPIO, I2C, SPI, UART, DAC, CAN, analog,
  digital, PWM, 5V, 32-bit, USB-C, 14-bit ADC, arduino-cli.
---

# Arduino Uno R4 Minima — Arduino Development Guide

Provides comprehensive reference for developing Arduino C++ firmware for the Arduino Uno R4 Minima (Renesas RA4M1).

## When to Use

- Writing Arduino C++ firmware targeting the Arduino Uno R4 Minima
- Looking up Arduino Uno R4 Minima pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the Arduino Uno R4 Minima and need GPIO reference
- Configuring I2C, SPI, UART, DAC, or CAN on the Arduino Uno R4 Minima in Arduino

## When NOT to Use

- For TinyGo development on the Uno R4 Minima → use the `Arduino-UnoR4Minima-TinyGo` skill
- For Arduino Uno R4 WiFi → use the `Arduino-UnoR4WiFi-Arduino` skill
- For Arduino Uno R3 → use the `Arduino-UnoR3-Arduino` skill
- For Arduino Nano → use the `Arduino-Nano-Arduino` skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Renesas RA4M1 (R7FA4M1AB3CFM) |
| **Architecture** | 32-bit Arm Cortex-M4 |
| **Clock Speed** | 48 MHz |
| **Flash** | 256 kB |
| **SRAM** | 32 kB |
| **EEPROM** | 8 kB (data flash) |
| **USB** | USB-C (native USB) |
| **Operating Voltage** | 5V |
| **Input Voltage (VIN)** | 6–24V |
| **DC Current per I/O Pin** | 8 mA |
| **Dimensions** | 68.85 × 53.34 mm |
| **Digital I/O** | 14 (D0–D13) |
| **PWM Outputs** | 6 (D3, D5, D6, D9, D10, D11) |
| **Analog Inputs** | 6 (A0–A5, up to 14-bit ADC) |
| **DAC Output** | 1 (A0) |
| **CAN Bus** | 1 (requires external transceiver) |
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
                    │        [Renesas RA4M1]        │
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
                    │          [ICSP]               │
                    └──────────────────────────────┘

  ~ = PWM capable    INT = External interrupt
  CAN TX/RX available on dedicated header (requires transceiver)
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

The Arduino Uno R4 requires the **Arduino UNO R4 Boards** core (`arduino:renesas_uno`).

### Board FQBN

```
arduino:renesas_uno:minima
```

### Arduino CLI Setup

```bash
# Update index and install the Renesas UNO R4 core
arduino-cli core update-index
arduino-cli core install arduino:renesas_uno

# Compile
arduino-cli compile --fqbn arduino:renesas_uno:minima ./sketch

# Upload (replace /dev/ttyACM0 with your port)
arduino-cli upload --fqbn arduino:renesas_uno:minima -p /dev/ttyACM0 ./sketch

# Monitor serial output
arduino-cli monitor -p /dev/ttyACM0 --config baudrate=9600
```

### Example: Blink (Arduino)

```cpp
// Built-in LED on D13
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

### I2C

- **SDA:** A4
- **SCL:** A5
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

### SPI

- **SCK:** D13
- **CIPO (MISO):** D12
- **COPI (MOSI):** D11
- **CS:** D10 (or any GPIO)
- **Arduino object:** `SPI`

```cpp
#include <SPI.h>

const int CS_PIN = 10; // D10

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
        Serial.print(c); // Echo to USB serial
    }
}
```

> **Note:** On the R4, `Serial` is USB CDC (native USB) and `Serial1` is the hardware UART on D0/D1. This is different from the Uno R3 where `Serial` goes through the ATmega16U2.

### Analog Read (ADC) — 14-bit Resolution

```cpp
void setup() {
    Serial.begin(9600);
    analogReadResolution(14); // 14-bit: 0–16383 (default is 10-bit)
}

void loop() {
    int value = analogRead(A0); // 14-bit: 0–16383
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
    // Output a sine wave on A0 (DAC)
    for (int i = 0; i < 360; i++) {
        float rad = i * 3.14159 / 180.0;
        int dacValue = (int)(2047.5 + 2047.5 * sin(rad));
        analogWrite(A0, dacValue);
        delayMicroseconds(100);
    }
}
```

> **Note:** `analogWrite()` on A0 uses the true DAC (12-bit). On PWM pins (D3, D5, D6, D9, D10, D11), `analogWrite()` produces PWM output.

### CAN Bus

```cpp
#include <Arduino_CAN.h>

void setup() {
    Serial.begin(9600);

    // Initialize CAN at 500 kbps
    if (!CAN.begin(CanBitRate::BR_500k)) {
        Serial.println("CAN init failed!");
        while (1);
    }
    Serial.println("CAN initialized");
}

void loop() {
    // Send a CAN message
    uint8_t data[] = {0x01, 0x02, 0x03, 0x04};
    CanMsg msg(CanStandardId(0x100), sizeof(data), data);
    CAN.write(msg);

    // Receive CAN messages
    if (CAN.available()) {
        CanMsg rxMsg = CAN.read();
        Serial.print("ID: 0x");
        Serial.print(rxMsg.id, HEX);
        Serial.print(" Data: ");
        for (int i = 0; i < rxMsg.data_length; i++) {
            Serial.print(rxMsg.data[i], HEX);
            Serial.print(" ");
        }
        Serial.println();
    }

    delay(100);
}
```

> **⚠ CAN requires an external transceiver** (e.g., MCP2551, SN65HVD230) connected to the CAN TX/RX pins on the board header.

### HID (Keyboard/Mouse Emulation)

```cpp
#include <Keyboard.h>

void setup() {
    pinMode(2, INPUT_PULLUP);
    Keyboard.begin();
}

void loop() {
    if (digitalRead(2) == LOW) {
        Keyboard.println("Hello from Uno R4!");
        delay(500);
    }
}
```

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

---

## Power Management

### Voltage and Current

- **Logic level:** 5V on all GPIO pins
- **Max current per pin:** 8 mA (lower than Uno R3's 20 mA!)
- **5V output:** From USB-C or regulated from VIN
- **3.3V output:** From onboard regulator
- **VIN range:** 6–24V (wider than Uno R3)

### ⚠ 5V Logic Level Warning

The Arduino Uno R4 Minima operates at **5V logic**. This is different from 3.3V boards (XIAO, ESP32, etc.):

- **Do NOT connect 3.3V sensors/devices directly** without level shifting
- **Do NOT connect R4 outputs to 3.3V device inputs** — the 5V signal can damage them
- Use a **bidirectional level shifter** for I2C/SPI/GPIO between 5V and 3.3V devices

### ⚠ Lower Current per Pin

The Uno R4 Minima has a **maximum of 8 mA per GPIO pin** — significantly lower than the Uno R3's 20 mA:

- **Do NOT drive LEDs directly** without a current-limiting resistor (use 470Ω–1kΩ)
- **Do NOT drive motors or relays directly** — use a transistor/MOSFET driver
- Consider using a buffer IC for driving multiple loads

### Low Power (Arduino)

```cpp
#include <RTC.h>

void setup() {
    RTC.begin();

    // Set alarm to wake up in 10 seconds
    RTCTime alarmTime;
    alarmTime.setSecond(10);

    AlarmMatch match;
    match.addMatchSecond();

    RTC.setAlarmCallback(alarmCallback, alarmTime, match);
}

void alarmCallback() {
    // Wake-up handler
}

void loop() {
    // Enter low-power mode
    // The RA4M1 supports several low-power modes
    // Use the LowPower library or direct register access
    delay(1000);
}
```

---

## Special Features

- **First 32-bit Uno** — Arm Cortex-M4 at 48 MHz (3× faster than ATmega328P)
- **14-bit ADC** — Configurable resolution via `analogReadResolution(14)`
- **12-bit DAC on A0** — True analog output via `analogWrite(A0, value)`
- **CAN Bus** — Hardware CAN with `Arduino_CAN` library (requires external transceiver)
- **Real-Time Clock (RTC)** — Built-in RTC with `RTC` library; VRTC pin for battery backup
- **HID support** — Native USB allows keyboard/mouse emulation via `Keyboard.h` / `Mouse.h`
- **USB-C connector** — Modern connector with native USB (no ATmega16U2 bridge)
- **24V VIN support** — Wider input voltage range (6–24V vs 7–12V on R3)
- **Uno R3 shield compatible** — Same header layout as Uno R3

---

## Common Gotchas / Notes

1. **5V logic** — All GPIO pins are 5V; use level shifters when connecting to 3.3V devices
2. **8 mA per pin** — Much lower than Uno R3's 20 mA; use drivers for LEDs and loads
3. **Serial vs Serial1** — `Serial` is USB CDC (native USB); `Serial1` is hardware UART on D0/D1
4. **D13 LED flickers during SPI** — Built-in LED shares the SPI SCK pin
5. **CAN needs transceiver** — CAN bus requires an external transceiver IC
6. **DAC only on A0** — Only one DAC output pin; other pins use PWM for `analogWrite()`
7. **analogReadResolution()** — Must call `analogReadResolution(14)` to get 14-bit ADC; default is 10-bit
8. **Double-tap reset for bootloader** — If upload fails, double-tap reset button
9. **Not all R3 shields compatible** — Shields drawing >8 mA per pin may not work correctly
10. **USB-C cable matters** — Use a data-capable USB-C cable (not charge-only)

---

## Reference Links

- **Arduino Uno R4 Minima docs:** https://docs.arduino.cc/hardware/uno-r4-minima/
- **Arduino UNO R4 core:** https://github.com/arduino/ArduinoCore-renesas
- **Renesas RA4M1 datasheet:** https://www.renesas.com/us/en/document/dst/ra4m1-group-datasheet
- **Arduino Language Reference:** https://www.arduino.cc/reference/en/
- **Pinout PDF:** https://docs.arduino.cc/resources/pinouts/ABX00080-full-pinout.pdf
- **Datasheet:** https://docs.arduino.cc/resources/datasheets/ABX00080-datasheet.pdf
