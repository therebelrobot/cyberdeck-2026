---
name: arduino-unor4minima-tinygo
description: >
  Provides comprehensive pinout reference, board specifications, and TinyGo development guide
  for the Arduino Uno R4 Minima (Renesas RA4M1) microcontroller. Use when writing TinyGo firmware
  for the Arduino Uno R4 Minima, wiring peripherals, or configuring pins. Keywords: Arduino, Uno,
  R4, Minima, RA4M1, Renesas, Cortex-M4, TinyGo, pinout, GPIO, I2C, SPI, UART, DAC, CAN, analog,
  digital, PWM, 5V, 32-bit, USB-C, 14-bit ADC.
---

# Arduino Uno R4 Minima — TinyGo Development Guide

Provides comprehensive reference for developing TinyGo firmware for the Arduino Uno R4 Minima (Renesas RA4M1).

## When to Use

- Writing TinyGo firmware targeting the Arduino Uno R4 Minima
- Looking up Arduino Uno R4 Minima pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the Arduino Uno R4 Minima and need GPIO reference
- Configuring I2C, SPI, UART, DAC, or CAN on the Arduino Uno R4 Minima in TinyGo

## When NOT to Use

- For Arduino/C++ development on the Uno R4 Minima → use the `Arduino-UnoR4Minima-Arduino` skill
- For Arduino Uno R4 WiFi → use the `Arduino-UnoR4WiFi-TinyGo` skill
- For Arduino Uno R3 → use the `Arduino-UnoR3-TinyGo` skill
- For Arduino Nano → use the `Arduino-Nano-TinyGo` skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Renesas RA4M1 (R7FA4M1AB3CFM) |
| **Architecture** | 32-bit Arm Cortex-M4 |
| **Clock Speed** | 48 MHz |
| **Flash** | 256 kB |
| **SRAM** | 32 kB |
| **EEPROM** | 8 kB (data flash) |
| **USB** | USB-C (native USB) |
| **Operating Voltage** | 5V |
| **Input Voltage (VIN)** | 6–24V |
| **DC Current per I/O Pin** | 8 mA |
| **Dimensions** | 68.85 × 53.34 mm |
| **Digital I/O** | 14 (D0–D13) |
| **PWM Outputs** | 6 (D3, D5, D6, D9, D10, D11) |
| **Analog Inputs** | 6 (A0–A5, up to 14-bit ADC) |
| **DAC Output** | 1 (A0) |
| **CAN Bus** | 1 (requires external transceiver) |
| **Built-in LED** | D13 |

---

## Pinout Diagram

```
                              [USB-C]         [Barrel Jack]
                    ┌──────────────────────────────┐
                    │  RESET  IOREF  5V  GND  VIN  │ ← Power Header
                    │  3.3V   AREF   GND            │
                    ├──────────────────────────────┤
          SCL/A5 ──┤ A5                        D13 ├── SCK / Built-in LED
          SDA/A4 ──┤ A4                        D12 ├── CIPO (MISO)
              A3 ──┤ A3                       ~D11 ├── COPI (MOSI) / PWM
              A2 ──┤ A2                       ~D10 ├── CS (SS) / PWM
              A1 ──┤ A1                        ~D9 ├── PWM
          DAC/A0 ──┤ A0                         D8 ├──
                    │                               │
                    │        [Renesas RA4M1]        │
                    │                               │
                    │                          D7 ├──
                    │                         ~D6 ├── PWM
                    │                         ~D5 ├── PWM
                    │                          D4 ├──
                    │                         ~D3 ├── PWM / INT1
                    │                          D2 ├── INT0
           TX ─────┤ D1                        D1 ├── TX
           RX ─────┤ D0                        D0 ├── RX
                    ├──────────────────────────────┤
                    │          [ICSP]               │
                    └──────────────────────────────┘

  ~ = PWM capable    INT = External interrupt
  CAN TX/RX available on dedicated header (requires transceiver)
```

---

## Pin Reference Table

| Pin | Digital | Analog | PWM | Interrupt | SPI | I2C | UART | Other |
|-----|---------|--------|-----|-----------|-----|-----|------|-------|
| D0  | ✓       | —      | —   | —         | —   | —   | **RX** | — |
| D1  | ✓       | —      | —   | —         | —   | —   | **TX** | — |
| D2  | ✓       | —      | —   | **INT0**  | —   | —   | —    | — |
| D3  | ✓       | —      | ✓   | **INT1**  | —   | —   | —    | — |
| D4  | ✓       | —      | —   | —         | —   | —   | —    | — |
| D5  | ✓       | —      | ✓   | —         | —   | —   | —    | — |
| D6  | ✓       | —      | ✓   | —         | —   | —   | —    | — |
| D7  | ✓       | —      | —   | —         | —   | —   | —    | — |
| D8  | ✓       | —      | —   | —         | —   | —   | —    | — |
| D9  | ✓       | —      | ✓   | —         | —   | —   | —    | — |
| D10 | ✓       | —      | ✓   | —         | **CS** | — | —  | — |
| D11 | ✓       | —      | ✓   | —         | **COPI** | — | — | — |
| D12 | ✓       | —      | —   | —         | **CIPO** | — | — | — |
| D13 | ✓       | —      | —   | —         | **SCK** | — | —  | Built-in LED |
| A0  | ✓       | ADC0   | —   | —         | —   | —   | —    | **DAC** |
| A1  | ✓       | ADC1   | —   | —         | —   | —   | —    | — |
| A2  | ✓       | ADC2   | —   | —         | —   | —   | —    | — |
| A3  | ✓       | ADC3   | —   | —         | —   | —   | —    | — |
| A4  | ✓       | ADC4   | —   | —         | —   | **SDA** | — | — |
| A5  | ✓       | ADC5   | —   | —         | —   | **SCL** | — | — |

### Power Pins

| Pin | Function |
|-----|----------|
| VIN | Input voltage (6–24V) |
| 5V  | Regulated 5V output |
| 3.3V | Regulated 3.3V output |
| GND | Ground |
| AREF | Analog reference voltage |
| IOREF | I/O reference voltage |
| RESET | Reset (active LOW) |

---

## TinyGo Setup

### Target Name

```
arduino-uno-r4-minima
```

### Installation

1. Install TinyGo: https://tinygo.org/getting-started/install/
2. Verify the target is available:
   ```bash
   tinygo info -target=arduino-uno-r4-minima
   ```

### Build and Flash

```bash
# Build only
tinygo build -target=arduino-uno-r4-minima -o firmware.bin ./main.go

# Build and flash (board must be connected via USB-C)
tinygo flash -target=arduino-uno-r4-minima ./main.go

# Monitor serial output
tinygo monitor -target=arduino-uno-r4-minima
```

> **Note:** If the board is not detected, double-tap the reset button to enter bootloader mode. The board will appear as a USB mass storage device.

### TinyGo Support Status

- **Status:** Supported (check latest TinyGo release for current status)
- **GPIO:** Supported
- **ADC:** Supported (14-bit configurable)
- **DAC:** Check TinyGo release notes for current support
- **PWM:** Supported on D3, D5, D6, D9, D10, D11
- **I2C:** Supported (`machine.I2C0`)
- **SPI:** Supported (`machine.SPI0`)
- **UART:** Supported (`machine.UART0`)
- **USB CDC:** Supported (native USB)
- **CAN Bus:** Not yet supported in TinyGo
- **RTC:** Check TinyGo release notes for current support

### Known Limitations (TinyGo on RA4M1)

- **CAN Bus** — Not supported in TinyGo; use Arduino/C++ for CAN applications
- **HID (keyboard/mouse)** — May not be fully supported; check TinyGo release notes
- **14-bit ADC** — TinyGo may default to lower resolution; check `machine.ADCConfig`
- **DAC** — Support may be limited; verify with your TinyGo version
- **RTC** — Real-time clock support may be limited in TinyGo

### Example: Blink (TinyGo)

```go
package main

import (
    "machine"
    "time"
)

func main() {
    led := machine.D13 // Built-in LED
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

- **SDA:** A4
- **SCL:** A5
- **TinyGo bus:** `machine.I2C0`

```go
i2c := machine.I2C0
err := i2c.Configure(machine.I2CConfig{
    SDA:       machine.SDA_PIN, // A4
    SCL:       machine.SCL_PIN, // A5
    Frequency: 400000,          // 400 kHz fast mode
})
if err != nil {
    println("I2C init failed:", err)
}

// Write to device
data := []byte{0x00, 0x01}
i2c.Tx(0x3C, data, nil)

// Read from device
buf := make([]byte, 2)
i2c.Tx(0x3C, []byte{0x00}, buf)
```

### SPI

- **SCK:** D13
- **CIPO (MISO):** D12
- **COPI (MOSI):** D11
- **CS:** D10 (or any GPIO)
- **TinyGo bus:** `machine.SPI0`

```go
spi := machine.SPI0
err := spi.Configure(machine.SPIConfig{
    SCK:       machine.D13,
    SDO:       machine.D11, // COPI (MOSI)
    SDI:       machine.D12, // CIPO (MISO)
    Frequency: 4000000,     // 4 MHz
})
if err != nil {
    println("SPI init failed:", err)
}

cs := machine.D10
cs.Configure(machine.PinConfig{Mode: machine.PinOutput})
cs.High()

// Transfer data
cs.Low()
result := make([]byte, 1)
spi.Tx([]byte{0x00}, result)
cs.High()
```

### UART

- **TX:** D1
- **RX:** D0
- **TinyGo bus:** `machine.UART0`
- **USB Serial:** `machine.Serial` (USB CDC)

```go
// USB serial (for println / serial monitor)
// println() outputs to USB CDC by default

// Hardware UART on D0/D1
uart := machine.UART0
uart.Configure(machine.UARTConfig{
    TX:       machine.UART_TX_PIN, // D1
    RX:       machine.UART_RX_PIN, // D0
    BaudRate: 9600,
})
uart.Write([]byte("Hello from Uno R4 Minima\r\n"))
```

### Analog Read (ADC)

```go
adc := machine.ADC{Pin: machine.ADC0} // A0
adc.Configure(machine.ADCConfig{
    Resolution: 14, // Up to 14-bit on RA4M1 (check TinyGo support)
})
value := adc.Get() // Returns 16-bit scaled value
println("ADC:", value)
```

### DAC Output

```go
// DAC on A0 — check TinyGo support for RA4M1
// If supported:
// dac := machine.DAC{Pin: machine.A0}
// dac.Configure(machine.DACConfig{})
// dac.Set(32768) // Mid-range output (~2.5V at 5V reference)
```

> **Note:** DAC support on the RA4M1 in TinyGo may be limited. Check the latest TinyGo release notes.

---

## Power Management

### Voltage and Current

- **Logic level:** 5V on all GPIO pins
- **Max current per pin:** 8 mA (lower than Uno R3's 20 mA!)
- **5V output:** From USB-C or regulated from VIN
- **3.3V output:** From onboard regulator
- **VIN range:** 6–24V (wider than Uno R3)

### ⚠ 5V Logic Level Warning

The Arduino Uno R4 Minima operates at **5V logic**. This is different from 3.3V boards (XIAO, ESP32, etc.):

- **Do NOT connect 3.3V sensors/devices directly** without level shifting
- **Do NOT connect R4 outputs to 3.3V device inputs** — the 5V signal can damage them
- Use a **bidirectional level shifter** for I2C/SPI/GPIO between 5V and 3.3V devices

### ⚠ Lower Current per Pin

The Uno R4 Minima has a **maximum of 8 mA per GPIO pin** — significantly lower than the Uno R3's 20 mA:

- **Do NOT drive LEDs directly** without a current-limiting resistor (use 470Ω–1kΩ for standard LEDs)
- **Do NOT drive motors or relays directly** — use a transistor/MOSFET driver
- Consider using a buffer IC (e.g., 74HC245) for driving multiple loads

### Low Power

The RA4M1 supports low-power modes, but TinyGo support may be limited:

```go
// TinyGo low-power support on RA4M1 is evolving
// Check latest TinyGo release notes for sleep mode support
// For production low-power applications, consider Arduino/C++
```

---

## Special Features

- **First 32-bit Uno** — Arm Cortex-M4 at 48 MHz (3× faster than ATmega328P)
- **14-bit ADC** — Configurable resolution (up to 14-bit vs 10-bit on R3)
- **12-bit DAC on A0** — True analog output (not available on R3)
- **CAN Bus** — Hardware CAN support (requires external transceiver like MCP2551)
- **Real-Time Clock (RTC)** — Built-in RTC with VRTC pin for battery backup
- **HID support** — Native USB allows keyboard/mouse emulation
- **USB-C connector** — Modern connector (vs USB-B on R3)
- **24V VIN support** — Wider input voltage range than R3 (6–24V vs 7–12V)
- **Uno R3 shield compatible** — Same header layout as Uno R3

---

## Common Gotchas / Notes

1. **5V logic** — All GPIO pins are 5V; use level shifters when connecting to 3.3V devices
2. **8 mA per pin** — Much lower than Uno R3's 20 mA; use drivers for LEDs and loads
3. **D0/D1 shared with UART** — External devices on D0/D1 conflict with serial communication
4. **D13 LED flickers during SPI** — Built-in LED shares the SPI SCK pin
5. **CAN not in TinyGo** — CAN bus requires Arduino/C++ framework
6. **DAC only on A0** — Only one DAC output pin available
7. **TinyGo support evolving** — Some RA4M1 features may not be fully supported yet; check release notes
8. **Double-tap reset for bootloader** — If upload fails, double-tap reset to enter bootloader mode
9. **Not all R3 shields compatible** — Shields that draw >8 mA per pin may not work correctly
10. **USB-C cable matters** — Use a data-capable USB-C cable (not charge-only)

---

## Reference Links

- **Arduino Uno R4 Minima docs:** https://docs.arduino.cc/hardware/uno-r4-minima/
- **TinyGo target docs:** https://tinygo.org/docs/reference/microcontrollers/arduino-uno-r4-minima/
- **Renesas RA4M1 datasheet:** https://www.renesas.com/us/en/document/dst/ra4m1-group-datasheet
- **Pinout PDF:** https://docs.arduino.cc/resources/pinouts/ABX00080-full-pinout.pdf
- **Datasheet:** https://docs.arduino.cc/resources/datasheets/ABX00080-datasheet.pdf
