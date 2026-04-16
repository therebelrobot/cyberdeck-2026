---
name: xiao-samd21-tinygo
description: >
  Provides comprehensive pinout reference, board specifications, and TinyGo development guide
  for the Seeed Studio XIAO SAMD21 microcontroller. Use when writing TinyGo firmware for the
  XIAO SAMD21, wiring peripherals, or configuring pins. Keywords: XIAO, SAMD21, TinyGo,
  ATSAMD21G18, Cortex-M0+, pinout, GPIO, I2C, SPI, UART, DAC, analog, digital, PWM.
---

# XIAO SAMD21 — TinyGo Development Guide

Provides comprehensive reference for developing TinyGo firmware for the Seeed Studio XIAO SAMD21.

## When to Use

- Writing TinyGo firmware targeting the XIAO SAMD21
- Looking up XIAO SAMD21 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO SAMD21 and need GPIO reference
- Configuring I2C, SPI, UART, or analog I/O on the XIAO SAMD21 in TinyGo

## When NOT to Use

- For Arduino/C++ development on the XIAO SAMD21 → use the `XIAO-SAMD21-Arduino` skill
- For other XIAO boards (RP2040, nRF52840, ESP32-C3) → use the corresponding board skill
- For non-XIAO SAMD21 boards (e.g., Arduino MKR, Adafruit Feather M0)

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Microchip ATSAMD21G18A-MU |
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

---

## Pinout Diagram

```
                      [USB-C]
                ┌───────────────┐
   D0/A0/DAC  ──┤ 1          14 ├── 5V
      D1/A1   ──┤ 2          13 ├── GND
      D2/A2   ──┤ 3          12 ├── 3V3
      D3/A3   ──┤ 4          11 ├── D10/A10/MOSI
   D4/A4/SDA  ──┤ 5          10 ├── D9/A9/MISO
   D5/A5/SCL  ──┤ 6           9 ├── D8/A8/SCK
    D6/A6/TX  ──┤ 7           8 ├── D7/A7/RX
                └───────────────┘
```

---

## Pin Reference Table

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|--------|-----|-----|-----|------|-------|
| D0  | PA02     | ✓       | A0     | —   | —   | —   | —    | **DAC** |
| D1  | PA04     | ✓       | A1     | ✓   | —   | —   | —    | — |
| D2  | PA10     | ✓       | A2     | ✓   | —   | —   | —    | — |
| D3  | PA11     | ✓       | A3     | ✓   | —   | —   | —    | — |
| D4  | PA08     | ✓       | A4     | ✓   | **SDA** | — | —  | — |
| D5  | PA09     | ✓       | A5     | ✓   | **SCL** | — | —  | — |
| D6  | PB08     | ✓       | A6     | ✓   | —   | —   | **TX** | — |
| D7  | PB09     | ✓       | A7     | ✓   | —   | —   | **RX** | — |
| D8  | PA07     | ✓       | A8     | ✓   | —   | **SCK** | — | — |
| D9  | PA05     | ✓       | A9     | ✓   | —   | **MISO** | — | — |
| D10 | PA06     | ✓       | A10    | ✓   | —   | **MOSI** | — | — |

### Internal / LED Pins

| Name | Chip Pin | Description |
|------|----------|-------------|
| USER_LED | PA17 | User LED (Yellow) — active LOW |
| TX_LED   | PA19 | TX indicator LED |
| RX_LED   | PA18 | RX indicator LED |

---

## TinyGo Setup

### Target Name

```
xiao
```

### Installation

1. Install TinyGo: https://tinygo.org/getting-started/install/
2. Verify the target is available:
   ```bash
   tinygo info -target=xiao
   ```

### Build and Flash

```bash
# Build only
tinygo build -target=xiao -o firmware.uf2 ./main.go

# Build and flash (board must be in bootloader mode)
tinygo flash -target=xiao ./main.go

# Enter bootloader mode: double-tap the reset pad quickly
```

### TinyGo Support Status

- **Status:** Fully supported
- **USB CDC:** Supported (serial over USB)
- **ADC:** Supported (12-bit)
- **DAC:** Supported on D0/A0
- **PWM:** Supported on D1–D10
- **I2C:** Supported (machine.I2C0)
- **SPI:** Supported (machine.SPI0)
- **UART:** Supported (machine.UART0)

### Example: Blink (TinyGo)

```go
package main

import (
    "machine"
    "time"
)

func main() {
    led := machine.LED // PA17 — onboard yellow LED
    led.Configure(machine.PinConfig{Mode: machine.PinOutput})

    for {
        led.Low()  // LED on (active LOW)
        time.Sleep(500 * time.Millisecond)
        led.High() // LED off
        time.Sleep(500 * time.Millisecond)
    }
}
```

---

## Communication Protocols

### I2C

- **SDA:** D4 (PA08)
- **SCL:** D5 (PA09)
- **TinyGo bus:** `machine.I2C0`

```go
i2c := machine.I2C0
err := i2c.Configure(machine.I2CConfig{
    SDA:       machine.SDA_PIN, // D4
    SCL:       machine.SCL_PIN, // D5
    Frequency: 400000,          // 400 kHz
})
if err != nil {
    println("I2C init failed:", err)
}
```

### SPI

- **SCK:** D8 (PA07)
- **MISO:** D9 (PA05)
- **MOSI:** D10 (PA06)
- **TinyGo bus:** `machine.SPI0`

```go
spi := machine.SPI0
err := spi.Configure(machine.SPIConfig{
    SCK:       machine.SPI0_SCK_PIN,  // D8
    SDO:       machine.SPI0_SDO_PIN,  // D10 (MOSI)
    SDI:       machine.SPI0_SDI_PIN,  // D9 (MISO)
    Frequency: 4000000,               // 4 MHz
})
if err != nil {
    println("SPI init failed:", err)
}
```

### UART

- **TX:** D6 (PB08)
- **RX:** D7 (PB09)
- **TinyGo bus:** `machine.UART0`

```go
uart := machine.UART0
uart.Configure(machine.UARTConfig{
    TX:       machine.UART_TX_PIN, // D6
    RX:       machine.UART_RX_PIN, // D7
    BaudRate: 115200,
})
uart.Write([]byte("Hello from XIAO SAMD21\r\n"))
```

### Analog Read (ADC)

```go
adc := machine.ADC{Pin: machine.A0} // D0/PA02
adc.Configure(machine.ADCConfig{
    Resolution: 12, // 12-bit (0–4095)
})
value := adc.Get() // Returns 16-bit scaled value
```

### DAC Output

```go
dac := machine.DAC{Pin: machine.A0} // Only D0/PA02 has DAC
dac.Configure(machine.DACConfig{})
dac.Set(32768) // Set to ~1.65V (mid-range of 3.3V)
```

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **Max current per pin:** ~7 mA (recommended), absolute max varies by pin
- **5V output:** Up to 500 mA (from USB)
- **3.3V output:** Up to 200 mA

### Deep Sleep

The SAMD21 supports standby sleep mode. In TinyGo:

```go
import "machine"

// Enter low-power standby mode
// Wake via external interrupt or RTC
machine.Sleep() // If supported by TinyGo target
```

> **Note:** TinyGo deep sleep support on SAMD21 is limited. Check the latest TinyGo release notes for current status. You may need to use direct register access for full standby mode.

### Battery

- No built-in battery charging circuit on the XIAO SAMD21
- Power via USB-C (5V) or 5V/3V3 pads

---

## Common Gotchas / Notes

1. **DAC only on D0/A0** — No other pin supports analog output
2. **PWM not on D0** — D0 (PA02) does not support PWM; D1–D10 do
3. **Interrupt conflict** — D5 and D7 cannot be used simultaneously for interrupts
4. **LED is active LOW** — `led.Low()` turns the LED ON, `led.High()` turns it OFF
5. **Bootloader mode** — Double-tap the reset pad quickly; the board appears as a USB drive
6. **ADC resolution** — TinyGo returns 16-bit scaled values from `Get()`, even though the hardware ADC is 12-bit
7. **No wireless** — This board has no WiFi or Bluetooth; use ESP32-C3 or nRF52840 variants for wireless

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/Seeeduino-XIAO/
- **TinyGo target docs:** https://tinygo.org/docs/reference/microcontrollers/xiao/
- **SAMD21 datasheet:** https://www.microchip.com/en-us/product/ATSAMD21G18A
- **Schematic:** https://files.seeedstudio.com/wiki/Seeeduino-XIAO/res/Seeeduino-XIAO-v1.0-SCH-191112.pdf
