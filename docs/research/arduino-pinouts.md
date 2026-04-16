# Arduino Classic Boards - Pinout Reference

> **Source**: [Arduino Official Documentation](https://docs.arduino.cc/hardware/)
> **Date Researched**: 2026-03-22

## Table of Contents

- [Quick Comparison](#quick-comparison)
- [Arduino Uno R3](#1-arduino-uno-r3)
- [Arduino Uno R4 Minima](#2-arduino-uno-r4-minima)
- [Arduino Uno R4 WiFi](#3-arduino-uno-r4-wifi)
- [Arduino Nano](#4-arduino-nano)
- [Arduino Mega 2560 Rev3](#5-arduino-mega-2560-rev3)

---

## Quick Comparison

| Feature | Uno R3 | Uno R4 Minima | Uno R4 WiFi | Nano | Mega 2560 |
|---|---|---|---|---|---|
| **MCU** | ATmega328P | Renesas RA4M1 | RA4M1 + ESP32-S3 | ATmega328P | ATmega2560 |
| **Architecture** | 8-bit AVR | 32-bit Arm Cortex-M4 | 32-bit Arm Cortex-M4 | 8-bit AVR | 8-bit AVR |
| **Clock Speed** | 16 MHz | 48 MHz | 48 MHz (RA4M1) / 240 MHz (ESP32) | 16 MHz | 16 MHz |
| **Flash** | 32 KB | 256 kB | 256 kB | 32 KB | 256 KB |
| **SRAM** | 2 KB | 32 kB | 32 kB | 2 KB | 8 KB |
| **EEPROM** | 1 KB | 8 kB | — | 1 KB | 4 KB |
| **Digital I/O** | 14 | 14 | 14 | 14 | 54 |
| **Analog Inputs** | 6 | 6 | 6 | 8 | 16 |
| **PWM Pins** | 6 | 6 | 6 | 6 | 15 |
| **UART** | 1 | 1 | 1 | 1 | 4 |
| **I2C** | 1 | 1 | 1 | 1 | 1 |
| **SPI** | 1 | 1 | 1 | 1 | 1 |
| **Operating Voltage** | 5V | 5V | 5V (3.3V ESP32) | 5V | 5V |
| **USB** | USB-B | USB-C | USB-C | Mini-B USB | USB-B |
| **Dimensions** | 68.6×53.4 mm | 68.85×53.34 mm | 68.85×53.34 mm | 45×18 mm | 101.5×53.3 mm |
| **Weight** | 25 g | — | — | 7 g | 37 g |
| **WiFi** | No | No | Yes (ESP32-S3) | No | No |
| **Bluetooth** | No | No | Yes (ESP32-S3) | No | No |
| **CAN Bus** | No | Yes | Yes | No | No |
| **DAC** | No | Yes (1) | Yes (1) | No | No |
| **LED Matrix** | No | No | Yes (12×8) | No | No |

---

## 1. Arduino Uno R3

- **Source**: [docs.arduino.cc/hardware/uno-rev3](https://docs.arduino.cc/hardware/uno-rev3/)
- **SKU**: A000066
- **Datasheet**: [A000066-datasheet.pdf](https://docs.arduino.cc/resources/datasheets/A000066-datasheet.pdf)
- **Pinout PDF**: [A000066-full-pinout.pdf](https://docs.arduino.cc/resources/pinouts/A000066-full-pinout.pdf)

### Specifications

| Parameter | Value |
|---|---|
| Microcontroller | ATmega328P (8-bit AVR) |
| USB-Serial Processor | ATmega16U2 (16 MHz) |
| Clock Speed | 16 MHz |
| Flash Memory | 32 KB (0.5 KB used by bootloader) |
| SRAM | 2 KB |
| EEPROM | 1 KB |
| Operating Voltage | 5V |
| Input Voltage (recommended) | 7-12V |
| Input Voltage (limit) | 6-20V |
| DC Current per I/O Pin | 20 mA |
| DC Current for 3.3V Pin | 50 mA |
| USB Connector | USB-B |
| Power Supply Connector | Barrel Plug |
| Dimensions | 68.6 × 53.4 mm |
| Weight | 25 g |

### Pin Summary

| Pin Type | Count | Pins |
|---|---|---|
| Digital I/O | 14 | D0–D13 |
| PWM (~) | 6 | D3, D5, D6, D9, D10, D11 |
| Analog Input | 6 | A0–A5 |
| External Interrupts | 2 | D2 (INT0), D3 (INT1) |
| Built-in LED | 1 | D13 |
| UART (Serial) | 1 | D0 (RX), D1 (TX) |
| I2C | 1 | A4 (SDA), A5 (SCL) |
| SPI | 1 | D11 (MOSI), D12 (MISO), D13 (SCK), D10 (SS) |
| AREF | 1 | AREF |
| Reset | 1 | RESET |

### Detailed Pinout Table

| Pin | Digital | Analog | PWM | Interrupt | SPI | I2C | UART | Other |
|---|---|---|---|---|---|---|---|---|
| D0 | ✓ | — | — | — | — | — | RX | — |
| D1 | ✓ | — | — | — | — | — | TX | — |
| D2 | ✓ | — | — | INT0 | — | — | — | — |
| D3 | ✓ | — | ~PWM | INT1 | — | — | — | — |
| D4 | ✓ | — | — | — | — | — | — | — |
| D5 | ✓ | — | ~PWM | — | — | — | — | — |
| D6 | ✓ | — | ~PWM | — | — | — | — | — |
| D7 | ✓ | — | — | — | — | — | — | — |
| D8 | ✓ | — | — | — | — | — | — | — |
| D9 | ✓ | — | ~PWM | — | — | — | — | — |
| D10 | ✓ | — | ~PWM | — | SS | — | — | — |
| D11 | ✓ | — | ~PWM | — | MOSI | — | — | — |
| D12 | ✓ | — | — | — | MISO | — | — | — |
| D13 | ✓ | — | — | — | SCK | — | — | Built-in LED |
| A0 | ✓ | ADC0 | — | — | — | — | — | — |
| A1 | ✓ | ADC1 | — | — | — | — | — | — |
| A2 | ✓ | ADC2 | — | — | — | — | — | — |
| A3 | ✓ | ADC3 | — | — | — | — | — | — |
| A4 | ✓ | ADC4 | — | — | — | SDA | — | — |
| A5 | ✓ | ADC5 | — | — | — | SCL | — | — |

### Power Pins

| Pin | Function |
|---|---|
| VIN | Input voltage (7-12V recommended) |
| 5V | Regulated 5V output |
| 3.3V | Regulated 3.3V output (50 mA max) |
| GND | Ground (3 pins) |
| AREF | Analog reference voltage |
| IOREF | I/O reference voltage |
| RESET | Reset (active LOW) |

### Special Features
- Replaceable DIP-28 ATmega328P chip
- ICSP header for direct programming
- Auto-reset via serial connection
- Overcurrent protection on USB

---

## 2. Arduino Uno R4 Minima

- **Source**: [docs.arduino.cc/hardware/uno-r4-minima](https://docs.arduino.cc/hardware/uno-r4-minima/)
- **SKU**: ABX00080
- **Datasheet**: [ABX00080-datasheet.pdf](https://docs.arduino.cc/resources/datasheets/ABX00080-datasheet.pdf)
- **Pinout PDF**: [ABX00080-full-pinout.pdf](https://docs.arduino.cc/resources/pinouts/ABX00080-full-pinout.pdf)

### Specifications

| Parameter | Value |
|---|---|
| Microcontroller | Renesas RA4M1 (Arm Cortex-M4) |
| Clock Speed | 48 MHz |
| Flash Memory | 256 kB |
| SRAM | 32 kB |
| EEPROM | 8 kB |
| Operating Voltage | 5V |
| Input Voltage (VIN) | 6-24V |
| DC Current per I/O Pin | 8 mA |
| USB Connector | USB-C |
| Dimensions | 68.85 × 53.34 mm |

### Pin Summary

| Pin Type | Count | Pins |
|---|---|---|
| Digital I/O | 14 | D0–D13 |
| PWM (~) | 6 | D3, D5, D6, D9, D10, D11 |
| Analog Input | 6 | A0–A5 (up to 14-bit ADC resolution) |
| DAC Output | 1 | A0 (DAC) |
| External Interrupts | 2 | D2 (INT0), D3 (INT1) |
| Built-in LED | 1 | D13 |
| UART (Serial) | 1 | D0 (RX), D1 (TX) |
| I2C | 1 | A4 (SDA), A5 (SCL) |
| SPI | 1 | D11 (COPI), D12 (CIPO), D13 (SCK), D10 (CS) |
| CAN Bus | 1 | CAN TX/RX (requires external transceiver) |

### Detailed Pinout Table

| Pin | Digital | Analog | PWM | Interrupt | SPI | I2C | UART | Other |
|---|---|---|---|---|---|---|---|---|
| D0 | ✓ | — | — | — | — | — | RX | — |
| D1 | ✓ | — | — | — | — | — | TX | — |
| D2 | ✓ | — | — | INT0 | — | — | — | — |
| D3 | ✓ | — | ~PWM | INT1 | — | — | — | — |
| D4 | ✓ | — | — | — | — | — | — | — |
| D5 | ✓ | — | ~PWM | — | — | — | — | — |
| D6 | ✓ | — | ~PWM | — | — | — | — | — |
| D7 | ✓ | — | — | — | — | — | — | — |
| D8 | ✓ | — | — | — | — | — | — | — |
| D9 | ✓ | — | ~PWM | — | — | — | — | — |
| D10 | ✓ | — | ~PWM | — | CS | — | — | — |
| D11 | ✓ | — | ~PWM | — | COPI | — | — | — |
| D12 | ✓ | — | — | — | CIPO | — | — | — |
| D13 | ✓ | — | — | — | SCK | — | — | Built-in LED |
| A0 | ✓ | ADC0 | — | — | — | — | — | DAC |
| A1 | ✓ | ADC1 | — | — | — | — | — | — |
| A2 | ✓ | ADC2 | — | — | — | — | — | — |
| A3 | ✓ | ADC3 | — | — | — | — | — | — |
| A4 | ✓ | ADC4 | — | — | — | SDA | — | — |
| A5 | ✓ | ADC5 | — | — | — | SCL | — | — |

### Special Features
- First UNO with 32-bit microcontroller
- 14-bit ADC resolution (configurable)
- 12-bit DAC on pin A0
- Real-Time Clock (RTC) built-in
- HID support (keyboard/mouse emulation)
- CAN Bus support (requires external transceiver)
- USB-C connector
- VIN supports up to 24V input
- **Note**: Max 8 mA per GPIO (lower than Uno R3's 20 mA)

---

## 3. Arduino Uno R4 WiFi

- **Source**: [docs.arduino.cc/hardware/uno-r4-wifi](https://docs.arduino.cc/hardware/uno-r4-wifi/)
- **SKU**: ABX00087
- **Datasheet**: [ABX00087-datasheet.pdf](https://docs.arduino.cc/resources/datasheets/ABX00087-datasheet.pdf)
- **Pinout PDF**: [ABX00087-full-pinout.pdf](https://docs.arduino.cc/resources/pinouts/ABX00087-full-pinout.pdf)

### Specifications

| Parameter | Value |
|---|---|
| Main Microcontroller | Renesas RA4M1 (Arm Cortex-M4) @ 48 MHz |
| Radio Module | ESP32-S3-MINI-1-N8 (up to 240 MHz) |
| RA4M1 Flash | 256 kB |
| RA4M1 RAM | 32 kB |
| ESP32-S3 ROM | 384 kB |
| ESP32-S3 SRAM | 512 kB |
| Operating Voltage | 5V (ESP32-S3 is 3.3V) |
| Input Voltage (VIN) | 6-24V |
| DC Current per I/O Pin | 8 mA |
| USB Connector | USB-C |
| Dimensions | 68.85 × 53.34 mm |

### Pin Summary

| Pin Type | Count | Pins |
|---|---|---|
| Digital I/O | 14 | D0–D13 |
| PWM (~) | 6 | D3, D5, D6, D9, D10, D11 |
| Analog Input | 6 | A0–A5 (up to 14-bit ADC resolution) |
| DAC Output | 1 | A0 (DAC) |
| External Interrupts | 2 | D2 (INT0), D3 (INT1) |
| Built-in LED | 1 | D13 |
| UART (Serial) | 1 | D0 (RX), D1 (TX) |
| I2C | 1 (+1 Qwiic) | A4 (SDA), A5 (SCL); Qwiic: IIC0 (Wire1) |
| SPI | 1 | D11 (COPI), D12 (CIPO), D13 (SCK), D10 (CS) |
| CAN Bus | 1 | CAN TX/RX (requires external transceiver) |

### Detailed Pinout Table

Same pin layout as Uno R4 Minima (see Section 2), plus:

| Pin | Digital | Analog | PWM | Interrupt | SPI | I2C | UART | Other |
|---|---|---|---|---|---|---|---|---|
| D0 | ✓ | — | — | — | — | — | RX | — |
| D1 | ✓ | — | — | — | — | — | TX | — |
| D2 | ✓ | — | — | INT0 | — | — | — | — |
| D3 | ✓ | — | ~PWM | INT1 | — | — | — | — |
| D4 | ✓ | — | — | — | — | — | — | — |
| D5 | ✓ | — | ~PWM | — | — | — | — | — |
| D6 | ✓ | — | ~PWM | — | — | — | — | — |
| D7 | ✓ | — | — | — | — | — | — | — |
| D8 | ✓ | — | — | — | — | — | — | — |
| D9 | ✓ | — | ~PWM | — | — | — | — | — |
| D10 | ✓ | — | ~PWM | — | CS | — | — | — |
| D11 | ✓ | — | ~PWM | — | COPI | — | — | — |
| D12 | ✓ | — | — | — | CIPO | — | — | — |
| D13 | ✓ | — | — | — | SCK | — | — | Built-in LED |
| A0 | ✓ | ADC0 | — | — | — | — | — | DAC |
| A1 | ✓ | ADC1 | — | — | — | — | — | — |
| A2 | ✓ | ADC2 | — | — | — | — | — | — |
| A3 | ✓ | ADC3 | — | — | — | — | — | — |
| A4 | ✓ | ADC4 | — | — | — | SDA | — | — |
| A5 | ✓ | ADC5 | — | — | — | SCL | — | — |

### Special Features
- **Wi-Fi**: 802.11 b/g/n via ESP32-S3
- **Bluetooth**: BLE 5.0 via ESP32-S3
- **12×8 LED Matrix**: Built-in, programmable
- **Qwiic Connector**: Secondary I2C bus (IIC0, 3.3V only, use `Wire1.begin()`)
- 14-bit ADC resolution (configurable)
- 12-bit DAC on pin A0
- Real-Time Clock (RTC) built-in
- HID support (keyboard/mouse emulation)
- CAN Bus support (requires external transceiver)
- USB-C connector
- **Note**: ESP header near USB-C is 3.3V only — do NOT connect 5V
- **Note**: Max 8 mA per GPIO (lower than Uno R3's 20 mA)

---

## 4. Arduino Nano

- **Source**: [docs.arduino.cc/hardware/nano](https://docs.arduino.cc/hardware/nano/)
- **SKU**: A000005
- **Datasheet**: [A000005-datasheet.pdf](https://docs.arduino.cc/resources/datasheets/A000005-datasheet.pdf)
- **Pinout PDF**: [A000005-full-pinout.pdf](https://docs.arduino.cc/resources/pinouts/A000005-full-pinout.pdf)

### Specifications

| Parameter | Value |
|---|---|
| Microcontroller | ATmega328P (8-bit AVR) |
| Clock Speed | 16 MHz |
| Flash Memory | 32 KB (2 KB used by bootloader) |
| SRAM | 2 KB |
| EEPROM | 1 KB |
| Operating Voltage | 5V |
| Input Voltage (recommended) | 7-12V |
| DC Current per I/O Pin | 20 mA |
| USB Connector | Mini-B USB |
| Dimensions | 45 × 18 mm |
| Weight | 7 g |

### Pin Summary

| Pin Type | Count | Pins |
|---|---|---|
| Digital I/O | 14 | D0–D13 |
| PWM (~) | 6 | D3, D5, D6, D9, D10, D11 |
| Analog Input | 8 | A0–A7 |
| External Interrupts | 2 | D2 (INT0), D3 (INT1) |
| Built-in LED | 1 | D13 |
| UART (Serial) | 1 | D0 (RX), D1 (TX) |
| I2C | 1 | A4 (SDA), A5 (SCL) |
| SPI | 1 | D11 (COPI), D12 (CIPO), D13 (SCK), any GPIO (CS) |

### Detailed Pinout Table

| Pin | Digital | Analog | PWM | Interrupt | SPI | I2C | UART | Other |
|---|---|---|---|---|---|---|---|---|
| D0 | ✓ | — | — | — | — | — | RX | — |
| D1 | ✓ | — | — | — | — | — | TX | — |
| D2 | ✓ | — | — | INT0 | — | — | — | — |
| D3 | ✓ | — | ~PWM | INT1 | — | — | — | — |
| D4 | ✓ | — | — | — | — | — | — | — |
| D5 | ✓ | — | ~PWM | — | — | — | — | — |
| D6 | ✓ | — | ~PWM | — | — | — | — | — |
| D7 | ✓ | — | — | — | — | — | — | — |
| D8 | ✓ | — | — | — | — | — | — | — |
| D9 | ✓ | — | ~PWM | — | — | — | — | — |
| D10 | ✓ | — | ~PWM | — | SS | — | — | — |
| D11 | ✓ | — | ~PWM | — | MOSI | — | — | — |
| D12 | ✓ | — | — | — | MISO | — | — | — |
| D13 | ✓ | — | — | — | SCK | — | — | Built-in LED |
| A0 | ✓ | ADC0 | — | — | — | — | — | — |
| A1 | ✓ | ADC1 | — | — | — | — | — | — |
| A2 | ✓ | ADC2 | — | — | — | — | — | — |
| A3 | ✓ | ADC3 | — | — | — | — | — | — |
| A4 | ✓ | ADC4 | — | — | — | SDA | — | — |
| A5 | ✓ | ADC5 | — | — | — | SCL | — | — |
| A6 | — | ADC6 | — | — | — | — | — | Analog only |
| A7 | — | ADC7 | — | — | — | — | — | Analog only |

### Power Pins

| Pin | Function |
|---|---|
| VIN | Input voltage (7-12V recommended) |
| 5V | Regulated 5V output |
| 3.3V | Regulated 3.3V output |
| GND | Ground |
| AREF | Analog reference voltage |
| RESET | Reset (active LOW) |

### Special Features
- Breadboard-friendly form factor with pin headers
- Smallest classic Arduino board (45 × 18 mm)
- 8 analog inputs (vs 6 on Uno) — A6 and A7 are analog-only
- ICSP header for direct programming
- Same ATmega328P as Uno R3 — code compatible
- Mini-B USB connector

---

## 5. Arduino Mega 2560 Rev3

- **Source**: [docs.arduino.cc/hardware/mega-2560](https://docs.arduino.cc/hardware/mega-2560/)
- **SKU**: A000067
- **Datasheet**: [A000067-datasheet.pdf](https://docs.arduino.cc/resources/datasheets/A000067-datasheet.pdf)
- **Pinout PDF**: [A000067-full-pinout.pdf](https://docs.arduino.cc/resources/pinouts/A000067-full-pinout.pdf)

### Specifications

| Parameter | Value |
|---|---|
| Microcontroller | ATmega2560 (8-bit AVR) |
| USB-Serial Processor | ATmega16U2 (16 MHz) |
| Clock Speed | 16 MHz |
| Flash Memory | 256 KB (8 KB used by bootloader) |
| SRAM | 8 KB |
| EEPROM | 4 KB |
| Operating Voltage | 5V |
| Input Voltage (recommended) | 7-12V |
| DC Current per I/O Pin | 20 mA |
| USB Connector | USB-B |
| Power Supply Connector | Barrel Plug |
| Supported Battery | 9V battery |
| Dimensions | 101.5 × 53.3 mm |
| Weight | 37 g |

### Pin Summary

| Pin Type | Count | Pins |
|---|---|---|
| Digital I/O | 54 | D0–D53 |
| PWM (~) | 15 | D2–D13, D44, D45, D46 |
| Analog Input | 16 | A0–A15 |
| External Interrupts | 6 | D2 (INT0), D3 (INT1), D18 (INT5), D19 (INT4), D20 (INT3), D21 (INT2) |
| Built-in LED | 1 | D13 |
| UART (Serial) | 4 | Serial0: D0(RX)/D1(TX), Serial1: D19(RX)/D18(TX), Serial2: D17(RX)/D16(TX), Serial3: D15(RX)/D14(TX) |
| I2C | 1 | D20 (SDA), D21 (SCL) |
| SPI | 1 | D50 (MISO), D51 (MOSI), D52 (SCK), D53 (SS) |
| AREF | 1 | AREF |
| Reset | 1 | RESET |

### Detailed Pinout Table — Digital Pins D0–D53

| Pin | Digital | PWM | Interrupt | SPI | I2C | UART | Other |
|---|---|---|---|---|---|---|---|
| D0 | ✓ | — | — | — | — | Serial0 RX | — |
| D1 | ✓ | — | — | — | — | Serial0 TX | — |
| D2 | ✓ | ~PWM | INT0 | — | — | — | — |
| D3 | ✓ | ~PWM | INT1 | — | — | — | — |
| D4 | ✓ | ~PWM | — | — | — | — | — |
| D5 | ✓ | ~PWM | — | — | — | — | — |
| D6 | ✓ | ~PWM | — | — | — | — | — |
| D7 | ✓ | ~PWM | — | — | — | — | — |
| D8 | ✓ | ~PWM | — | — | — | — | — |
| D9 | ✓ | ~PWM | — | — | — | — | — |
| D10 | ✓ | ~PWM | — | — | — | — | — |
| D11 | ✓ | ~PWM | — | — | — | — | — |
| D12 | ✓ | ~PWM | — | — | — | — | — |
| D13 | ✓ | ~PWM | — | — | — | — | Built-in LED |
| D14 | ✓ | — | — | — | — | Serial3 TX | — |
| D15 | ✓ | — | — | — | — | Serial3 RX | — |
| D16 | ✓ | — | — | — | — | Serial2 TX | — |
| D17 | ✓ | — | — | — | — | Serial2 RX | — |
| D18 | ✓ | — | INT5 | — | — | Serial1 TX | — |
| D19 | ✓ | — | INT4 | — | — | Serial1 RX | — |
| D20 | ✓ | — | INT3 | — | SDA | — | — |
| D21 | ✓ | — | INT2 | — | SCL | — | — |
| D22–D43 | ✓ | — | — | — | — | — | General purpose |
| D44 | ✓ | ~PWM | — | — | — | — | — |
| D45 | ✓ | ~PWM | — | — | — | — | — |
| D46 | ✓ | ~PWM | — | — | — | — | — |
| D47–D49 | ✓ | — | — | — | — | — | General purpose |
| D50 | ✓ | — | — | MISO | — | — | — |
| D51 | ✓ | — | — | MOSI | — | — | — |
| D52 | ✓ | — | — | SCK | — | — | — |
| D53 | ✓ | — | — | SS | — | — | — |

### Analog Pins

| Pin | Analog | Digital | Other |
|---|---|---|---|
| A0 | ADC0 | ✓ | — |
| A1 | ADC1 | ✓ | — |
| A2 | ADC2 | ✓ | — |
| A3 | ADC3 | ✓ | — |
| A4 | ADC4 | ✓ | — |
| A5 | ADC5 | ✓ | — |
| A6 | ADC6 | ✓ | — |
| A7 | ADC7 | ✓ | — |
| A8 | ADC8 | ✓ | — |
| A9 | ADC9 | ✓ | — |
| A10 | ADC10 | ✓ | — |
| A11 | ADC11 | ✓ | — |
| A12 | ADC12 | ✓ | — |
| A13 | ADC13 | ✓ | — |
| A14 | ADC14 | ✓ | — |
| A15 | ADC15 | ✓ | — |

### Power Pins

| Pin | Function |
|---|---|
| VIN | Input voltage (7-12V recommended) |
| 5V | Regulated 5V output |
| 3.3V | Regulated 3.3V output (50 mA max) |
| GND | Ground (multiple pins) |
| AREF | Analog reference voltage |
| IOREF | I/O reference voltage |
| RESET | Reset (active LOW) |

### Special Features
- 54 digital I/O pins — the most of any classic Arduino
- 16 analog inputs (all can also be used as digital I/O)
- 15 PWM outputs
- 4 hardware serial ports (UARTs)
- 6 external interrupt pins
- ICSP header for direct programming
- Auto-reset via serial connection
- UNO shield compatible (same header layout on one end)
- Barrel plug power connector
- Replaceable ATmega2560 chip (DIP package not available — SMD)

---