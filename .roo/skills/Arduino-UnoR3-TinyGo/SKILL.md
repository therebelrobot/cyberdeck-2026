---
name: arduino-unor3-tinygo
description: >
  Provides comprehensive pinout reference, board specifications, and TinyGo development guide
  for the Arduino Uno R3 (ATmega328P) microcontroller. Use when writing TinyGo firmware for the
  Arduino Uno R3, wiring peripherals, or configuring pins. Keywords: Arduino, Uno, R3, ATmega328P,
  AVR, TinyGo, pinout, GPIO, I2C, SPI, UART, analog, digital, PWM, 5V, 8-bit.
---

# Arduino Uno R3 — TinyGo Development Guide

Provides comprehensive reference for developing TinyGo firmware for the Arduino Uno R3 (ATmega328P).

## When to Use

- Writing TinyGo firmware targeting the Arduino Uno R3
- Looking up Arduino Uno R3 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the Arduino Uno R3 and need GPIO reference
- Configuring I2C, SPI, UART, or analog I/O on the Arduino Uno R3 in TinyGo

## When NOT to Use

- For Arduino/C++ development on the Uno R3 → use the `Arduino-UnoR3-Arduino` skill
- For Arduino Uno R4 boards → use the `Arduino-UnoR4Minima-TinyGo` or `Arduino-UnoR4WiFi-TinyGo` skill
- For Arduino Nano → use the `Arduino-Nano-TinyGo` skill
- For Arduino Mega 2560 → use the `Arduino-Mega2560-TinyGo` skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | ATmega328P |
| **Architecture** | 8-bit AVR |
| **Clock Speed** | 16 MHz |
| **Flash** | 32 KB (0.5 KB used by bootloader) |
| **SRAM** | 2 KB |
| **EEPROM** | 1 KB |
| **USB** | USB-B (via ATmega16U2 USB-serial) |
| **Operating Voltage** | 5V |
| **Input Voltage (VIN)** | 7–12V recommended (6–20V limit) |
| **DC Current per I/O Pin** | 20 mA |
| **DC Current for 3.3V Pin** | 50 mA |
| **Dimensions** | 68.6 × 53.4 mm |
| **Weight** | 25 g |
| **Digital I/O** | 14 (D0–D13) |
| **PWM Outputs** | 6 (D3, D5, D6, D9, D10, D11) |
| **Analog Inputs** | 6 (A0–A5, 10-bit ADC) |
| **Built-in LED** | D13 |

---

## Pinout Diagram

```
                              [USB-B]        [Barrel Jack]
                    ┌──────────────────────────────┐
                    │  RESET  IOREF  5V  GND  VIN  │ ← Power Header
                    │  3.3V   AREF   GND            │
                    ├──────────────────────────────┤
          SCL/A5 ──┤ A5                        D13 ├── SCK / Built-in LED
          SDA/A4 ──┤ A4                        D12 ├── MISO
              A3 ──┤ A3                       ~D11 ├── MOSI / PWM
              A2 ──┤ A2                       ~D10 ├── SS / PWM
              A1 ──┤ A1                        ~D9 ├── PWM
              A0 ──┤ A0                         D8 ├──
                    │                               │
                    │         [ATmega328P]          │
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

### Power Pins

| Pin | Function |
|-----|----------|
| VIN | Input voltage (7–12V recommended) |
| 5V  | Regulated 5V output |
| 3.3V | Regulated 3.3V output (50 mA max) |
| GND | Ground (3 pins) |
| AREF | Analog reference voltage |
| IOREF | I/O reference voltage |
| RESET | Reset (active LOW) |

---

## TinyGo Setup

### Target Name

```
arduino-uno
```

### Installation

1. Install TinyGo: https://tinygo.org/getting-started/install/
2. Install AVR toolchain (avr-gcc, avrdude) — required for AVR targets
3. Verify the target is available:
   ```bash
   tinygo info -target=arduino-uno
   ```

### Build and Flash

```bash
# Build only
tinygo build -target=arduino-uno -o firmware.hex ./main.go

# Build and flash (board must be connected via USB)
tinygo flash -target=arduino-uno ./main.go

# Monitor serial output
tinygo monitor -target=arduino-uno
```

### TinyGo Support Status

- **Status:** Supported (with AVR limitations)
- **GPIO:** Supported
- **ADC:** Supported (10-bit)
- **PWM:** Supported on D3, D5, D6, D9, D10, D11
- **I2C:** Supported (`machine.I2C0`)
- **SPI:** Supported (`machine.SPI0`)
- **UART:** Supported (`machine.UART0`)
- **USB CDC:** Not available (USB is handled by ATmega16U2)
- **Goroutines:** Limited — AVR has only 2 KB SRAM; avoid many goroutines
- **fmt package:** Not recommended — too large for 32 KB flash; use `println()` instead

### Known Limitations (AVR / TinyGo)

- **2 KB SRAM** — Very limited heap; avoid large allocations, slices, or maps
- **32 KB Flash** — Many standard library packages are too large; `fmt` alone can exceed flash
- **No hardware FPU** — Floating-point math is emulated and slow
- **No goroutine preemption** — Cooperative scheduling only
- **No USB CDC** — Serial communication goes through ATmega16U2; use `machine.UART0`
- **Interrupts** — Limited TinyGo interrupt support on AVR

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

// Transfer data
cs.Low()
result := make([]byte, 1)
spi.Tx([]byte{0x00}, result)
cs.High()
```

> **⚠ Warning:** D13 is shared between SPI SCK and the built-in LED. When using SPI, the LED will flicker during data transfers.

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
uart.Write([]byte("Hello from Arduino Uno R3\r\n"))
```

> **Note:** D0/D1 are shared with the USB-serial bridge (ATmega16U2). Using UART0 for external devices will conflict with serial upload/monitor. Disconnect external devices from D0/D1 before uploading.

### Analog Read (ADC)

```go
adc := machine.ADC{Pin: machine.ADC0} // A0
adc.Configure(machine.ADCConfig{
    Resolution: 10, // 10-bit (0–1023)
})
value := adc.Get() // Returns 16-bit scaled value
println("ADC:", value)
```

---

## Power Management

### Voltage and Current

- **Logic level:** 5V on all GPIO pins
- **Max current per pin:** 20 mA
- **Total current (all pins):** 200 mA max
- **5V output:** From USB or regulated from VIN
- **3.3V output:** 50 mA max (from onboard regulator)

### ⚠ 5V Logic Level Warning

The Arduino Uno R3 operates at **5V logic**. This is different from 3.3V boards (XIAO, ESP32, etc.):

- **Do NOT connect 3.3V sensors/devices directly** without level shifting
- **Do NOT connect Uno outputs to 3.3V device inputs** — the 5V signal can damage them
- Use a **bidirectional level shifter** (e.g., BSS138-based) for I2C/SPI/GPIO between 5V and 3.3V devices
- A simple **voltage divider** (e.g., 1kΩ + 2kΩ) works for unidirectional 5V→3.3V signals

### Low Power

The ATmega328P supports several sleep modes, but TinyGo has limited support:

```go
// TinyGo does not have full sleep mode support on AVR
// For low-power applications, consider using Arduino/C++ instead
// or direct register manipulation via volatile memory access
```

> **Note:** Classic AVR boards like the Uno R3 do not have sophisticated deep sleep support in TinyGo. For battery-powered low-power applications, consider the Arduino/C++ framework or a board with better TinyGo sleep support.

---

## Special Features

- **The classic reference board** — Most Arduino shields and tutorials target the Uno R3
- **Replaceable DIP-28 ATmega328P** — The MCU is socketed and can be swapped
- **ICSP header** — For direct AVR programming (bypassing bootloader)
- **Auto-reset** — Serial connection triggers reset for easy upload
- **Overcurrent protection** — Resettable polyfuse on USB
- **ATmega16U2 USB-serial bridge** — Dedicated chip for USB communication

---

## Common Gotchas / Notes

1. **5V logic** — All GPIO pins are 5V; use level shifters when connecting to 3.3V devices
2. **2 KB SRAM** — Extremely limited; avoid large buffers, strings, or many goroutines in TinyGo
3. **32 KB Flash** — Many Go standard library packages won't fit; use `println()` instead of `fmt.Println()`
4. **D0/D1 shared with USB-serial** — External UART devices on D0/D1 conflict with programming/serial monitor
5. **D13 LED flickers during SPI** — The built-in LED is on the same pin as SPI SCK
6. **No USB CDC in TinyGo** — Serial goes through ATmega16U2; `println()` outputs to hardware UART
7. **10-bit ADC only** — Analog resolution is 10-bit (0–1023), not 12-bit or 14-bit like newer boards
8. **No DAC** — No analog output capability; use PWM for pseudo-analog output
9. **No wireless** — No WiFi or Bluetooth; use external modules (ESP8266, HC-05) if needed
10. **Bootloader uses 0.5 KB** — Actual available flash is ~31.5 KB

---

## Reference Links

- **Arduino Uno R3 docs:** https://docs.arduino.cc/hardware/uno-rev3/
- **TinyGo target docs:** https://tinygo.org/docs/reference/microcontrollers/arduino-uno/
- **ATmega328P datasheet:** https://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-7810-Automotive-Microcontrollers-ATmega328P_Datasheet.pdf
- **Pinout PDF:** https://docs.arduino.cc/resources/pinouts/A000066-full-pinout.pdf
- **Schematic:** https://docs.arduino.cc/resources/datasheets/A000066-datasheet.pdf
