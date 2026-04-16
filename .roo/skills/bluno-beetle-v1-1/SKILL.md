---
name: bluno-beetle-v1-1
description: >
  Provides comprehensive pinout reference, board specifications, and Arduino C++ development guide
  for the DFRobot Bluno Beetle v1.1 (DFR0339) Bluetooth LE development board. Use when writing
  Arduino firmware for the Bluno Beetle, wiring peripherals, or configuring Bluetooth. Keywords:
  DFRobot, Bluno Beetle, BLE, Bluetooth 4.0, ATmega32u4, Arduino Leonardo compatible, wearable,
  compact, wireless, HID, iBeacon, Micro USB, 5V, 8-bit, AVR, pinout, GPIO, I2C, SPI, UART,
  analog, digital, PWM, arduino-cli.
---

# Bluno Beetle v1.1 — Arduino Development Guide

Provides comprehensive reference for developing Arduino C++ firmware for the DFRobot Bluno Beetle v1.1 (DFR0339).

## When to Use

- Writing Arduino C++ firmware targeting the Bluno Beetle v1.1
- Looking up Bluno Beetle pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the Bluno Beetle and need GPIO reference
- Configuring I2C, SPI, UART, analog I/O, or Bluetooth LE on the Bluno Beetle
- Setting up wireless programming or BLE communication

## When NOT to Use

- For standard Arduino Uno R3 (different MCU and form factor)
- For Bluno Mega 2560 (different board form factor and size)
- For Bluno M3 (different MCU - STM32)

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | ATmega32u4 |
| **Architecture** | 8-bit AVR |
| **Clock Speed** | 16 MHz |
| **Flash** | 32 KB (4 KB used by bootloader) |
| **SRAM** | 2.5 KB |
| **EEPROM** | 1 KB |
| **USB** | Micro USB |
| **Operating Voltage** | 5V DC |
| **Input Voltage (USB/VIN)** | 5V USB or 7–12V VIN |
| **DC Current per I/O Pin** | 40 mA |
| **BLE Chip** | Bluetooth 4.0 (CC2540 or compatible) |
| **Digital I/O** | 10 (D0–D13, partial) |
| **PWM Outputs** | 4 |
| **Analog Inputs** | 5 (A0–A4) |
| **UART** | 1 (D0/D1) |
| **I2C** | 1 (SDA/SCL) |
| **SPI** | Via ICSP header |
| **Dimensions** | ~34.5 × 20 mm (compact wearable form factor) |
| **Weight** | ~4 g |

---

## Pinout Diagram

```
                         [Micro USB]
                   ┌─────────────────────┐
                   │                     │
             D13 ──┤ D13           D12  ├── D12 / MISO
            3.3V ──┤ 3V3           D11  ├── ~D11 / MOSI / PWM
             AREF ──┤ AREF          D10  ├── ~D10 / SS / PWM
           A0/D14 ──┤ A0            D9   ├── ~D9 / PWM
           A1/D15 ──┤ A1            D8   ├── D8
           A2/D16 ──┤ A2            D7   ├── D7
           A3/D17 ──┤ A3            D6   ├── ~D6 / PWM
       SDA/A4/D18 ──┤ A4            D5   ├── ~D5 / PWM
       SCL/A5/D19 ──┤ A5            D4   ├── D4
              5V ──┤ 5V             GND  ├── GND
           RESET ──┤ RST           RST  ├── RESET
              GND ──┤ GND           D0   ├── RX
              VIN ──┤ VIN           D1   ├── TX
                   │                     │
                   └─────────────────────┘

  ~ = PWM capable
  Note: Only D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13 available
  A0–A4 are analog input pins (also usable as digital I/O)
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
| D13 | ✓       | —      | —   | —         | **SCK** | — | — | Built-in LED |
| A0  | ✓       | ✓ (10-bit) | — | — | — | — | — | — |
| A1  | ✓       | ✓ (10-bit) | — | — | — | — | — | — |
| A2  | ✓       | ✓ (10-bit) | — | — | — | — | — | — |
| A3  | ✓       | ✓ (10-bit) | — | — | — | — | — | — |
| A4  | ✓       | ✓ (10-bit) | — | — | — | **SDA** | — | — |
| A5  | ✓       | ✓ (10-bit) | — | — | — | **SCL** | — | — |

---

## Communication Interfaces

### Bluetooth Low Energy (BLE)

- **Chip**: Bluetooth 4.0 (CC2540 or compatible)
- **Profiles Supported**: UART Serial (Bluetooth Serial), HID, iBeacon
- **Communication**: Acts as BLE central or peripheral
- **Wireless Programming**: Supported via BLE (requires BLE link to device)
- **AT Commands**: Configurable via serial monitor at 115200 baud
- **Default BLE Name**: `Bluno Beetle` or `DFRobot`

### USB

- **Type**: Micro USB
- **Role**: Programming, serial communication, and power
- **Driver**: Built-in CDC (no extra driver needed on most systems)

### UART

- **Pins**: D0 (RX), D1 (TX)
- **Voltage**: 5V TTL
- **Default Baud**: 115200 (BLE communication)
- **Use**: Serial communication with BLE module

### I2C

- **Pins**: A4 (SDA), A5 (SCL)
- **Voltage**: 5V
- **Speed**: 100kHz (Standard) / 400kHz (Fast)
- **Use**: Sensors, displays, expanders

### SPI

- **Header**: ICSP (6-pin)
- **Pins**: MOSI (D11), MISO (D12), SCK (D13), SS (D10)
- **Use**: Flash memory, displays, high-speed communication

---

## Power Supply

| Source | Voltage | Notes |
|--------|---------|-------|
| Micro USB | 5V | Primary power and programming |
| VIN | 7–12V | External power input (regulated to 5V) |
| 5V Pin | 5V | External 5V supply (bypass regulator) |
| 3.3V Pin | 3.3V | Available from on-board regulator (limited current) |

**Power Consumption**:
- Typical: ~15–25 mA (with BLE active)
- Sleep: ~5 mA (with BLE idle)
- BLE transmit: up to ~30 mA

**Important**: The BLE module operates at 3.3V logic, but I/O is 5V tolerant.

---

## Programming

### Arduino IDE Setup

1. Install the Arduino Leonardo board definition (Bluno Beetle is Leonardo-compatible)
2. Select **Arduino Leonardo** as the board type
3. Micro USB for programming
4. No external programmer required

### arduino-cli Installation

```bash
# Add Leonardo core (usually included by default)
arduino-cli core install arduino:avr
arduino-cli board list
```

### Program via Serial Bootloader

The ATmega32u4 has a built-in USB bootloader (Caterina) that appears as a COM port when connected via USB.

### Wireless Programming (BLE)

1. Connect to Bluno Beetle via BLE (from phone/tablet with BLE terminal)
2. Use DFRobot's BLE Arduino app or compatible BLE serial app
3. Upload sketch via BLE (requires BLE link established)

---

## BLE AT Commands

Configure BLE module via UART at 115200 baud:

| Command | Description | Example |
|---------|-------------|---------|
| `AT` | Test connection | `AT` → `OK` |
| `AT+NAME=<name>` | Set BLE device name | `AT+NAME=MyBeetle` |
| `AT+BAUD=<n>` | Set UART baud rate | `AT+BAUD=4` (9600) |
| `AT+ROLE=<role>` | Set role (0=peripheral, 1=central) | `AT+ROLE=0` |
| `AT+LOWPOWER=<n>` | Enable low power mode | `AT+LOWPOWER=1` |
| `AT+IBEA=<n>` | Enable iBeacon mode | `AT+IBEA=1` |
| `AT+HIDEN=<n>` | Enable HID mode | `AT+HIDEN=1` |

---

## Compatible Shields/Accessories

- **DFRobot Beetle Shield**: Compatible extension board
- **Grove System**: Via adapter cables (5V Grove modules)
- **Standard Arduino Shields**: Limited due to compact size (verify pinout)
- **Servo Motors**: 5V servos compatible
- **I2C Sensors**: Any 5V or 3.3V I2C sensor (use level shifting if needed)

---

## Example Use Cases

### BLE Serial Communication

```cpp
// BLE Serial passthrough - use with BLE serial apps
void setup() {
  Serial.begin(115200);  // USB Serial
  Serial1.begin(115200); // BLE/UART Serial (ATmega32u4 has separate Serial1)
}

void loop() {
  if (Serial.available()) {
    Serial1.write(Serial.read()); // USB to BLE
  }
  if (Serial1.available()) {
    Serial.write(Serial1.read()); // BLE to USB
  }
}
```

### LED Control via BLE

```cpp
const int LED_PIN = 13;

void setup() {
  pinMode(LED_PIN, OUTPUT);
  Serial1.begin(115200); // BLE serial
}

void loop() {
  if (Serial1.available() > 0) {
    char cmd = Serial1.read();
    if (cmd == '1') {
      digitalWrite(LED_PIN, HIGH);
      Serial1.println("LED ON");
    } else if (cmd == '0') {
      digitalWrite(LED_PIN, LOW);
      Serial1.println("LED OFF");
    }
  }
}
```

### I2C Sensor Example

```cpp
#include <Wire.h>

void setup() {
  Serial.begin(115200);
  Wire.begin();
}

void loop() {
  // Example I2C sensor read
  Wire.requestFrom(0x68, 1); // MPU-6050 example address
  if (Wire.available()) {
    Serial.println(Wire.read());
  }
  delay(100);
}
```

---

## Bootloader Reset

If the board becomes unresponsive during upload:

1. Connect via Micro USB
2. Rapidly press the reset button twice in succession
3. The board will appear as a new COM port (Leonardo bootloader)
4. Upload immediately

---

## Links

- [DFRobot Bluno Beetle Wiki](https://wiki.dfrobot.com/Bluno_Beetle_SKU_DFR0339)
- [DFRobot Product Page](https://www.dfrobot.com/product-1259.html)
- [Arduino Leonardo Documentation](https://docs.arduino.cc/hardware/leonardo)
- [BLE AT Command Reference](https://wiki.dfrobot.com/Bluno_Beetle_SKU_DFR0339#target-7)
