# XIAO Microcontroller Pinouts - Batch 2

> Research compiled from Seeed Studio Wiki documentation pages.
> Date: 2026-03-22

## Table of Contents
- [1. XIAO ESP32-S3](#1-xiao-esp32-s3)
- [2. XIAO ESP32-S3 Sense](#2-xiao-esp32-s3-sense)
- [3. XIAO ESP32-C6](#3-xiao-esp32-c6)
- [4. XIAO RP2350](#4-xiao-rp2350)
- [5. XIAO RA4M1](#5-xiao-ra4m1)

---

## 1. XIAO ESP32-S3

**Wiki URL:** https://wiki.seeedstudio.com/xiao_esp32s3_getting_started/

### Specifications

| Parameter | Value |
|-----------|-------|
| **MCU/Processor** | ESP32-S3R8, Xtensa LX7 dual-core, 32-bit @ up to 240 MHz |
| **Architecture** | Xtensa LX7 (dual-core) |
| **Flash** | 8MB |
| **PSRAM** | 8MB |
| **RAM** | On-chip (part of ESP32-S3R8) |
| **Wireless** | 2.4GHz Wi-Fi, Bluetooth Low Energy 5.0 / Bluetooth Mesh |
| **USB** | USB Type-C |
| **Operating Voltage** | 3.3V logic; Input: 5V (Type-C), 3.7V (BAT) |
| **Deep Sleep** | 14μA |
| **Dimensions** | 21 x 17.8mm |
| **Working Temperature** | -20°C ~ 65°C |

### Interfaces
- 1x UART
- 1x I2C (IIC)
- 1x SPI
- 11x GPIO (PWM capable)
- 9x ADC
- 1x User LED (GPIO21)
- 1x Charge LED
- 1x Reset button
- 1x Boot button

### Pin Map

| XIAO Pin | Function | Chip Pin | Alternate Functions | Description |
|----------|----------|----------|-------------------|-------------|
| 5V | VBUS | - | - | Power Input/Output |
| GND | - | - | - | Ground |
| 3V3 | 3V3_OUT | - | - | Power Output |
| D0 | Analog | GPIO1 | TOUCH1 | GPIO, ADC |
| D1 | Analog | GPIO2 | TOUCH2 | GPIO, ADC |
| D2 | Analog | GPIO3 | TOUCH3 | GPIO, ADC |
| D3 | Analog | GPIO4 | TOUCH4 | GPIO, ADC |
| D4 | Analog, SDA | GPIO5 | TOUCH5 | GPIO, I2C Data, ADC |
| D5 | Analog, SCL | GPIO6 | TOUCH6 | GPIO, I2C Clock, ADC |
| D6 | TX | GPIO43 | - | GPIO, UART Transmit |
| D7 | RX | GPIO44 | - | GPIO, UART Receive |
| D8 | Analog, SCK | GPIO7 | TOUCH7 | GPIO, SPI Clock, ADC |
| D9 | Analog, MISO | GPIO8 | TOUCH8 | GPIO, SPI Data, ADC |
| D10 | Analog, MOSI | GPIO9 | TOUCH9 | GPIO, SPI Data, ADC |

### Bottom Pads (JTAG)

| Pin | Chip Pin | Description |
|-----|----------|-------------|
| MTDO | GPIO40 | JTAG |
| MTDI | GPIO41 | JTAG, ADC |
| MTCK | GPIO39 | JTAG, ADC |
| MTMS | GPIO42 | JTAG, ADC |

### Internal Pins

| Pin | Chip Pin | Description |
|-----|----------|-------------|
| Reset | CHIP_PU | Reset |
| Boot | GPIO0 | Enter Boot Mode |
| U.FL-R-SMT1 | LNA_IN | UFL antenna connector |
| CHARGE_LED | - | CHG-LED |
| USER_LED | GPIO21 | User Light |

### Special Notes
- Pins D11 (GPIO42) and D12 (GPIO41) are assigned but do **NOT** support ADC functionality despite being labeled "Analog"
- All D0-D10 pins support PWM
- Touch sensing available on D0-D5, D8-D10
- 3V3 output can supply up to 700mA

### Pin Layout (text representation)
```
        USB-C
    ┌───────────┐
D0  │●         ●│ D10
D1  │●         ●│ D9
D2  │●         ●│ D8
D3  │●         ●│ D7
D4  │●         ●│ D6
D5  │●         ●│ D5
3V3 │●         ●│ GND
    └───────────┘
     [BAT pads]
  [Bottom JTAG pads]
```

---

## 2. XIAO ESP32-S3 Sense

**Wiki URL:** https://wiki.seeedstudio.com/xiao_esp32s3_getting_started/ (same page as ESP32-S3)

### Specifications

| Parameter | Value |
|-----------|-------|
| **MCU/Processor** | ESP32-S3R8, Xtensa LX7 dual-core, 32-bit @ up to 240 MHz |
| **Architecture** | Xtensa LX7 (dual-core) |
| **Flash** | 8MB |
| **PSRAM** | 8MB |
| **RAM** | On-chip (part of ESP32-S3R8) |
| **Wireless** | 2.4GHz Wi-Fi, Bluetooth Low Energy 5.0 / Bluetooth Mesh |
| **Built-in Sensors** | 1x OV3660 camera sensor, 1x Digital Microphone |
| **Storage** | Onboard SD Card Slot (supports 32GB FAT) |
| **USB** | USB Type-C |
| **Operating Voltage** | 3.3V logic; Input: 5V (Type-C), 3.7V (BAT) |
| **Deep Sleep** | 3mA (with expansion board) |
| **Dimensions** | 21 x 17.8 x 15mm (with expansion board) |
| **Working Temperature** | -20°C ~ 65°C |

### Differences from ESP32-S3 (base)
- Adds OV3660 camera sensor (previously OV2640, now discontinued; also compatible with OV5640)
- Adds digital microphone (PDM)
- Adds SD card slot
- Adds I2S interface
- Adds B2B connector (with 2 additional GPIOs)
- Higher power consumption due to sensors

### Pin Map
Same as XIAO ESP32-S3 (see above), plus the following internal pins used by the expansion board:

### Digital Microphone Pins

| Pin | Chip Pin | Description |
|-----|----------|-------------|
| Digital microphone_CLK | GPIO42 | PDM clock pin for MIC |
| Digital microphone_DATA | GPIO41 | PDM data pin for MIC |

### SD Card Pins (shared with external pins)

| Pin | Chip Pin | Description |
|-----|----------|-------------|
| SD Card CS | GPIO3 | SD card chip select |
| SD Card SCK | GPIO7 | SD card clock |
| SD Card MISO | GPIO8 | SD card data input |
| SD Card MOSI | GPIO10 | SD card data output |

### Camera Pins (internal, via B2B connector)

| Chip Pin | Description |
|----------|-------------|
| GPIO10 | Camera clock |
| GPIO11 | Camera video data (Y8) |
| GPIO12 | Camera video data (Y7) |
| GPIO13 | Camera pixel clock |
| GPIO14 | Camera video data (Y6) |
| GPIO15 | Camera video data (Y2) |
| GPIO16 | Camera video data (Y5) |
| GPIO17 | Camera video data (Y3) |
| GPIO18 | Camera video data (Y4) |
| GPIO40 | I2C data for Camera |
| GPIO39 | I2C clock for Camera |
| GPIO38 | Camera vertical sync |
| GPIO47 | Camera horizontal sync |
| GPIO48 | Camera video data (Y9) |

### Special Notes
- When using the camera/SD card, some external pins (D2/GPIO3, D8/GPIO7, D9/GPIO8) are shared and may conflict
- The microphone uses GPIO41 and GPIO42 (same as D12 and D11 external pins)
- Camera OV2640 has been discontinued; OV3660 is the current model; OV5640 is also compatible

---

## 3. XIAO ESP32-C6

**Wiki URL:** https://wiki.seeedstudio.com/xiao_esp32c6_getting_started/

### Specifications

| Parameter | Value |
|-----------|-------|
| **MCU/Processor** | Espressif ESP32-C6 SoC |
| **Architecture** | Two 32-bit RISC-V processors (HP: up to 160 MHz, LP: up to 20 MHz) |
| **Flash** | 4MB |
| **RAM** | 512KB SRAM |
| **Wireless** | 2.4GHz Wi-Fi 6 (802.11ax), Bluetooth 5.0 (LE), Zigbee, Thread (IEEE 802.15.4) |
| **USB** | USB Type-C |
| **Operating Voltage** | 3.3V logic; Input: 5V (Type-C), 3.7V (BAT) |
| **Deep Sleep** | 15μA |
| **Dimensions** | 21 x 17.8mm |
| **Working Temperature** | -40°C ~ 85°C |

### Interfaces
- 1x UART
- 1x LP_UART (low-power UART)
- 1x I2C (IIC)
- 1x LP_I2C (low-power I2C)
- 1x SPI
- 1x SDIO
- 11x GPIO (PWM capable)
- 7x ADC
- 1x Reset button
- 1x Boot button

### Special Features
- **Matter native** - supports Thread and Zigbee for smart home interoperability
- **Wi-Fi 6** support (802.11ax)
- **Dual RISC-V processors** (high-performance + low-power)
- **RF Switch** - toggle between built-in ceramic antenna and external UFL antenna via GPIO14 (requires GPIO3 set LOW first)
- Secure boot, encryption, Trusted Execution Environment (TEE)

### Pin Map

| XIAO Pin | Function | Chip Pin | Alternate Functions | Description |
|----------|----------|----------|-------------------|-------------|
| 5V | VBUS | - | - | Power Input/Output |
| GND | - | - | - | Ground |
| 3V3 | 3V3_OUT | - | - | Power Output |
| D0 | Analog | GPIO0 | LP_GPIO0 | GPIO, ADC |
| D1 | Analog | GPIO1 | LP_GPIO1 | GPIO, ADC |
| D2 | Analog | GPIO2 | LP_GPIO2 | GPIO, ADC |
| D3 | Digital | GPIO21 | SDIO_DATA1 | GPIO |
| D4 | SDA | GPIO22 | SDIO_DATA2 | GPIO, I2C Data |
| D5 | SCL | GPIO23 | SDIO_DATA3 | GPIO, I2C Clock |
| D6 | TX | GPIO16 | - | GPIO, UART Transmit |
| D7 | RX | GPIO17 | - | GPIO, UART Receive |
| D8 | SCK | GPIO19 | SPI_CLK | GPIO, SPI Clock |
| D9 | MISO | GPIO20 | SPI_MISO | GPIO, SPI Data |
| D10 | MOSI | GPIO18 | SPI_MOSI | GPIO, SPI Data |

### Bottom Pads (JTAG)

| Pin | Chip Pin | Description |
|-----|----------|-------------|
| MTDO | GPIO7 | JTAG |
| MTDI | GPIO5 | JTAG, ADC |
| MTCK | GPIO6 | JTAG, ADC |
| MTMS | GPIO4 | JTAG, ADC |

### Internal Pins

| Pin | Chip Pin | Description |
|-----|----------|-------------|
| EN | CHIP_PU | Reset |
| Boot | GPIO9 | Enter Boot Mode |
| RF Switch Port Select | GPIO14 | Switch onboard/UFL antenna |
| RF Switch Power | GPIO3 | Power for RF switch |
| Light (User LED) | GPIO15 | User Light |

### Pin Layout (text representation)
```
        USB-C
    ┌───────────┐
D0  │●         ●│ D10
D1  │●         ●│ D9
D2  │●         ●│ D8
D3  │●         ●│ D7
D4  │●         ●│ D6
D5  │●         ●│ D5
3V3 │●         ●│ GND
    └───────────┘
     [BAT pads]
  [Bottom JTAG pads]
```

---

## 4. XIAO RP2350

**Wiki URL:** https://wiki.seeedstudio.com/xiao_rp2350_arduino/

### Specifications

| Parameter | Value |
|-----------|-------|
| **MCU/Processor** | Raspberry Pi RP2350 |
| **Architecture** | Dual ARM Cortex-M33 @ 150MHz with FPU |
| **Flash** | 2MB |
| **RAM** | 520KB SRAM |
| **Wireless** | None |
| **USB** | USB Type-C |
| **Operating Voltage** | 3.3V logic |
| **Deep Sleep** | ~50μA |
| **Dimensions** | 21 x 17.8mm |
| **Working Temperature** | -20°C ~ 70°C |
| **Security** | OTP, Secure Boot, Arm TrustZone |

### Interfaces
- 19 Pins (All PWM capable)
- 3x Analog (ADC)
- 19x Digital
- 2x I2C
- 2x UART
- 2x SPI
- 1x User LED (GPIO25, Yellow)
- 1x Power LED
- 1x RGB LED (GPIO22)
- 1x Reset button
- 1x Boot button

### Special Features
- **Expanded 8 new IOs** on the back compared to previous XIAO MCUs (19 GPIOs total)
- **Dual Cortex-M33** with FPU (floating point unit)
- **Arm TrustZone** security
- **Battery voltage reading** via internal ADC_BAT (GPIO29)
- Compatible with C/C++, MicroPython, Arduino

### Pin Map

| XIAO Pin | Function | Chip Pin | Description |
|----------|----------|----------|-------------|
| 5V | VBUS | - | Power Input/Output |
| GND | - | - | Ground |
| 3V3 | 3V3_OUT | - | Power Output |
| D0 | Analog | GPIO26 | GPIO, ADC |
| D1 | Analog | GPIO27 | GPIO, ADC |
| D2 | Analog | GPIO28 | GPIO, ADC |
| D3 | SPIO_CSn | GPIO5 | GPIO, SPI CS |
| D4 | SDA1 | GPIO6 | GPIO, I2C Data |
| D5 | SCL1 | GPIO7 | GPIO, I2C Clock |
| D6 | TX0 | GPIO0 | GPIO, UART Transmit |
| D7 | RX0 | GPIO1 | GPIO, UART Receive |
| D8 | SPIO_SCK | GPIO2 | GPIO, SPI Clock |
| D9 | SPIO_MISO | GPIO4 | GPIO, SPI Data |
| D10 | SPIO_MOSI | GPIO3 | GPIO, SPI Data |

### Back Pads (8 additional IOs)

| XIAO Pin | Function | Chip Pin | Description |
|----------|----------|----------|-------------|
| D11 | RX1 | GPIO21 | GPIO, UART Receive |
| D12 | TX1 | GPIO20 | GPIO, UART Transmit |
| D13 | SCL0 | GPIO17 | GPIO, I2C Clock |
| D14 | SDA0 | GPIO16 | GPIO, I2C Data |
| D15 | SPI1_MOSI | GPIO11 | GPIO, SPI Data |
| D16 | SPI1_MISO | GPIO12 | GPIO, SPI Data |
| D17 | SPI1_SCK | GPIO10 | GPIO, SPI Clock |
| D18 | SPI1_CSn | GPIO9 | SPI CS |

### Internal Pins

| Pin | Chip Pin | Description |
|-----|----------|-------------|
| ADC_BAT | GPIO29 | Read battery voltage |
| Reset | RUN | Reset |
| Boot | RP2040_BOOT | Enter Boot Mode |
| CHARGE_LED | NCHG | CHG-LED (Red) |
| RGB LED | GPIO22 | RGB LED |
| USER_LED | GPIO25 | User Light (Yellow) |

### Pin Layout (text representation)
```
          USB-C
      ┌───────────┐
  D0  │●         ●│ D10
  D1  │●         ●│ D9
  D2  │●         ●│ D8
  D3  │●         ●│ D7
  D4  │●         ●│ D6
  D5  │●         ●│ D5
  3V3 │●         ●│ GND
      └───────────┘
       [BAT pads]
  [Back: D11-D18 pads]
```

---

## 5. XIAO RA4M1

**Wiki URL:** https://wiki.seeedstudio.com/getting_started_xiao_ra4m1/

### Specifications

| Parameter | Value |
|-----------|-------|
| **MCU/Processor** | Renesas RA4M1 (R7FA4M1AB3CNE) |
| **Architecture** | 32-bit ARM Cortex-M4 with FPU @ up to 48 MHz |
| **Flash** | 256KB |
| **RAM** | 32KB SRAM |
| **EEPROM** | 8KB |
| **Wireless** | None |
| **USB** | USB 2.0 (Type-C connector) |
| **Operating Voltage** | 3.3V logic |
| **Deep Sleep** | 42.6μA @ 3.7V |
| **Dimensions** | 21 x 17.8mm |
| **Working Temperature** | -20°C ~ 70°C |
| **Security** | AES128/256 |

### Interfaces
- 19 IOs total
- 6x Analog (ADC, 14-bit)
- 19x Digital
- 2x I2C (IIC)
- 2x UART
- 2x SPI
- 1x CAN BUS (CRX0/CTX0 on D9/D10)
- 1x 12-bit DAC
- 1x User LED (P011, Yellow)
- 1x Power LED
- 1x RGB LED (P112, enable via P500)
- 1x Reset button
- 1x Boot button

### Special Features
- **Same MCU as Arduino Uno R4** (R7FA4M1AB3CNE) - natively compatible with Arduino IDE
- **14-bit ADC** (higher resolution than most XIAO boards)
- **12-bit DAC** output
- **CAN BUS** interface (on D9/CRX0 and D10/CTX0)
- **8KB EEPROM** built-in
- **Expanded 8 new IOs** on the back (19 GPIOs total)
- Battery voltage reading via internal ADC_BAT (P400)
- Hardware encryption (AES128/256)

### Pin Map

| XIAO Pin | Function | Chip Pin | Alternate Functions | Description | Arduino # |
|----------|----------|----------|-------------------|-------------|-----------|
| 5V | VBUS | - | - | Power Input/Output | - |
| GND | - | - | - | Ground | - |
| 3V3 | 3V3_OUT | - | - | Power Output | - |
| D0 | Analog | P014 | AN009 | GPIO, ADC | 0 |
| D1 | Analog | P000 | AN000 | GPIO, ADC | 1 |
| D2 | Analog | P001 | AN001 | GPIO, ADC | 2 |
| D3 | Analog | P002 | AN002 | GPIO, ADC | 3 |
| D4 | SDA1 | P206 | - | GPIO, I2C Data | 4 |
| D5 | Analog, SCL1 | P100 | - | GPIO, I2C Clock, ADC | 5 |
| D6 | TXD2 | P302 | SDA2 | GPIO, UART Transmit, I2C | 6 |
| D7 | RXD2 | P301 | SCL2 | GPIO, UART Receive, I2C | 7 |
| D8 | SPI1_SCK | P111 | - | GPIO, SPI Clock | 8 |
| D9 | SPI1_MISO | P110 | CRX0 | GPIO, SPI Data, CAN RX | 9 |
| D10 | SPI1_MOSI | P109 | CTX0 | GPIO, SPI Data, CAN TX | 10 |

### Back Pads (8 additional IOs)

| XIAO Pin | Function | Chip Pin | Alternate Functions | Description |
|----------|----------|----------|-------------------|-------------|
| D11 | RX9 | P408 | - | GPIO, UART |
| D12 | TX9 | P409 | - | GPIO, UART |
| D13 | GPIO | P013 | - | GPIO |
| D14 | GPIO | P012 | - | GPIO |
| D15 | TXD0 | P101 | SDA0, AN021, SPI0_MOSI | GPIO, UART TX, ADC, SPI, I2C |
| D16 | RXD0 | P104 | SCL0, SPI0_MISO | GPIO, UART RX, SPI, I2C |
| D17 | CRX0 | P102 | AN020, SPI0_SCK | GPIO, UART, ADC, SPI |
| D18 | CTX0 | P103 | AN019 | GPIO, SPI, ADC, UART |

### Internal Pins

| Pin | Chip Pin | Description | Arduino # |
|-----|----------|-------------|-----------|
| ADC_BAT | P400 | Read battery voltage | - |
| Reset | RES | Reset | - |
| Boot | P201 | Enter Boot Mode | - |
| RGB LED | P112 | RGB LED | 20 |
| RGB LED EN | P500 | RGB LED Enable | 21 |
| CHARGE_LED | VBUS | CHG-LED (Red) | - |
| USER_LED | P011 | User Light (Yellow) | 19 |

### Pin Layout (text representation)
```
          USB-C
      ┌───────────┐
  D0  │●         ●│ D10
  D1  │●         ●│ D9
  D2  │●         ●│ D8
  D3  │●         ●│ D7
  D4  │●         ●│ D6
  D5  │●         ●│ D5
  3V3 │●         ●│ GND
      └───────────┘
       [BAT pads]
  [Back: D11-D18 pads]
```

---

## Cross-Board Comparison Summary

| Feature | ESP32-S3 | ESP32-S3 Sense | ESP32-C6 | RP2350 | RA4M1 |
|---------|----------|----------------|----------|--------|-------|
| **MCU** | ESP32-S3R8 | ESP32-S3R8 | ESP32-C6 | RP2350 | RA4M1 |
| **Architecture** | Xtensa LX7 dual-core | Xtensa LX7 dual-core | RISC-V dual-core | Cortex-M33 dual-core | Cortex-M4 |
| **Clock** | 240 MHz | 240 MHz | 160 MHz (HP) / 20 MHz (LP) | 150 MHz | 48 MHz |
| **Flash** | 8MB | 8MB | 4MB | 2MB | 256KB |
| **RAM** | 8MB PSRAM | 8MB PSRAM | 512KB SRAM | 520KB SRAM | 32KB SRAM |
| **WiFi** | ✅ 2.4GHz | ✅ 2.4GHz | ✅ Wi-Fi 6 | ❌ | ❌ |
| **Bluetooth** | ✅ BLE 5.0 | ✅ BLE 5.0 | ✅ BLE 5.0 | ❌ | ❌ |
| **Zigbee/Thread** | ❌ | ❌ | ✅ | ❌ | ❌ |
| **Camera** | ❌ | ✅ OV3660 | ❌ | ❌ | ❌ |
| **Microphone** | ❌ | ✅ PDM | ❌ | ❌ | ❌ |
| **SD Card** | ❌ | ✅ | ❌ | ❌ | ❌ |
| **CAN BUS** | ❌ | ❌ | ❌ | ❌ | ✅ |
| **DAC** | ❌ | ❌ | ❌ | ❌ | ✅ 12-bit |
| **ADC Channels** | 9 | 9 | 7 | 3 | 6 (14-bit) |
| **Total GPIOs** | 11 | 11 (+2 B2B) | 11 | 19 | 19 |
| **I2C** | 1 | 1 | 1 (+1 LP) | 2 | 2 |
| **UART** | 1 | 1 | 1 (+1 LP) | 2 | 2 |
| **SPI** | 1 | 1 | 1 | 2 | 2 |
| **Deep Sleep** | 14μA | 3mA | 15μA | ~50μA | 42.6μA |
| **Dimensions** | 21×17.8mm | 21×17.8×15mm | 21×17.8mm | 21×17.8mm | 21×17.8mm |
| **USB** | Type-C | Type-C | Type-C | Type-C | Type-C |
| **Logic Level** | 3.3V | 3.3V | 3.3V | 3.3V | 3.3V |

## Common XIAO Pin Layout

All XIAO boards share the same form factor with 14 pins (7 per side) on the edges:

```
Left side (top to bottom):   Right side (top to bottom):
D0                           D10
D1                           D9
D2                           D8
D3                           D7 (RX)
D4 (SDA)                     D6 (TX)
D5 (SCL)                     5V
3V3                          GND
```

The RP2350 and RA4M1 add 8 additional pads on the bottom (D11-D18).

## Notes & Missing Information

1. **ESP32-S3 / S3 Sense**: The wiki also documents an "ESP32-S3 Plus" variant with 16MB Flash and 18 GPIOs, but this was not in the original research scope.
2. **ESP32-C6**: GPIO3 and GPIO14 are used internally for RF switch control (antenna selection). Using D0 (GPIO0) for external wake-up from deep sleep is supported.
3. **RP2350**: The "Boot" pin is labeled "RP2040_BOOT" in the wiki (likely a documentation artifact from the RP2040 predecessor).
4. **RA4M1**: D6/D7 pins have alternate I2C functions (SDA2/SCL2), giving this board effectively 3 I2C buses. The CAN BUS pins share with SPI1 MISO/MOSI (D9/D10).
5. **Operating voltage**: All boards operate at 3.3V logic level. All accept 5V via USB Type-C and 3.7V via battery pads.
