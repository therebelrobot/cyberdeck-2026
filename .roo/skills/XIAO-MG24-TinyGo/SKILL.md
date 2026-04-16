---
name: xiao-mg24-tinygo
description: >
  Provides comprehensive pinout reference, board specifications, and TinyGo development guide
  for the Seeed Studio XIAO MG24 microcontroller. Use when writing TinyGo firmware for the
  XIAO MG24, wiring peripherals, or configuring pins. Keywords: XIAO, MG24, EFR32MG24, TinyGo,
  Silicon Labs, ARM Cortex-M33, Zigbee, Thread, Matter, BLE 5.3, pinout, GPIO, I2C, SPI, UART,
  analog, digital, PWM, battery, deep sleep, 802.15.4.
---

# XIAO MG24 — TinyGo Development Guide

Provides comprehensive reference for developing TinyGo firmware for the Seeed Studio XIAO MG24.

## When to Use

- Writing TinyGo firmware targeting the XIAO MG24
- Looking up XIAO MG24 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO MG24 and need GPIO reference
- Configuring I2C, SPI, UART, or analog I/O on the XIAO MG24 in TinyGo

## When NOT to Use

- For Arduino/C++ development on the XIAO MG24 → use the `XIAO-MG24-Arduino` skill
- For the XIAO MG24 Sense (with IMU/microphone) → use the `XIAO-MG24-Sense-TinyGo` skill
- For other XIAO boards → use the corresponding board skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Silicon Labs EFR32MG24 |
| **Architecture** | ARM Cortex-M33, 32-bit RISC |
| **Clock Speed** | 78 MHz |
| **Flash** | 1536 KB (on-chip) + 4 MB (onboard) |
| **RAM** | 256 KB |
| **AI/ML** | Built-in AI/ML hardware accelerator (MVP) |
| **ADC** | 12-bit, 1 Msps |
| **Wireless** | BLE 5.3, Zigbee, Thread, Matter, 802.15.4 |
| **USB** | USB Type-C (via SAMD11 serial bridge) |
| **Operating Voltage** | 3.3V logic / 5V USB input |
| **Supply Voltage** | 5V (USB) or 3.7V (battery) |
| **Dimensions** | 21 × 17.8 mm |
| **Working Temp** | -20°C to 70°C |
| **GPIO Count** | 22 (all PWM-capable) |
| **Analog Pins** | 19 |
| **Low Power** | 1.95 μA (typical) |
| **Normal** | 6.71 mA (typical) |
| **Sleep** | 1.91 mA (typical) |
| **Antenna** | 2.4 GHz ceramic antenna (4.97 dBi) + U.FL connector |
| **Battery** | Supports LiPo charge/discharge (3.7V BAT input) |
| **TX Power** | Up to +19.5 dBm |
| **RX Sensitivity** | -105.4 dBm (250 kbps DSSS) |

---

## Pinout Diagram

```
                XIAO MG24 (Top View)
                ┌─────────────────┐
                │    [USB-C]      │
       D0/A0 ──┤ PC00      PC07 ├── D7/A7 (RX0)
       D1/A1 ──┤ PC01      PC06 ├── D6/A6 (TX0)
       D2/A2 ──┤ PC02      PC05 ├── D5/A5 (SCL)
       D3/A3 ──┤ PC03      PC04 ├── D4/A4 (SDA)
         GND ──┤                 ├── D10/A10 (MOSI0)
          5V ──┤                 ├── D9/A9 (MISO0)
         3V3 ──┤                 ├── D8/A8 (SCK0)
                └─────────────────┘
  Bottom pads: D11-D18 (accessible via soldering)
  Ceramic antenna + U.FL connector on top edge
```

---

## Pin Reference Table

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|--------|-----|-----|-----|------|-------|
| D0  | PC00     | ✓       | ADC    | ✓   | —   | —   | —    | — |
| D1  | PC01     | ✓       | ADC    | ✓   | —   | —   | —    | — |
| D2  | PC02     | ✓       | ADC    | ✓   | —   | —   | —    | — |
| D3  | PC03     | ✓       | ADC    | ✓   | —   | **SPI** | — | — |
| D4  | PC04     | ✓       | ADC    | ✓   | **SDA** | — | — | — |
| D5  | PC05     | ✓       | ADC    | ✓   | **SCL** | — | — | — |
| D6  | PC06     | ✓       | ADC    | ✓   | —   | —   | **TX0** | — |
| D7  | PC07     | ✓       | ADC    | ✓   | —   | —   | **RX0** | — |
| D8  | PA03     | ✓       | ADC    | ✓   | —   | **SCK0** | — | — |
| D9  | PA04     | ✓       | ADC    | ✓   | —   | **MISO0** | — | — |
| D10 | PA05     | ✓       | ADC    | ✓   | —   | **MOSI0** | — | — |
| D11 | PA09     | ✓       | ADC    | ✓   | —   | —   | RX1 | SAMD11_TX |
| D12 | PA08     | ✓       | ADC    | ✓   | —   | —   | TX1 | SAMD11_RX |
| D13 | PB02     | ✓       | ADC    | ✓   | SCL1 | — | — | — |
| D14 | PB03     | ✓       | ADC    | ✓   | SDA1 | — | — | — |
| D15 | PB00     | ✓       | ADC    | ✓   | —   | **MOSI1** | — | — |
| D16 | PB01     | ✓       | ADC    | ✓   | —   | **MISO1** | — | — |
| D17 | PA00     | ✓       | ADC    | ✓   | —   | **SCK1** | — | — |
| D18 | PD02     | ✓       | ADC    | ✓   | —   | —   | — | Csn |

### Internal / Special Pins

| Name | Chip Pin | Description |
|------|----------|-------------|
| USER_LED | PA07 | User LED (Yellow) |
| CHARGE_LED | VBUS | Charge LED (Red) |
| ADC_BAT | PD04 | Read battery voltage |
| RF Switch Port | PB04 | Switch onboard/UFL antenna |
| RF Switch Power | PB05 | RF power control |
| Reset | RESET | Reset button |

---

## TinyGo Setup

### ⚠ TinyGo Support Status

**Status: Not yet available**

TinyGo does not currently have a target definition for the Silicon Labs EFR32MG24. The EFR32 family is not yet supported in TinyGo's machine package.

When support is added, the target name would likely be:

```
xiao-mg24
```

### What Would Be Needed

1. TinyGo would need to add LLVM support for the EFR32MG24 (Cortex-M33)
2. A machine package definition for the XIAO MG24 pin mappings
3. Silicon Labs GSDK (Gecko SDK) integration for peripheral drivers

### Current Alternatives

- Use **Arduino IDE** with the Silicon Labs Arduino core (see `XIAO-MG24-Arduino` skill)
- Use **Simplicity Studio** with the Gecko SDK for native development
- Use **PlatformIO** with the Silicon Labs platform

### Expected Build and Flash Commands (Future)

```bash
# Build only (when supported)
tinygo build -target=xiao-mg24 -o firmware.bin ./main.go

# Build and flash via USB serial (when supported)
tinygo flash -target=xiao-mg24 ./main.go
```

### Example: Blink LED (TinyGo — Future)

```go
package main

import (
    "machine"
    "time"
)

func main() {
    // USER_LED is PA07 (Yellow)
    led := machine.LED // Would map to PA07
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

### I2C (Future TinyGo API)

- **SDA:** D4 (PC04)
- **SCL:** D5 (PC05)
- **Secondary — SDA:** D14 (PB03), **SCL:** D13 (PB02)

```go
// When TinyGo support is available:
i2c := machine.I2C0
err := i2c.Configure(machine.I2CConfig{
    SDA:       machine.SDA_PIN, // D4 / PC04
    SCL:       machine.SCL_PIN, // D5 / PC05
    Frequency: 400000,          // 400 kHz
})
if err != nil {
    println("I2C init failed:", err)
}
```

### SPI (Future TinyGo API)

- **SCK:** D8 (PA03)
- **MISO:** D9 (PA04)
- **MOSI:** D10 (PA05)
- **Secondary — SCK:** D17 (PA00), **MISO:** D16 (PB01), **MOSI:** D15 (PB00)

```go
// When TinyGo support is available:
spi := machine.SPI0
err := spi.Configure(machine.SPIConfig{
    SCK:       machine.SPI0_SCK_PIN,  // D8 / PA03
    SDO:       machine.SPI0_SDO_PIN,  // D10 / PA05 (MOSI)
    SDI:       machine.SPI0_SDI_PIN,  // D9 / PA04 (MISO)
    Frequency: 4000000,               // 4 MHz
})
if err != nil {
    println("SPI init failed:", err)
}
```

### UART (Future TinyGo API)

- **TX:** D6 (PC06)
- **RX:** D7 (PC07)
- **Secondary — TX:** D12 (PA08), **RX:** D11 (PA09)

```go
// When TinyGo support is available:
uart := machine.UART0
uart.Configure(machine.UARTConfig{
    TX:       machine.UART_TX_PIN, // D6 / PC06
    RX:       machine.UART_RX_PIN, // D7 / PC07
    BaudRate: 115200,
})
uart.Write([]byte("Hello from XIAO MG24\r\n"))
```

### Analog Read (Future TinyGo API)

```go
// 19 analog pins available (D0-D18 except D11, D12, D13)
adc := machine.ADC{Pin: machine.A0} // D0 / PC00
adc.Configure(machine.ADCConfig{})
value := adc.Get() // Returns 16-bit scaled value
```

### Wireless Protocols

The XIAO MG24 supports Zigbee, Thread, Matter, and BLE 5.3 at the hardware level. These protocols require the Silicon Labs Gecko SDK and are not expected to be available through TinyGo in the near term.

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **5V output:** From USB VBUS
- **Max per-pin current:** Refer to EFR32MG24 datasheet (typically 20 mA per GPIO)
- **Normal operation:** ~6.71 mA
- **Sleep:** ~1.91 mA
- **Low power:** ~1.95 μA

### Battery Support

- **Battery pad:** Solder LiPo battery to BAT+ and BAT- pads on the bottom
- **Charge LED:** Red LED indicates charging status
- **Input:** 3.7V LiPo battery
- **Battery voltage:** Read via ADC_BAT (PD04)

### Deep Sleep

⚠ **WARNING: Deep sleep can brick the XIAO MG24!**

Entering deep sleep mode (EM4) on the EFR32MG24 can make the board unresponsive. The SAMD11 serial bridge cannot wake the main MCU from EM4.

**Recovery procedure (double-tap reset):**
1. Press RESET quickly twice within 500ms
2. This enters the bootloader mode
3. Re-flash firmware to recover

```go
// Deep sleep is NOT recommended on the XIAO MG24 due to bricking risk.
// If you must use low-power modes, use EM2 (sleep) instead of EM4 (deep sleep).
```

---

## Special Features

### AI/ML Hardware Accelerator (MVP)

The EFR32MG24 includes a Matrix Vector Processor (MVP) for on-device AI/ML inference. This is accessible through the Silicon Labs Gecko SDK but not through TinyGo.

### All 22 GPIOs Support PWM

Every GPIO pin on the XIAO MG24 supports PWM output, providing maximum flexibility for motor control, LED dimming, and servo applications.

### 19 Analog Input Pins

The XIAO MG24 has 19 analog-capable pins with 12-bit ADC resolution at 1 Msps — the most analog pins of any XIAO board.

### Dual Antenna Support

- Onboard 2.4 GHz ceramic antenna (4.97 dBi)
- U.FL connector for external antenna
- Software-switchable via RF Switch (PB04/PB05)

### Security Features

- Hardware Cryptographic Acceleration
- True Random Number Generator
- ARM TrustZone
- Secure Boot
- Secure Vault (Secure Debug Unlock)

---

## Common Gotchas / Notes

1. **TinyGo not yet supported** — The EFR32MG24 is not currently supported by TinyGo; use Arduino or Simplicity Studio
2. **Deep sleep bricks the board** — EM4 deep sleep makes the board unresponsive; use double-tap reset to recover
3. **No BOOT button** — Recovery uses escape pin (PC1 pulled LOW) instead of a boot button
4. **SAMD11 serial bridge** — USB is handled by a SAMD11 chip, not native USB on the EFR32MG24
5. **All pins are analog** — 19 of 22 GPIO pins support ADC (12-bit)
6. **All pins support PWM** — All 22 GPIO pins can output PWM
7. **Bottom pads D11-D18** — 8 additional pins accessible only via soldering on the bottom of the board
8. **3.3V logic only** — Do NOT connect 5V signals directly to GPIO pins
9. **Dual SPI buses** — SPI0 (D8-D10) and SPI1 (D15-D17) available
10. **Dual UART buses** — UART0 (D6/D7) and UART1 (D11/D12, shared with SAMD11)

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/xiao_mg24_getting_started/
- **EFR32MG24 Datasheet:** https://www.silabs.com/documents/public/data-sheets/efr32mg24-datasheet.pdf
- **Silicon Labs Gecko SDK:** https://github.com/SiliconLabs/gecko_sdk
- **TinyGo (check for future support):** https://tinygo.org/docs/reference/microcontrollers/
- **Schematic:** https://files.seeedstudio.com/wiki/XIAO_MG24/res/XIAO_MG24_Schematic.pdf
