---
name: arduino-nano-tinygo
description: >
  Provides comprehensive pinout reference, board specifications, and TinyGo development guide
  for the Arduino Nano (ATmega328P) microcontroller. Use when writing TinyGo firmware for the
  Arduino Nano, wiring peripherals, or configuring pins. Keywords: Arduino, Nano, ATmega328P,
  AVR, TinyGo, pinout, GPIO, I2C, SPI, UART, analog, digital, PWM, 5V, 8-bit, breadboard,
  Mini-B USB, compact.
---

# Arduino Nano — TinyGo Development Guide

Provides comprehensive reference for developing TinyGo firmware for the Arduino Nano (ATmega328P).

## When to Use

- Writing TinyGo firmware targeting the Arduino Nano
- Looking up Arduino Nano pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the Arduino Nano and need GPIO reference
- Configuring I2C, SPI, UART, or analog I/O on the Arduino Nano in TinyGo

## When NOT to Use

- For Arduino/C++ development on the Nano → use the `Arduino-Nano-Arduino` skill
- For Arduino Uno R3 → use the `Arduino-UnoR3-TinyGo` skill (same MCU, different form factor)
- For Arduino Mega 2560 → use the `Arduino-Mega2560-TinyGo` skill
- For Arduino Nano Every, Nano 33, or Nano ESP32 → these are different boards

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | ATmega328P |
| **Architecture** | 8-bit AVR |
| **Clock Speed** | 16 MHz |
| **Flash** | 32 KB (2 KB used by bootloader) |
| **SRAM** | 2 KB |
| **EEPROM** | 1 KB |
| **USB** | Mini-B USB |
| **Operating Voltage** | 5V |
| **Input Voltage (VIN)** | 7–12V recommended |
| **DC Current per I/O Pin** | 20 mA |
| **Dimensions** | 45 × 18 mm |
| **Weight** | 7 g |
| **Digital I/O** | 14 (D0–D13) |
| **PWM Outputs** | 6 (D3, D5, D6, D9, D10, D11) |
| **Analog Inputs** | 8 (A0–A7; A6/A7 are analog-only) |
| **Built-in LED** | D13 |

---

## Pinout Diagram

```
                          [Mini-B USB]
                    ┌─────────────────────┐
                    │                     │
              D13 ──┤ D13           D12  ├── D12
             3.3V ──┤ 3V3           D11  ├── ~D11 / MOSI / PWM
             AREF ──┤ AREF          D10  ├── ~D10 / SS / PWM
           A0/D14 ──┤ A0            D9   ├── ~D9 / PWM
           A1/D15 ──┤ A1            D8   ├── D8
           A2/D16 ──┤ A2            D7   ├── D7
           A3/D17 ──┤ A3            D6   ├── ~D6 / PWM
       SDA/A4/D18 ──┤ A4            D5   ├── ~D5 / PWM
       SCL/A5/D19 ──┤ A5            D4   ├── D4
        A6 (analog) ┤ A6            D3   ├── ~D3 / PWM / INT1
        A7 (analog) ┤ A7            D2   ├── D2 / INT0
               5V ──┤ 5V            GND  ├── GND
            RESET ──┤ RST           RST  ├── RESET
              GND ──┤ GND           D0   ├── RX
              VIN ──┤ VIN           D1   ├── TX
                    │                     │
                    └─────────────────────┘

  ~ = PWM capable    INT = External interrupt
  A6/A7 = Analog input ONLY (no digital I/O)
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
| D10 | ✓       | —      | ✓   | —         | **SS** | — | —  | — |
| D11 | ✓       | —      | ✓   | —         | **MOSI** | — | — | — |
| D12 | ✓       | —      | —   | —         | **MISO** | — | — | — |
| D13 | ✓       | —      | —   | —         | **SCK** | — | —  | Built-in LED |
| A0  | ✓       | ADC0   | —   | —         | —   | —   | —    | — |
| A1  | ✓       | ADC1   | —   | —         | —   | —   | —    | — |
| A2  | ✓       | ADC2   | —   | —         | —   | —   | —    | — |
| A3  | ✓       | ADC3   | —   | —         | —   | —   | —    | — |
| A4  | ✓       | ADC4   | —   | —         | —   | **SDA** | — | — |
| A5  | ✓       | ADC5   | —   | —         | —   | **SCL** | — | — |
| A6  | **—**   | ADC6   | —   | —         | —   | —   | —    | **Analog only** |
| A7  | **—**   | ADC7   | —   | —         | —   | —   | —    | **Analog only** |

### Power Pins

| Pin | Function |
|-----|----------|
| VIN | Input voltage (7–12V recommended) |
| 5V  | Regulated 5V output |
| 3.3V | Regulated 3.3V output |
| GND | Ground |
| AREF | Analog reference voltage |
| RESET | Reset (active LOW) |

---

## TinyGo Setup

### Target Name

```
arduino-nano
```

### Installation

1. Install TinyGo: https://tinygo.org/getting-started/install/
2. Install AVR toolchain (avr-gcc, avrdude) — required for AVR targets
3. Verify the target is available:
   ```bash
   tinygo info -target=arduino-nano
   ```

### Build and Flash

```bash
# Build only
tinygo build -target=arduino-nano -o firmware.hex ./main.go

# Build and flash (board must be connected via USB)
tinygo flash -target=arduino-nano ./main.go

# Monitor serial output
tinygo monitor -target=arduino-nano
```

### TinyGo Support Status

- **Status:** Supported (with AVR limitations)
- **GPIO:** Supported
- **ADC:** Supported (10-bit)
- **PWM:** Supported on D3, D5, D6, D9, D10, D11
- **I2C:** Supported (`machine.I2C0`)
- **SPI:** Supported (`machine.SPI0`)
- **UART:** Supported (`machine.UART0`)
- **USB CDC:** Not available (USB is handled by FTDI/CH340 chip)
- **Goroutines:** Limited — AVR has only 2 KB SRAM; avoid many goroutines
- **fmt package:** Not recommended — too large for 32 KB flash; use `println()` instead

### Known Limitations (AVR / TinyGo)

- **2 KB SRAM** — Very limited heap; avoid large allocations, slices, or maps
- **32 KB Flash** — Many standard library packages are too large; `fmt` alone can exceed flash
- **30 KB usable** — Bootloader uses 2 KB (vs 0.5 KB on Uno R3)
- **No hardware FPU** — Floating-point math is emulated and slow
- **No goroutine preemption** — Cooperative scheduling only
- **No USB CDC** — Serial goes through FTDI/CH340; use `machine.UART0`
- **A6/A7 analog only** — Cannot be used as digital I/O in TinyGo either

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
    Frequency: 100000,          // 100 kHz (standard mode)
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
- **MISO:** D12
- **MOSI:** D11
- **SS:** D10 (or any GPIO)
- **TinyGo bus:** `machine.SPI0`

```go
spi := machine.SPI0
err := spi.Configure(machine.SPIConfig{
    SCK:       machine.D13,
    SDO:       machine.D11, // MOSI
    SDI:       machine.D12, // MISO
    Frequency: 4000000,     // 4 MHz
})
if err != nil {
    println("SPI init failed:", err)
}

cs := machine.D10
cs.Configure(machine.PinConfig{Mode: machine.PinOutput})
cs.High()

cs.Low()
result := make([]byte, 1)
spi.Tx([]byte{0x00}, result)
cs.High()
```

> **⚠ Warning:** D13 is shared between SPI SCK and the built-in LED. The LED will flicker during SPI transfers.

### UART

- **TX:** D1
- **RX:** D0
- **TinyGo bus:** `machine.UART0`

```go
uart := machine.UART0
uart.Configure(machine.UARTConfig{
    TX:       machine.UART_TX_PIN, // D1
    RX:       machine.UART_RX_PIN, // D0
    BaudRate: 9600,
})
uart.Write([]byte("Hello from Arduino Nano\r\n"))
```

> **Note:** D0/D1 are shared with the USB-serial bridge. Disconnect external devices from D0/D1 before uploading.

### Analog Read (ADC)

```go
// Standard analog pins (A0–A5 also work as digital)
adc := machine.ADC{Pin: machine.ADC0} // A0
adc.Configure(machine.ADCConfig{
    Resolution: 10, // 10-bit (0–1023)
})
value := adc.Get() // Returns 16-bit scaled value
println("A0:", value)

// A6 and A7 — analog only (no digital capability)
adc6 := machine.ADC{Pin: machine.ADC6} // A6
adc6.Configure(machine.ADCConfig{})
value6 := adc6.Get()
println("A6:", value6)
```

---

## Power Management

### Voltage and Current

- **Logic level:** 5V on all GPIO pins
- **Max current per pin:** 20 mA
- **Total current (all pins):** 200 mA max
- **5V output:** From USB or regulated from VIN
- **3.3V output:** From onboard regulator

### ⚠ 5V Logic Level Warning

The Arduino Nano operates at **5V logic**. This is different from 3.3V boards (XIAO, ESP32, etc.):

- **Do NOT connect 3.3V sensors/devices directly** without level shifting
- **Do NOT connect Nano outputs to 3.3V device inputs** — the 5V signal can damage them
- Use a **bidirectional level shifter** for I2C/SPI/GPIO between 5V and 3.3V devices
- A simple **voltage divider** works for unidirectional 5V→3.3V signals

### Low Power

The ATmega328P supports sleep modes, but TinyGo has limited support:

```go
// TinyGo does not have full sleep mode support on AVR
// For low-power applications, consider using Arduino/C++ instead
```

> **Note:** The Nano's small form factor makes it popular for battery projects, but TinyGo lacks AVR sleep mode support. Use the Arduino/C++ framework for low-power applications.

---

## Special Features

- **Smallest classic Arduino** — 45 × 18 mm, breadboard-friendly with DIP pin headers
- **8 analog inputs** — 2 more than Uno R3 (A6 and A7 are analog-only)
- **Same ATmega328P as Uno R3** — Code compatible; same flash/SRAM/EEPROM
- **Breadboard-friendly** — Pin headers fit directly into standard breadboards
- **ICSP header** — For direct AVR programming
- **Mini-B USB** — Older connector style (not USB-C or USB-B)

---

## Common Gotchas / Notes

1. **5V logic** — All GPIO pins are 5V; use level shifters when connecting to 3.3V devices
2. **A6/A7 are analog-only** — Cannot be used as digital I/O; no `pinMode()`, no `digitalRead()`/`digitalWrite()`
3. **2 KB SRAM** — Extremely limited; avoid large buffers, strings, or many goroutines
4. **30 KB usable flash** — Bootloader uses 2 KB (more than Uno R3's 0.5 KB)
5. **D0/D1 shared with USB-serial** — External UART devices conflict with programming/serial monitor
6. **D13 LED flickers during SPI** — Built-in LED shares SPI SCK
7. **No USB CDC in TinyGo** — Serial goes through FTDI/CH340 chip
8. **10-bit ADC only** — Analog resolution is 10-bit (0–1023)
9. **No DAC** — No analog output; use PWM for pseudo-analog
10. **No wireless** — No WiFi or Bluetooth; use external modules if needed
11. **Mini-B USB cable** — Requires a Mini-B USB cable (not Micro-B or USB-C)
12. **Clone variations** — Many Nano clones use CH340 instead of FTDI; may need CH340 drivers

---

## Reference Links

- **Arduino Nano docs:** https://docs.arduino.cc/hardware/nano/
- **TinyGo target docs:** https://tinygo.org/docs/reference/microcontrollers/arduino-nano/
- **ATmega328P datasheet:** https://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-7810-Automotive-Microcontrollers-ATmega328P_Datasheet.pdf
- **Pinout PDF:** https://docs.arduino.cc/resources/pinouts/A000005-full-pinout.pdf
- **Datasheet:** https://docs.arduino.cc/resources/datasheets/A000005-datasheet.pdf
