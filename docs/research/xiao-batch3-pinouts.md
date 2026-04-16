# XIAO Batch 3 — Pinout & Specification Research

> **Date researched:** 2026-03-22
> **Sources:** Seeed Studio Wiki ([wiki.seeedstudio.com](https://wiki.seeedstudio.com))

---

## Table of Contents

1. [XIAO MG24](#1-xiao-mg24)
2. [XIAO MG24 Sense](#2-xiao-mg24-sense)
3. [XIAO nRF54L15](#3-xiao-nrf54l15)
4. [XIAO nRF54L15 Sense](#4-xiao-nrf54l15-sense)
5. [XIAO ESP32-C5](#5-xiao-esp32-c5)

---

## 1. XIAO MG24

**Wiki:** <https://wiki.seeedstudio.com/xiao_mg24_getting_started/>

### 1.1 Core Specifications

| Parameter | Value |
|---|---|
| **MCU** | Silicon Labs EFR32MG24 |
| **Architecture** | ARM Cortex-M33, 32-bit RISC |
| **Clock Speed** | 78 MHz |
| **Flash** | 1536 KB (on-chip) + 4 MB (onboard) |
| **RAM** | 256 KB |
| **AI/ML** | Built-in AI/ML hardware accelerator (MVP) |
| **ADC** | 12-bit, 1 Msps |
| **Operating Voltage** | 3.3 V logic |
| **Supply Voltage** | 5 V (USB) or 3.7 V (battery) |
| **USB** | USB Type-C (via SAMD11 serial bridge) |
| **Dimensions** | 21 × 17.8 mm |
| **Working Temperature** | -20°C to 70°C |
| **Low Power (Typ.)** | 1.95 μA |
| **Normal (Typ.)** | 6.71 mA |
| **Sleep (Typ.)** | 1.91 mA |

### 1.2 Wireless Connectivity

- **Bluetooth LE 5.3**, Bluetooth mesh
- **Zigbee**
- **Thread**
- **Matter**
- **802.15.4**
- TX power: up to +19.5 dBm
- RX sensitivity: -105.4 dBm (250 kbps DSSS)
- 2.4 GHz ceramic antenna (4.97 dBi) + U.FL connector

### 1.3 Security

- Hardware Cryptographic Acceleration
- True Random Number Generator
- ARM® TrustZone®
- Secure Boot
- Secure Debug Unlock (Secure Vault)

### 1.4 Onboard Components

| Component | Details |
|---|---|
| LEDs | 1× User LED (Yellow, PA07), 1× Charge LED (Red) |
| Buttons | 1× RESET |
| Sensors | None (see MG24 Sense) |

### 1.5 Pin Map

**Interface Summary:** 22 Pins (All PWM): 19× Analog, 19× Digital, 1× I²C, 2× UART, 2× SPI

| XIAO Pin | Function | Chip Pin | Alternate Functions | Description |
|---|---|---|---|---|
| 5V | VBUS | — | — | Power Input/Output |
| GND | — | — | — | Ground |
| 3V3 | 3V3_OUT | — | — | Power Output |
| D0 | Analog | PC00 | — | GPIO, ADC |
| D1 | Analog | PC01 | — | GPIO, ADC |
| D2 | Analog | PC02 | — | GPIO, ADC |
| D3 | Analog | PC03 | — | GPIO, SPI, ADC |
| D4 | Analog, SDA | PC04 | — | GPIO, I2C Data, ADC |
| D5 | Analog, SCL | PC05 | — | GPIO, I2C Clock, ADC |
| D6 | Analog, TX0 | PC06 | — | GPIO, UART Transmit, ADC |
| D7 | Analog, RX0 | PC07 | — | GPIO, UART Receive, ADC |
| D8 | Analog, SCK0 | PA03 | — | GPIO, SPI Clock, ADC |
| D9 | Analog, MISO0 | PA04 | — | GPIO, SPI Data, ADC |
| D10 | Analog, MOSI0 | PA05 | — | GPIO, SPI Data, ADC |
| D11 | Analog | PA09 | SAMD11_TX | GPIO, UART Receive, ADC |
| D12 | Analog | PA08 | SAMD11_RX | GPIO, UART Transmit, ADC |
| D13 | Analog | PB02 | — | GPIO, I2C Clock, ADC |
| D14 | Analog | PB03 | — | GPIO, I2C Data, ADC |
| D15 | Analog, MOSI1 | PB00 | — | GPIO, SPI Data, ADC |
| D16 | Analog, MISO1 | PB01 | — | GPIO, SPI Data, ADC |
| D17 | Analog, SCK1 | PA00 | — | GPIO, SPI Clock, ADC |
| D18 | Analog, CS | PD02 | Csn | GPIO, Csn, ADC |

**Additional Internal Pins:**

| Pin | Chip Pin | Description |
|---|---|---|
| ADC_BAT | PD04 | Read battery voltage |
| RF Switch Port Select | PB04 | Switch onboard/UFL antenna |
| RF Switch Power | PB05 | RF Power |
| Reset | RESET | Reset |
| USER_LED | PA07 | User Light (Yellow) |
| CHARGE_LED | VBUS | Charge LED (Red) |

### 1.6 Pin Layout (Text Diagram)

```
        XIAO MG24 (Top View)
        ┌─────────────────┐
        │    [USB-C]      │
   D0 ──┤ PC00      PC07 ├── D7 (RX0)
   D1 ──┤ PC01      PC06 ├── D6 (TX0)
   D2 ──┤ PC02      PC05 ├── D5 (SCL)
   D3 ──┤ PC03      PC04 ├── D4 (SDA)
  GND ──┤                 ├── D10 (MOSI0)
  5V  ──┤                 ├── D9 (MISO0)
  3V3 ──┤                 ├── D8 (SCK0)
        └─────────────────┘
  Bottom pads: D11-D18 (accessible via soldering)
```

---

## 2. XIAO MG24 Sense

**Wiki:** <https://wiki.seeedstudio.com/xiao_mg24_getting_started/> (shared page with MG24)

### 2.1 Core Specifications

Identical to XIAO MG24 (same MCU, memory, wireless, dimensions).

### 2.2 Additional Sensors (Sense variant only)

| Sensor | Type |
|---|---|
| **Microphone** | 1× Onboard Analog Microphone |
| **IMU** | 1× Onboard 6-Axis IMU |

### 2.3 Pin Map

Same as XIAO MG24 — all 22 pins, same functions.

### 2.4 Key Differences from MG24

| Feature | MG24 | MG24 Sense |
|---|---|---|
| Microphone | ❌ | ✅ Analog Microphone |
| IMU | ❌ | ✅ 6-Axis IMU |
| All other specs | Same | Same |

---

## 3. XIAO nRF54L15

**Wiki:** <https://wiki.seeedstudio.com/xiao_nrf54l15_sense_getting_started/> (shared page with Sense)

### 3.1 Core Specifications

| Parameter | Value |
|---|---|
| **MCU** | Nordic nRF54L15 |
| **Architecture** | ARM Cortex-M33 @ 128 MHz + RISC-V coprocessor @ 128 MHz (FLPR) |
| **NVM (Flash)** | 1.5 MB |
| **RAM** | 256 KB |
| **ADC** | 14-bit |
| **Operating Voltage** | 3.3 V logic |
| **Supply Voltage** | 3.7 to 5 V |
| **USB** | USB Type-C (via SAMD11 serial bridge) |
| **Dimensions** | 21 × 17.8 mm (standard XIAO) |
| **Operating Temperature** | -40°C to 105°C |
| **TX Power** | +8 dBm |
| **RX Sensitivity** | -96 dBm |

### 3.2 Wireless Connectivity

- **Bluetooth LE 6.0** (including Channel Sounding)
- **NFC**
- **Thread**
- **Zigbee**
- **Matter**
- **Amazon Sidewalk**
- **Proprietary 2.4 GHz protocols** (up to 4 Mbps)
- **802.15.4-2020**

### 3.3 Security

- ARM® TrustZone® isolation
- Tamper detectors
- Channel leakage protection on encryption engine
- Cryptographic engine protection

### 3.4 Highlighted Peripherals

- 14-bit ADC
- Global RTC (available in System OFF mode)
- Built-in Li-ion battery management (internal PMIC)
- Battery voltage collection support

### 3.5 Onboard Components

| Component | Details |
|---|---|
| LEDs | 1× User LED (Green, P2.00), 1× Charge LED (Red) |
| Buttons | 1× RESET, 1× User Key (P0.00) |
| Sensors | None (see nRF54L15 Sense) |
| Antenna | Ceramic antenna + U.FL connector (switchable via RF switch) |

### 3.6 Pin Map

| XIAO Pin | Function | Chip Pin | Description |
|---|---|---|---|
| 5V | VBUS | — | Power Input/Output |
| GND | — | — | Ground |
| 3V3 | 3V3_OUT | — | Power Output |
| D0 | Analog | P1.04 | GPIO, ADC |
| D1 | Analog | P1.05 | GPIO, ADC |
| D2 | Analog | P1.06 | GPIO, ADC |
| D3 | Analog | P1.07 | GPIO, ADC |
| D4 | SDA-0 | P1.10 | GPIO, I2C Data |
| D5 | SCL-0 | P1.11 | GPIO, I2C Clock |
| D6 | TX | P2.08 | GPIO, UART Transmit |
| D7 | RX | P2.07 | GPIO, UART Receive |
| D8 | SPI_SCK | P2.01 | GPIO, SPI Clock |
| D9 | SPI_MISO | P2.04 | GPIO, SPI Data |
| D10 | SPI_MOSI | P2.02 | GPIO, SPI Data |
| D11 | SCL-1 | P0.03 | GPIO, I2C |
| D12 | SDA-1 | P0.04 | GPIO, I2C |
| D13 | GPIO | P2.10 | GPIO |
| D14 | GPIO | P2.09 | GPIO |
| D15 | GPIO | P2.06 | GPIO |

**Additional Internal/Debug Pins:**

| Pin | Chip Pin | Description |
|---|---|---|
| NFC1 | P1.02 | NFC |
| NFC2 | P1.03 | NFC |
| AIN7_VBAT | P1.14 | Read battery voltage |
| RF Switch Port Select | P2.05 | Switch onboard antenna |
| RF Switch Power | P2.03 | Power |
| USER KEY | P0.00 | User Key |
| USER_LED | P2.00 | User Light |
| CHARGE_LED | charge_LED | CHG-LED (Red) |
| nRF54L15_SWCLK | SWDCLK | JTAG |
| nRF54L15_SWD-IO | SWDIO | JTAG |
| nRF54L15_RST | RST | JTAG |
| SAMD11_SWCLK | PA30 | JTAG |
| SAMD11_SWDIO | PA31 | JTAG |
| SAMD11_RST | RST2 | JTAG |

### 3.7 Pin Layout (Text Diagram)

```
        XIAO nRF54L15 (Top View)
        ┌─────────────────┐
        │    [USB-C]      │
   D0 ──┤ P1.04    P2.07 ├── D7 (RX)
   D1 ──┤ P1.05    P2.08 ├── D6 (TX)
   D2 ──┤ P1.06    P1.11 ├── D5 (SCL)
   D3 ──┤ P1.07    P1.10 ├── D4 (SDA)
  GND ──┤                 ├── D10 (MOSI)
  5V  ──┤                 ├── D9 (MISO)
  3V3 ──┤                 ├── D8 (SCK)
        └─────────────────┘
  Bottom pads: D11-D15, NFC1, NFC2, JTAG
```

---

## 4. XIAO nRF54L15 Sense

**Wiki:** <https://wiki.seeedstudio.com/xiao_nrf54l15_sense_getting_started/> (shared page with nRF54L15)

### 4.1 Core Specifications

Identical to XIAO nRF54L15 (same MCU, memory, wireless, dimensions).

### 4.2 Additional Sensors (Sense variant only)

| Sensor | Model | Type |
|---|---|---|
| **IMU** | LSM6DS3TR-C | 6 DOF (Accelerometer + Gyroscope) |
| **Microphone** | MSM261DGT006 | Digital Microphone |

### 4.3 Pin Map

Same as XIAO nRF54L15 — all pins identical.

### 4.4 Key Differences from nRF54L15

| Feature | nRF54L15 | nRF54L15 Sense |
|---|---|---|
| IMU | ❌ | ✅ LSM6DS3TR-C (6 DOF) |
| Microphone | ❌ | ✅ MSM261DGT006 |
| All other specs | Same | Same |

---

## 5. XIAO ESP32-C5

**Wiki:** <https://wiki.seeedstudio.com/xiao_esp32c5_getting_started/>

### 5.1 Core Specifications

| Parameter | Value |
|---|---|
| **MCU** | Espressif ESP32-C5 |
| **Architecture** | 32-bit RISC-V single-core |
| **Clock Speed** | 240 MHz |
| **Flash** | 8 MB |
| **PSRAM** | 8 MB |
| **On-chip SRAM** | 384 KB |
| **On-chip ROM** | 320 KB |
| **Operating Voltage** | 3.3 V logic |
| **USB** | USB Type-C |
| **Dimensions** | 21 × 17.8 mm |
| **Battery Charge Chip** | SGM40567 |

### 5.2 Wireless Connectivity

- **Wi-Fi 6** (IEEE 802.11 a/b/g/n/ac/ax) — **2.4 GHz & 5 GHz dual-band**
- **Bluetooth 5 (LE)**, Bluetooth mesh
- Station, SoftAP, concurrent SoftAP+Station, promiscuous (monitor) mode

### 5.3 Security

- Cryptographic hardware accelerators: AES-128/256, SHA family, HMAC
- Dedicated digital signature peripheral
- Secure Boot (V2)

### 5.4 Onboard Components

| Component | Details |
|---|---|
| LEDs | 1× User LED (Yellow, GPIO27), 1× Charge LED (Red) |
| Buttons | 1× RESET, 1× BOOT (GPIO28) |
| Antenna | External RF antenna (U.FL connector) |

### 5.5 Pin Map

**Interface Summary:** 1× I2C, 1× SPI, 2× UART, up to 11× GPIO (PWM-capable), 5× ADC channels, JTAG pads on reverse side

| XIAO Pin | Function | Chip Pin | Alternate Functions | Description |
|---|---|---|---|---|
| 5V | VBUS | — | — | Power Input/Output |
| GND | — | — | — | Ground |
| 3V3 | 3V3_OUT | — | — | Power Output |
| D0 | Analog | GPIO1 | LP_UART_DSRN, LP_GPIO1 | GPIO, ADC |
| D1 | — | GPIO0 | LP_UART_DTRN, LP_GPIO0 | GPIO |
| D2 | — | GPIO25 | — | GPIO |
| D3 | — | GPIO7 | SDIO_DATA1 | GPIO |
| D4 | SDA | GPIO23 | — | GPIO, I2C Data |
| D5 | SCL | GPIO24 | — | GPIO, I2C Clock |
| D6 | TX | GPIO11 | — | GPIO, UART Transmit |
| D7 | RX | GPIO12 | — | GPIO, UART Receive |
| D8 | SCK | GPIO8 | TOUCH7 | GPIO, SPI Clock |
| D9 | MISO | GPIO9 | TOUCH8 | GPIO, SPI Data |
| D10 | MOSI | GPIO10 | TOUCH9 | GPIO, SPI Data |

**Additional Internal/Debug Pins (bottom pads):**

| Pin | Chip Pin | Alternate Functions | Description |
|---|---|---|---|
| MTDO | GPIO5 | LP_UART_TXD, LP_GPIO5 | JTAG |
| MTDI | GPIO3 | LP_I2C_SCL, LP_GPIO3 | JTAG, ADC |
| MTCK | GPIO4 | LP_UART_RXD, LP_GPIO4 | JTAG, ADC |
| MTMS | GPIO2 | LP_I2C_SDA, LP_GPIO2 | JTAG, ADC |
| ADC_BAT | GPIO6 | — | Read battery voltage |
| ADC_CRL | GPIO26 | — | Enable/disable battery measurement circuit |
| Boot | GPIO28 | — | Enter Boot Mode |
| USER_LED | GPIO27 | — | User Light (Yellow) |
| CHARGE_LED | VCC_3V3 | — | Charge LED (Red) |

### 5.6 Pin Layout (Text Diagram)

```
        XIAO ESP32-C5 (Top View)
        ┌─────────────────┐
        │    [USB-C]      │
   D0 ──┤ GPIO1   GPIO12 ├── D7 (RX)
   D1 ──┤ GPIO0   GPIO11 ├── D6 (TX)
   D2 ──┤ GPIO25  GPIO24 ├── D5 (SCL)
   D3 ──┤ GPIO7   GPIO23 ├── D4 (SDA)
  GND ──┤                 ├── D10 (MOSI)
  5V  ──┤                 ├── D9 (MISO)
  3V3 ──┤                 ├── D8 (SCK)
        └─────────────────┘
  Bottom pads: JTAG (MTDO/MTDI/MTCK/MTMS), Boot
  External antenna: U.FL connector
```

---

## Batch 3 Comparison Table

| Feature | XIAO MG24 | XIAO MG24 Sense | XIAO nRF54L15 | XIAO nRF54L15 Sense | XIAO ESP32-C5 |
|---|---|---|---|---|---|
| **MCU** | EFR32MG24 | EFR32MG24 | nRF54L15 | nRF54L15 | ESP32-C5 |
| **Architecture** | Cortex-M33 | Cortex-M33 | Cortex-M33 + RISC-V | Cortex-M33 + RISC-V | RISC-V |
| **Clock** | 78 MHz | 78 MHz | 128 MHz | 128 MHz | 240 MHz |
| **Flash** | 1536 KB + 4 MB | 1536 KB + 4 MB | 1.5 MB NVM | 1.5 MB NVM | 8 MB |
| **RAM** | 256 KB | 256 KB | 256 KB | 256 KB | 384 KB SRAM |
| **PSRAM** | — | — | — | — | 8 MB |
| **WiFi** | ❌ | ❌ | ❌ | ❌ | ✅ Wi-Fi 6 (dual-band) |
| **Bluetooth** | BLE 5.3 | BLE 5.3 | BLE 6.0 | BLE 6.0 | BLE 5.0 |
| **Zigbee** | ✅ | ✅ | ✅ | ✅ | ❌ |
| **Thread** | ✅ | ✅ | ✅ | ✅ | ❌ |
| **Matter** | ✅ | ✅ | ✅ | ✅ | ❌ |
| **NFC** | ❌ | ❌ | ✅ | ✅ | ❌ |
| **IMU** | ❌ | ✅ 6-Axis | ❌ | ✅ LSM6DS3TR-C | ❌ |
| **Microphone** | ❌ | ✅ Analog | ❌ | ✅ MSM261DGT006 | ❌ |
| **ADC Resolution** | 12-bit | 12-bit | 14-bit | 14-bit | 12-bit |
| **GPIO Count** | 22 (all PWM) | 22 (all PWM) | 16 | 16 | 11 (all PWM) |
| **Analog Pins** | 19 | 19 | 4 (D0-D3) | 4 (D0-D3) | 5 |
| **I2C** | 1 bus | 1 bus | 2 buses | 2 buses | 1 bus |
| **SPI** | 2 buses | 2 buses | 1 bus | 1 bus | 1 bus |
| **UART** | 2 buses | 2 buses | 1 bus | 1 bus | 2 buses |
| **USB** | Type-C | Type-C | Type-C | Type-C | Type-C |
| **Dimensions** | 21×17.8 mm | 21×17.8 mm | 21×17.8 mm | 21×17.8 mm | 21×17.8 mm |
| **Op. Temp** | -20°C to 70°C | -20°C to 70°C | -40°C to 105°C | -40°C to 105°C | Not specified |
| **Software** | Arduino IDE | Arduino IDE | nRF Connect SDK / PlatformIO | nRF Connect SDK / PlatformIO | Arduino IDE |

---

## Notes

- **XIAO MG24 / MG24 Sense** share a single wiki page. The only hardware difference is the Sense variant includes an analog microphone and 6-axis IMU. Both use a SAMD11 serial bridge chip (no native USB on the EFR32MG24). No BOOT button — uses escape pin (PC1 pulled LOW) for recovery.
- **XIAO nRF54L15 / nRF54L15 Sense** also share a single wiki page. The Sense variant adds an LSM6DS3TR-C IMU and MSM261DGT006 microphone. Both include a unique RISC-V coprocessor alongside the Cortex-M33. Uses SAMD11 serial bridge. Has a user button (P0.00) in addition to reset.
- **XIAO ESP32-C5** is the first XIAO with **dual-band Wi-Fi 6** (2.4 GHz + 5 GHz). It uses an external antenna via U.FL connector. No Sense variant exists. Has both RESET and BOOT buttons. JTAG pins are on bottom pads and should not be used as deep sleep wake-up sources.
- All boards in this batch maintain the standard XIAO form factor (21 × 17.8 mm) with USB-C and the same edge pin layout (D0-D10 on edges, additional pads on bottom).
- The nRF54L15 boards have the widest operating temperature range (-40°C to 105°C) and support the newest Bluetooth standard (BLE 6.0 with Channel Sounding).
- The MG24 boards have the most GPIO pins (22, all PWM-capable) and the most analog inputs (19).
