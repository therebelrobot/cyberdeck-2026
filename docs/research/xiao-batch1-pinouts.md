# XIAO Batch 1 — Pinout & Specification Research

> **Source:** Seeed Studio Wiki (wiki.seeedstudio.com)
> **Date researched:** 2026-03-22
> **Boards covered:** XIAO SAMD21, XIAO RP2040, XIAO nRF52840, XIAO nRF52840 Sense, XIAO ESP32-C3

---

## Common XIAO Form Factor

All boards in this batch share the same physical form factor:
- **Dimensions:** 21 × 17.8 mm (thumb-sized)
- **USB:** USB Type-C
- **Pin layout:** 14 castellated pads (7 per side) + bottom pads (GND, 3V3, battery)
- **Logic level:** 3.3V (all boards)
- **Power input:** 5V via USB-C or VIN pad

### Standard XIAO Pin Positions (all boards)

```
         USB-C
    ┌──────────────┐
D0  │ 1          14│ 5V
D1  │ 2          13│ GND
D2  │ 3          12│ 3V3
D3  │ 4          11│ D10
D4  │ 5          10│ D9
D5  │ 6           9│ D8
D6  │ 7           8│ D7
    └──────────────┘
      (bottom pads)
```

---

## 1. XIAO SAMD21

**Wiki:** https://wiki.seeedstudio.com/Seeeduino-XIAO/

### Specifications

| Parameter | Value |
|---|---|
| **MCU** | Microchip SAMD21G18 (ATSAMD21G18A-MU) |
| **Architecture** | ARM Cortex-M0+ 32-bit |
| **Clock Speed** | Up to 48 MHz |
| **Flash** | 256 KB |
| **RAM** | 32 KB SRAM |
| **Wireless** | None |
| **USB** | USB Type-C |
| **Operating Voltage** | 3.3V MCU / 5V input |
| **Max Output** | 5V @ 500mA, 3.3V @ 200mA |
| **Dimensions** | 21 × 17.8 mm |
| **Working Temp** | -40°C to 85°C |
| **GPIO Count** | 14 total (11 digital, 11 analog, 10 PWM) |
| **Special** | 1× DAC output (D0/A0), QTouch support |
| **Software** | Arduino, PlatformIO, MicroPython, CircuitPython, Zephyr |

### Pin Map

| XIAO Pin | Function | Chip Pin | Description |
|---|---|---|---|
| 5V | VBUS | — | Power Input/Output |
| GND | — | — | Ground |
| 3V3 | 3V3_OUT | — | Power Output |
| D0 | Analog | PA02 | GPIO, ADC, **DAC** |
| D1 | Analog | PA04 | GPIO, ADC |
| D2 | Analog | PA10 | GPIO, ADC |
| D3 | Analog | PA11 | GPIO, ADC |
| D4 | Analog, **SDA** | PA08 | GPIO, I2C Data, ADC |
| D5 | Analog, **SCL** | PA09 | GPIO, I2C Clock, ADC |
| D6 | Analog, **TX** | PB08 | GPIO, UART Transmit, ADC |
| D7 | Analog, **RX** | PB09 | GPIO, UART Receive, ADC |
| D8 | Analog, **SPI_SCK** | PA07 | GPIO, SPI Clock, ADC |
| D9 | Analog, **SPI_MISO** | PA05 | GPIO, SPI Data, ADC |
| D10 | Analog, **SPI_MOSI** | PA06 | GPIO, SPI Data |

### Internal/LED Pins

| Pin | Chip Pin | Description |
|---|---|---|
| TX_LED | PA19 | TX indicator LED |
| RX_LED | PA18 | RX indicator LED |
| Power_LED | VBUS | Charge LED (Red) |
| USER_LED | PA17 | User LED (Yellow) |

### Notes
- All pins support interrupts (but D5 and D7 cannot be used simultaneously for interrupts)
- DAC only on D0/A0 (10-bit resolution, 0–3.3V)
- ADC supports up to 12-bit resolution
- PWM on D1–D10

---

## 2. XIAO RP2040

**Wiki:** https://wiki.seeedstudio.com/XIAO-RP2040/

### Specifications

| Parameter | Value |
|---|---|
| **MCU** | Raspberry Pi RP2040 |
| **Architecture** | Dual-core ARM Cortex-M0+ |
| **Clock Speed** | Up to 133 MHz |
| **Flash** | 2 MB onboard |
| **RAM** | 264 KB SRAM |
| **Wireless** | None |
| **USB** | USB Type-C |
| **Operating Voltage** | 3.3V MCU / 5V input |
| **Dimensions** | 21 × 17.8 mm |
| **Working Temp** | -20°C to 70°C |
| **GPIO Count** | 14 total (11 digital, 4 analog, 11 PWM) |
| **Onboard** | User LED (3 colors), Power LED, RGB LED (WS2812), Reset Button, Boot Button |
| **Software** | Arduino, PlatformIO, MicroPython, CircuitPython, TinyGo, Rust, Zephyr |

### Pin Map

| XIAO Pin | Function | Chip Pin | Description |
|---|---|---|---|
| 5V | VBUS | — | Power Input/Output |
| GND | — | — | Ground |
| 3V3 | 3V3_OUT | — | Power Output |
| D0 | Analog | GPIO26 | GPIO, ADC |
| D1 | Analog | GPIO27 | GPIO, ADC |
| D2 | Analog | GPIO28 | GPIO, ADC |
| D3 | Analog | GPIO29 | GPIO, ADC |
| D4 | **SDA** | GPIO6 | GPIO, I2C Data |
| D5 | **SCL** | GPIO7 | GPIO, I2C Clock |
| D6 | **TX** | GPIO0 | GPIO, UART Transmit |
| D7 | **RX**, CSn | GPIO1 | GPIO, UART Receive, SPI CS |
| D8 | **SCK** | GPIO2 | GPIO, SPI Clock |
| D9 | **MISO** | GPIO4 | GPIO, SPI Data |
| D10 | **MOSI** | GPIO3 | GPIO, SPI Data |

### Internal/LED Pins

| Pin | Chip Pin | Description |
|---|---|---|
| RGB LED | GPIO12 | WS2812 RGB LED data |
| USER_LED_R | GPIO17 | Red user LED |
| USER_LED_G | GPIO16 | Green user LED |
| USER_LED_B | GPIO25 | Blue user LED |
| CHARGE_LED | VCC_3V3 | Charge LED (Red) |

### Notes
- Only 4 analog pins (D0–D3) vs 11 on SAMD21
- All 11 digital pins support PWM
- LEDs are active LOW (pull low to turn on)
- Boot button enters UF2 bootloader mode

---

## 3. XIAO nRF52840

**Wiki:** https://wiki.seeedstudio.com/XIAO_BLE/

### Specifications

| Parameter | Value |
|---|---|
| **MCU** | Nordic nRF52840 |
| **Architecture** | ARM Cortex-M4 32-bit with FPU |
| **Clock Speed** | 64 MHz |
| **Flash** | 1 MB internal + 2 MB onboard |
| **RAM** | 256 KB |
| **Wireless** | Bluetooth Low Energy 5.4, Bluetooth Mesh, NFC |
| **USB** | USB Type-C |
| **Operating Voltage** | 3.3V MCU / 5V input |
| **Dimensions** | 21 × 17.8 mm |
| **GPIO Count** | 14 pads (11 digital/PWM, 6 analog/ADC) |
| **Onboard** | 3-in-one RGB LED, Charge LED, Reset Button |
| **Battery** | BQ25101 charge chip, supports LiPo charge/discharge |
| **Standby Power** | < 5 μA |
| **Software** | Arduino, MicroPython, CircuitPython |

### Pin Map

| XIAO Pin | Function | Chip Pin | Description |
|---|---|---|---|
| 5V | VBUS | — | Power Input/Output |
| GND | — | — | Ground |
| 3V3 | 3V3_OUT | — | Power Output |
| D0 | Analog | P0.02 | GPIO, AIN0 |
| D1 | Analog | P0.03 | GPIO, AIN1 |
| D2 | Analog | P0.28 | GPIO, AIN4 |
| D3 | Analog | P0.29 | GPIO, AIN5 |
| D4 | Analog, **SDA** | P0.04 | GPIO, I2C Data, AIN2 |
| D5 | Analog, **SCL** | P0.05 | GPIO, I2C Clock, AIN3 |
| D6 | **TX** | P1.11 | GPIO, UART Transmit |
| D7 | **RX** | P1.12 | GPIO, UART Receive |
| D8 | **SPI_SCK** | P1.13 | GPIO, SPI Clock |
| D9 | **SPI_MISO** | P1.14 | GPIO, SPI Data |
| D10 | **SPI_MOSI** | P1.15 | GPIO, SPI Data |

### Additional Pins (Bottom Pads / Internal)

| Pin | Chip Pin | Description |
|---|---|---|
| NFC1 | P0.09 | NFC antenna |
| NFC2 | P0.10 | NFC antenna |
| Reset | P0.18 | Reset |
| ADC_BAT | P0.14 | Read battery voltage |
| USER_LED_R | P0.26 | Red RGB LED |
| USER_LED_G | P0.30 | Green RGB LED |
| USER_LED_B | P0.06 | Blue RGB LED |
| CHARGE_LED | P0.17 | Charge indicator (Red) |

### Notes
- 6 analog pins (D0–D5 all have ADC)
- 11 PWM pins
- NFC antenna pads on bottom of board
- LEDs are active LOW
- Battery charging current selectable: 50mA (P0.13 HIGH) or 100mA (P0.13 LOW)
- Two Arduino libraries: "Seeed nRF52 Boards" (BLE/low power) and "Seeed nRF52 mbed-enabled Boards" (ML/IMU/PDM)

---

## 4. XIAO nRF52840 Sense

**Wiki:** https://wiki.seeedstudio.com/XIAO_BLE/ (same page as nRF52840)

### Specifications

Same as XIAO nRF52840 above, **plus:**

| Parameter | Value |
|---|---|
| **IMU** | LSM6DS3TR-C 6-axis (accelerometer + gyroscope) |
| **Microphone** | PDM digital microphone (MSM261D3526H1CPM) |

### Additional Sense-Only Pins

| Pin | Chip Pin | Description |
|---|---|---|
| 6DOF IMU_PWR | P1.08 | Power switch for IMU module |
| 6DOF IMU_INT1 | P0.11 | Interrupt signal from IMU |
| PDM Mic_DATA | P0.16 | PDM audio data input |
| PDM Mic_CLK | P1.00 | PDM audio clock output |

### Notes
- Pin mapping for D0–D10 is **identical** to XIAO nRF52840
- The Sense variant adds the IMU and microphone on internal pins (not exposed on GPIO pads)
- Same form factor and dimensions

---

## 5. XIAO ESP32-C3

**Wiki:** https://wiki.seeedstudio.com/XIAO_ESP32C3_Getting_Started/

### Specifications

| Parameter | Value |
|---|---|
| **MCU** | Espressif ESP32-C3 |
| **Architecture** | 32-bit RISC-V single-core |
| **Clock Speed** | Up to 160 MHz |
| **Flash** | 4 MB onboard |
| **RAM** | 400 KB SRAM |
| **Wireless** | WiFi 802.11 b/g/n (2.4 GHz), Bluetooth 5.0 (BLE), Bluetooth Mesh |
| **USB** | USB Type-C |
| **Operating Voltage** | 3.3V MCU / 5V input |
| **Max 3.3V Output** | 500 mA |
| **Dimensions** | 21 × 17.8 mm |
| **Working Temp** | -40°C to 85°C |
| **GPIO Count** | 11 digital/PWM, 4 analog/ADC |
| **Deep Sleep** | ~44 μA |
| **WiFi Active** | ~75 mA |
| **Antenna** | External U.FL antenna (included) |
| **Battery** | Supports LiPo charge/discharge (3.7V BAT input) |
| **Software** | Arduino, ESP-IDF, MicroPython, CircuitPython, PlatformIO |

### Pin Map

| XIAO Pin | Function | Chip Pin | Alternate Functions | Description |
|---|---|---|---|---|
| 5V | VBUS | — | — | Power Input/Output |
| GND | — | — | — | Ground |
| 3V3 | 3V3_OUT | — | — | Power Output |
| D0 | Analog | GPIO2 | ADC1_CH2 | GPIO, ADC |
| D1 | Analog | GPIO3 | ADC1_CH3 | GPIO, ADC |
| D2 | Analog | GPIO4 | ADC1_CH4, MTMS | GPIO, ADC |
| D3 | Analog | GPIO5 | ADC2_CH0, MTDI | GPIO, ADC |
| D4 | **SDA** | GPIO6 | FSPICLK, MTCK | GPIO, I2C Data |
| D5 | **SCL** | GPIO7 | FSPID, MTDO | GPIO, I2C Clock |
| D6 | **TX** | GPIO21 | U0TXD | GPIO, UART Transmit |
| D7 | **RX** | GPIO20 | U0RXD | GPIO, UART Receive |
| D8 | **SCK** | GPIO8 | — | GPIO, SPI Clock |
| D9 | **MISO** | GPIO9 | — | GPIO, SPI Data |
| D10 | **MOSI** | GPIO10 | FSPICS0 | GPIO, SPI Data |

### Additional Pins

| Pin | Chip Pin | Description |
|---|---|---|
| Reset | CHIP_EN | Enable/Reset |
| Boot | GPIO9 | Enter bootloader mode |
| U.FL Antenna | LNA_IN | External antenna connector |
| CHG LED | VCC_3V3 | Charge indicator |

### Strapping Pins Warning
- **GPIO2** (D0), **GPIO8** (D8), and **GPIO9** (D9) are strapping pins
- Their state at boot determines boot mode — be careful with external pull-ups/downs on these pins

### Notes
- No built-in user LED (LED_BUILTIN not available)
- External U.FL antenna provides better RF range than PCB antennas
- ADC2 (D3/GPIO5) may give unreliable readings; prefer ADC1 pins (D0–D2)
- Deep sleep wake-up supported on D0–D3 only
- JTAG available on D2–D5 (MTMS, MTDI, MTCK, MTDO)

---

## Cross-Board Comparison Summary

| Feature | SAMD21 | RP2040 | nRF52840 | nRF52840 Sense | ESP32-C3 |
|---|---|---|---|---|---|
| **Architecture** | Cortex-M0+ | Dual Cortex-M0+ | Cortex-M4F | Cortex-M4F | RISC-V |
| **Clock** | 48 MHz | 133 MHz | 64 MHz | 64 MHz | 160 MHz |
| **Flash** | 256 KB | 2 MB | 1MB+2MB | 1MB+2MB | 4 MB |
| **RAM** | 32 KB | 264 KB | 256 KB | 256 KB | 400 KB |
| **WiFi** | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Bluetooth** | ❌ | ❌ | BLE 5.4 | BLE 5.4 | BLE 5.0 |
| **NFC** | ❌ | ❌ | ✅ | ✅ | ❌ |
| **IMU** | ❌ | ❌ | ❌ | ✅ (6-axis) | ❌ |
| **Microphone** | ❌ | ❌ | ❌ | ✅ (PDM) | ❌ |
| **Analog Pins** | 11 | 4 | 6 | 6 | 4 |
| **Digital Pins** | 11 | 11 | 11 | 11 | 11 |
| **PWM Pins** | 10 | 11 | 11 | 11 | 11 |
| **DAC** | ✅ (1) | ❌ | ❌ | ❌ | ❌ |
| **I2C** | D4/D5 | D4/D5 | D4/D5 | D4/D5 | D4/D5 |
| **SPI** | D8/D9/D10 | D8/D9/D10 | D8/D9/D10 | D8/D9/D10 | D8/D9/D10 |
| **UART** | D6/D7 | D6/D7 | D6/D7 | D6/D7 | D6/D7 |
| **Battery Charge** | ❌ | ❌ | ✅ | ✅ | ✅ |
| **Antenna** | — | — | Onboard | Onboard | External U.FL |
| **Dimensions** | 21×17.8mm | 21×17.8mm | 21×17.8mm | 21×17.8mm | 21×17.8mm |

### Consistent Pin Mapping Across All Boards

All XIAO boards maintain the same functional pin assignment:
- **D4** = SDA (I2C Data)
- **D5** = SCL (I2C Clock)
- **D6** = TX (UART Transmit)
- **D7** = RX (UART Receive)
- **D8** = SCK (SPI Clock)
- **D9** = MISO (SPI Data In)
- **D10** = MOSI (SPI Data Out)

This consistent mapping means peripheral wiring is identical across all XIAO boards, enabling easy board swaps.
