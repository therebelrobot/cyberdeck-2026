---
name: xiao-rp2350-tinygo
description: >
  Provides comprehensive pinout reference, board specifications, and TinyGo development guide
  for the Seeed Studio XIAO RP2350 microcontroller. Use when writing TinyGo firmware for the
  XIAO RP2350, wiring peripherals, or configuring pins. Keywords: XIAO, RP2350, TinyGo,
  Raspberry Pi, dual-core, Cortex-M33, FPU, TrustZone, PIO, pinout, GPIO, I2C, SPI, UART,
  analog, digital, PWM, RGB LED, back pads, 19 GPIO, battery.
---

# XIAO RP2350 — TinyGo Development Guide

Provides comprehensive reference for developing TinyGo firmware for the Seeed Studio XIAO RP2350.

## When to Use

- Writing TinyGo firmware targeting the XIAO RP2350
- Looking up XIAO RP2350 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO RP2350 and need GPIO reference
- Configuring I2C, SPI, UART, or analog I/O on the XIAO RP2350 in TinyGo

## When NOT to Use

- For Arduino/C++ development on the XIAO RP2350 → use the `XIAO-RP2350-Arduino` skill
- For the XIAO RP2040 (previous generation) → use the `XIAO-RP2040-TinyGo` skill
- For other XIAO boards → use the corresponding board skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Raspberry Pi RP2350 |
| **Architecture** | Dual ARM Cortex-M33 with FPU |
| **Clock Speed** | Up to 150 MHz |
| **Flash** | 2 MB |
| **RAM** | 520 KB SRAM |
| **Wireless** | None |
| **USB** | USB Type-C |
| **Operating Voltage** | 3.3V logic |
| **Dimensions** | 21 × 17.8 mm |
| **Working Temp** | -20°C to 70°C |
| **GPIO Count** | 19 total (11 edge + 8 back pads), all PWM capable |
| **ADC Channels** | 3 (D0–D2) |
| **Deep Sleep** | ~50 μA |
| **Onboard** | User LED (Yellow, GPIO25), RGB LED (GPIO22), Power LED, Reset & Boot buttons |
| **Security** | OTP, Secure Boot, Arm TrustZone |

---

## Pinout Diagram

```
                      [USB-C]
                ┌───────────────┐
      D0/A0   ──┤ 1          14 ├── 5V
      D1/A1   ──┤ 2          13 ├── GND
      D2/A2   ──┤ 3          12 ├── 3V3
    D3/SPI_CS ──┤ 4          11 ├── D10/MOSI
    D4/SDA1   ──┤ 5          10 ├── D9/MISO
    D5/SCL1   ──┤ 6           9 ├── D8/SCK
     D6/TX0   ──┤ 7           8 ├── D7/RX0
                └───────────────┘
         Bottom pads: BAT+, BAT-
    Back pads (8 additional IOs):
      D11/RX1  D12/TX1  D13/SCL0  D14/SDA0
      D15/MOSI1  D16/MISO1  D17/SCK1  D18/CS1
```

---

## Pin Reference Table

### Edge Pins (11 GPIOs)

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|--------|-----|-----|-----|------|-------|
| D0  | GPIO26   | ✓       | ADC    | ✓   | —   | —   | —    | — |
| D1  | GPIO27   | ✓       | ADC    | ✓   | —   | —   | —    | — |
| D2  | GPIO28   | ✓       | ADC    | ✓   | —   | —   | —    | — |
| D3  | GPIO5    | ✓       | —      | ✓   | —   | **CS0** | — | SPI0_CSn |
| D4  | GPIO6    | ✓       | —      | ✓   | **SDA1** | — | — | — |
| D5  | GPIO7    | ✓       | —      | ✓   | **SCL1** | — | — | — |
| D6  | GPIO0    | ✓       | —      | ✓   | —   | —   | **TX0** | — |
| D7  | GPIO1    | ✓       | —      | ✓   | —   | —   | **RX0** | — |
| D8  | GPIO2    | ✓       | —      | ✓   | —   | **SCK0** | — | SPI0_SCK |
| D9  | GPIO4    | ✓       | —      | ✓   | —   | **MISO0** | — | SPI0_MISO |
| D10 | GPIO3    | ✓       | —      | ✓   | —   | **MOSI0** | — | SPI0_MOSI |

### Back Pads (8 additional GPIOs)

| Pin | Chip Pin | Digital | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|-----|-----|-----|------|-------|
| D11 | GPIO21   | ✓       | ✓   | —   | —   | **RX1** | — |
| D12 | GPIO20   | ✓       | ✓   | —   | —   | **TX1** | — |
| D13 | GPIO17   | ✓       | ✓   | **SCL0** | — | — | — |
| D14 | GPIO16   | ✓       | ✓   | **SDA0** | — | — | — |
| D15 | GPIO11   | ✓       | ✓   | —   | **MOSI1** | — | SPI1_MOSI |
| D16 | GPIO12   | ✓       | ✓   | —   | **MISO1** | — | SPI1_MISO |
| D17 | GPIO10   | ✓       | ✓   | —   | **SCK1** | — | SPI1_SCK |
| D18 | GPIO9    | ✓       | ✓   | —   | **CS1** | — | SPI1_CSn |

### Internal / Special Pins

| Name | Chip Pin | Description |
|------|----------|-------------|
| USER_LED | GPIO25 | Yellow user LED |
| RGB LED | GPIO22 | Addressable RGB LED |
| ADC_BAT | GPIO29 | Battery voltage reading (internal) |
| Reset | RUN | Reset |
| Boot | RP2040_BOOT | Enter bootloader (UF2 mode) |
| CHARGE_LED | NCHG | Red charge indicator |

---

## TinyGo Setup

### Target Name

```
xiao-rp2350
```

### Installation

1. Install TinyGo (≥ 0.34.0 recommended for RP2350 support): https://tinygo.org/getting-started/install/
2. Verify the target is available:
   ```bash
   tinygo info -target=xiao-rp2350
   ```

### Build and Flash

```bash
# Build only (produces UF2 file)
tinygo build -target=xiao-rp2350 -o firmware.uf2 ./main.go

# Build and flash (board must be in bootloader mode)
tinygo flash -target=xiao-rp2350 ./main.go

# Enter bootloader mode: hold BOOT button, press RESET, release BOOT
# Board appears as USB drive named "RP2350"
```

### TinyGo Support Status

- **Status:** Supported (RP2350 support added in TinyGo 0.34+)
- **USB CDC:** Supported (serial over USB)
- **ADC:** Supported on D0–D2 (12-bit)
- **PWM:** Supported on all 19 GPIO pins
- **I2C:** Supported (`machine.I2C0`, `machine.I2C1`)
- **SPI:** Supported (`machine.SPI0`, `machine.SPI1`)
- **UART:** Supported (`machine.UART0`, `machine.UART1`)
- **PIO:** Supported via `machine` package
- **RGB LED:** Supported via WS2812 driver
- **Dual-core:** TinyGo currently uses only one core
- **TrustZone:** Not accessible from TinyGo

### Example: Blink (TinyGo)

```go
package main

import (
    "machine"
    "time"
)

func main() {
    led := machine.LED // GPIO25 — Yellow user LED
    led.Configure(machine.PinConfig{Mode: machine.PinOutput})

    for {
        led.High()
        time.Sleep(500 * time.Millisecond)
        led.Low()
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
    neo := machine.GPIO22 // RGB LED data pin
    neo.Configure(machine.PinConfig{Mode: machine.PinOutput})

    ws := ws2812.New(neo)
    leds := []color.RGBA{
        {R: 255, G: 0, B: 0, A: 255},
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

### I2C (Two Buses)

**I2C1 (edge pins — primary):**
- **SDA:** D4 (GPIO6)
- **SCL:** D5 (GPIO7)
- **TinyGo bus:** `machine.I2C1`

**I2C0 (back pads):**
- **SDA:** D14 (GPIO16)
- **SCL:** D13 (GPIO17)
- **TinyGo bus:** `machine.I2C0`

```go
// Primary I2C on edge pins
i2c := machine.I2C1
err := i2c.Configure(machine.I2CConfig{
    SDA:       machine.SDA_PIN, // D4 / GPIO6
    SCL:       machine.SCL_PIN, // D5 / GPIO7
    Frequency: 400000,          // 400 kHz
})
if err != nil {
    println("I2C init failed:", err)
}

// Secondary I2C on back pads
i2c0 := machine.I2C0
err = i2c0.Configure(machine.I2CConfig{
    SDA:       machine.GPIO16, // D14
    SCL:       machine.GPIO17, // D13
    Frequency: 400000,
})
```

### SPI (Two Buses)

**SPI0 (edge pins — primary):**
- **SCK:** D8 (GPIO2)
- **MISO:** D9 (GPIO4)
- **MOSI:** D10 (GPIO3)
- **CS:** D3 (GPIO5) or any GPIO
- **TinyGo bus:** `machine.SPI0`

**SPI1 (back pads):**
- **SCK:** D17 (GPIO10)
- **MISO:** D16 (GPIO12)
- **MOSI:** D15 (GPIO11)
- **CS:** D18 (GPIO9)
- **TinyGo bus:** `machine.SPI1`

```go
// Primary SPI on edge pins
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

### UART (Two Buses)

**UART0 (edge pins — primary):**
- **TX:** D6 (GPIO0)
- **RX:** D7 (GPIO1)
- **TinyGo bus:** `machine.UART0`

**UART1 (back pads):**
- **TX:** D12 (GPIO20)
- **RX:** D11 (GPIO21)
- **TinyGo bus:** `machine.UART1`

```go
// Primary UART on edge pins
uart := machine.UART0
uart.Configure(machine.UARTConfig{
    TX:       machine.UART_TX_PIN, // D6 / GPIO0
    RX:       machine.UART_RX_PIN, // D7 / GPIO1
    BaudRate: 115200,
})
uart.Write([]byte("Hello from XIAO RP2350\r\n"))

// Secondary UART on back pads
uart1 := machine.UART1
uart1.Configure(machine.UARTConfig{
    TX:       machine.GPIO20, // D12
    RX:       machine.GPIO21, // D11
    BaudRate: 9600,
})
```

### Analog Read (ADC)

```go
adc := machine.ADC{Pin: machine.ADC0} // D0 / GPIO26
adc.Configure(machine.ADCConfig{
    Resolution: 12, // 12-bit (0–4095)
})
value := adc.Get() // Returns 16-bit scaled value
```

> **Note:** Only D0–D2 (GPIO26–28) support analog input. All other pins are digital only.

### Battery Voltage Reading

```go
batAdc := machine.ADC{Pin: machine.GPIO29} // Internal ADC_BAT
batAdc.Configure(machine.ADCConfig{})
rawValue := batAdc.Get()
// Convert to voltage: V = rawValue * 3.3 / 65535 * 2 (voltage divider)
```

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **5V output:** From USB VBUS
- **3.3V output:** Regulated from onboard LDO
- **Deep sleep:** ~50 μA

### Battery Support

- **Battery pads:** Solder LiPo battery to BAT+ and BAT- pads on the bottom
- **Charge LED:** Red LED indicates charging status
- **Battery voltage:** Readable via internal ADC_BAT (GPIO29)
- **Input:** 3.7V LiPo battery

### Deep Sleep

```go
import "machine"

// Basic sleep — reduces power consumption
machine.Sleep()
```

> **Note:** TinyGo dormant mode support on RP2350 is evolving. For full dormant mode, you may need direct register access. Check the latest TinyGo release notes.

---

## Special Features

### Expanded GPIO (19 Total)

The XIAO RP2350 has 8 additional GPIO pads on the back (D11–D18), providing:
- 2nd UART (TX1/RX1)
- 2nd I2C (SDA0/SCL0)
- 2nd SPI (full bus with CS)

This gives 19 total GPIOs — significantly more than other XIAO boards with 11.

### Dual Cortex-M33 with FPU

The RP2350 has dual ARM Cortex-M33 cores with hardware floating-point unit. TinyGo currently uses only one core. The FPU accelerates floating-point math operations.

### Arm TrustZone

The RP2350 supports Arm TrustZone for hardware-based security isolation. Not accessible from TinyGo.

### PIO (Programmable I/O)

The RP2350 includes PIO state machines for custom I/O protocols. TinyGo supports PIO via the `machine` package:

```go
// PIO is used internally by drivers like WS2812
// Direct PIO programming is possible but advanced
```

### RGB LED (WS2812)

Addressable RGB LED on GPIO22. See the RGB LED example above.

### OTP (One-Time Programmable) Memory

The RP2350 includes OTP memory for secure boot keys and configuration. Not accessible from TinyGo.

---

## Common Gotchas / Notes

1. **Only 3 analog pins** — D0–D2 (GPIO26–28) have ADC; all other pins are digital only
2. **19 GPIOs total** — 11 on edge + 8 on back pads (D11–D18); back pads require soldering
3. **Two of each bus** — 2× I2C, 2× SPI, 2× UART available (edge + back pads)
4. **No wireless** — No WiFi or Bluetooth; use ESP32 variants for wireless
5. **Boot mode** — Hold BOOT, press RESET, release BOOT; board appears as "RP2350" USB drive
6. **User LED on GPIO25** — Yellow LED, active HIGH
7. **RGB LED on GPIO22** — WS2812 addressable LED
8. **Battery voltage** — Readable via internal GPIO29 ADC
9. **Dual-core unused** — TinyGo uses only one of the two Cortex-M33 cores
10. **3.3V logic only** — Do NOT connect 5V signals directly to GPIO pins
11. **Boot pin label** — Wiki labels it "RP2040_BOOT" (documentation artifact from predecessor)

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/xiao_rp2350_arduino/
- **TinyGo target docs:** https://tinygo.org/docs/reference/microcontrollers/
- **RP2350 datasheet:** https://datasheets.raspberrypi.com/rp2350/rp2350-datasheet.pdf
- **Schematic:** https://files.seeedstudio.com/wiki/XIAO-RP2350/res/XIAO_RP2350_v1.0_SCH.pdf
