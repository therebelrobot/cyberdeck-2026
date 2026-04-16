---
name: arduino-unor4wifi-tinygo
description: >
  Provides comprehensive pinout reference, board specifications, and TinyGo development guide
  for the Arduino Uno R4 WiFi (Renesas RA4M1 + ESP32-S3) microcontroller. Use when writing TinyGo
  firmware for the Arduino Uno R4 WiFi, wiring peripherals, or configuring pins. Keywords: Arduino,
  Uno, R4, WiFi, RA4M1, ESP32-S3, Renesas, Cortex-M4, TinyGo, pinout, GPIO, I2C, SPI, UART, DAC,
  CAN, WiFi, BLE, Bluetooth, LED matrix, Qwiic, analog, digital, PWM, 5V, 32-bit, USB-C.
---

# Arduino Uno R4 WiFi — TinyGo Development Guide

Provides comprehensive reference for developing TinyGo firmware for the Arduino Uno R4 WiFi (Renesas RA4M1 + ESP32-S3).

## When to Use

- Writing TinyGo firmware targeting the Arduino Uno R4 WiFi
- Looking up Arduino Uno R4 WiFi pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the Arduino Uno R4 WiFi and need GPIO reference
- Configuring I2C, SPI, UART, DAC, or CAN on the Arduino Uno R4 WiFi in TinyGo

## When NOT to Use

- For Arduino/C++ development on the Uno R4 WiFi → use the `Arduino-UnoR4WiFi-Arduino` skill
- For Arduino Uno R4 Minima → use the `Arduino-UnoR4Minima-TinyGo` skill
- For Arduino Uno R3 → use the `Arduino-UnoR3-TinyGo` skill
- For Arduino Nano → use the `Arduino-Nano-TinyGo` skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **Main MCU** | Renesas RA4M1 (Arm Cortex-M4) |
| **Radio Module** | ESP32-S3-MINI-1-N8 |
| **Architecture** | 32-bit Arm Cortex-M4 (RA4M1) + Xtensa LX7 (ESP32-S3) |
| **Clock Speed** | 48 MHz (RA4M1) / up to 240 MHz (ESP32-S3) |
| **RA4M1 Flash** | 256 kB |
| **RA4M1 SRAM** | 32 kB |
| **ESP32-S3 ROM** | 384 kB |
| **ESP32-S3 SRAM** | 512 kB |
| **USB** | USB-C (native USB) |
| **Operating Voltage** | 5V (RA4M1) / 3.3V (ESP32-S3) |
| **Input Voltage (VIN)** | 6–24V |
| **DC Current per I/O Pin** | 8 mA |
| **WiFi** | 802.11 b/g/n (2.4 GHz) via ESP32-S3 |
| **Bluetooth** | BLE 5.0 via ESP32-S3 |
| **LED Matrix** | 12×8 (96 LEDs) built-in |
| **Dimensions** | 68.85 × 53.34 mm |
| **Digital I/O** | 14 (D0–D13) |
| **PWM Outputs** | 6 (D3, D5, D6, D9, D10, D11) |
| **Analog Inputs** | 6 (A0–A5, up to 14-bit ADC) |
| **DAC Output** | 1 (A0) |
| **CAN Bus** | 1 (requires external transceiver) |
| **Qwiic/STEMMA QT** | 1 (secondary I2C, 3.3V) |
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
                    │  [RA4M1]    [12×8 LED Matrix] │
                    │  [ESP32-S3]   [Qwiic I2C]    │
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
                    │    [ICSP]    [ESP32 Header]   │
                    └──────────────────────────────┘

  ~ = PWM capable    INT = External interrupt
  CAN TX/RX on dedicated header    Qwiic = secondary I2C (3.3V)
  ⚠ ESP32 header near USB-C is 3.3V only
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

### Additional Interfaces

| Interface | Pins / Notes |
|-----------|-------------|
| Qwiic I2C | Secondary I2C bus (IIC0) — **3.3V only** — use `Wire1` |
| CAN Bus | CAN TX/RX on dedicated header (requires external transceiver) |
| LED Matrix | 12×8 (96 LEDs) — controlled via internal I2C to LED driver |
| ESP32-S3 Header | Near USB-C — **3.3V only, do NOT connect 5V** |

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

> **⚠ TinyGo support for the Arduino Uno R4 WiFi may not be available yet.** The RA4M1 MCU target exists (`arduino-uno-r4-minima`), but the WiFi variant with ESP32-S3 co-processor may not have a dedicated TinyGo target. Check the latest TinyGo release notes.

```
arduino-uno-r4-minima
```

> **Note:** You may be able to use the `arduino-uno-r4-minima` target for basic GPIO/I2C/SPI/UART on the RA4M1, but WiFi, BLE, and LED matrix features (which require the ESP32-S3) will NOT be available through TinyGo.

### Installation

1. Install TinyGo: https://tinygo.org/getting-started/install/
2. Check if the target is available:
   ```bash
   tinygo info -target=arduino-uno-r4-minima
   ```

### Build and Flash

```bash
# Build only (using the R4 Minima target)
tinygo build -target=arduino-uno-r4-minima -o firmware.bin ./main.go

# Build and flash
tinygo flash -target=arduino-uno-r4-minima ./main.go

# Monitor serial output
tinygo monitor -target=arduino-uno-r4-minima
```

> **Note:** If the board is not detected, double-tap the reset button to enter bootloader mode.

### TinyGo Support Status

- **Status:** Partial — RA4M1 GPIO/peripherals may work; ESP32-S3 features unavailable
- **GPIO:** Supported (RA4M1 pins)
- **ADC:** Supported (14-bit configurable)
- **DAC:** Check TinyGo release notes
- **PWM:** Supported on D3, D5, D6, D9, D10, D11
- **I2C:** Supported (`machine.I2C0`) — main bus on A4/A5
- **SPI:** Supported (`machine.SPI0`)
- **UART:** Supported (`machine.UART0`)
- **USB CDC:** Supported (native USB)
- **WiFi:** ❌ Not available in TinyGo (requires ESP32-S3)
- **BLE:** ❌ Not available in TinyGo (requires ESP32-S3)
- **LED Matrix:** ❌ Not available in TinyGo (requires ESP32-S3 communication)
- **CAN Bus:** Not yet supported in TinyGo
- **Qwiic I2C:** May work as `machine.I2C1` — check TinyGo support

### Known Limitations (TinyGo on R4 WiFi)

- **No WiFi/BLE** — The ESP32-S3 handles wireless; TinyGo targets the RA4M1 only
- **No LED Matrix** — The 12×8 LED matrix is controlled via the ESP32-S3
- **No Qwiic guarantee** — The secondary I2C bus (Wire1/Qwiic) may not be mapped in TinyGo
- **CAN Bus** — Not supported in TinyGo
- **For WiFi/BLE/LED matrix** — Use the Arduino/C++ framework instead (`Arduino-UnoR4WiFi-Arduino` skill)

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

### I2C (Main Bus)

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

### I2C (Qwiic — Secondary Bus)

- **Qwiic connector:** Secondary I2C bus at **3.3V only**
- **TinyGo bus:** `machine.I2C1` (if supported)

> **⚠ Warning:** The Qwiic connector operates at **3.3V**. Do NOT connect 5V I2C devices to the Qwiic port. TinyGo support for the secondary I2C bus may be limited.

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

cs.Low()
result := make([]byte, 1)
spi.Tx([]byte{0x00}, result)
cs.High()
```

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
uart.Write([]byte("Hello from Uno R4 WiFi\r\n"))
```

### Analog Read (ADC)

```go
adc := machine.ADC{Pin: machine.ADC0} // A0
adc.Configure(machine.ADCConfig{
    Resolution: 14, // Up to 14-bit on RA4M1
})
value := adc.Get() // Returns 16-bit scaled value
println("ADC:", value)
```

---

## Power Management

### Voltage and Current

- **Logic level:** 5V on RA4M1 GPIO pins; **3.3V on ESP32-S3 and Qwiic**
- **Max current per pin:** 8 mA
- **5V output:** From USB-C or regulated from VIN
- **3.3V output:** From onboard regulator
- **VIN range:** 6–24V

### ⚠ Mixed Voltage Warning

The Uno R4 WiFi has **two voltage domains**:

- **5V:** All standard Arduino header pins (D0–D13, A0–A5)
- **3.3V:** ESP32-S3 header near USB-C and Qwiic connector

**Do NOT connect 5V signals to the ESP32-S3 header or Qwiic connector** — this will damage the ESP32-S3.

### ⚠ Lower Current per Pin

The Uno R4 WiFi has a **maximum of 8 mA per GPIO pin**:

- Use current-limiting resistors for LEDs (470Ω–1kΩ)
- Use transistor/MOSFET drivers for motors and relays

---

## Special Features

- **WiFi 802.11 b/g/n** — Via ESP32-S3 (not accessible from TinyGo)
- **BLE 5.0** — Via ESP32-S3 (not accessible from TinyGo)
- **12×8 LED Matrix** — 96 programmable LEDs (not accessible from TinyGo)
- **Qwiic/STEMMA QT connector** — Secondary I2C at 3.3V for easy sensor connection
- **14-bit ADC** — Configurable resolution
- **12-bit DAC on A0** — True analog output
- **CAN Bus** — Hardware CAN (requires external transceiver)
- **RTC** — Built-in real-time clock
- **HID support** — Native USB keyboard/mouse emulation
- **USB-C** — Modern connector with native USB
- **Uno R3 shield compatible** — Same header layout

> **For WiFi, BLE, and LED matrix features, use the Arduino/C++ framework** — these require the ESP32-S3 co-processor which TinyGo cannot access.

---

## Common Gotchas / Notes

1. **No WiFi/BLE in TinyGo** — These features require the ESP32-S3; use Arduino/C++ instead
2. **No LED matrix in TinyGo** — The 12×8 matrix is controlled via ESP32-S3
3. **5V logic on headers** — Standard pins are 5V; use level shifters for 3.3V devices
4. **3.3V on Qwiic/ESP32 header** — Do NOT connect 5V to these interfaces
5. **8 mA per pin** — Lower than Uno R3; use drivers for loads
6. **D0/D1 shared with UART** — External devices conflict with serial
7. **D13 LED flickers during SPI** — Built-in LED shares SPI SCK
8. **Double-tap reset for bootloader** — If upload fails, double-tap reset
9. **USB-C cable matters** — Use a data-capable cable
10. **TinyGo target** — Use `arduino-uno-r4-minima` target; WiFi-specific target may not exist

---

## Reference Links

- **Arduino Uno R4 WiFi docs:** https://docs.arduino.cc/hardware/uno-r4-wifi/
- **TinyGo RA4M1 target:** https://tinygo.org/docs/reference/microcontrollers/arduino-uno-r4-minima/
- **Renesas RA4M1 datasheet:** https://www.renesas.com/us/en/document/dst/ra4m1-group-datasheet
- **ESP32-S3 datasheet:** https://www.espressif.com/sites/default/files/documentation/esp32-s3_datasheet_en.pdf
- **Pinout PDF:** https://docs.arduino.cc/resources/pinouts/ABX00087-full-pinout.pdf
- **Datasheet:** https://docs.arduino.cc/resources/datasheets/ABX00087-datasheet.pdf
