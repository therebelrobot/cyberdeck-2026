# Raspberry Pi 4 Model B & Raspberry Pi 5 — GPIO Pinouts & Specifications

> **Sources:** [pinout.xyz](https://pinout.xyz/), [Raspberry Pi official documentation](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html), [Wikipedia — Raspberry Pi 4](https://en.wikipedia.org/wiki/Raspberry_Pi_4), [Wikipedia — Raspberry Pi](https://en.wikipedia.org/wiki/Raspberry_Pi), [Waveshare RPi 5 comparison](https://www.waveshare.com/raspberry-pi-5.htm)
>
> **Date researched:** 2026-03-22

---

## Table of Contents

1. [Raspberry Pi 4 Model B Specifications](#raspberry-pi-4-model-b-specifications)
2. [Raspberry Pi 5 Specifications](#raspberry-pi-5-specifications)
3. [Specifications Comparison Table](#specifications-comparison-table)
4. [40-Pin GPIO Header — Complete Pinout](#40-pin-gpio-header--complete-pinout)
5. [Pin Function Groups](#pin-function-groups)
6. [Key Differences Between RPi 4 and RPi 5](#key-differences-between-rpi-4-and-rpi-5)

---

## Raspberry Pi 4 Model B Specifications

### Processor
| Parameter | Value |
|-----------|-------|
| **SoC** | Broadcom BCM2711 |
| **Architecture** | ARM Cortex-A72 (ARMv8-A, 64-bit) |
| **Cores** | 4 (quad-core) |
| **Clock Speed** | 1.5 GHz (B0 stepping) / 1.8 GHz (C0 stepping, mid-2021+) |
| **L1 Cache** | 32 KB data + 48 KB instruction per core |
| **L2 Cache** | 1 MB shared |
| **GPU** | VideoCore VI @ 500 MHz |
| **GPU APIs** | OpenGL ES 3.1, Vulkan 1.2 |

### Memory
| Option | Type |
|--------|------|
| 1 GB | LPDDR4 @ 3200 MHz |
| 2 GB | LPDDR4 @ 3200 MHz |
| 4 GB | LPDDR4 @ 3200 MHz |
| 8 GB | LPDDR4 @ 3200 MHz |

### Connectivity
| Interface | Details |
|-----------|---------|
| **WiFi** | 2.4 GHz and 5.0 GHz IEEE 802.11ac (Wi-Fi 5) dual-band |
| **Bluetooth** | Bluetooth 5.0, BLE |
| **Ethernet** | Gigabit Ethernet (true gigabit, via dedicated PCI Express bus) |
| **USB** | 2 × USB 3.0 + 2 × USB 2.0 |

### Video Output
| Interface | Details |
|-----------|---------|
| **HDMI** | 2 × micro-HDMI (up to 4Kp60 single / 4Kp30 dual) |
| **DSI** | 1 × 2-lane MIPI DSI display port (exposed) |
| **Composite** | 4-pole stereo audio and composite video port |

### Camera
| Interface | Details |
|-----------|---------|
| **CSI** | 1 × 2-lane MIPI CSI camera port (exposed) |

### Storage
| Interface | Details |
|-----------|---------|
| **MicroSD** | Standard MicroSD card slot |
| **USB Boot** | Supported (USB mass storage boot) |
| **NVMe** | Not natively supported (PCIe used internally for USB 3.0) |

### Power
| Parameter | Value |
|-----------|-------|
| **Input** | USB-C |
| **Voltage** | 5V |
| **Current** | 3A recommended (2.5A minimum if USB peripherals < 500mA) |
| **PoE** | Supported with separate PoE+ HAT |

### Physical
| Parameter | Value |
|-----------|-------|
| **Dimensions** | 85.6 mm × 56.5 mm |
| **GPIO Header** | 40-pin standard Raspberry Pi header |
| **Released** | June 24, 2019 |
| **End of Life** | Will remain in production until January 2034 |

### Multimedia
| Capability | Details |
|------------|---------|
| **H.265 (HEVC)** | Hardware decode @ 4Kp60 |
| **H.264 (AVC)** | Hardware decode @ 1080p60, encode @ 1080p30 |

---

## Raspberry Pi 5 Specifications

### Processor
| Parameter | Value |
|-----------|-------|
| **SoC** | Broadcom BCM2712 |
| **Architecture** | ARM Cortex-A76 (ARMv8.2-A, 64-bit) |
| **Cores** | 4 (quad-core) |
| **Clock Speed** | 2.4 GHz |
| **L2 Cache** | 512 KB per core |
| **L3 Cache** | 2 MB shared |
| **GPU** | VideoCore VII |
| **I/O Controller** | RP1 (Raspberry Pi custom southbridge chip) |
| **Memory Interface** | 32-bit LPDDR4X, up to 17 GB/s bandwidth |

### Memory
| Option | Type |
|--------|------|
| 1 GB | LPDDR4X |
| 2 GB | LPDDR4X |
| 4 GB | LPDDR4X |
| 8 GB | LPDDR4X |
| 16 GB | LPDDR4X |

### Connectivity
| Interface | Details |
|-----------|---------|
| **WiFi** | 2.4 GHz and 5.0 GHz IEEE 802.11ac (Wi-Fi 5) dual-band |
| **Bluetooth** | Bluetooth 5.0, BLE |
| **Ethernet** | Gigabit Ethernet |
| **USB** | 2 × USB 3.0 (simultaneous 5 Gbps) + 2 × USB 2.0 |
| **PCIe** | 1 × PCIe 2.0 interface (exposed, for NVMe etc.) |

### Video Output
| Interface | Details |
|-----------|---------|
| **HDMI** | 2 × micro-HDMI (up to 4Kp60 dual display) |
| **DSI/CSI** | 2 × 4-lane MIPI connectors (interchangeable DSI/CSI) |
| **Composite** | Not available (no 3.5mm A/V jack) |

### Camera
| Interface | Details |
|-----------|---------|
| **CSI/DSI** | 2 × 4-lane MIPI connectors (can be used as 2× camera, 2× display, or 1 of each) |

### Storage
| Interface | Details |
|-----------|---------|
| **MicroSD** | MicroSD card slot with high-speed SDR104 mode |
| **USB Boot** | Supported |
| **NVMe** | Supported via PCIe 2.0 (with M.2 HAT+) |

### Power
| Parameter | Value |
|-----------|-------|
| **Input** | USB-C |
| **Voltage** | 5V |
| **Current** | 5A recommended (supports USB PD) |
| **PoE** | Supported with separate new PoE+ HAT |

### Physical
| Parameter | Value |
|-----------|-------|
| **Dimensions** | 85 mm × 56 mm |
| **GPIO Header** | 40-pin standard Raspberry Pi header |
| **Released** | October 2023 |

### Additional RPi 5 Features
| Feature | Details |
|---------|---------|
| **RTC** | Onboard Real-Time Clock with RTC battery connector |
| **UART Connector** | Dedicated 3-pin UART debug connector |
| **Power Button** | Onboard power button |
| **Fan Connector** | 4-pin fan header with PWM speed control |
| **RP1 I/O Controller** | Custom Raspberry Pi southbridge handling GPIO, USB, Ethernet, etc. |

---

## Specifications Comparison Table

| Feature | Raspberry Pi 4 Model B | Raspberry Pi 5 |
|---------|----------------------|----------------|
| **SoC** | BCM2711 | BCM2712 |
| **CPU** | Cortex-A72 @ 1.5/1.8 GHz | Cortex-A76 @ 2.4 GHz |
| **GPU** | VideoCore VI @ 500 MHz | VideoCore VII |
| **I/O Controller** | Integrated in SoC | RP1 (dedicated chip) |
| **RAM Options** | 1/2/4/8 GB LPDDR4 | 1/2/4/8/16 GB LPDDR4X |
| **WiFi** | 802.11ac dual-band | 802.11ac dual-band |
| **Bluetooth** | 5.0, BLE | 5.0, BLE |
| **Ethernet** | Gigabit | Gigabit |
| **USB 3.0** | 2 ports | 2 ports (simultaneous 5 Gbps) |
| **USB 2.0** | 2 ports | 2 ports |
| **PCIe** | Internal only (for USB 3.0) | 1 × PCIe 2.0 (exposed) |
| **HDMI** | 2 × micro-HDMI (4Kp30 dual) | 2 × micro-HDMI (4Kp60 dual) |
| **DSI** | 1 × 2-lane | 2 × 4-lane (interchangeable) |
| **CSI** | 1 × 2-lane | 2 × 4-lane (interchangeable) |
| **Audio/Video Jack** | 4-pole 3.5mm | None |
| **MicroSD** | Standard | SDR104 high-speed |
| **NVMe** | Not supported | Via PCIe 2.0 |
| **Power** | 5V/3A USB-C | 5V/5A USB-C (PD) |
| **PoE** | Via PoE+ HAT | Via new PoE+ HAT |
| **RTC** | None | Onboard + battery connector |
| **Power Button** | None | Onboard |
| **Fan Header** | None | 4-pin PWM |
| **UART Debug** | Via GPIO | Dedicated 3-pin connector |
| **Dimensions** | 85.6 × 56.5 mm | 85 × 56 mm |
| **Price Range** | $35–$75 | $45–$205 |

---

## 40-Pin GPIO Header — Complete Pinout

The 40-pin GPIO header is **physically identical** between the Raspberry Pi 4 Model B and Raspberry Pi 5. Both use the same BCM (Broadcom) GPIO numbering for the pins exposed on the header.

> **Note:** On RPi 5, the GPIO pins are managed by the RP1 I/O controller chip rather than the BCM2711 SoC directly. The BCM numbering and pin functions remain the same from a user perspective.

### Pin Layout (Board Orientation: GPIO header on right, HDMI on left)

```
                    3V3  (1)  (2)  5V
          GPIO 2 / SDA1  (3)  (4)  5V
          GPIO 3 / SCL1  (5)  (6)  GND
         GPIO 4 / GPCLK0 (7)  (8)  GPIO 14 / TXD0
                    GND  (9)  (10) GPIO 15 / RXD0
               GPIO 17  (11) (12) GPIO 18 / PCM_CLK / PWM0
               GPIO 27  (13) (14) GND
               GPIO 22  (15) (16) GPIO 23
                    3V3  (17) (18) GPIO 24
     GPIO 10 / SPI0_MOSI (19) (20) GND
     GPIO 9  / SPI0_MISO (21) (22) GPIO 25
     GPIO 11 / SPI0_SCLK (23) (24) GPIO 8  / SPI0_CE0
                    GND  (25) (26) GPIO 7  / SPI0_CE1
    GPIO 0  / EEPROM_SDA (27) (28) GPIO 1  / EEPROM_SCL
                GPIO 5   (29) (30) GND
                GPIO 6   (31) (32) GPIO 12 / PWM0
         GPIO 13 / PWM1  (33) (34) GND
      GPIO 19 / PCM_FS   (35) (36) GPIO 16
               GPIO 26   (37) (38) GPIO 20 / PCM_DIN
                    GND  (39) (40) GPIO 21 / PCM_DOUT
```

### Complete Pin Reference Table

| Physical Pin | Function | BCM GPIO | WiringPi | Alt Functions |
|:---:|:---|:---:|:---:|:---|
| 1 | **3.3V Power** | — | — | Power |
| 2 | **5V Power** | — | — | Power |
| 3 | **GPIO 2** | 2 | 8 | I2C1 SDA, SMI SA3 |
| 4 | **5V Power** | — | — | Power |
| 5 | **GPIO 3** | 3 | 9 | I2C1 SCL, SMI SA2 |
| 6 | **Ground** | — | — | GND |
| 7 | **GPIO 4** | 4 | 7 | GPCLK0, SMI SA1 |
| 8 | **GPIO 14** | 14 | 15 | UART0 TXD, SMI SD6 |
| 9 | **Ground** | — | — | GND |
| 10 | **GPIO 15** | 15 | 16 | UART0 RXD, SMI SD7 |
| 11 | **GPIO 17** | 17 | 0 | SPI1 CE1, SMI SD9 |
| 12 | **GPIO 18** | 18 | 1 | PCM CLK, SPI1 CE0, PWM0 |
| 13 | **GPIO 27** | 27 | 2 | SMI SD13 |
| 14 | **Ground** | — | — | GND |
| 15 | **GPIO 22** | 22 | 3 | SMI SD14 |
| 16 | **GPIO 23** | 23 | 4 | SMI SD15 |
| 17 | **3.3V Power** | — | — | Power |
| 18 | **GPIO 24** | 24 | 5 | SMI SD16 |
| 19 | **GPIO 10** | 10 | 12 | SPI0 MOSI, SMI SD2 |
| 20 | **Ground** | — | — | GND |
| 21 | **GPIO 9** | 9 | 13 | SPI0 MISO, SMI SD1 |
| 22 | **GPIO 25** | 25 | 6 | SMI SD17 |
| 23 | **GPIO 11** | 11 | 14 | SPI0 SCLK, SMI SD3 |
| 24 | **GPIO 8** | 8 | 10 | SPI0 CE0, SMI SD0 |
| 25 | **Ground** | — | — | GND |
| 26 | **GPIO 7** | 7 | 11 | SPI0 CE1, SMI SWE_N/SRW_N |
| 27 | **GPIO 0** | 0 | 30 | I2C0 SDA (EEPROM), SMI SA5 |
| 28 | **GPIO 1** | 1 | 31 | I2C0 SCL (EEPROM), SMI SA4 |
| 29 | **GPIO 5** | 5 | 21 | GPCLK1, SMI SA0 |
| 30 | **Ground** | — | — | GND |
| 31 | **GPIO 6** | 6 | 22 | GPCLK2, SMI SOE_N/SE |
| 32 | **GPIO 12** | 12 | 26 | PWM0 |
| 33 | **GPIO 13** | 13 | 23 | PWM1 |
| 34 | **Ground** | — | — | GND |
| 35 | **GPIO 19** | 19 | 24 | PCM FS, SPI1 MISO, PWM1 |
| 36 | **GPIO 16** | 16 | 27 | SPI1 CE2 |
| 37 | **GPIO 26** | 26 | 25 | — |
| 38 | **GPIO 20** | 20 | 28 | PCM DIN, SPI1 MOSI, GPCLK0 |
| 39 | **Ground** | — | — | GND |
| 40 | **GPIO 21** | 21 | 29 | PCM DOUT, SPI1 SCLK, GPCLK1 |

### Pin Summary

| Pin Type | Count | Physical Pins |
|----------|-------|---------------|
| **3.3V Power** | 2 | 1, 17 |
| **5V Power** | 2 | 2, 4 |
| **Ground** | 8 | 6, 9, 14, 20, 25, 30, 34, 39 |
| **GPIO** | 26 | 3, 5, 7, 8, 10, 11, 12, 13, 15, 16, 18, 19, 21, 22, 23, 24, 26, 27, 28, 29, 31, 32, 33, 35, 36, 37, 38, 40 |
| **ID EEPROM** | 2 | 27 (GPIO 0), 28 (GPIO 1) — reserved for HAT identification |
| **Total** | 40 | — |

---

## Pin Function Groups

### I2C (Inter-Integrated Circuit)

| Bus | SDA Pin | SCL Pin | BCM GPIO | Physical Pins | Notes |
|-----|---------|---------|----------|---------------|-------|
| **I2C1** | SDA1 | SCL1 | GPIO 2, GPIO 3 | 3, 5 | Primary I2C bus. Fixed 1.8 kΩ pull-up to 3.3V. Not suitable for general GPIO use. |
| **I2C0** | SDA0 | SCL0 | GPIO 0, GPIO 1 | 27, 28 | Reserved for HAT EEPROM identification. Can be used as alternate I2C bus. |

> **Note:** I2C is a multi-drop bus — multiple devices can share the same SDA/SCL lines, each with a unique address. Detect devices with: `sudo i2cdetect -y 1`

### SPI (Serial Peripheral Interface)

| Bus | Pin Function | BCM GPIO | Physical Pin | WiringPi |
|-----|-------------|----------|:---:|:---:|
| **SPI0** | MOSI | GPIO 10 | 19 | 12 |
| **SPI0** | MISO | GPIO 9 | 21 | 13 |
| **SPI0** | SCLK | GPIO 11 | 23 | 14 |
| **SPI0** | CE0 | GPIO 8 | 24 | 10 |
| **SPI0** | CE1 | GPIO 7 | 26 | 11 |
| **SPI1** | CE0 | GPIO 18 | 12 | 1 |
| **SPI1** | CE1 | GPIO 17 | 11 | 0 |
| **SPI1** | CE2 | GPIO 16 | 36 | 27 |
| **SPI1** | MISO | GPIO 19 | 35 | 24 |
| **SPI1** | MOSI | GPIO 20 | 38 | 28 |
| **SPI1** | SCLK | GPIO 21 | 40 | 29 |

> **Note:** SPI0 is enabled by default with CE0 (GPIO 8) and CE1 (GPIO 7). SPI1 can be enabled via device tree overlay: `dtoverlay=spi1-3cs` in `/boot/firmware/config.txt`.

### UART (Universal Asynchronous Receiver/Transmitter)

| Bus | Pin Function | BCM GPIO | Physical Pin | WiringPi |
|-----|-------------|----------|:---:|:---:|
| **UART0** | TXD | GPIO 14 | 8 | 15 |
| **UART0** | RXD | GPIO 15 | 10 | 16 |

> **Notes:**
> - RPi 2/3 have two UARTs (uart0 and uart1). RPi 4 has four additional UARTs available.
> - Only uart0/1 is enabled over GPIO 14/15 by default.
> - Additional UARTs can be enabled through device tree overlays.
> - RPi 5 has a dedicated 3-pin UART debug connector in addition to the GPIO UART.
> - Pi is 3.3V logic — do NOT connect directly to 5V devices (e.g., Arduino) without level shifting.

### PWM (Pulse-Width Modulation)

| Channel | BCM GPIO Options | Physical Pin Options | Notes |
|---------|-----------------|:---:|-------|
| **PWM0** | GPIO 12 or GPIO 18 | 32 or 12 | Channel 0 output can be routed to either pin |
| **PWM1** | GPIO 13 or GPIO 19 | 33 or 35 | Channel 1 output can be routed to either pin |

> **Note:** The PWM controller (`pwm@7e20c000`) has two independent channels. Software PWM is available on all GPIO pins. Hardware PWM is limited to the four pins above.

### PCM (Pulse Code Modulation) / I2S

| Pin Function | BCM GPIO | Physical Pin | WiringPi |
|-------------|----------|:---:|:---:|
| PCM CLK | GPIO 18 | 12 | 1 |
| PCM FS (Frame Sync) | GPIO 19 | 35 | 24 |
| PCM DIN (Data In) | GPIO 20 | 38 | 28 |
| PCM DOUT (Data Out) | GPIO 21 | 40 | 29 |

### GPCLK (General Purpose Clock)

| Pin Function | BCM GPIO | Physical Pin |
|-------------|----------|:---:|
| GPCLK0 | GPIO 4 | 7 |
| GPCLK1 | GPIO 5 | 29 |
| GPCLK2 | GPIO 6 | 31 |

### 1-Wire

| Pin Function | BCM GPIO | Physical Pin | Notes |
|-------------|----------|:---:|-------|
| 1-Wire Data | GPIO 4 | 7 | Default 1-Wire pin. Enable with `dtoverlay=w1-gpio` |

---

## Key Differences Between RPi 4 and RPi 5

### Performance
| Aspect | RPi 4 | RPi 5 | Improvement |
|--------|-------|-------|-------------|
| CPU | Cortex-A72 @ 1.5 GHz | Cortex-A76 @ 2.4 GHz | ~2-3× faster |
| GPU | VideoCore VI | VideoCore VII | Significant upgrade |
| RAM Max | 8 GB LPDDR4 | 16 GB LPDDR4X | 2× max capacity |
| Memory Bandwidth | — | Up to 17 GB/s | Higher bandwidth |

### I/O Architecture
- **RPi 4:** GPIO and I/O peripherals are integrated into the BCM2711 SoC
- **RPi 5:** GPIO and I/O peripherals are managed by the **RP1** southbridge chip (designed by Raspberry Pi), connected to the BCM2712 via PCIe. This is a fundamental architectural change.

### New Features on RPi 5
1. **PCIe 2.0 ×1 interface** — Exposed for NVMe SSDs and other PCIe peripherals
2. **Onboard RTC** — Real-Time Clock with battery connector for timekeeping without network
3. **Power button** — Onboard power/reset button
4. **4-pin fan header** — PWM-controlled fan connector for active cooling
5. **Dedicated UART connector** — 3-pin debug UART separate from GPIO header
6. **Dual 4-lane MIPI** — 2 × 4-lane MIPI connectors (vs 2-lane on RPi 4), interchangeable between DSI display and CSI camera
7. **USB PD support** — USB Power Delivery for more reliable power
8. **SDR104 MicroSD** — High-speed SD card mode

### Removed Features on RPi 5
1. **3.5mm A/V jack** — No composite video or analog audio output
2. **2-lane MIPI connectors** — Replaced with 4-lane (different connector, requires adapter for old cameras/displays)

### GPIO Compatibility
- The **40-pin header pinout is identical** between RPi 4 and RPi 5
- Same BCM GPIO numbering (GPIO 0–27)
- Same physical pin layout
- Same I2C, SPI, UART, PWM pin assignments
- **However:** On RPi 5, the RP1 chip manages GPIO instead of the BCM SoC directly. This means:
  - Some low-level register access code may need updating
  - The `libgpiod` library is recommended over direct register manipulation
  - Timing characteristics may differ slightly
  - All standard GPIO libraries (RPi.GPIO, gpiozero, pigpio) have been updated for RPi 5 compatibility

---

## Additional Notes

### Voltage Levels
- All GPIO pins operate at **3.3V logic levels**
- GPIO pins are **NOT 5V tolerant** — applying 5V will damage the board
- Maximum current per GPIO pin: ~16 mA (recommended), 50 mA absolute max across all pins

### HAT EEPROM Pins
- Physical pins 27 and 28 (GPIO 0 and GPIO 1) are reserved for the HAT identification EEPROM
- These pins have fixed 1.8 kΩ pull-ups to 3.3V
- They should not be used for general-purpose I/O when a HAT is connected

### Device Tree Overlays
Many alternate pin functions require enabling via device tree overlays in `/boot/firmware/config.txt`:
- `dtoverlay=spi1-3cs` — Enable SPI1 with 3 chip selects
- `dtoverlay=w1-gpio` — Enable 1-Wire on GPIO 4
- `dtoverlay=uart2` through `dtoverlay=uart5` — Enable additional UARTs (RPi 4/5)
- `dtoverlay=pwm` — Enable hardware PWM
- `dtoverlay=i2c-gpio` — Enable software I2C on arbitrary pins
