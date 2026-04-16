---
name: xiao-ra4m1-tinygo
description: >
  Provides comprehensive pinout reference, board specifications, and TinyGo development guide
  for the Seeed Studio XIAO RA4M1 microcontroller. Use when writing TinyGo firmware for the
  XIAO RA4M1, wiring peripherals, or configuring pins. Keywords: XIAO, RA4M1, TinyGo, Renesas,
  Cortex-M4, FPU, CAN bus, DAC, 14-bit ADC, EEPROM, Arduino Uno R4, pinout, GPIO, I2C, SPI,
  UART, analog, digital, PWM, RGB LED, back pads, 19 GPIO, battery.
---

# XIAO RA4M1 — TinyGo Development Guide

Provides comprehensive reference for developing TinyGo firmware for the Seeed Studio XIAO RA4M1.

## When to Use

- Writing TinyGo firmware targeting the XIAO RA4M1
- Looking up XIAO RA4M1 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO RA4M1 and need GPIO reference
- Configuring I2C, SPI, UART, CAN bus, DAC, or analog I/O on the XIAO RA4M1 in TinyGo

## When NOT to Use

- For Arduino/C++ development on the XIAO RA4M1 → use the `XIAO-RA4M1-Arduino` skill
- For other XIAO boards → use the corresponding board skill
- For the Arduino Uno R4 (same MCU, different board) → check Arduino Uno R4 resources

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Renesas RA4M1 (R7FA4M1AB3CNE) |
| **Architecture** | 32-bit ARM Cortex-M4 with FPU |
| **Clock Speed** | Up to 48 MHz |
| **Flash** | 256 KB |
| **RAM** | 32 KB SRAM |
| **EEPROM** | 8 KB built-in |
| **Wireless** | None |
| **USB** | USB 2.0 (Type-C connector) |
| **Operating Voltage** | 3.3V logic |
| **Dimensions** | 21 × 17.8 mm |
| **Working Temp** | -20°C to 70°C |
| **GPIO Count** | 19 total (11 edge + 8 back pads) |
| **ADC Channels** | 6 (14-bit resolution) |
| **DAC** | 1 (12-bit) |
| **CAN Bus** | 1 (CRX0/CTX0 on D9/D10) |
| **Deep Sleep** | ~42.6 μA @ 3.7V |
| **Onboard** | User LED (Yellow, P011), RGB LED (P112, enable via P500) |
| **Security** | AES128/256 hardware encryption |

---

## Pinout Diagram

```
                      [USB-C]
                ┌───────────────┐
      D0/A0   ──┤ 1          14 ├── 5V
      D1/A1   ──┤ 2          13 ├── GND
      D2/A2   ──┤ 3          12 ├── 3V3
      D3/A3   ──┤ 4          11 ├── D10/MOSI/CTX0
    D4/SDA1   ──┤ 5          10 ├── D9/MISO/CRX0
    D5/SCL1/A4──┤ 6           9 ├── D8/SCK
    D6/TX/SDA2──┤ 7           8 ├── D7/RX/SCL2
                └───────────────┘
         Bottom pads: BAT+, BAT-
    Back pads (8 additional IOs):
      D11/RX9  D12/TX9  D13  D14
      D15/TX0/SDA0  D16/RX0/SCL0  D17/CRX0  D18/CTX0
```

---

## Pin Reference Table

### Edge Pins (11 GPIOs)

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other | Arduino # |
|-----|----------|---------|--------|-----|-----|-----|------|-------|-----------|
| D0  | P014     | ✓       | AN009 (14-bit) | ✓ | — | — | — | — | 0 |
| D1  | P000     | ✓       | AN000 (14-bit) | ✓ | — | — | — | — | 1 |
| D2  | P001     | ✓       | AN001 (14-bit) | ✓ | — | — | — | — | 2 |
| D3  | P002     | ✓       | AN002 (14-bit) | ✓ | — | — | — | — | 3 |
| D4  | P206     | ✓       | —      | ✓   | **SDA1** | — | — | — | 4 |
| D5  | P100     | ✓       | ADC    | ✓   | **SCL1** | — | — | — | 5 |
| D6  | P302     | ✓       | —      | ✓   | **SDA2** | — | **TX2** | — | 6 |
| D7  | P301     | ✓       | —      | ✓   | **SCL2** | — | **RX2** | — | 7 |
| D8  | P111     | ✓       | —      | ✓   | —   | **SCK1** | — | — | 8 |
| D9  | P110     | ✓       | —      | ✓   | —   | **MISO1** | — | **CRX0** (CAN RX) | 9 |
| D10 | P109     | ✓       | —      | ✓   | —   | **MOSI1** | — | **CTX0** (CAN TX) | 10 |

### Back Pads (8 additional GPIOs)

| Pin | Chip Pin | Digital | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|-----|-----|-----|------|-------|
| D11 | P408     | ✓       | ✓   | —   | —   | **RX9** | — |
| D12 | P409     | ✓       | ✓   | —   | —   | **TX9** | — |
| D13 | P013     | ✓       | ✓   | —   | —   | — | — |
| D14 | P012     | ✓       | ✓   | —   | —   | — | — |
| D15 | P101     | ✓       | ✓   | **SDA0** | **MOSI0** | **TX0** | AN021 (ADC) |
| D16 | P104     | ✓       | ✓   | **SCL0** | **MISO0** | **RX0** | — |
| D17 | P102     | ✓       | ✓   | —   | **SCK0** | — | AN020 (ADC), CRX0 |
| D18 | P103     | ✓       | ✓   | —   | — | — | AN019 (ADC), CTX0 |

### Internal / Special Pins

| Name | Chip Pin | Description | Arduino # |
|------|----------|-------------|-----------|
| USER_LED | P011 | Yellow user LED | 19 |
| RGB LED | P112 | RGB LED data | 20 |
| RGB LED EN | P500 | RGB LED enable (set HIGH) | 21 |
| ADC_BAT | P400 | Battery voltage reading | — |
| Reset | RES | Reset | — |
| Boot | P201 | Enter bootloader | — |
| CHARGE_LED | VBUS | Red charge indicator | — |

---

## TinyGo Setup

### Target Name

```
xiao-ra4m1
```

### Installation

1. Install TinyGo (≥ 0.33.0 recommended for RA4M1 support): https://tinygo.org/getting-started/install/
2. Verify the target is available:
   ```bash
   tinygo info -target=xiao-ra4m1
   ```

### Build and Flash

```bash
# Build only
tinygo build -target=xiao-ra4m1 -o firmware.bin ./main.go

# Build and flash via USB
tinygo flash -target=xiao-ra4m1 ./main.go

# Enter bootloader mode: double-tap RESET button quickly
# Board appears as USB drive
```

### TinyGo Support Status

- **Status:** Experimental / evolving — Renesas RA4M1 support is newer in TinyGo
- **USB CDC:** Supported (serial over USB)
- **ADC:** Supported on D0–D3, D5 (14-bit resolution)
- **PWM:** Supported on digital pins
- **I2C:** Supported (`machine.I2C0`, `machine.I2C1`)
- **SPI:** Supported (`machine.SPI0`, `machine.SPI1`)
- **UART:** Supported (`machine.UART0`)
- **CAN Bus:** ❌ Not yet supported in TinyGo
- **DAC:** ❌ Not yet supported in TinyGo
- **EEPROM:** ❌ Not directly accessible from TinyGo
- **AES encryption:** ❌ Not accessible from TinyGo

> **⚠ Important:** TinyGo RA4M1 support is evolving. CAN bus, DAC, EEPROM, and hardware encryption are not available. For these features, use the Arduino skill instead.

### Example: Blink (TinyGo)

```go
package main

import (
    "machine"
    "time"
)

func main() {
    led := machine.LED // P011 — Yellow user LED
    led.Configure(machine.PinConfig{Mode: machine.PinOutput})

    for {
        led.High()
        time.Sleep(500 * time.Millisecond)
        led.Low()
        time.Sleep(500 * time.Millisecond)
    }
}
```

### Example: RGB LED

```go
package main

import (
    "image/color"
    "machine"
    "time"

    "tinygo.org/x/drivers/ws2812"
)

func main() {
    // Enable RGB LED power
    rgbEn := machine.GPIO(21) // P500 — RGB LED enable
    rgbEn.Configure(machine.PinConfig{Mode: machine.PinOutput})
    rgbEn.High()

    neo := machine.GPIO(20) // P112 — RGB LED data
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

### I2C (Multiple Buses)

**I2C1 (edge pins — primary):**
- **SDA:** D4 (P206)
- **SCL:** D5 (P100)
- **TinyGo bus:** `machine.I2C1`

**I2C2 (edge pins — alternate on D6/D7):**
- **SDA:** D6 (P302)
- **SCL:** D7 (P301)

**I2C0 (back pads):**
- **SDA:** D15 (P101)
- **SCL:** D16 (P104)
- **TinyGo bus:** `machine.I2C0`

```go
// Primary I2C on edge pins
i2c := machine.I2C1
err := i2c.Configure(machine.I2CConfig{
    SDA:       machine.SDA_PIN, // D4 / P206
    SCL:       machine.SCL_PIN, // D5 / P100
    Frequency: 400000,          // 400 kHz
})
if err != nil {
    println("I2C init failed:", err)
}
```

### SPI

**SPI1 (edge pins — primary):**
- **SCK:** D8 (P111)
- **MISO:** D9 (P110)
- **MOSI:** D10 (P109)
- **CS:** Any GPIO (user-defined)
- **TinyGo bus:** `machine.SPI1`

```go
spi := machine.SPI1
err := spi.Configure(machine.SPIConfig{
    SCK:       machine.SPI1_SCK_PIN,  // D8 / P111
    SDO:       machine.SPI1_SDO_PIN,  // D10 / P109 (MOSI)
    SDI:       machine.SPI1_SDI_PIN,  // D9 / P110 (MISO)
    Frequency: 4000000,               // 4 MHz
})
if err != nil {
    println("SPI init failed:", err)
}
```

> **⚠ Warning:** D9 (MISO) and D10 (MOSI) are shared with CAN bus (CRX0/CTX0). Do not use SPI1 and CAN bus simultaneously.

### UART

**UART2 (edge pins — primary):**
- **TX:** D6 (P302)
- **RX:** D7 (P301)
- **TinyGo bus:** `machine.UART0` (mapped to hardware UART2)

```go
uart := machine.UART0
uart.Configure(machine.UARTConfig{
    TX:       machine.UART_TX_PIN, // D6 / P302
    RX:       machine.UART_RX_PIN, // D7 / P301
    BaudRate: 115200,
})
uart.Write([]byte("Hello from XIAO RA4M1\r\n"))
```

### Analog Read (ADC — 14-bit)

```go
adc := machine.ADC{Pin: machine.ADC0} // D0 / P014
adc.Configure(machine.ADCConfig{
    Resolution: 14, // 14-bit (0–16383)
})
value := adc.Get() // Returns 16-bit scaled value
```

> **Note:** 6 ADC channels on edge pins: D0–D3 (14-bit) and D5. Additional ADC channels on back pads D15, D17, D18. The RA4M1 has 14-bit ADC resolution — higher than most XIAO boards.

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **5V output:** From USB VBUS
- **3.3V output:** Regulated from onboard LDO
- **Deep sleep:** ~42.6 μA @ 3.7V

### Battery Support

- **Battery pads:** Solder LiPo battery to BAT+ and BAT- pads on the bottom
- **Charge LED:** Red LED indicates charging status
- **Battery voltage:** Readable via internal ADC_BAT (P400)
- **Input:** 3.7V LiPo battery

### Deep Sleep

TinyGo deep sleep support on RA4M1 is limited:

```go
import "machine"

machine.Sleep()
```

> **Note:** Full low-power mode support requires Renesas RA4M1 HAL APIs not yet exposed in TinyGo. For advanced power management, use the Arduino variant.

---

## Special Features

### Same MCU as Arduino Uno R4

The XIAO RA4M1 uses the same Renesas R7FA4M1AB3CNE MCU as the Arduino Uno R4. This means:
- Native Arduino IDE compatibility
- Shared libraries and community resources
- Same peripheral capabilities in a much smaller form factor

### CAN Bus

The RA4M1 has a built-in CAN bus controller:
- **CRX0 (CAN RX):** D9 (P110) — shared with SPI1 MISO
- **CTX0 (CAN TX):** D10 (P109) — shared with SPI1 MOSI

**CAN bus is NOT supported in TinyGo.** Use the Arduino variant for CAN bus projects.

> **⚠ Pin conflict:** CAN bus shares D9/D10 with SPI1. Cannot use both simultaneously.

### 12-bit DAC

The RA4M1 has a 12-bit DAC output. **DAC is NOT supported in TinyGo.** Use the Arduino variant for analog output.

### 14-bit ADC

The RA4M1 has 14-bit ADC resolution (0–16383), providing higher precision than the typical 12-bit ADC on other XIAO boards.

### 8 KB EEPROM

Built-in 8 KB EEPROM for non-volatile data storage. **EEPROM is NOT directly accessible from TinyGo.** Use the Arduino variant for EEPROM access.

### Hardware Encryption (AES128/256)

The RA4M1 includes hardware AES encryption. Not accessible from TinyGo.

### Expanded GPIO (19 Total)

8 additional GPIO pads on the back (D11–D18), providing extra UART, I2C, and SPI buses.

---

## Common Gotchas / Notes

1. **CAN bus not available in TinyGo** — Use Arduino for CAN bus projects
2. **DAC not available in TinyGo** — Use Arduino for analog output
3. **EEPROM not accessible** — Use Arduino for non-volatile storage
4. **CAN/SPI pin conflict** — D9/D10 are shared between SPI1 and CAN bus; cannot use both
5. **D6/D7 dual function** — These pins serve as UART TX/RX AND I2C SDA2/SCL2; avoid using both simultaneously
6. **14-bit ADC** — Higher resolution than other XIAO boards; 6 channels on edge pins
7. **RGB LED requires enable** — Set P500 (Arduino pin 21) HIGH before using RGB LED on P112
8. **Boot mode** — Double-tap RESET button quickly to enter bootloader
9. **3.3V logic only** — Do NOT connect 5V signals directly to GPIO pins
10. **Same MCU as Uno R4** — Many Arduino Uno R4 resources apply to this board
11. **19 GPIOs total** — 11 on edge + 8 on back pads; back pads require soldering
12. **Lower clock speed** — 48 MHz is slower than ESP32 variants; adequate for most embedded tasks

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/getting_started_xiao_ra4m1/
- **TinyGo target docs:** https://tinygo.org/docs/reference/microcontrollers/
- **RA4M1 datasheet:** https://www.renesas.com/us/en/document/dst/ra4m1-group-datasheet
- **RA4M1 user manual:** https://www.renesas.com/us/en/document/man/ra4m1-group-users-manual-hardware
- **Schematic:** https://files.seeedstudio.com/wiki/XIAO-RA4M1/res/XIAO_RA4M1_v1.0_SCH.pdf
