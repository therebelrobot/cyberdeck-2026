---
name: xiao-nrf54l15-sense-tinygo
description: >
  Provides comprehensive pinout reference, board specifications, and TinyGo development guide
  for the Seeed Studio XIAO nRF54L15 Sense microcontroller. Use when writing TinyGo firmware for the
  XIAO nRF54L15 Sense, wiring peripherals, or configuring pins. Keywords: XIAO, nRF54L15, Sense,
  TinyGo, Nordic, ARM Cortex-M33, RISC-V, BLE 6.0, Channel Sounding, NFC, Thread, Zigbee, Matter,
  LSM6DS3TR-C, IMU, microphone, MSM261DGT006, pinout, GPIO, I2C, SPI, UART, analog, digital, PWM.
---

# XIAO nRF54L15 Sense — TinyGo Development Guide

Provides comprehensive reference for developing TinyGo firmware for the Seeed Studio XIAO nRF54L15 Sense.

## When to Use

- Writing TinyGo firmware targeting the XIAO nRF54L15 Sense
- Looking up XIAO nRF54L15 Sense pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO nRF54L15 Sense and need GPIO reference
- Working with the onboard LSM6DS3TR-C IMU or MSM261DGT006 microphone

## When NOT to Use

- For Arduino/C++ development on the XIAO nRF54L15 Sense → use the `XIAO-nRF54L15-Sense-Arduino` skill
- For the XIAO nRF54L15 (without sensors) → use the `XIAO-nRF54L15-TinyGo` skill
- For the XIAO nRF52840 Sense (older board) → use the corresponding board skill
- For other XIAO boards → use the corresponding board skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Nordic nRF54L15 |
| **Architecture** | ARM Cortex-M33 @ 128 MHz + RISC-V coprocessor @ 128 MHz (FLPR) |
| **Flash (NVM)** | 1.5 MB |
| **RAM** | 256 KB |
| **ADC** | 14-bit |
| **Wireless** | BLE 6.0 (Channel Sounding), NFC, Thread, Zigbee, Matter, Amazon Sidewalk, 802.15.4-2020 |
| **USB** | USB Type-C (via SAMD11 serial bridge) |
| **Operating Voltage** | 3.3V logic |
| **Supply Voltage** | 3.7V to 5V |
| **Dimensions** | 21 × 17.8 mm |
| **Working Temp** | -40°C to 105°C |
| **GPIO Count** | 16 |
| **Analog Pins** | 4 (D0-D3) |
| **TX Power** | +8 dBm |
| **RX Sensitivity** | -96 dBm |
| **Antenna** | Ceramic antenna + U.FL connector (switchable) |
| **Battery** | Built-in Li-ion battery management (internal PMIC) |
| **IMU** | LSM6DS3TR-C (6 DOF — Accelerometer + Gyroscope) |
| **Microphone** | MSM261DGT006 (Digital Microphone) |
| **Buttons** | 1× RESET, 1× User Key (P0.00) |

---

## Pinout Diagram

```
          XIAO nRF54L15 Sense (Top View)
                ┌─────────────────┐
                │    [USB-C]      │
       D0/A0 ──┤ P1.04    P2.07 ├── D7 (RX)
       D1/A1 ──┤ P1.05    P2.08 ├── D6 (TX)
       D2/A2 ──┤ P1.06    P1.11 ├── D5 (SCL)
       D3/A3 ──┤ P1.07    P1.10 ├── D4 (SDA)
         GND ──┤                 ├── D10 (MOSI)
          5V ──┤                 ├── D9 (MISO)
         3V3 ──┤                 ├── D8 (SCK)
                └─────────────────┘
  Bottom pads: D11-D15, NFC1, NFC2, JTAG
  Onboard: LSM6DS3TR-C IMU + MSM261DGT006 Mic
  Ceramic antenna + U.FL connector on top edge
```

---

## Pin Reference Table

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|--------|-----|-----|-----|------|-------|
| D0  | P1.04    | ✓       | ADC    | ✓   | —   | —   | —    | — |
| D1  | P1.05    | ✓       | ADC    | ✓   | —   | —   | —    | — |
| D2  | P1.06    | ✓       | ADC    | ✓   | —   | —   | —    | — |
| D3  | P1.07    | ✓       | ADC    | ✓   | —   | —   | —    | — |
| D4  | P1.10    | ✓       | —      | ✓   | **SDA-0** | — | — | — |
| D5  | P1.11    | ✓       | —      | ✓   | **SCL-0** | — | — | — |
| D6  | P2.08    | ✓       | —      | ✓   | —   | —   | **TX** | — |
| D7  | P2.07    | ✓       | —      | ✓   | —   | —   | **RX** | — |
| D8  | P2.01    | ✓       | —      | ✓   | —   | **SCK** | — | — |
| D9  | P2.04    | ✓       | —      | ✓   | —   | **MISO** | — | — |
| D10 | P2.02    | ✓       | —      | ✓   | —   | **MOSI** | — | — |
| D11 | P0.03    | ✓       | —      | ✓   | **SCL-1** | — | — | Bottom pad |
| D12 | P0.04    | ✓       | —      | ✓   | **SDA-1** | — | — | Bottom pad |
| D13 | P2.10    | ✓       | —      | ✓   | —   | —   | — | Bottom pad |
| D14 | P2.09    | ✓       | —      | ✓   | —   | —   | — | Bottom pad |
| D15 | P2.06    | ✓       | —      | ✓   | —   | —   | — | Bottom pad |

### Internal / Special Pins

| Name | Chip Pin | Description |
|------|----------|-------------|
| USER_LED | P2.00 | User LED (Green) |
| CHARGE_LED | charge_LED | Charge LED (Red) |
| USER KEY | P0.00 | User button |
| NFC1 | P1.02 | NFC antenna pin 1 |
| NFC2 | P1.03 | NFC antenna pin 2 |
| AIN7_VBAT | P1.14 | Read battery voltage |
| RF Switch Port | P2.05 | Switch onboard antenna |
| RF Switch Power | P2.03 | RF power control |

---

## TinyGo Setup

### ⚠ TinyGo Support Status

**Status: Not yet available**

TinyGo does not currently have a target definition for the Nordic nRF54L15. The nRF54 series is newer than the nRF52 series that TinyGo currently supports.

When support is added, the target name would likely be:

```
xiao-nrf54l15
```

### What Would Be Needed

1. TinyGo would need to add support for the nRF54L15 (Cortex-M33 + RISC-V FLPR coprocessor)
2. A machine package definition for the XIAO nRF54L15 pin mappings
3. Nordic nRF Connect SDK integration for peripheral drivers
4. BLE 6.0 SoftDevice or equivalent stack support
5. TinyGo driver for LSM6DS3TR-C IMU (already exists in tinygo.org/x/drivers for the nRF52840 Sense)
6. PDM/I2S driver for MSM261DGT006 digital microphone

### Current Alternatives

- Use **nRF Connect SDK** with Zephyr RTOS for native development
- Use **Arduino IDE** with the Seeed nRF boards package (see `XIAO-nRF54L15-Sense-Arduino` skill)
- Use **PlatformIO** with the Nordic platform

### Expected Build and Flash Commands (Future)

```bash
# Build only (when supported)
tinygo build -target=xiao-nrf54l15 -o firmware.bin ./main.go

# Build and flash via USB serial (when supported)
tinygo flash -target=xiao-nrf54l15 ./main.go
```

### Example: Blink LED (TinyGo — Future)

```go
package main

import (
    "machine"
    "time"
)

func main() {
    // USER_LED is P2.00 (Green)
    led := machine.LED // Would map to P2.00
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

- **I2C0 — SDA:** D4 (P1.10), **SCL:** D5 (P1.11)
- **I2C1 — SDA:** D12 (P0.04), **SCL:** D11 (P0.03)
- **Note:** The onboard LSM6DS3TR-C IMU uses the I2C bus

```go
// When TinyGo support is available:
i2c := machine.I2C0
err := i2c.Configure(machine.I2CConfig{
    SDA:       machine.SDA_PIN, // D4 / P1.10
    SCL:       machine.SCL_PIN, // D5 / P1.11
    Frequency: 400000,          // 400 kHz
})
if err != nil {
    println("I2C init failed:", err)
}
```

### SPI (Future TinyGo API)

- **SCK:** D8 (P2.01)
- **MISO:** D9 (P2.04)
- **MOSI:** D10 (P2.02)

```go
// When TinyGo support is available:
spi := machine.SPI0
err := spi.Configure(machine.SPIConfig{
    SCK:       machine.SPI0_SCK_PIN,  // D8 / P2.01
    SDO:       machine.SPI0_SDO_PIN,  // D10 / P2.02 (MOSI)
    SDI:       machine.SPI0_SDI_PIN,  // D9 / P2.04 (MISO)
    Frequency: 4000000,               // 4 MHz
})
if err != nil {
    println("SPI init failed:", err)
}
```

### UART (Future TinyGo API)

- **TX:** D6 (P2.08)
- **RX:** D7 (P2.07)

```go
// When TinyGo support is available:
uart := machine.UART0
uart.Configure(machine.UARTConfig{
    TX:       machine.UART_TX_PIN, // D6 / P2.08
    RX:       machine.UART_RX_PIN, // D7 / P2.07
    BaudRate: 115200,
})
uart.Write([]byte("Hello from XIAO nRF54L15 Sense\r\n"))
```

### Analog Read (Future TinyGo API)

```go
// 4 analog pins available (D0-D3), 14-bit ADC
adc := machine.ADC{Pin: machine.A0} // D0 / P1.04
adc.Configure(machine.ADCConfig{})
value := adc.Get() // Returns 16-bit scaled value
```

### BLE 6.0 / NFC / Thread / Zigbee / Matter

These protocols require the Nordic nRF Connect SDK and are not expected to be available through TinyGo in the near term.

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **Supply voltage:** 3.7V to 5V
- **TX power:** +8 dBm
- **Built-in PMIC:** Internal Li-ion battery management

### Battery Support

- **Built-in PMIC:** Internal power management IC for Li-ion battery charging
- **Battery voltage:** Read via AIN7_VBAT (P1.14)
- **Charge LED:** Red LED indicates charging status
- **Input:** 3.7V Li-ion battery

### Deep Sleep

```go
// Deep sleep support in TinyGo for nRF54L15 is not yet available.
// The hardware supports:
// - System ON idle (low power with fast wake-up)
// - System OFF (deep sleep with RTC wake-up)
// - Global RTC available in System OFF mode
```

> **Note:** There are known battery boot issues — the board may not boot reliably from battery power alone in some configurations.

---

## Special Features (Sense Variant)

### LSM6DS3TR-C IMU (6 DOF)

The Sense variant includes an LSM6DS3TR-C 6-axis IMU (accelerometer + gyroscope) connected via I2C:

```go
// When TinyGo support is available:
// TinyGo already has an LSM6DS3TR-C driver in tinygo.org/x/drivers
// (used with the XIAO nRF52840 Sense)
//
// import "tinygo.org/x/drivers/lsm6ds3tr"
//
// i2c := machine.I2C0
// i2c.Configure(machine.I2CConfig{...})
// imu := lsm6ds3tr.New(i2c)
// imu.Configure(lsm6ds3tr.Configuration{})
// ax, ay, az := imu.ReadAcceleration()
// gx, gy, gz := imu.ReadRotation()
```

### MSM261DGT006 Digital Microphone

The Sense variant includes an MSM261DGT006 digital microphone (PDM interface):

```go
// When TinyGo support is available:
// The digital microphone uses PDM (Pulse Density Modulation)
// TinyGo would need PDM peripheral support for the nRF54L15
// to read audio data from this microphone.
```

### Dual-Core Architecture

- **ARM Cortex-M33 @ 128 MHz** — Main application processor
- **RISC-V coprocessor @ 128 MHz (FLPR)** — Fast Lightweight Peripheral Processor

### BLE 6.0 with Channel Sounding

Centimeter-level distance measurement between BLE devices.

### NFC Support

Dedicated NFC antenna pins (NFC1/P1.02, NFC2/P1.03) on bottom pads.

### 14-bit ADC

Higher resolution ADC on D0-D3.

### Global RTC

Real-time counter available even in System OFF mode.

### User Button

Dedicated user button on P0.00.

### Security Features

- ARM TrustZone isolation
- Tamper detectors
- Cryptographic engine protection

---

## Common Gotchas / Notes

1. **TinyGo not yet supported** — The nRF54L15 is not currently supported by TinyGo; use nRF Connect SDK or Arduino
2. **Battery boot issues** — The board may not boot reliably from battery power alone
3. **JTAG pin restrictions** — JTAG pins on bottom pads; avoid conflicts during debugging
4. **Only 4 analog pins** — D0-D3 have ADC (14-bit); D4-D15 are digital only
5. **Same pinout as nRF54L15** — The Sense variant has identical pin mappings; only adds onboard sensors
6. **IMU on I2C bus** — The LSM6DS3TR-C uses the I2C bus; be aware of address conflicts
7. **Digital microphone (PDM)** — The MSM261DGT006 uses PDM, not analog; requires PDM peripheral support
8. **SAMD11 serial bridge** — USB is handled by a SAMD11 chip, not native USB
9. **NFC pins on bottom** — NFC1/NFC2 require soldering to access
10. **3.3V logic only** — Do NOT connect 5V signals directly to GPIO pins

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/xiao_nrf54l15_sense_getting_started/
- **Nordic nRF54L15 Product Page:** https://www.nordicsemi.com/Products/nRF54L15
- **LSM6DS3TR-C Datasheet:** https://www.st.com/resource/en/datasheet/lsm6ds3tr-c.pdf
- **TinyGo LSM6DS3TR driver:** https://pkg.go.dev/tinygo.org/x/drivers/lsm6ds3tr
- **nRF Connect SDK:** https://developer.nordicsemi.com/nRF_Connect_SDK/doc/latest/nrf/index.html
- **TinyGo (check for future support):** https://tinygo.org/docs/reference/microcontrollers/
- **Schematic:** https://files.seeedstudio.com/wiki/XIAO-nRF54L15/res/XIAO_nRF54L15_Schematic.pdf
