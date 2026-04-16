---
name: xiao-esp32c3-tinygo
description: >
  Provides comprehensive pinout reference, board specifications, and TinyGo development guide
  for the Seeed Studio XIAO ESP32-C3 microcontroller. Use when writing TinyGo firmware for the
  XIAO ESP32-C3, wiring peripherals, or configuring pins. Keywords: XIAO, ESP32-C3, TinyGo,
  Espressif, RISC-V, WiFi, BLE, Bluetooth, pinout, GPIO, I2C, SPI, UART, analog, digital,
  PWM, battery, deep sleep, antenna.
---

# XIAO ESP32-C3 — TinyGo Development Guide

Provides comprehensive reference for developing TinyGo firmware for the Seeed Studio XIAO ESP32-C3.

## When to Use

- Writing TinyGo firmware targeting the XIAO ESP32-C3
- Looking up XIAO ESP32-C3 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO ESP32-C3 and need GPIO reference
- Configuring I2C, SPI, UART, WiFi, or analog I/O on the XIAO ESP32-C3 in TinyGo

## When NOT to Use

- For Arduino/C++ development on the XIAO ESP32-C3 → use the `XIAO-ESP32C3-Arduino` skill
- For other XIAO boards (SAMD21, RP2040, nRF52840) → use the corresponding board skill
- For other ESP32 variants (ESP32-S3, ESP32-C6) → use the corresponding board skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Espressif ESP32-C3 |
| **Architecture** | 32-bit RISC-V single-core |
| **Clock Speed** | Up to 160 MHz |
| **Flash** | 4 MB onboard |
| **RAM** | 400 KB SRAM |
| **Wireless** | WiFi 802.11 b/g/n (2.4 GHz), Bluetooth 5.0 (BLE), Bluetooth Mesh |
| **USB** | USB Type-C |
| **Operating Voltage** | 3.3V MCU / 5V input |
| **Max 3.3V Output** | 500 mA |
| **Dimensions** | 21 × 17.8 mm |
| **Working Temp** | -40°C to 85°C |
| **GPIO Count** | 11 digital/PWM, 4 analog/ADC |
| **Deep Sleep** | ~44 μA |
| **WiFi Active** | ~75 mA |
| **Antenna** | External U.FL antenna (included) |
| **Battery** | Supports LiPo charge/discharge (3.7V BAT input) |

---

## Pinout Diagram

```
                      [USB-C]
                ┌───────────────┐
      D0/A0   ──┤ 1          14 ├── 5V
      D1/A1   ──┤ 2          13 ├── GND
      D2/A2   ──┤ 3          12 ├── 3V3
      D3/A3   ──┤ 4          11 ├── D10/MOSI
    D4/SDA    ──┤ 5          10 ├── D9/MISO
    D5/SCL    ──┤ 6           9 ├── D8/SCK
     D6/TX    ──┤ 7           8 ├── D7/RX
                └───────────────┘
         Bottom pads: GND, RST, BAT+, BAT-
         U.FL antenna connector on top edge
```

---

## Pin Reference Table

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|--------|-----|-----|-----|------|-------|
| D0  | GPIO2    | ✓       | ADC1_2 | ✓   | —   | —   | —    | **⚠ Strapping** |
| D1  | GPIO3    | ✓       | ADC1_3 | ✓   | —   | —   | —    | — |
| D2  | GPIO4    | ✓       | ADC1_4 | ✓   | —   | —   | —    | MTMS/JTAG |
| D3  | GPIO5    | ✓       | ADC2_0 | ✓   | —   | —   | —    | MTDI/JTAG |
| D4  | GPIO6    | ✓       | —      | ✓   | **SDA** | — | —  | MTCK/JTAG |
| D5  | GPIO7    | ✓       | —      | ✓   | **SCL** | — | —  | MTDO/JTAG |
| D6  | GPIO21   | ✓       | —      | ✓   | —   | —   | **TX** | — |
| D7  | GPIO20   | ✓       | —      | ✓   | —   | —   | **RX** | — |
| D8  | GPIO8    | ✓       | —      | ✓   | —   | **SCK** | — | **⚠ Strapping** |
| D9  | GPIO9    | ✓       | —      | ✓   | —   | **MISO** | — | **⚠ Strapping/Boot** |
| D10 | GPIO10   | ✓       | —      | ✓   | —   | **MOSI** | — | FSPICS0 |

### Strapping Pins Warning

| Pin | GPIO | Boot Effect |
|-----|------|-------------|
| D0  | GPIO2 | Must be floating or HIGH at boot |
| D8  | GPIO8 | Must be HIGH at boot (has internal pull-up) |
| D9  | GPIO9 | Boot button — LOW enters download mode |

**⚠ Do NOT place external pull-downs on D0, D8, or D9** — this can prevent the board from booting.

### Internal / Special Pins

| Name | Chip Pin | Description |
|------|----------|-------------|
| Reset | CHIP_EN | Enable/Reset |
| Boot | GPIO9 | Enter bootloader (same as D9) |
| U.FL Antenna | LNA_IN | External antenna connector |
| CHG LED | VCC_3V3 | Charge indicator |

> **Note:** There is NO built-in user LED on the XIAO ESP32-C3. `LED_BUILTIN` is not available.

---

## TinyGo Setup

### Target Name

```
xiao-esp32c3
```

### Installation

1. Install TinyGo: https://tinygo.org/getting-started/install/
2. Verify the target is available:
   ```bash
   tinygo info -target=xiao-esp32c3
   ```

### Build and Flash

```bash
# Build only
tinygo build -target=xiao-esp32c3 -o firmware.bin ./main.go

# Build and flash via USB serial
tinygo flash -target=xiao-esp32c3 ./main.go

# Enter bootloader mode (if needed): hold BOOT (D9), press RESET, release BOOT
```

### TinyGo Support Status

- **Status:** Supported (ESP32-C3 RISC-V)
- **USB CDC:** Supported (serial over USB)
- **ADC:** Supported on D0–D3 (ADC1 channels)
- **PWM:** Supported on all 11 digital pins
- **I2C:** Supported (machine.I2C0)
- **SPI:** Supported (machine.SPI0)
- **UART:** Supported (machine.UART0)
- **WiFi:** Limited support — check latest TinyGo release notes
- **BLE:** Limited support — check latest TinyGo release notes
- **Deep Sleep:** Limited support

> **Important:** TinyGo WiFi and BLE support on ESP32-C3 is evolving. For full WiFi/BLE functionality, consider using Arduino/ESP-IDF instead.

### Example: Blink External LED (TinyGo)

```go
package main

import (
    "machine"
    "time"
)

func main() {
    // No built-in LED — use an external LED on D0
    led := machine.D0 // GPIO2
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

- **SDA:** D4 (GPIO6)
- **SCL:** D5 (GPIO7)
- **TinyGo bus:** `machine.I2C0`

```go
i2c := machine.I2C0
err := i2c.Configure(machine.I2CConfig{
    SDA:       machine.SDA_PIN, // D4 / GPIO6
    SCL:       machine.SCL_PIN, // D5 / GPIO7
    Frequency: 400000,          // 400 kHz
})
if err != nil {
    println("I2C init failed:", err)
}
```

### SPI

- **SCK:** D8 (GPIO8)
- **MISO:** D9 (GPIO9)
- **MOSI:** D10 (GPIO10)
- **TinyGo bus:** `machine.SPI0`

```go
spi := machine.SPI0
err := spi.Configure(machine.SPIConfig{
    SCK:       machine.SPI0_SCK_PIN,  // D8 / GPIO8
    SDO:       machine.SPI0_SDO_PIN,  // D10 / GPIO10 (MOSI)
    SDI:       machine.SPI0_SDI_PIN,  // D9 / GPIO9 (MISO)
    Frequency: 4000000,               // 4 MHz
})
if err != nil {
    println("SPI init failed:", err)
}
```

> **⚠ Warning:** D8 (GPIO8) and D9 (GPIO9) are strapping pins. SPI devices connected to these pins must not pull them LOW during boot.

### UART

- **TX:** D6 (GPIO21)
- **RX:** D7 (GPIO20)
- **TinyGo bus:** `machine.UART0`

```go
uart := machine.UART0
uart.Configure(machine.UARTConfig{
    TX:       machine.UART_TX_PIN, // D6 / GPIO21
    RX:       machine.UART_RX_PIN, // D7 / GPIO20
    BaudRate: 115200,
})
uart.Write([]byte("Hello from XIAO ESP32-C3\r\n"))
```

### Analog Read (ADC)

```go
adc := machine.ADC{Pin: machine.A0} // D0 / GPIO2
adc.Configure(machine.ADCConfig{})
value := adc.Get() // Returns 16-bit scaled value
```

> **Note:** Only D0–D3 support analog input. D3 (GPIO5/ADC2) may give unreliable readings; prefer D0–D2 (ADC1 channels).

### WiFi (TinyGo)

```go
// WiFi support on ESP32-C3 in TinyGo is evolving.
// Check https://tinygo.org for current status.
// For production WiFi applications, consider Arduino/ESP-IDF.
```

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **5V output:** From USB VBUS
- **3.3V output:** Up to 500 mA
- **WiFi active:** ~75 mA
- **Deep sleep:** ~44 μA

### Battery Support

- **Battery pad:** Solder LiPo battery to BAT+ and BAT- pads on the bottom
- **Charge LED:** Indicates charging status
- **Input:** 3.7V LiPo battery

### Deep Sleep

The ESP32-C3 supports deep sleep with ~44 μA current draw:

```go
// Deep sleep support in TinyGo for ESP32-C3 is limited.
// For full deep sleep with wake-up sources, consider Arduino/ESP-IDF.

// Wake-up sources supported by hardware:
// - Timer wake-up
// - GPIO wake-up (D0–D3 only)
```

> **Note:** Deep sleep wake-up is supported on D0–D3 only.

---

## Common Gotchas / Notes

1. **No built-in LED** — There is no user LED on the XIAO ESP32-C3; `LED_BUILTIN` is not available
2. **Strapping pins** — D0 (GPIO2), D8 (GPIO8), D9 (GPIO9) affect boot mode; do NOT pull them LOW externally
3. **D9 is the Boot button** — Holding D9 LOW during reset enters download mode
4. **Only 4 analog pins** — D0–D3 have ADC; D4–D10 are digital only
5. **ADC2 unreliable** — D3 (GPIO5/ADC2_CH0) may give unreliable readings; prefer D0–D2 (ADC1)
6. **External antenna** — Uses U.FL connector; the included antenna must be connected for WiFi/BLE
7. **WiFi/BLE in TinyGo** — Support is evolving; for production WiFi/BLE, consider Arduino/ESP-IDF
8. **JTAG on D2–D5** — These pins double as JTAG (MTMS, MTDI, MTCK, MTDO); avoid conflicts during debugging
9. **Deep sleep wake** — Only D0–D3 support deep sleep wake-up
10. **3.3V logic only** — Do NOT connect 5V signals directly to GPIO pins

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/XIAO_ESP32C3_Getting_Started/
- **TinyGo target docs:** https://tinygo.org/docs/reference/microcontrollers/xiao-esp32c3/
- **ESP32-C3 datasheet:** https://www.espressif.com/sites/default/files/documentation/esp32-c3_datasheet_en.pdf
- **Schematic:** https://files.seeedstudio.com/wiki/XIAO_WiFi/Resources/Seeed-Studio-XIAO-ESP32C3-v1.2.pdf
