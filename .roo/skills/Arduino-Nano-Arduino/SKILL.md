---
name: arduino-nano-arduino
description: >
  Provides comprehensive pinout reference, board specifications, and Arduino C++ development guide
  for the Arduino Nano (ATmega328P) microcontroller. Use when writing Arduino firmware for the
  Arduino Nano, wiring peripherals, or configuring pins. Keywords: Arduino, Nano, ATmega328P,
  AVR, C++, pinout, GPIO, I2C, SPI, UART, analog, digital, PWM, 5V, 8-bit, breadboard,
  Mini-B USB, compact, arduino-cli.
---

# Arduino Nano — Arduino Development Guide

Provides comprehensive reference for developing Arduino C++ firmware for the Arduino Nano (ATmega328P).

## When to Use

- Writing Arduino C++ firmware targeting the Arduino Nano
- Looking up Arduino Nano pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the Arduino Nano and need GPIO reference
- Configuring I2C, SPI, UART, or analog I/O on the Arduino Nano in Arduino

## When NOT to Use

- For TinyGo development on the Nano → use the `Arduino-Nano-TinyGo` skill
- For Arduino Uno R3 → use the `Arduino-UnoR3-Arduino` skill (same MCU, different form factor)
- For Arduino Mega 2560 → use the `Arduino-Mega2560-Arduino` skill
- For Arduino Nano Every, Nano 33, or Nano ESP32 → these are different boards

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | ATmega328P |
| **Architecture** | 8-bit AVR |
| **Clock Speed** | 16 MHz |
| **Flash** | 32 KB (2 KB used by bootloader) |
| **SRAM** | 2 KB |
| **EEPROM** | 1 KB |
| **USB** | Mini-B USB |
| **Operating Voltage** | 5V |
| **Input Voltage (VIN)** | 7–12V recommended |
| **DC Current per I/O Pin** | 20 mA |
| **Dimensions** | 45 × 18 mm |
| **Weight** | 7 g |
| **Digital I/O** | 14 (D0–D13) |
| **PWM Outputs** | 6 (D3, D5, D6, D9, D10, D11) |
| **Analog Inputs** | 8 (A0–A7; A6/A7 are analog-only) |
| **Built-in LED** | D13 |

---

## Pinout Diagram

```
                          [Mini-B USB]
                    ┌─────────────────────┐
                    │                     │
              D13 ──┤ D13           D12  ├── D12
             3.3V ──┤ 3V3           D11  ├── ~D11 / MOSI / PWM
             AREF ──┤ AREF          D10  ├── ~D10 / SS / PWM
           A0/D14 ──┤ A0            D9   ├── ~D9 / PWM
           A1/D15 ──┤ A1            D8   ├── D8
           A2/D16 ──┤ A2            D7   ├── D7
           A3/D17 ──┤ A3            D6   ├── ~D6 / PWM
       SDA/A4/D18 ──┤ A4            D5   ├── ~D5 / PWM
       SCL/A5/D19 ──┤ A5            D4   ├── D4
        A6 (analog) ┤ A6            D3   ├── ~D3 / PWM / INT1
        A7 (analog) ┤ A7            D2   ├── D2 / INT0
               5V ──┤ 5V            GND  ├── GND
            RESET ──┤ RST           RST  ├── RESET
              GND ──┤ GND           D0   ├── RX
              VIN ──┤ VIN           D1   ├── TX
                    │                     │
                    └─────────────────────┘

  ~ = PWM capable    INT = External interrupt
  A6/A7 = Analog input ONLY (no digital I/O)
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
| A6  | **—**   | ADC6   | —   | —         | —   | —   | —    | **Analog only** |
| A7  | **—**   | ADC7   | —   | —         | —   | —   | —    | **Analog only** |

### Power Pins

| Pin | Function |
|-----|----------|
| VIN | Input voltage (7–12V recommended) |
| 5V  | Regulated 5V output |
| 3.3V | Regulated 3.3V output |
| GND | Ground |
| AREF | Analog reference voltage |
| RESET | Reset (active LOW) |

---

## Arduino Setup

### Board Manager

The Arduino Nano is included in the **built-in** Arduino AVR core. No additional board manager URL is needed.

### Board FQBN

```
arduino:avr:nano
```

> **Note:** Some Nano clones use the "old bootloader." If upload fails, try:
> ```
> arduino:avr:nano:cpu=atmega328old
> ```

### Arduino CLI Setup

```bash
# The AVR core is built-in; update index to ensure it's available
arduino-cli core update-index
arduino-cli core install arduino:avr

# Compile
arduino-cli compile --fqbn arduino:avr:nano ./sketch

# Upload (replace /dev/ttyUSB0 with your port)
arduino-cli upload --fqbn arduino:avr:nano -p /dev/ttyUSB0 ./sketch

# For clones with old bootloader:
arduino-cli upload --fqbn arduino:avr:nano:cpu=atmega328old -p /dev/ttyUSB0 ./sketch

# Monitor serial output
arduino-cli monitor -p /dev/ttyUSB0 --config baudrate=9600
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

### SPI

- **SCK:** D13
- **MISO:** D12
- **MOSI:** D11
- **SS:** D10 (or any GPIO)
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

> **⚠ Warning:** D13 is shared between SPI SCK and the built-in LED. The LED will flicker during SPI transfers.

### UART

- **TX:** D1
- **RX:** D0
- **Arduino object:** `Serial`

```cpp
void setup() {
    Serial.begin(9600);
}

void loop() {
    if (Serial.available()) {
        char c = Serial.read();
        Serial.print("Received: ");
        Serial.println(c);
    }
}
```

> **Note:** The Nano has only one hardware UART, shared between USB-serial and D0/D1. For additional serial ports, use `SoftwareSerial`:

```cpp
#include <SoftwareSerial.h>

SoftwareSerial mySerial(2, 3); // RX=D2, TX=D3

void setup() {
    Serial.begin(9600);
    mySerial.begin(9600);
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
}

void loop() {
    // Standard analog pins (A0–A5 also work as digital)
    int value0 = analogRead(A0); // 10-bit: 0–1023
    float voltage = value0 * (5.0 / 1023.0);

    // A6 and A7 — analog only (no digital capability)
    int value6 = analogRead(A6);
    int value7 = analogRead(A7);

    Serial.print("A0: ");
    Serial.print(value0);
    Serial.print("  A6: ");
    Serial.print(value6);
    Serial.print("  A7: ");
    Serial.println(value7);

    delay(100);
}
```

### PWM Output

```cpp
void setup() {
    pinMode(9, OUTPUT);
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

    EEPROM.write(0, 42);
    uint8_t value = EEPROM.read(0);
    Serial.print("EEPROM[0] = ");
    Serial.println(value);
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
- **3.3V output:** From onboard regulator

### ⚠ 5V Logic Level Warning

The Arduino Nano operates at **5V logic**. This is different from 3.3V boards (XIAO, ESP32, etc.):

- **Do NOT connect 3.3V sensors/devices directly** without level shifting
- **Do NOT connect Nano outputs to 3.3V device inputs** — the 5V signal can damage them
- Use a **bidirectional level shifter** for I2C/SPI/GPIO between 5V and 3.3V devices
- A simple **voltage divider** works for unidirectional 5V→3.3V signals

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
    set_sleep_mode(SLEEP_MODE_PWR_DOWN);
    sleep_enable();
    sleep_mode(); // CPU sleeps here until interrupt
    sleep_disable();
}
```

> **Sleep modes:** `SLEEP_MODE_IDLE` (~15 mA), `SLEEP_MODE_PWR_DOWN` (~0.1 μA + peripherals). The Nano's small size makes it popular for battery projects.

---

## Special Features

- **Smallest classic Arduino** — 45 × 18 mm, breadboard-friendly with DIP pin headers
- **8 analog inputs** — 2 more than Uno R3 (A6 and A7 are analog-only)
- **Same ATmega328P as Uno R3** — Code compatible; same flash/SRAM/EEPROM
- **Breadboard-friendly** — Pin headers fit directly into standard breadboards
- **ICSP header** — For direct AVR programming
- **Mini-B USB** — Older connector style
- **SoftwareSerial** — Emulate additional serial ports on any digital pins

---

## Common Gotchas / Notes

1. **5V logic** — All GPIO pins are 5V; use level shifters when connecting to 3.3V devices
2. **A6/A7 are analog-only** — Cannot use `pinMode()`, `digitalRead()`, or `digitalWrite()` on A6/A7
3. **2 KB SRAM** — Limited RAM; avoid large `String` objects, use `F()` macro for flash strings
4. **30 KB usable flash** — Bootloader uses 2 KB (more than Uno R3's 0.5 KB)
5. **D0/D1 shared with USB-serial** — External UART devices conflict with programming/serial monitor
6. **D13 LED flickers during SPI** — Built-in LED shares SPI SCK
7. **Only 2 external interrupts** — INT0 (D2) and INT1 (D3)
8. **10-bit ADC only** — Analog resolution is 10-bit (0–1023)
9. **No DAC** — No analog output; use PWM with `analogWrite()`
10. **No wireless** — No WiFi or Bluetooth; use external modules if needed
11. **Old bootloader on clones** — Many clones need `cpu=atmega328old` FQBN option
12. **CH340 driver** — Nano clones often use CH340 USB-serial chip; install CH340 drivers if needed
13. **Use F() macro** — `Serial.println(F("text"))` stores strings in flash instead of SRAM

---

## Reference Links

- **Arduino Nano docs:** https://docs.arduino.cc/hardware/nano/
- **ATmega328P datasheet:** https://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-7810-Automotive-Microcontrollers-ATmega328P_Datasheet.pdf
- **Arduino Language Reference:** https://www.arduino.cc/reference/en/
- **Pinout PDF:** https://docs.arduino.cc/resources/pinouts/A000005-full-pinout.pdf
- **Datasheet:** https://docs.arduino.cc/resources/datasheets/A000005-datasheet.pdf
