---
name: xiao-esp32s3-tinygo
description: >
  Provides comprehensive pinout reference, board specifications, and TinyGo development guide
  for the Seeed Studio XIAO ESP32-S3 microcontroller. Use when writing TinyGo firmware for the
  XIAO ESP32-S3, wiring peripherals, or configuring pins. Keywords: XIAO, ESP32-S3, TinyGo,
  Espressif, Xtensa, dual-core, WiFi, BLE, Bluetooth, PSRAM, USB OTG, pinout, GPIO, I2C, SPI,
  UART, analog, digital, PWM, touch, deep sleep, battery.
---

# XIAO ESP32-S3 — TinyGo Development Guide

Provides comprehensive reference for developing TinyGo firmware for the Seeed Studio XIAO ESP32-S3.

## When to Use

- Writing TinyGo firmware targeting the XIAO ESP32-S3
- Looking up XIAO ESP32-S3 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO ESP32-S3 and need GPIO reference
- Configuring I2C, SPI, UART, or analog I/O on the XIAO ESP32-S3 in TinyGo

## When NOT to Use

- For Arduino/C++ development on the XIAO ESP32-S3 → use the `XIAO-ESP32S3-Arduino` skill
- For the XIAO ESP32-S3 Sense variant (with camera/mic) → use the `XIAO-ESP32S3-Sense-TinyGo` skill
- For other XIAO boards (SAMD21, RP2040, nRF52840, ESP32-C3) → use the corresponding board skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Espressif ESP32-S3R8 |
| **Architecture** | Xtensa LX7 dual-core, 32-bit |
| **Clock Speed** | Up to 240 MHz |
| **Flash** | 8 MB |
| **PSRAM** | 8 MB |
| **RAM** | On-chip SRAM (part of ESP32-S3R8) |
| **Wireless** | 2.4 GHz WiFi 802.11 b/g/n, Bluetooth 5.0 (BLE), Bluetooth Mesh |
| **USB** | USB Type-C (native USB OTG) |
| **Operating Voltage** | 3.3V logic; 5V input (Type-C), 3.7V (BAT) |
| **Dimensions** | 21 × 17.8 mm |
| **Working Temp** | -20°C to 65°C |
| **GPIO Count** | 11 digital/PWM, 9 analog/ADC |
| **Deep Sleep** | ~14 μA |
| **Touch Pins** | 9 (D0–D5, D8–D10) |
| **Antenna** | Onboard ceramic + U.FL connector |
| **Battery** | Supports LiPo charge/discharge (3.7V BAT pads) |

---

## Pinout Diagram

```
                      [USB-C]
                ┌───────────────┐
      D0/A0   ──┤ 1          14 ├── 5V
      D1/A1   ──┤ 2          13 ├── GND
      D2/A2   ──┤ 3          12 ├── 3V3
      D3/A3   ──┤ 4          11 ├── D10/A6/MOSI
    D4/SDA/A4 ──┤ 5          10 ├── D9/A5/MISO
    D5/SCL/A5 ──┤ 6           9 ├── D8/A4/SCK
      D6/TX   ──┤ 7           8 ├── D7/RX
                └───────────────┘
         Bottom pads: BAT+, BAT-, GND
         JTAG pads: MTDO(GPIO40), MTDI(GPIO41),
                    MTCK(GPIO39), MTMS(GPIO42)
         U.FL antenna connector on top edge
```

---

## Pin Reference Table

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|--------|-----|-----|-----|------|-------|
| D0  | GPIO1    | ✓       | ADC    | ✓   | —   | —   | —    | TOUCH1 |
| D1  | GPIO2    | ✓       | ADC    | ✓   | —   | —   | —    | TOUCH2 |
| D2  | GPIO3    | ✓       | ADC    | ✓   | —   | —   | —    | TOUCH3 |
| D3  | GPIO4    | ✓       | ADC    | ✓   | —   | —   | —    | TOUCH4 |
| D4  | GPIO5    | ✓       | ADC    | ✓   | **SDA** | — | —  | TOUCH5 |
| D5  | GPIO6    | ✓       | ADC    | ✓   | **SCL** | — | —  | TOUCH6 |
| D6  | GPIO43   | ✓       | —      | ✓   | —   | —   | **TX** | — |
| D7  | GPIO44   | ✓       | —      | ✓   | —   | —   | **RX** | — |
| D8  | GPIO7    | ✓       | ADC    | ✓   | —   | **SCK** | — | TOUCH7 |
| D9  | GPIO8    | ✓       | ADC    | ✓   | —   | **MISO** | — | TOUCH8 |
| D10 | GPIO9    | ✓       | ADC    | ✓   | —   | **MOSI** | — | TOUCH9 |

### Bottom JTAG Pads

| Pin | Chip Pin | Description |
|-----|----------|-------------|
| MTDO | GPIO40 | JTAG |
| MTDI | GPIO41 | JTAG, ADC |
| MTCK | GPIO39 | JTAG, ADC |
| MTMS | GPIO42 | JTAG, ADC |

### Internal / Special Pins

| Name | Chip Pin | Description |
|------|----------|-------------|
| Reset | CHIP_PU | Reset |
| Boot | GPIO0 | Enter bootloader |
| USER_LED | GPIO21 | User LED |
| CHG LED | — | Charge indicator |
| U.FL Antenna | LNA_IN | External antenna connector |

---

## TinyGo Setup

### Target Name

```
xiao-esp32s3
```

### Installation

1. Install TinyGo (≥ 0.32.0 recommended): https://tinygo.org/getting-started/install/
2. Verify the target is available:
   ```bash
   tinygo info -target=xiao-esp32s3
   ```

### Build and Flash

```bash
# Build only
tinygo build -target=xiao-esp32s3 -o firmware.bin ./main.go

# Build and flash via USB serial
tinygo flash -target=xiao-esp32s3 ./main.go

# Enter bootloader mode: hold BOOT button, press RESET, release BOOT
# Then flash via esptool (used internally by TinyGo)
```

### TinyGo Support Status

- **Status:** Experimental / evolving — ESP32-S3 support is newer in TinyGo
- **USB CDC:** Supported (serial over USB)
- **ADC:** Supported on D0–D5, D8–D10 (9 channels)
- **PWM:** Supported on all digital pins
- **I2C:** Supported (`machine.I2C0`)
- **SPI:** Supported (`machine.SPI0`)
- **UART:** Supported (`machine.UART0`)
- **WiFi:** Not yet supported in TinyGo (ESP32-S3 WiFi requires ESP-IDF)
- **BLE:** Not yet supported in TinyGo
- **PSRAM:** Not directly accessible from TinyGo
- **Touch:** Not yet supported in TinyGo

> **⚠ Important:** TinyGo ESP32-S3 support is evolving. WiFi, BLE, touch, and PSRAM are not available. For wireless features, use the Arduino skill instead.

### Example: Blink (TinyGo)

```go
package main

import (
    "machine"
    "time"
)

func main() {
    led := machine.LED // GPIO21 — User LED
    led.Configure(machine.PinConfig{Mode: machine.PinOutput})

    for {
        led.High()
        time.Sleep(500 * time.Millisecond)
        led.Low()
        time.Sleep(500 * time.Millisecond)
    }
}
```

---

## Communication Protocols

### I2C

- **SDA:** D4 (GPIO5)
- **SCL:** D5 (GPIO6)
- **TinyGo bus:** `machine.I2C0`

```go
i2c := machine.I2C0
err := i2c.Configure(machine.I2CConfig{
    SDA:       machine.SDA_PIN, // D4 / GPIO5
    SCL:       machine.SCL_PIN, // D5 / GPIO6
    Frequency: 400000,          // 400 kHz
})
if err != nil {
    println("I2C init failed:", err)
}
```

### SPI

- **SCK:** D8 (GPIO7)
- **MISO:** D9 (GPIO8)
- **MOSI:** D10 (GPIO9)
- **CS:** Any GPIO (user-defined)
- **TinyGo bus:** `machine.SPI0`

```go
spi := machine.SPI0
err := spi.Configure(machine.SPIConfig{
    SCK:       machine.SPI0_SCK_PIN,  // D8 / GPIO7
    SDO:       machine.SPI0_SDO_PIN,  // D10 / GPIO9 (MOSI)
    SDI:       machine.SPI0_SDI_PIN,  // D9 / GPIO8 (MISO)
    Frequency: 4000000,               // 4 MHz
})
if err != nil {
    println("SPI init failed:", err)
}
```

### UART

- **TX:** D6 (GPIO43)
- **RX:** D7 (GPIO44)
- **TinyGo bus:** `machine.UART0`

```go
uart := machine.UART0
uart.Configure(machine.UARTConfig{
    TX:       machine.UART_TX_PIN, // D6 / GPIO43
    RX:       machine.UART_RX_PIN, // D7 / GPIO44
    BaudRate: 115200,
})
uart.Write([]byte("Hello from XIAO ESP32-S3\r\n"))
```

### Analog Read (ADC)

```go
adc := machine.ADC{Pin: machine.ADC0} // D0 / GPIO1
adc.Configure(machine.ADCConfig{
    Resolution: 12, // 12-bit (0–4095)
})
value := adc.Get() // Returns 16-bit scaled value
```

> **Note:** 9 ADC channels available on D0–D5 and D8–D10. D6 and D7 (UART) do not have ADC.

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **5V output:** From USB VBUS
- **3.3V output:** Up to 700 mA
- **Deep sleep:** ~14 μA

### Battery Support

- **Battery pads:** Solder LiPo battery to BAT+ and BAT- pads on the bottom
- **Charge LED:** Indicates charging status
- **Input:** 3.7V LiPo battery

### Deep Sleep

TinyGo deep sleep support on ESP32-S3 is limited. Basic sleep:

```go
import "machine"

// Basic sleep — reduces power consumption
machine.Sleep()
```

> **Note:** Full deep sleep with GPIO wake-up requires ESP-IDF APIs not yet exposed in TinyGo. For advanced power management, consider the Arduino variant.

---

## Special Features

### USB OTG

The ESP32-S3 has native USB OTG support. TinyGo uses this for USB CDC serial. Full USB OTG host/device functionality is not yet available in TinyGo.

### PSRAM (8 MB)

The ESP32-S3R8 includes 8 MB of PSRAM for extended memory. This is not directly accessible from TinyGo. For PSRAM usage, use the Arduino/ESP-IDF framework.

### Dual-Core

The ESP32-S3 has dual Xtensa LX7 cores. TinyGo currently uses only one core.

### Touch Sensing

9 capacitive touch pins (D0–D5, D8–D10) are available in hardware but not yet supported in TinyGo.

---

## Common Gotchas / Notes

1. **WiFi/BLE not available in TinyGo** — ESP32-S3 wireless requires ESP-IDF; use Arduino for WiFi/BLE projects
2. **PSRAM not accessible** — The 8 MB PSRAM cannot be used from TinyGo
3. **Touch pins not supported** — Hardware touch sensing is present but not exposed in TinyGo
4. **Dual-core unused** — TinyGo uses only one of the two Xtensa LX7 cores
5. **Boot mode** — Hold BOOT, press RESET, release BOOT to enter bootloader for flashing
6. **User LED on GPIO21** — Active HIGH (unlike some other XIAO boards)
7. **9 ADC channels** — D0–D5 and D8–D10 all support analog input
8. **3.3V logic only** — Do NOT connect 5V signals directly to GPIO pins
9. **JTAG pads on bottom** — GPIO39–42 are accessible via bottom solder pads
10. **D6/D7 no ADC** — UART TX/RX pins (GPIO43/44) do not support analog input

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/xiao_esp32s3_getting_started/
- **TinyGo target docs:** https://tinygo.org/docs/reference/microcontrollers/
- **ESP32-S3 datasheet:** https://www.espressif.com/sites/default/files/documentation/esp32-s3_datasheet_en.pdf
- **ESP32-S3 technical reference:** https://www.espressif.com/sites/default/files/documentation/esp32-s3_technical_reference_manual_en.pdf
- **Schematic:** https://files.seeedstudio.com/wiki/SeeedStudio-XIAO-ESP32S3/res/XIAO_ESP32S3_SCH_v1.2.pdf
