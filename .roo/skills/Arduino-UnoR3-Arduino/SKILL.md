---
name: arduino-unor3-arduino
description: >
  Provides comprehensive pinout reference, board specifications, and Arduino C++ development guide
  for the Arduino Uno R3 (ATmega328P) microcontroller. Use when writing Arduino firmware for the
  Arduino Uno R3, wiring peripherals, or configuring pins. Keywords: Arduino, Uno, R3, ATmega328P,
  AVR, C++, pinout, GPIO, I2C, SPI, UART, analog, digital, PWM, 5V, 8-bit, arduino-cli.
---

# Arduino Uno R3 — Arduino Development Guide

Provides comprehensive reference for developing Arduino C++ firmware for the Arduino Uno R3 (ATmega328P).

## When to Use

- Writing Arduino C++ firmware targeting the Arduino Uno R3
- Looking up Arduino Uno R3 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the Arduino Uno R3 and need GPIO reference
- Configuring I2C, SPI, UART, or analog I/O on the Arduino Uno R3 in Arduino

## When NOT to Use

- For TinyGo development on the Uno R3 → use the `Arduino-UnoR3-TinyGo` skill
- For Arduino Uno R4 boards → use the `Arduino-UnoR4Minima-Arduino` or `Arduino-UnoR4WiFi-Arduino` skill
- For Arduino Nano → use the `Arduino-Nano-Arduino` skill
- For Arduino Mega 2560 → use the `Arduino-Mega2560-Arduino` skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | ATmega328P |
| **Architecture** | 8-bit AVR |
| **Clock Speed** | 16 MHz |
| **Flash** | 32 KB (0.5 KB used by bootloader) |
| **SRAM** | 2 KB |
| **EEPROM** | 1 KB |
| **USB** | USB-B (via ATmega16U2 USB-serial) |
| **Operating Voltage** | 5V |
| **Input Voltage (VIN)** | 7–12V recommended (6–20V limit) |
| **DC Current per I/O Pin** | 20 mA |
| **DC Current for 3.3V Pin** | 50 mA |
| **Dimensions** | 68.6 × 53.4 mm |
| **Weight** | 25 g |
| **Digital I/O** | 14 (D0–D13) |
| **PWM Outputs** | 6 (D3, D5, D6, D9, D10, D11) |
| **Analog Inputs** | 6 (A0–A5, 10-bit ADC) |
| **Built-in LED** | D13 |

---

## Pinout Diagram

```
                              [USB-B]        [Barrel Jack]
                    ┌──────────────────────────────┐
                    │  RESET  IOREF  5V  GND  VIN  │ ← Power Header
                    │  3.3V   AREF   GND            │
                    ├──────────────────────────────┤
          SCL/A5 ──┤ A5                        D13 ├── SCK / Built-in LED
          SDA/A4 ──┤ A4                        D12 ├── MISO
              A3 ──┤ A3                       ~D11 ├── MOSI / PWM
              A2 ──┤ A2                       ~D10 ├── SS / PWM
              A1 ──┤ A1                        ~D9 ├── PWM
              A0 ──┤ A0                         D8 ├──
                    │                               │
                    │         [ATmega328P]          │
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
| D10 | ✓       | —      | ✓   | —         | **SS** | — | —  | — |
| D11 | ✓       | —      | ✓   | —         | **MOSI** | — | — | — |
| D12 | ✓       | —      | —   | —         | **MISO** | — | — | — |
| D13 | ✓       | —      | —   | —         | **SCK** | — | —  | Built-in LED |
| A0  | ✓       | ADC0   | —   | —         | —   | —   | —    | — |
| A1  | ✓       | ADC1   | —   | —         | —   | —   | —    | — |
| A2  | ✓       | ADC2   | —   | —         | —   | —   | —    | — |
| A3  | ✓       | ADC3   | —   | —         | —   | —   | —    | — |
| A4  | ✓       | ADC4   | —   | —         | —   | **SDA** | — | — |
| A5  | ✓       | ADC5   | —   | —         | —   | **SCL** | — | — |

### Power Pins

| Pin | Function |
|-----|----------|
| VIN | Input voltage (7–12V recommended) |
| 5V  | Regulated 5V output |
| 3.3V | Regulated 3.3V output (50 mA max) |
| GND | Ground (3 pins) |
| AREF | Analog reference voltage |
| IOREF | I/O reference voltage |
| RESET | Reset (active LOW) |

---

## Arduino Setup

### Board Manager

The Arduino Uno R3 is included in the **built-in** Arduino AVR core. No additional board manager URL is needed.

### Board FQBN

```
arduino:avr:uno
```

### Arduino CLI Setup

```bash
# The AVR core is built-in; update index to ensure it's available
arduino-cli core update-index
arduino-cli core install arduino:avr

# Compile
arduino-cli compile --fqbn arduino:avr:uno ./sketch

# Upload (replace /dev/ttyACM0 with your port)
arduino-cli upload --fqbn arduino:avr:uno -p /dev/ttyACM0 ./sketch

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
    Wire.beginTransmission(0x3C); // Address
    Wire.write(0x00);             // Register
    Wire.endTransmission();

    Wire.requestFrom(0x3C, 1);   // Request 1 byte
    if (Wire.available()) {
        uint8_t data = Wire.read();
    }
}
```

### SPI

- **SCK:** D13
- **MISO:** D12
- **MOSI:** D11
- **SS:** D10 (or any GPIO)
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

> **⚠ Warning:** D13 is shared between SPI SCK and the built-in LED. The LED will flicker during SPI transfers.

### UART

- **TX:** D1
- **RX:** D0
- **Arduino object:** `Serial`

```cpp
void setup() {
    Serial.begin(9600); // USB serial (via ATmega16U2)
}

void loop() {
    if (Serial.available()) {
        char c = Serial.read();
        Serial.print("Received: ");
        Serial.println(c);
    }
}
```

> **Note:** The Uno R3 has only one hardware UART, shared between USB-serial and D0/D1. For additional serial ports, use `SoftwareSerial`:

```cpp
#include <SoftwareSerial.h>

SoftwareSerial mySerial(2, 3); // RX=D2, TX=D3

void setup() {
    Serial.begin(9600);    // USB serial
    mySerial.begin(9600);  // Software serial on D2/D3
}

void loop() {
    if (mySerial.available()) {
        Serial.write(mySerial.read());
    }
}
```

### Analog Read (ADC)

```cpp
void setup() {
    Serial.begin(9600);
    // analogReference(DEFAULT); // 5V reference (default)
    // analogReference(EXTERNAL); // Use AREF pin
}

void loop() {
    int value = analogRead(A0); // 10-bit: 0–1023
    float voltage = value * (5.0 / 1023.0);
    Serial.print("A0: ");
    Serial.print(value);
    Serial.print(" (");
    Serial.print(voltage);
    Serial.println("V)");
    delay(100);
}
```

### PWM Output

```cpp
void setup() {
    pinMode(9, OUTPUT); // D9 — PWM capable
}

void loop() {
    // analogWrite range: 0–255 (8-bit)
    for (int i = 0; i <= 255; i++) {
        analogWrite(9, i);
        delay(5);
    }
}
```

> **PWM frequencies:** D5/D6 run at ~980 Hz; D3/D9/D10/D11 run at ~490 Hz.

### External Interrupts

```cpp
volatile bool triggered = false;

void isr() {
    triggered = true;
}

void setup() {
    Serial.begin(9600);
    pinMode(2, INPUT_PULLUP);
    attachInterrupt(digitalPinToInterrupt(2), isr, FALLING); // INT0 on D2
}

void loop() {
    if (triggered) {
        Serial.println("Interrupt on D2!");
        triggered = false;
    }
}
```

### EEPROM

```cpp
#include <EEPROM.h>

void setup() {
    Serial.begin(9600);

    // Write a byte
    EEPROM.write(0, 42);

    // Read a byte
    uint8_t value = EEPROM.read(0);
    Serial.print("EEPROM[0] = ");
    Serial.println(value);

    // EEPROM.put() / EEPROM.get() for structs
}
```

> **Note:** EEPROM has ~100,000 write cycles per cell. Avoid writing in a loop.

---

## Power Management

### Voltage and Current

- **Logic level:** 5V on all GPIO pins
- **Max current per pin:** 20 mA
- **Total current (all pins):** 200 mA max
- **5V output:** From USB or regulated from VIN
- **3.3V output:** 50 mA max (from onboard regulator)

### ⚠ 5V Logic Level Warning

The Arduino Uno R3 operates at **5V logic**. This is different from 3.3V boards (XIAO, ESP32, etc.):

- **Do NOT connect 3.3V sensors/devices directly** without level shifting
- **Do NOT connect Uno outputs to 3.3V device inputs** — the 5V signal can damage them
- Use a **bidirectional level shifter** (e.g., BSS138-based) for I2C/SPI/GPIO between 5V and 3.3V devices
- A simple **voltage divider** (e.g., 1kΩ + 2kΩ) works for unidirectional 5V→3.3V signals

### Low Power (Arduino)

```cpp
#include <avr/sleep.h>
#include <avr/power.h>

void setup() {
    pinMode(2, INPUT_PULLUP);
    attachInterrupt(digitalPinToInterrupt(2), wakeUp, LOW);
}

void wakeUp() {
    // ISR — keep empty or minimal
}

void loop() {
    // Do work...

    // Enter power-down mode
    set_sleep_mode(SLEEP_MODE_PWR_DOWN);
    sleep_enable();
    sleep_mode(); // CPU sleeps here until interrupt

    // Wakes up here
    sleep_disable();
}
```

> **Sleep modes:** `SLEEP_MODE_IDLE` (~15 mA), `SLEEP_MODE_PWR_DOWN` (~0.1 μA + peripherals). Wake via external interrupt (INT0/INT1) or watchdog timer.

---

## Special Features

- **The classic reference board** — Most Arduino shields and tutorials target the Uno R3
- **Replaceable DIP-28 ATmega328P** — The MCU is socketed and can be swapped
- **ICSP header** — For direct AVR programming (bypassing bootloader)
- **Auto-reset** — Serial connection triggers reset for easy upload
- **Overcurrent protection** — Resettable polyfuse on USB
- **ATmega16U2 USB-serial bridge** — Dedicated chip for USB communication
- **SoftwareSerial** — Emulate additional serial ports on any digital pins

---

## Common Gotchas / Notes

1. **5V logic** — All GPIO pins are 5V; use level shifters when connecting to 3.3V devices
2. **2 KB SRAM** — Limited RAM; avoid large `String` objects, use `F()` macro for string literals in flash
3. **32 KB Flash** — Watch sketch size; large libraries can fill flash quickly
4. **D0/D1 shared with USB-serial** — External UART devices on D0/D1 conflict with programming/serial monitor
5. **D13 LED flickers during SPI** — The built-in LED is on the same pin as SPI SCK
6. **Only 2 external interrupts** — INT0 (D2) and INT1 (D3); use pin-change interrupts for more
7. **10-bit ADC only** — Analog resolution is 10-bit (0–1023)
8. **No DAC** — No analog output; use PWM with `analogWrite()` for pseudo-analog
9. **No wireless** — No WiFi or Bluetooth; use external modules (ESP8266, HC-05) if needed
10. **Use F() macro** — `Serial.println(F("text"))` stores strings in flash instead of SRAM

---

## Reference Links

- **Arduino Uno R3 docs:** https://docs.arduino.cc/hardware/uno-rev3/
- **ATmega328P datasheet:** https://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-7810-Automotive-Microcontrollers-ATmega328P_Datasheet.pdf
- **Arduino Language Reference:** https://www.arduino.cc/reference/en/
- **Pinout PDF:** https://docs.arduino.cc/resources/pinouts/A000066-full-pinout.pdf
- **Schematic:** https://docs.arduino.cc/resources/datasheets/A000066-datasheet.pdf
