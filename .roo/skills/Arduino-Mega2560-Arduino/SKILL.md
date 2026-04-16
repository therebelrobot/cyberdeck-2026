---
name: Arduino-Mega2560-Arduino
description: >
  Provides comprehensive pinout reference, board specifications, and Arduino C++ development guide
  for the Arduino Mega 2560 (ATmega2560) microcontroller. Use when writing Arduino firmware for the
  Arduino Mega 2560, wiring peripherals, or configuring pins. Keywords: Arduino, Mega, 2560,
  ATmega2560, AVR, C++, pinout, GPIO, I2C, SPI, UART, analog, digital, PWM, 5V, 8-bit,
  54 pins, 4 UARTs, 16 analog, arduino-cli.
---

# Arduino Mega 2560 — Arduino Development Guide

Provides comprehensive reference for developing Arduino C++ firmware for the Arduino Mega 2560 (ATmega2560).

## When to Use

- Writing Arduino C++ firmware targeting the Arduino Mega 2560
- Looking up Arduino Mega 2560 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the Arduino Mega 2560 and need GPIO reference
- Configuring I2C, SPI, UART, or analog I/O on the Arduino Mega 2560 in Arduino

## When NOT to Use

- For TinyGo development on the Mega 2560 → use the `Arduino-Mega2560-TinyGo` skill
- For Arduino Uno R3 → use the `Arduino-UnoR3-Arduino` skill
- For Arduino Nano → use the `Arduino-Nano-Arduino` skill
- For Arduino Uno R4 boards → use the corresponding R4 skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | ATmega2560 |
| **Architecture** | 8-bit AVR |
| **Clock Speed** | 16 MHz |
| **Flash** | 256 KB (8 KB used by bootloader) |
| **SRAM** | 8 KB |
| **EEPROM** | 4 KB |
| **USB** | USB-B (via ATmega16U2 USB-serial) |
| **Operating Voltage** | 5V |
| **Input Voltage (VIN)** | 7–12V recommended |
| **DC Current per I/O Pin** | 20 mA |
| **Dimensions** | 101.5 × 53.3 mm |
| **Weight** | 37 g |
| **Digital I/O** | 54 (D0–D53) |
| **PWM Outputs** | 15 (D2–D13, D44, D45, D46) |
| **Analog Inputs** | 16 (A0–A15, 10-bit ADC) |
| **UARTs** | 4 (Serial, Serial1, Serial2, Serial3) |
| **External Interrupts** | 6 (D2, D3, D18, D19, D20, D21) |
| **Built-in LED** | D13 |

---

## Pinout Diagram

```
                    [USB-B]                    [Barrel Jack]
    ┌──────────────────────────────────────────────────────┐
    │  RESET  IOREF  5V  GND  GND  VIN                    │ ← Power Header
    │  3.3V   AREF   GND                                  │
    ├──────────────────────────────────────────────────────┤
    │                                                      │
    │  ANALOG HEADER                                       │
    │  A0  A1  A2  A3  A4  A5  A6  A7                    │
    │  A8  A9  A10 A11 A12 A13 A14 A15                   │
    │                                                      │
    ├──────────────────────────────────────────────────────┤
    │                                                      │
    │  DIGITAL HEADER (Uno-compatible side)                │
    │  D0/RX0  D1/TX0  D2  D3  D4  D5  D6  D7           │
    │  D8  D9  D10  D11  D12  D13/LED                    │
    │                                                      │
    │                  [ATmega2560]                        │
    │                                                      │
    │  DIGITAL HEADER (extended)                           │
    │  D14/TX3  D15/RX3  D16/TX2  D17/RX2                │
    │  D18/TX1  D19/RX1  D20/SDA  D21/SCL                │
    │  D22  D23  D24  D25  D26  D27  D28  D29            │
    │  D30  D31  D32  D33  D34  D35  D36  D37            │
    │  D38  D39  D40  D41  D42  D43  D44  D45            │
    │  D46  D47  D48  D49  D50/MISO  D51/MOSI            │
    │  D52/SCK  D53/SS                                    │
    │                                                      │
    ├──────────────────────────────────────────────────────┤
    │          [ICSP]                                      │
    └──────────────────────────────────────────────────────┘

  PWM: D2–D13, D44, D45, D46
  UARTs: Serial(D0/D1), Serial1(D18/D19), Serial2(D16/D17), Serial3(D14/D15)
  I2C: D20(SDA), D21(SCL)
  SPI: D50(MISO), D51(MOSI), D52(SCK), D53(SS)
  Interrupts: D2(INT0), D3(INT1), D18(INT5), D19(INT4), D20(INT3), D21(INT2)
```

---

## Pin Reference Table

### Digital Pins D0–D21 (Communication & Interrupt Pins)

| Pin | Digital | PWM | Interrupt | SPI | I2C | UART | Other |
|-----|---------|-----|-----------|-----|-----|------|-------|
| D0  | ✓       | —   | —         | —   | —   | **Serial RX** | — |
| D1  | ✓       | —   | —         | —   | —   | **Serial TX** | — |
| D2  | ✓       | ✓   | **INT0**  | —   | —   | —    | — |
| D3  | ✓       | ✓   | **INT1**  | —   | —   | —    | — |
| D4  | ✓       | ✓   | —         | —   | —   | —    | — |
| D5  | ✓       | ✓   | —         | —   | —   | —    | — |
| D6  | ✓       | ✓   | —         | —   | —   | —    | — |
| D7  | ✓       | ✓   | —         | —   | —   | —    | — |
| D8  | ✓       | ✓   | —         | —   | —   | —    | — |
| D9  | ✓       | ✓   | —         | —   | —   | —    | — |
| D10 | ✓       | ✓   | —         | —   | —   | —    | — |
| D11 | ✓       | ✓   | —         | —   | —   | —    | — |
| D12 | ✓       | ✓   | —         | —   | —   | —    | — |
| D13 | ✓       | ✓   | —         | —   | —   | —    | Built-in LED |
| D14 | ✓       | —   | —         | —   | —   | **Serial3 TX** | — |
| D15 | ✓       | —   | —         | —   | —   | **Serial3 RX** | — |
| D16 | ✓       | —   | —         | —   | —   | **Serial2 TX** | — |
| D17 | ✓       | —   | —         | —   | —   | **Serial2 RX** | — |
| D18 | ✓       | —   | **INT5**  | —   | —   | **Serial1 TX** | — |
| D19 | ✓       | —   | **INT4**  | —   | —   | **Serial1 RX** | — |
| D20 | ✓       | —   | **INT3**  | —   | **SDA** | — | — |
| D21 | ✓       | —   | **INT2**  | —   | **SCL** | — | — |

### Digital Pins D22–D53 (Extended I/O)

| Pin | Digital | PWM | SPI | Other |
|-----|---------|-----|-----|-------|
| D22–D43 | ✓  | —   | —   | General purpose |
| D44 | ✓       | ✓   | —   | — |
| D45 | ✓       | ✓   | —   | — |
| D46 | ✓       | ✓   | —   | — |
| D47–D49 | ✓  | —   | —   | General purpose |
| D50 | ✓       | —   | **MISO** | — |
| D51 | ✓       | —   | **MOSI** | — |
| D52 | ✓       | —   | **SCK** | — |
| D53 | ✓       | —   | **SS** | — |

### Analog Pins A0–A15

| Pin | Analog | Digital | Other |
|-----|--------|---------|-------|
| A0  | ADC0   | ✓       | — |
| A1  | ADC1   | ✓       | — |
| A2  | ADC2   | ✓       | — |
| A3  | ADC3   | ✓       | — |
| A4  | ADC4   | ✓       | — |
| A5  | ADC5   | ✓       | — |
| A6  | ADC6   | ✓       | — |
| A7  | ADC7   | ✓       | — |
| A8  | ADC8   | ✓       | — |
| A9  | ADC9   | ✓       | — |
| A10 | ADC10  | ✓       | — |
| A11 | ADC11  | ✓       | — |
| A12 | ADC12  | ✓       | — |
| A13 | ADC13  | ✓       | — |
| A14 | ADC14  | ✓       | — |
| A15 | ADC15  | ✓       | — |

### Power Pins

| Pin | Function |
|-----|----------|
| VIN | Input voltage (7–12V recommended) |
| 5V  | Regulated 5V output |
| 3.3V | Regulated 3.3V output (50 mA max) |
| GND | Ground (multiple pins) |
| AREF | Analog reference voltage |
| IOREF | I/O reference voltage |
| RESET | Reset (active LOW) |

---

## Arduino Setup

### Board Manager

The Arduino Mega 2560 is included in the **built-in** Arduino AVR core. No additional board manager URL is needed.

### Board FQBN

```
arduino:avr:mega
```

### Arduino CLI Setup

```bash
# The AVR core is built-in; update index to ensure it's available
arduino-cli core update-index
arduino-cli core install arduino:avr

# Compile
arduino-cli compile --fqbn arduino:avr:mega ./sketch

# Upload (replace /dev/ttyACM0 with your port)
arduino-cli upload --fqbn arduino:avr:mega -p /dev/ttyACM0 ./sketch

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

### I2C

- **SDA:** D20
- **SCL:** D21
- **Arduino object:** `Wire`

```cpp
#include <Wire.h>

void setup() {
    Wire.begin(); // SDA=D20, SCL=D21
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

> **⚠ Important:** I2C pins on the Mega are **D20/D21**, NOT A4/A5 like on the Uno/Nano. Rewire when porting projects from Uno to Mega.

### SPI

- **MISO:** D50
- **MOSI:** D51
- **SCK:** D52
- **SS:** D53 (or any GPIO)
- **Arduino object:** `SPI`

```cpp
#include <SPI.h>

const int CS_PIN = 53; // D53

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

> **⚠ Important:** SPI pins on the Mega are **D50–D53**, NOT D10–D13 like on the Uno/Nano. Shields designed for Uno SPI will NOT work without rewiring or using the ICSP header (which is shared between Uno and Mega).

### UART (4 Hardware Serial Ports)

The Mega 2560 has **4 hardware UARTs** — no need for SoftwareSerial:

| UART | TX Pin | RX Pin | Arduino Object |
|------|--------|--------|----------------|
| Serial  | D1  | D0  | `Serial` (also USB) |
| Serial1 | D18 | D19 | `Serial1` |
| Serial2 | D16 | D17 | `Serial2` |
| Serial3 | D14 | D15 | `Serial3` |

```cpp
void setup() {
    Serial.begin(9600);    // USB serial (via ATmega16U2)
    Serial1.begin(9600);   // Hardware UART 1 (D18/D19)
    Serial2.begin(9600);   // Hardware UART 2 (D16/D17)
    Serial3.begin(9600);   // Hardware UART 3 (D14/D15)
}

void loop() {
    // Read from Serial1, echo to USB serial
    if (Serial1.available()) {
        char c = Serial1.read();
        Serial.print("Serial1: ");
        Serial.println(c);
    }

    // Read from Serial2
    if (Serial2.available()) {
        char c = Serial2.read();
        Serial.print("Serial2: ");
        Serial.println(c);
    }

    // Read from Serial3
    if (Serial3.available()) {
        char c = Serial3.read();
        Serial.print("Serial3: ");
        Serial.println(c);
    }
}
```

> **Tip:** With 4 hardware UARTs, the Mega is ideal for projects that need multiple serial devices (GPS, Bluetooth, sensors) simultaneously without SoftwareSerial overhead.

### Analog Read (ADC)

```cpp
void setup() {
    Serial.begin(9600);
}

void loop() {
    // All 16 analog pins available
    for (int i = 0; i <= 15; i++) {
        int value = analogRead(A0 + i); // 10-bit: 0–1023
        Serial.print("A");
        Serial.print(i);
        Serial.print(": ");
        Serial.print(value);
        Serial.print("  ");
    }
    Serial.println();
    delay(500);
}
```

### PWM Output

```cpp
void setup() {
    // 15 PWM pins available: D2–D13, D44, D45, D46
    pinMode(9, OUTPUT);
    pinMode(44, OUTPUT);
}

void loop() {
    // analogWrite range: 0–255 (8-bit)
    analogWrite(9, 128);   // 50% duty cycle on D9
    analogWrite(44, 64);   // 25% duty cycle on D44
}
```

> **PWM frequencies:** Vary by timer. D4/D13 ~980 Hz; D2/D3/D5–D12 ~490 Hz; D44/D45/D46 ~490 Hz.

### External Interrupts (6 pins)

```cpp
volatile int count = 0;

void isr() {
    count++;
}

void setup() {
    Serial.begin(9600);

    // 6 interrupt pins available
    pinMode(2, INPUT_PULLUP);
    attachInterrupt(digitalPinToInterrupt(2), isr, FALLING);  // INT0

    // Other interrupt pins:
    // D3  → INT1
    // D18 → INT5
    // D19 → INT4
    // D20 → INT3 (shared with SDA!)
    // D21 → INT2 (shared with SCL!)
}

void loop() {
    Serial.print("Count: ");
    Serial.println(count);
    delay(500);
}
```

> **⚠ Warning:** D20 and D21 are shared between I2C (SDA/SCL) and external interrupts (INT3/INT2). You cannot use I2C and interrupts on these pins simultaneously.

### EEPROM

```cpp
#include <EEPROM.h>

void setup() {
    Serial.begin(9600);

    // 4 KB EEPROM (addresses 0–4095)
    EEPROM.write(0, 42);
    uint8_t value = EEPROM.read(0);
    Serial.print("EEPROM[0] = ");
    Serial.println(value);

    Serial.print("EEPROM size: ");
    Serial.println(EEPROM.length()); // 4096
}
```

> **Note:** 4 KB EEPROM — 4× more than Uno/Nano. ~100,000 write cycles per cell.

---

## Power Management

### Voltage and Current

- **Logic level:** 5V on all GPIO pins
- **Max current per pin:** 20 mA
- **Total current (all pins):** 200 mA max
- **5V output:** From USB or regulated from VIN
- **3.3V output:** 50 mA max (from onboard regulator)

### ⚠ 5V Logic Level Warning

The Arduino Mega 2560 operates at **5V logic**:

- **Do NOT connect 3.3V sensors/devices directly** without level shifting
- **Do NOT connect Mega outputs to 3.3V device inputs** — the 5V signal can damage them
- Use a **bidirectional level shifter** for I2C/SPI/GPIO between 5V and 3.3V devices

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
    // Disable unused peripherals to save power
    power_adc_disable();
    power_spi_disable();
    power_usart1_disable();
    power_usart2_disable();
    power_usart3_disable();
    power_timer1_disable();
    power_timer2_disable();
    power_timer3_disable();
    power_timer4_disable();
    power_timer5_disable();
    power_twi_disable();

    set_sleep_mode(SLEEP_MODE_PWR_DOWN);
    sleep_enable();
    sleep_mode();
    sleep_disable();

    // Re-enable peripherals after wake
    power_all_enable();
}
```

> **Note:** The Mega has more peripherals to disable than the Uno, offering more granular power control.

---

## Special Features

- **54 digital I/O pins** — The most of any classic Arduino
- **16 analog inputs** — All can also be used as digital I/O
- **15 PWM outputs** — D2–D13, D44, D45, D46
- **4 hardware UARTs** — Serial, Serial1, Serial2, Serial3 (no SoftwareSerial needed)
- **6 external interrupts** — More than any other classic Arduino
- **8 KB SRAM** — 4× more than Uno/Nano
- **256 KB Flash** — 8× more than Uno/Nano
- **4 KB EEPROM** — 4× more than Uno/Nano
- **Uno shield compatible** — Same header layout on one end
- **ICSP header** — For direct AVR programming (also provides SPI for shields)
- **Barrel plug power** — Same as Uno R3
- **ATmega16U2 USB-serial** — Same as Uno R3

---

## Common Gotchas / Notes

1. **5V logic** — All GPIO pins are 5V; use level shifters for 3.3V devices
2. **SPI pins are D50–D53** — NOT D10–D13 like Uno/Nano; use ICSP header for shield compatibility
3. **I2C pins are D20/D21** — NOT A4/A5 like Uno/Nano; rewire when porting
4. **D20/D21 shared** — I2C (SDA/SCL) and interrupts (INT3/INT2) share these pins
5. **D0/D1 shared with Serial** — Same as Uno; conflicts with USB-serial
6. **Use F() macro** — `Serial.println(F("text"))` stores strings in flash; important even with 8 KB SRAM
7. **Pin numbering** — D22–D53 use different port mappings; verify with datasheet
8. **Shield compatibility** — SPI shields designed for Uno (D10–D13) need ICSP header or rewiring
9. **10-bit ADC only** — Same resolution as Uno/Nano
10. **No DAC** — No analog output; use PWM with `analogWrite()`
11. **No wireless** — No WiFi or Bluetooth; use external modules
12. **Larger bootloader** — 8 KB bootloader reduces usable flash to ~248 KB
13. **Higher power draw** — More peripherals = higher idle current than Uno/Nano

---

## Reference Links

- **Arduino Mega 2560 docs:** https://docs.arduino.cc/hardware/mega-2560/
- **ATmega2560 datasheet:** https://ww1.microchip.com/downloads/en/devicedoc/atmel-2549-8-bit-avr-microcontroller-atmega640-1280-1281-2560-2561_datasheet.pdf
- **Arduino Language Reference:** https://www.arduino.cc/reference/en/
- **Pinout PDF:** https://docs.arduino.cc/resources/pinouts/A000067-full-pinout.pdf
- **Datasheet:** https://docs.arduino.cc/resources/datasheets/A000067-datasheet.pdf
