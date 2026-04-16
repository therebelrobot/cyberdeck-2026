---
name: xiao-esp32s3-sense-tinygo
description: >
  Provides comprehensive pinout reference, board specifications, and TinyGo development guide
  for the Seeed Studio XIAO ESP32-S3 Sense microcontroller. Use when writing TinyGo firmware for the
  XIAO ESP32-S3 Sense, wiring peripherals, or configuring pins. Keywords: XIAO, ESP32-S3, Sense,
  TinyGo, Espressif, Xtensa, dual-core, WiFi, BLE, Bluetooth, PSRAM, camera, OV3660, microphone,
  PDM, SD card, pinout, GPIO, I2C, SPI, UART, analog, digital, PWM, touch, deep sleep, battery.
---

# XIAO ESP32-S3 Sense — TinyGo Development Guide

Provides comprehensive reference for developing TinyGo firmware for the Seeed Studio XIAO ESP32-S3 Sense.

## When to Use

- Writing TinyGo firmware targeting the XIAO ESP32-S3 Sense
- Looking up XIAO ESP32-S3 Sense pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO ESP32-S3 Sense and need GPIO reference
- Understanding pin conflicts between camera/SD card/microphone and external pins

## When NOT to Use

- For Arduino/C++ development on the XIAO ESP32-S3 Sense → use the `XIAO-ESP32S3-Sense-Arduino` skill
- For the base XIAO ESP32-S3 (without camera/mic) → use the `XIAO-ESP32S3-TinyGo` skill
- For other XIAO boards → use the corresponding board skill

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
| **Camera** | OV3660 (also compatible with OV5640) |
| **Microphone** | Digital PDM microphone |
| **Storage** | Onboard SD card slot (supports 32 GB FAT) |
| **USB** | USB Type-C (native USB OTG) |
| **Operating Voltage** | 3.3V logic; 5V input (Type-C), 3.7V (BAT) |
| **Dimensions** | 21 × 17.8 × 15 mm (with expansion board) |
| **Working Temp** | -20°C to 65°C |
| **GPIO Count** | 11 digital/PWM, 9 analog/ADC (+2 via B2B connector) |
| **Deep Sleep** | ~3 mA (with expansion board) |
| **Touch Pins** | 9 (D0–D5, D8–D10) |
| **Battery** | Supports LiPo charge/discharge (3.7V BAT pads) |

---

## Pinout Diagram

```
                      [USB-C]
                ┌───────────────┐
      D0/A0   ──┤ 1          14 ├── 5V
      D1/A1   ──┤ 2          13 ├── GND
   ⚠ D2/A2   ──┤ 3          12 ├── 3V3
      D3/A3   ──┤ 4          11 ├── D10/A6/MOSI
    D4/SDA/A4 ──┤ 5          10 ├──⚠D9/A5/MISO
    D5/SCL/A5 ──┤ 6           9 ├──⚠D8/A4/SCK
      D6/TX   ──┤ 7           8 ├── D7/RX
                └───────────────┘
         Bottom pads: BAT+, BAT-, GND
         JTAG pads: MTDO(GPIO40), MTDI(GPIO41),
                    MTCK(GPIO39), MTMS(GPIO42)
         ⚠ = shared with SD card / microphone
         Camera via B2B connector (internal)
```

---

## Pin Reference Table

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|--------|-----|-----|-----|------|-------|
| D0  | GPIO1    | ✓       | ADC    | ✓   | —   | —   | —    | TOUCH1 |
| D1  | GPIO2    | ✓       | ADC    | ✓   | —   | —   | —    | TOUCH2 |
| D2  | GPIO3    | ✓       | ADC    | ✓   | —   | —   | —    | TOUCH3, **⚠ SD_CS** |
| D3  | GPIO4    | ✓       | ADC    | ✓   | —   | —   | —    | TOUCH4 |
| D4  | GPIO5    | ✓       | ADC    | ✓   | **SDA** | — | —  | TOUCH5 |
| D5  | GPIO6    | ✓       | ADC    | ✓   | **SCL** | — | —  | TOUCH6 |
| D6  | GPIO43   | ✓       | —      | ✓   | —   | —   | **TX** | — |
| D7  | GPIO44   | ✓       | —      | ✓   | —   | —   | **RX** | — |
| D8  | GPIO7    | ✓       | ADC    | ✓   | —   | **SCK** | — | TOUCH7, **⚠ SD_SCK** |
| D9  | GPIO8    | ✓       | ADC    | ✓   | —   | **MISO** | — | TOUCH8, **⚠ SD_MISO** |
| D10 | GPIO9    | ✓       | ADC    | ✓   | —   | **MOSI** | — | TOUCH9 |

### ⚠ Pin Conflicts (Sense Expansion Board)

| Peripheral | Pins Used | Conflicts With |
|------------|-----------|----------------|
| **SD Card** | GPIO3 (CS), GPIO7 (SCK), GPIO8 (MISO), GPIO10 (MOSI) | D2, D8, D9 external pins |
| **Microphone** | GPIO42 (CLK), GPIO41 (DATA) | D11, D12 bottom JTAG pads |
| **Camera** | GPIO10–18, GPIO38–40, GPIO47–48 | Internal B2B connector only |

> **⚠ Critical:** When using the SD card, external pins D2 (GPIO3), D8 (GPIO7), and D9 (GPIO8) are unavailable. When using the microphone, bottom pads D11 (GPIO42) and D12 (GPIO41) are unavailable.

### Digital Microphone Pins

| Pin | Chip Pin | Description |
|-----|----------|-------------|
| MIC_CLK | GPIO42 | PDM clock pin |
| MIC_DATA | GPIO41 | PDM data pin |

### Camera Pins (internal, via B2B connector)

| Chip Pin | Description |
|----------|-------------|
| GPIO10 | Camera clock |
| GPIO11 | Camera Y8 |
| GPIO12 | Camera Y7 |
| GPIO13 | Camera pixel clock |
| GPIO14 | Camera Y6 |
| GPIO15 | Camera Y2 |
| GPIO16 | Camera Y5 |
| GPIO17 | Camera Y3 |
| GPIO18 | Camera Y4 |
| GPIO40 | Camera I2C data (SIOD) |
| GPIO39 | Camera I2C clock (SIOC) |
| GPIO38 | Camera VSYNC |
| GPIO47 | Camera HSYNC |
| GPIO48 | Camera Y9 |

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

> **Note:** TinyGo uses the same target for both the base ESP32-S3 and the Sense variant. The camera, microphone, and SD card are expansion board peripherals.

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
```

### TinyGo Support Status

- **Status:** Experimental / evolving — ESP32-S3 support is newer in TinyGo
- **USB CDC:** Supported (serial over USB)
- **ADC:** Supported on D0–D5, D8–D10 (9 channels)
- **PWM:** Supported on all digital pins
- **I2C:** Supported (`machine.I2C0`)
- **SPI:** Supported (`machine.SPI0`)
- **UART:** Supported (`machine.UART0`)
- **Camera:** ❌ Not supported in TinyGo (requires ESP-IDF camera driver)
- **Microphone (PDM):** ❌ Not supported in TinyGo (requires I2S/PDM driver)
- **SD Card:** Partial — SPI-based SD card drivers may work via `tinygo.org/x/drivers`
- **WiFi:** ❌ Not yet supported in TinyGo
- **BLE:** ❌ Not yet supported in TinyGo
- **PSRAM:** ❌ Not directly accessible from TinyGo
- **Touch:** ❌ Not yet supported in TinyGo

> **⚠ Important:** The Sense-specific features (camera, microphone) are NOT available in TinyGo. For camera/mic projects, use the Arduino skill instead. TinyGo on this board is best suited for GPIO, I2C, SPI, UART, and ADC projects.

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

> **⚠ Warning:** When the SD card is in use, D8 (SCK) and D9 (MISO) are shared. Do not use external SPI devices on these pins simultaneously with the SD card.

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
uart.Write([]byte("Hello from XIAO ESP32-S3 Sense\r\n"))
```

### Analog Read (ADC)

```go
adc := machine.ADC{Pin: machine.ADC0} // D0 / GPIO1
adc.Configure(machine.ADCConfig{
    Resolution: 12, // 12-bit (0–4095)
})
value := adc.Get() // Returns 16-bit scaled value
```

> **Note:** 9 ADC channels on D0–D5 and D8–D10. D6/D7 (UART) do not have ADC.

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **5V output:** From USB VBUS
- **3.3V output:** Up to 700 mA
- **Deep sleep:** ~3 mA (higher than base ESP32-S3 due to expansion board)

### Battery Support

- **Battery pads:** Solder LiPo battery to BAT+ and BAT- pads on the bottom
- **Charge LED:** Indicates charging status
- **Input:** 3.7V LiPo battery

### Deep Sleep

TinyGo deep sleep support on ESP32-S3 is limited:

```go
import "machine"

machine.Sleep()
```

> **Note:** Deep sleep current is ~3 mA with the Sense expansion board attached (vs ~14 μA for the base ESP32-S3). The camera and microphone circuits draw standby power. For lowest power, consider the base ESP32-S3 variant.

---

## Special Features (Sense-Specific)

### Camera (OV3660)

The Sense variant includes an OV3660 camera sensor (OV5640 also compatible). **Camera is NOT supported in TinyGo** — it requires the ESP-IDF camera driver. Use the Arduino variant for camera projects.

Camera pins are internal via the B2B connector and do not conflict with the standard edge pins (D0–D10).

### Digital Microphone (PDM)

The Sense variant includes a PDM digital microphone. **Microphone is NOT supported in TinyGo** — it requires I2S/PDM driver support. Use the Arduino variant for audio projects.

- **MIC_CLK:** GPIO42 (shared with D11/MTMS bottom pad)
- **MIC_DATA:** GPIO41 (shared with D12/MTDI bottom pad)

### SD Card Slot

The Sense variant includes an SD card slot using SPI:
- **SD_CS:** GPIO3 (shared with D2)
- **SD_SCK:** GPIO7 (shared with D8)
- **SD_MISO:** GPIO8 (shared with D9)
- **SD_MOSI:** GPIO10 (shared with camera clock)

TinyGo may support SD card access via SPI-based drivers from `tinygo.org/x/drivers`, but this is not officially tested on this board.

### USB OTG

The ESP32-S3 has native USB OTG. TinyGo uses this for USB CDC serial. Full USB OTG host/device functionality is not yet available in TinyGo.

### PSRAM (8 MB)

Not directly accessible from TinyGo.

---

## Common Gotchas / Notes

1. **Camera/Mic NOT supported in TinyGo** — Use Arduino for camera and microphone projects
2. **SD card shares pins with D2, D8, D9** — Cannot use these external pins when SD card is active
3. **Microphone shares pins with JTAG pads** — GPIO41/42 (D11/D12) unavailable when mic is active
4. **Higher deep sleep current** — ~3 mA with expansion board vs ~14 μA for base ESP32-S3
5. **WiFi/BLE not available in TinyGo** — ESP32-S3 wireless requires ESP-IDF
6. **Same TinyGo target** — Uses `xiao-esp32s3` target (same as base variant)
7. **Boot mode** — Hold BOOT, press RESET, release BOOT to enter bootloader
8. **User LED on GPIO21** — Active HIGH
9. **3.3V logic only** — Do NOT connect 5V signals directly to GPIO pins
10. **OV2640 discontinued** — The camera is now OV3660; OV5640 is also compatible

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/xiao_esp32s3_getting_started/
- **TinyGo target docs:** https://tinygo.org/docs/reference/microcontrollers/
- **ESP32-S3 datasheet:** https://www.espressif.com/sites/default/files/documentation/esp32-s3_datasheet_en.pdf
- **ESP32-S3 technical reference:** https://www.espressif.com/sites/default/files/documentation/esp32-s3_technical_reference_manual_en.pdf
- **Schematic:** https://files.seeedstudio.com/wiki/SeeedStudio-XIAO-ESP32S3/res/XIAO_ESP32S3_SCH_v1.2.pdf
