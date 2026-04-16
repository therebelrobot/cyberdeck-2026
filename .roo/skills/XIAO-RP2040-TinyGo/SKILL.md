---
name: xiao-rp2040-tinygo
description: >
  Provides comprehensive pinout reference, board specifications, and TinyGo development guide
  for the Seeed Studio XIAO RP2040 microcontroller. Use when writing TinyGo firmware for the
  XIAO RP2040, wiring peripherals, or configuring pins. Keywords: XIAO, RP2040, TinyGo,
  Raspberry Pi, dual-core, Cortex-M0+, pinout, GPIO, I2C, SPI, UART, WS2812, RGB LED, PWM.
---

# XIAO RP2040 — TinyGo Development Guide

Provides comprehensive reference for developing TinyGo firmware for the Seeed Studio XIAO RP2040.

## When to Use

- Writing TinyGo firmware targeting the XIAO RP2040
- Looking up XIAO RP2040 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO RP2040 and need GPIO reference
- Configuring I2C, SPI, UART, or analog I/O on the XIAO RP2040 in TinyGo

## When NOT to Use

- For Arduino/C++ development on the XIAO RP2040 → use the `XIAO-RP2040-Arduino` skill
- For other XIAO boards (SAMD21, nRF52840, ESP32-C3) → use the corresponding board skill
- For the Raspberry Pi Pico (different board, same MCU)

---

## Board Overview

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
| **Onboard** | RGB LED (WS2812), 3-color user LED, Power LED, Reset & Boot buttons |

---

## Pinout Diagram

```
                      [USB-C]
                ┌───────────────┐
      D0/A0   ──┤ 1          14 ├── 5V
      D1/A1   ──┤ 2          13 ├── GND
      D2/A2   ──┤ 3          12 ├── 3V3
      D3/A3   ──┤ 4          11 ├── D10/MOSI
    D4/SDA    ──┤ 5          10 ├── D9/MISO
    D5/SCL    ──┤ 6           9 ├── D8/SCK
     D6/TX    ──┤ 7           8 ├── D7/RX/CSn
                └───────────────┘
```

---

## Pin Reference Table

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|--------|-----|-----|-----|------|-------|
| D0  | GPIO26   | ✓       | A0     | ✓   | —   | —   | —    | — |
| D1  | GPIO27   | ✓       | A1     | ✓   | —   | —   | —    | — |
| D2  | GPIO28   | ✓       | A2     | ✓   | —   | —   | —    | — |
| D3  | GPIO29   | ✓       | A3     | ✓   | —   | —   | —    | — |
| D4  | GPIO6    | ✓       | —      | ✓   | **SDA** | — | —  | — |
| D5  | GPIO7    | ✓       | —      | ✓   | **SCL** | — | —  | — |
| D6  | GPIO0    | ✓       | —      | ✓   | —   | —   | **TX** | — |
| D7  | GPIO1    | ✓       | —      | ✓   | —   | **CSn** | **RX** | — |
| D8  | GPIO2    | ✓       | —      | ✓   | —   | **SCK** | — | — |
| D9  | GPIO4    | ✓       | —      | ✓   | —   | **MISO** | — | — |
| D10 | GPIO3    | ✓       | —      | ✓   | —   | **MOSI** | — | — |

### Internal / LED Pins

| Name | Chip Pin | Description |
|------|----------|-------------|
| RGB LED (WS2812) | GPIO12 | Addressable RGB LED (NeoPixel protocol) |
| USER_LED_R | GPIO17 | Red user LED — active LOW |
| USER_LED_G | GPIO16 | Green user LED — active LOW |
| USER_LED_B | GPIO25 | Blue user LED — active LOW |

---

## TinyGo Setup

### Target Name

```
xiao-rp2040
```

### Installation

1. Install TinyGo: https://tinygo.org/getting-started/install/
2. Verify the target is available:
   ```bash
   tinygo info -target=xiao-rp2040
   ```

### Build and Flash

```bash
# Build only (produces UF2 file)
tinygo build -target=xiao-rp2040 -o firmware.uf2 ./main.go

# Build and flash (board must be in bootloader mode)
tinygo flash -target=xiao-rp2040 ./main.go

# Enter bootloader mode: hold BOOT button, press RESET, release BOOT
# Board appears as USB drive named "RPI-RP2"
```

### TinyGo Support Status

- **Status:** Fully supported
- **USB CDC:** Supported (serial over USB)
- **ADC:** Supported on D0–D3 (12-bit)
- **PWM:** Supported on all 11 digital pins
- **I2C:** Supported (machine.I2C0, machine.I2C1)
- **SPI:** Supported (machine.SPI0)
- **UART:** Supported (machine.UART0)
- **WS2812:** Supported via `machine` package or `tinygo.org/x/drivers/ws2812`
- **PIO:** Supported via `machine` package

### Example: Blink (TinyGo)

```go
package main

import (
    "machine"
    "time"
)

func main() {
    // Use the blue user LED (GPIO25)
    led := machine.LED // Maps to GPIO25 (blue LED)
    led.Configure(machine.PinConfig{Mode: machine.PinOutput})

    for {
        led.Low()  // LED on (active LOW)
        time.Sleep(500 * time.Millisecond)
        led.High() // LED off
        time.Sleep(500 * time.Millisecond)
    }
}
```

### Example: RGB LED (WS2812)

```go
package main

import (
    "image/color"
    "machine"
    "time"

    "tinygo.org/x/drivers/ws2812"
)

func main() {
    neo := machine.GPIO12 // WS2812 data pin
    neo.Configure(machine.PinConfig{Mode: machine.PinOutput})

    ws := ws2812.New(neo)
    leds := []color.RGBA{
        {R: 255, G: 0, B: 0, A: 255}, // Red
    }

    for {
        leds[0] = color.RGBA{R: 255, G: 0, B: 0, A: 255}
        ws.WriteColors(leds)
        time.Sleep(500 * time.Millisecond)

        leds[0] = color.RGBA{R: 0, G: 255, B: 0, A: 255}
        ws.WriteColors(leds)
        time.Sleep(500 * time.Millisecond)

        leds[0] = color.RGBA{R: 0, G: 0, B: 255, A: 255}
        ws.WriteColors(leds)
        time.Sleep(500 * time.Millisecond)
    }
}
```

---

## Communication Protocols

### I2C

- **SDA:** D4 (GPIO6)
- **SCL:** D5 (GPIO7)
- **TinyGo bus:** `machine.I2C0`

```go
i2c := machine.I2C0
err := i2c.Configure(machine.I2CConfig{
    SDA:       machine.SDA_PIN, // D4 / GPIO6
    SCL:       machine.SCL_PIN, // D5 / GPIO7
    Frequency: 400000,          // 400 kHz
})
if err != nil {
    println("I2C init failed:", err)
}
```

### SPI

- **SCK:** D8 (GPIO2)
- **MISO:** D9 (GPIO4)
- **MOSI:** D10 (GPIO3)
- **CS:** D7 (GPIO1) or any GPIO
- **TinyGo bus:** `machine.SPI0`

```go
spi := machine.SPI0
err := spi.Configure(machine.SPIConfig{
    SCK:       machine.SPI0_SCK_PIN,  // D8 / GPIO2
    SDO:       machine.SPI0_SDO_PIN,  // D10 / GPIO3 (MOSI)
    SDI:       machine.SPI0_SDI_PIN,  // D9 / GPIO4 (MISO)
    Frequency: 4000000,               // 4 MHz
})
if err != nil {
    println("SPI init failed:", err)
}
```

### UART

- **TX:** D6 (GPIO0)
- **RX:** D7 (GPIO1)
- **TinyGo bus:** `machine.UART0`

```go
uart := machine.UART0
uart.Configure(machine.UARTConfig{
    TX:       machine.UART_TX_PIN, // D6 / GPIO0
    RX:       machine.UART_RX_PIN, // D7 / GPIO1
    BaudRate: 115200,
})
uart.Write([]byte("Hello from XIAO RP2040\r\n"))
```

### Analog Read (ADC)

```go
adc := machine.ADC{Pin: machine.A0} // D0 / GPIO26
adc.Configure(machine.ADCConfig{
    Resolution: 12, // 12-bit (0–4095)
})
value := adc.Get() // Returns 16-bit scaled value
```

> **Note:** Only D0–D3 (GPIO26–29) support analog input. D4–D10 are digital only.

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **5V output:** From USB VBUS
- **3.3V output:** Regulated from onboard LDO

### Deep Sleep

The RP2040 supports dormant and sleep modes. In TinyGo:

```go
import "machine"

// Basic sleep — reduces power consumption
// Full dormant mode may require direct register access
machine.Sleep()
```

> **Note:** TinyGo dormant mode support on RP2040 is evolving. Check the latest TinyGo release notes. For full dormant mode, you may need to use the `rp` package for direct register access.

### Battery

- No built-in battery charging circuit on the XIAO RP2040
- Power via USB-C (5V) or 5V/3V3 pads

---

## Common Gotchas / Notes

1. **Only 4 analog pins** — D0–D3 (GPIO26–29) have ADC; D4–D10 are digital only
2. **LEDs are active LOW** — Pull the pin LOW to turn the LED ON
3. **WS2812 RGB LED on GPIO12** — Not directly on a user-accessible pad; use the `ws2812` driver
4. **Boot mode** — Hold BOOT button, press RESET, release BOOT; board appears as "RPI-RP2" USB drive
5. **D7 dual function** — D7 (GPIO1) serves as both UART RX and SPI CSn; avoid using both simultaneously
6. **No DAC** — Unlike the SAMD21, the RP2040 has no DAC output; use PWM for pseudo-analog
7. **No wireless** — This board has no WiFi or Bluetooth; use ESP32-C3 or nRF52840 variants for wireless
8. **Dual-core** — The RP2040 has two cores, but TinyGo currently uses only one core by default

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/XIAO-RP2040/
- **TinyGo target docs:** https://tinygo.org/docs/reference/microcontrollers/xiao-rp2040/
- **RP2040 datasheet:** https://datasheets.raspberrypi.com/rp2040/rp2040-datasheet.pdf
- **Schematic:** https://files.seeedstudio.com/wiki/XIAO-RP2040/res/Seeed-Studio-XIAO-RP2040-v1.3.pdf
