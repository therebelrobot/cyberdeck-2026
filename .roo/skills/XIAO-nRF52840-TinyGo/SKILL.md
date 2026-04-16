---
name: xiao-nrf52840-tinygo
description: >
  Provides comprehensive pinout reference, board specifications, and TinyGo development guide
  for the Seeed Studio XIAO nRF52840 microcontroller. Use when writing TinyGo firmware for the
  XIAO nRF52840, wiring peripherals, or configuring pins. Keywords: XIAO, nRF52840, TinyGo,
  Nordic, Cortex-M4, BLE, Bluetooth, NFC, pinout, GPIO, I2C, SPI, UART, analog, digital, PWM, battery.
---

# XIAO nRF52840 — TinyGo Development Guide

Provides comprehensive reference for developing TinyGo firmware for the Seeed Studio XIAO nRF52840.

## When to Use

- Writing TinyGo firmware targeting the XIAO nRF52840
- Looking up XIAO nRF52840 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO nRF52840 and need GPIO reference
- Configuring I2C, SPI, UART, BLE, or analog I/O on the XIAO nRF52840 in TinyGo

## When NOT to Use

- For Arduino/C++ development on the XIAO nRF52840 → use the `XIAO-nRF52840-Arduino` skill
- For the XIAO nRF52840 **Sense** variant (with IMU + microphone) → use the `XIAO-nRF52840-Sense-TinyGo` skill
- For other XIAO boards (SAMD21, RP2040, ESP32-C3) → use the corresponding board skill

---

## Board Overview

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

---

## Pinout Diagram

```
                      [USB-C]
                ┌───────────────┐
      D0/A0   ──┤ 1          14 ├── 5V
      D1/A1   ──┤ 2          13 ├── GND
      D2/A2   ──┤ 3          12 ├── 3V3
      D3/A3   ──┤ 4          11 ├── D10/MOSI
   D4/A4/SDA  ──┤ 5          10 ├── D9/MISO
   D5/A5/SCL  ──┤ 6           9 ├── D8/SCK
     D6/TX    ──┤ 7           8 ├── D7/RX
                └───────────────┘
         Bottom pads: GND, RST, NFC1, NFC2, 3V3, BAT
```

---

## Pin Reference Table

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|--------|-----|-----|-----|------|-------|
| D0  | P0.02    | ✓       | AIN0   | ✓   | —   | —   | —    | — |
| D1  | P0.03    | ✓       | AIN1   | ✓   | —   | —   | —    | — |
| D2  | P0.28    | ✓       | AIN4   | ✓   | —   | —   | —    | — |
| D3  | P0.29    | ✓       | AIN5   | ✓   | —   | —   | —    | — |
| D4  | P0.04    | ✓       | AIN2   | ✓   | **SDA** | — | —  | — |
| D5  | P0.05    | ✓       | AIN3   | ✓   | **SCL** | — | —  | — |
| D6  | P1.11    | ✓       | —      | ✓   | —   | —   | **TX** | — |
| D7  | P1.12    | ✓       | —      | ✓   | —   | —   | **RX** | — |
| D8  | P1.13    | ✓       | —      | ✓   | —   | **SCK** | — | — |
| D9  | P1.14    | ✓       | —      | ✓   | —   | **MISO** | — | — |
| D10 | P1.15    | ✓       | —      | ✓   | —   | **MOSI** | — | — |

### Internal / LED / Special Pins

| Name | Chip Pin | Description |
|------|----------|-------------|
| USER_LED_R | P0.26 | Red RGB LED — active LOW |
| USER_LED_G | P0.30 | Green RGB LED — active LOW |
| USER_LED_B | P0.06 | Blue RGB LED — active LOW |
| CHARGE_LED | P0.17 | Charge indicator (Red) |
| NFC1 | P0.09 | NFC antenna pad (bottom) |
| NFC2 | P0.10 | NFC antenna pad (bottom) |
| ADC_BAT | P0.14 | Battery voltage sense |
| CHG_RATE | P0.13 | Charge rate: HIGH=50mA, LOW=100mA |
| Reset | P0.18 | Reset pad (bottom) |

---

## TinyGo Setup

### Target Name

```
xiao-ble
```

### Installation

1. Install TinyGo: https://tinygo.org/getting-started/install/
2. Verify the target is available:
   ```bash
   tinygo info -target=xiao-ble
   ```

### Build and Flash

```bash
# Build only (produces UF2 file)
tinygo build -target=xiao-ble -o firmware.uf2 ./main.go

# Build and flash (board must be in bootloader mode)
tinygo flash -target=xiao-ble ./main.go

# Enter bootloader mode: double-tap the reset pad quickly
# Board appears as USB drive named "XIAO-SENSE" (same for both variants)
```

### TinyGo Support Status

- **Status:** Supported
- **USB CDC:** Supported (serial over USB)
- **ADC:** Supported on D0–D5 (AIN0–AIN5)
- **PWM:** Supported on all 11 digital pins
- **I2C:** Supported (machine.I2C0)
- **SPI:** Supported (machine.SPI0)
- **UART:** Supported (machine.UART0)
- **BLE:** Supported via `tinygo.org/x/bluetooth`
- **NFC:** Not directly supported in TinyGo

### Example: Blink (TinyGo)

```go
package main

import (
    "machine"
    "time"
)

func main() {
    led := machine.LED // Maps to red LED (P0.26)
    led.Configure(machine.PinConfig{Mode: machine.PinOutput})

    for {
        led.Low()  // LED on (active LOW)
        time.Sleep(500 * time.Millisecond)
        led.High() // LED off
        time.Sleep(500 * time.Millisecond)
    }
}
```

### Example: RGB LED

```go
package main

import (
    "machine"
    "time"
)

func main() {
    ledR := machine.LED_RED   // P0.26
    ledG := machine.LED_GREEN // P0.30
    ledB := machine.LED_BLUE  // P0.06

    ledR.Configure(machine.PinConfig{Mode: machine.PinOutput})
    ledG.Configure(machine.PinConfig{Mode: machine.PinOutput})
    ledB.Configure(machine.PinConfig{Mode: machine.PinOutput})

    // All off
    ledR.High()
    ledG.High()
    ledB.High()

    for {
        ledR.Low(); time.Sleep(500 * time.Millisecond); ledR.High()
        ledG.Low(); time.Sleep(500 * time.Millisecond); ledG.High()
        ledB.Low(); time.Sleep(500 * time.Millisecond); ledB.High()
    }
}
```

### Example: BLE Peripheral

```go
package main

import (
    "time"
    "tinygo.org/x/bluetooth"
)

var adapter = bluetooth.DefaultAdapter

func main() {
    must("enable BLE", adapter.Enable())

    adv := adapter.DefaultAdvertisement()
    must("config adv", adv.Configure(bluetooth.AdvertisementOptions{
        LocalName: "XIAO-nRF52840",
    }))
    must("start adv", adv.Start())

    for {
        time.Sleep(time.Second)
    }
}

func must(action string, err error) {
    if err != nil {
        panic("failed to " + action + ": " + err.Error())
    }
}
```

> Install: `go get tinygo.org/x/bluetooth`

---

## Communication Protocols

### I2C

- **SDA:** D4 (P0.04)
- **SCL:** D5 (P0.05)
- **TinyGo bus:** `machine.I2C0`

```go
i2c := machine.I2C0
err := i2c.Configure(machine.I2CConfig{
    SDA:       machine.SDA_PIN, // D4 / P0.04
    SCL:       machine.SCL_PIN, // D5 / P0.05
    Frequency: 400000,          // 400 kHz
})
if err != nil {
    println("I2C init failed:", err)
}
```

### SPI

- **SCK:** D8 (P1.13)
- **MISO:** D9 (P1.14)
- **MOSI:** D10 (P1.15)
- **TinyGo bus:** `machine.SPI0`

```go
spi := machine.SPI0
err := spi.Configure(machine.SPIConfig{
    SCK:       machine.SPI0_SCK_PIN,  // D8 / P1.13
    SDO:       machine.SPI0_SDO_PIN,  // D10 / P1.15 (MOSI)
    SDI:       machine.SPI0_SDI_PIN,  // D9 / P1.14 (MISO)
    Frequency: 4000000,               // 4 MHz
})
if err != nil {
    println("SPI init failed:", err)
}
```

### UART

- **TX:** D6 (P1.11)
- **RX:** D7 (P1.12)
- **TinyGo bus:** `machine.UART0`

```go
uart := machine.UART0
uart.Configure(machine.UARTConfig{
    TX:       machine.UART_TX_PIN, // D6 / P1.11
    RX:       machine.UART_RX_PIN, // D7 / P1.12
    BaudRate: 115200,
})
uart.Write([]byte("Hello from XIAO nRF52840\r\n"))
```

### Analog Read (ADC)

```go
adc := machine.ADC{Pin: machine.A0} // D0 / P0.02
adc.Configure(machine.ADCConfig{})
value := adc.Get() // Returns 16-bit scaled value
```

> **Note:** 6 analog pins available: D0–D5 (AIN0–AIN5).

### BLE (Bluetooth Low Energy)

See the BLE Peripheral example above. The `tinygo.org/x/bluetooth` package supports:
- Advertising
- GATT server (peripheral role)
- GATT client (central role)
- Scanning

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **5V output:** From USB VBUS
- **3.3V output:** Regulated from onboard LDO
- **Standby power:** < 5 μA

### Battery Support

The XIAO nRF52840 has a built-in BQ25101 charge chip:

- **Battery pad:** Solder LiPo battery to BAT+ and BAT- pads on the bottom
- **Charge rate:** 50 mA (P0.13 HIGH) or 100 mA (P0.13 LOW, default)
- **Charge LED:** Red LED (P0.17) indicates charging status

```go
// Read battery voltage
batADC := machine.ADC{Pin: machine.Pin(0x0E)} // P0.14 (ADC_BAT)
batADC.Configure(machine.ADCConfig{})
rawValue := batADC.Get()
// Convert to voltage: V = rawValue * 3.3 / 65535 * 2 (voltage divider)
```

### Deep Sleep

The nRF52840 supports System OFF mode with < 5 μA current:

```go
// TinyGo deep sleep support on nRF52840 is evolving.
// Basic sleep:
machine.Sleep()

// For full System OFF mode, direct register access may be needed.
// Wake sources: GPIO interrupt, NFC field, reset pin
```

---

## Common Gotchas / Notes

1. **6 analog pins** — D0–D5 all have ADC (AIN0–AIN5); D6–D10 are digital only
2. **LEDs are active LOW** — Pull the pin LOW to turn the LED ON
3. **Two Arduino libraries exist** — "Seeed nRF52 Boards" (BLE/low power) vs "Seeed nRF52 mbed-enabled Boards" (ML/IMU); TinyGo uses its own target
4. **NFC pads on bottom** — P0.09 and P0.10 are NFC antenna pads; not exposed as GPIO on side pads
5. **Battery charging** — Default charge rate is 100 mA; set P0.13 HIGH for 50 mA
6. **Bootloader mode** — Double-tap the reset pad; board appears as "XIAO-SENSE" USB drive
7. **No WiFi** — This board has BLE only; use ESP32-C3 for WiFi
8. **This is NOT the Sense variant** — No IMU or microphone; for those features use the XIAO nRF52840 Sense

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/XIAO_BLE/
- **TinyGo target docs:** https://tinygo.org/docs/reference/microcontrollers/xiao-ble/
- **nRF52840 datasheet:** https://infocenter.nordicsemi.com/pdf/nRF52840_PS_v1.1.pdf
- **TinyGo Bluetooth package:** https://github.com/tinygo-org/bluetooth
- **Schematic:** https://files.seeedstudio.com/wiki/XIAO-BLE/Seeed-Studio-XIAO-nRF52840-Sense-v1.1.pdf
