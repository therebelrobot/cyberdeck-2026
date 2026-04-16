---
name: xiao-esp32c5-tinygo
description: >
  Provides comprehensive pinout reference, board specifications, and TinyGo development guide
  for the Seeed Studio XIAO ESP32-C5 microcontroller. Use when writing TinyGo firmware for the
  XIAO ESP32-C5, wiring peripherals, or configuring pins. Keywords: XIAO, ESP32-C5, TinyGo,
  Espressif, RISC-V, WiFi 6, dual-band, 5GHz, 2.4GHz, BLE 5.0, Bluetooth, pinout, GPIO, I2C,
  SPI, UART, analog, digital, PWM, battery, deep sleep, PSRAM, 8MB.
---

# XIAO ESP32-C5 — TinyGo Development Guide

Provides comprehensive reference for developing TinyGo firmware for the Seeed Studio XIAO ESP32-C5.

## When to Use

- Writing TinyGo firmware targeting the XIAO ESP32-C5
- Looking up XIAO ESP32-C5 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO ESP32-C5 and need GPIO reference
- Configuring I2C, SPI, UART, WiFi, or analog I/O on the XIAO ESP32-C5 in TinyGo

## When NOT to Use

- For Arduino/C++ development on the XIAO ESP32-C5 → use the `XIAO-ESP32C5-Arduino` skill
- For the XIAO ESP32-C3 (older single-band WiFi) → use the `XIAO-ESP32C3-TinyGo` skill
- For other XIAO boards → use the corresponding board skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Espressif ESP32-C5 |
| **Architecture** | 32-bit RISC-V single-core |
| **Clock Speed** | 240 MHz |
| **Flash** | 8 MB |
| **PSRAM** | 8 MB |
| **On-chip SRAM** | 384 KB |
| **On-chip ROM** | 320 KB |
| **Wireless** | WiFi 6 (802.11 a/b/g/n/ac/ax) dual-band 2.4 GHz + 5 GHz, BLE 5.0, Bluetooth Mesh |
| **USB** | USB Type-C |
| **Operating Voltage** | 3.3V logic |
| **Dimensions** | 21 × 17.8 mm |
| **GPIO Count** | 11 (all PWM-capable) |
| **Analog Pins** | 5 (D0 + JTAG pads) |
| **Battery Charge Chip** | SGM40567 |
| **Antenna** | External RF antenna (U.FL connector) |
| **Buttons** | 1× RESET, 1× BOOT (GPIO28) |

---

## Pinout Diagram

```
            XIAO ESP32-C5 (Top View)
                ┌─────────────────┐
                │    [USB-C]      │
       D0/A0 ──┤ GPIO1   GPIO12 ├── D7 (RX)
          D1 ──┤ GPIO0   GPIO11 ├── D6 (TX)
          D2 ──┤ GPIO25  GPIO24 ├── D5 (SCL)
          D3 ──┤ GPIO7   GPIO23 ├── D4 (SDA)
         GND ──┤                 ├── D10 (MOSI)
          5V ──┤                 ├── D9 (MISO)
         3V3 ──┤                 ├── D8 (SCK)
                └─────────────────┘
  Bottom pads: JTAG (MTDO/MTDI/MTCK/MTMS), Boot
  External antenna: U.FL connector
```

---

## Pin Reference Table

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|--------|-----|-----|-----|------|-------|
| D0  | GPIO1    | ✓       | ADC    | ✓   | —   | —   | —    | LP_UART_DSRN, LP_GPIO1 |
| D1  | GPIO0    | ✓       | —      | ✓   | —   | —   | —    | LP_UART_DTRN, LP_GPIO0 |
| D2  | GPIO25   | ✓       | —      | ✓   | —   | —   | —    | — |
| D3  | GPIO7    | ✓       | —      | ✓   | —   | —   | —    | SDIO_DATA1 |
| D4  | GPIO23   | ✓       | —      | ✓   | **SDA** | — | — | — |
| D5  | GPIO24   | ✓       | —      | ✓   | **SCL** | — | — | — |
| D6  | GPIO11   | ✓       | —      | ✓   | —   | —   | **TX** | — |
| D7  | GPIO12   | ✓       | —      | ✓   | —   | —   | **RX** | — |
| D8  | GPIO8    | ✓       | —      | ✓   | —   | **SCK** | — | TOUCH7 |
| D9  | GPIO9    | ✓       | —      | ✓   | —   | **MISO** | — | TOUCH8 |
| D10 | GPIO10   | ✓       | —      | ✓   | —   | **MOSI** | — | TOUCH9 |

### Bottom Pads (JTAG / Debug)

| Name | Chip Pin | Analog | Other |
|------|----------|--------|-------|
| MTDO | GPIO5    | —      | LP_UART_TXD, LP_GPIO5, JTAG |
| MTDI | GPIO3    | ADC    | LP_I2C_SCL, LP_GPIO3, JTAG |
| MTCK | GPIO4    | ADC    | LP_UART_RXD, LP_GPIO4, JTAG |
| MTMS | GPIO2    | ADC    | LP_I2C_SDA, LP_GPIO2, JTAG |
| ADC_BAT | GPIO6 | —      | Battery voltage measurement |
| ADC_CRL | GPIO26 | —     | Enable/disable battery measurement circuit |
| Boot | GPIO28   | —      | Enter Boot Mode |

### Internal / Special Pins

| Name | Chip Pin | Description |
|------|----------|-------------|
| USER_LED | GPIO27 | User LED (Yellow) |
| CHARGE_LED | VCC_3V3 | Charge LED (Red) |
| Boot | GPIO28 | Boot button |

---

## TinyGo Setup

### ⚠ TinyGo Support Status

**Status: Not yet available**

TinyGo does not currently have a target definition for the ESP32-C5. The ESP32-C5 is a newer Espressif chip and TinyGo support has not yet been added.

When support is added, the target name would likely be:

```
xiao-esp32c5
```

### What Would Be Needed

1. TinyGo would need to add LLVM support for the ESP32-C5 (RISC-V)
2. A machine package definition for the XIAO ESP32-C5 pin mappings
3. ESP-IDF integration for WiFi 6 and BLE 5.0 drivers
4. PSRAM support for the 8 MB external PSRAM

### Current Alternatives

- Use **Arduino IDE** with the ESP32 Arduino core (see `XIAO-ESP32C5-Arduino` skill)
- Use **ESP-IDF** for native development with full WiFi 6 support
- Use **PlatformIO** with the Espressif platform

### Expected Build and Flash Commands (Future)

```bash
# Build only (when supported)
tinygo build -target=xiao-esp32c5 -o firmware.bin ./main.go

# Build and flash via USB serial (when supported)
tinygo flash -target=xiao-esp32c5 ./main.go

# Enter bootloader mode (if needed): hold BOOT (GPIO28), press RESET, release BOOT
```

### Example: Blink LED (TinyGo — Future)

```go
package main

import (
    "machine"
    "time"
)

func main() {
    // USER_LED is GPIO27 (Yellow)
    led := machine.LED // Would map to GPIO27
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

- **SDA:** D4 (GPIO23)
- **SCL:** D5 (GPIO24)

```go
// When TinyGo support is available:
i2c := machine.I2C0
err := i2c.Configure(machine.I2CConfig{
    SDA:       machine.SDA_PIN, // D4 / GPIO23
    SCL:       machine.SCL_PIN, // D5 / GPIO24
    Frequency: 400000,          // 400 kHz
})
if err != nil {
    println("I2C init failed:", err)
}
```

### SPI (Future TinyGo API)

- **SCK:** D8 (GPIO8)
- **MISO:** D9 (GPIO9)
- **MOSI:** D10 (GPIO10)

```go
// When TinyGo support is available:
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

### UART (Future TinyGo API)

- **TX:** D6 (GPIO11)
- **RX:** D7 (GPIO12)

```go
// When TinyGo support is available:
uart := machine.UART0
uart.Configure(machine.UARTConfig{
    TX:       machine.UART_TX_PIN, // D6 / GPIO11
    RX:       machine.UART_RX_PIN, // D7 / GPIO12
    BaudRate: 115200,
})
uart.Write([]byte("Hello from XIAO ESP32-C5\r\n"))
```

### Analog Read (Future TinyGo API)

```go
// D0 (GPIO1) supports analog input on the edge pins
// Additional ADC channels on bottom JTAG pads (MTDI/GPIO3, MTCK/GPIO4, MTMS/GPIO2)
adc := machine.ADC{Pin: machine.A0} // D0 / GPIO1
adc.Configure(machine.ADCConfig{})
value := adc.Get() // Returns 16-bit scaled value
```

### WiFi 6 (Dual-Band)

The XIAO ESP32-C5 supports WiFi 6 (802.11ax) on both 2.4 GHz and 5 GHz bands. WiFi support in TinyGo for ESP32 chips is evolving:

```go
// WiFi 6 dual-band support on ESP32-C5 in TinyGo is not yet available.
// For production WiFi applications, use Arduino/ESP-IDF.
// Check https://tinygo.org for current status.
```

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **5V output:** From USB VBUS
- **Battery charge chip:** SGM40567

### Battery Support

- **Battery pad:** Solder LiPo battery to BAT+ and BAT- pads on the bottom
- **Charge LED:** Red LED indicates charging status
- **Battery voltage:** Read via ADC_BAT (GPIO6)
- **Battery measurement control:** ADC_CRL (GPIO26) enables/disables the measurement circuit

### Deep Sleep

```go
// Deep sleep support in TinyGo for ESP32-C5 is not yet available.
// The hardware supports:
// - Timer wake-up
// - GPIO wake-up
// - UART wake-up

// ⚠ JTAG pins (D4/D5/D6/D7 bottom pads — MTDO/MTDI/MTCK/MTMS)
// should NOT be used as deep sleep wake-up sources.
```

---

## Special Features

### First Dual-Band WiFi 6 XIAO

The XIAO ESP32-C5 is the first XIAO board with dual-band WiFi 6 support:
- **2.4 GHz** — Compatible with existing networks, better range
- **5 GHz** — Less interference, higher throughput
- **802.11ax (WiFi 6)** — Improved efficiency, OFDMA, Target Wake Time

### 8 MB PSRAM

Large external PSRAM (8 MB) enables memory-intensive applications like image processing, audio buffering, and large data structures.

### 8 MB Flash

Generous flash storage (8 MB) for firmware, file systems (SPIFFS/LittleFS), and OTA updates.

### RISC-V @ 240 MHz

The fastest RISC-V XIAO board at 240 MHz clock speed.

### Touch Pins

D8 (TOUCH7), D9 (TOUCH8), D10 (TOUCH9) support capacitive touch sensing.

### Low-Power Peripherals

The ESP32-C5 includes low-power (LP) peripherals:
- LP_UART on D0/D1 (and JTAG pads)
- LP_I2C on JTAG pads (MTDI/MTMS)
- LP_GPIO on D0/D1 and JTAG pads

### Security Features

- AES-128/256 hardware acceleration
- SHA family hardware acceleration
- HMAC
- Digital signature peripheral
- Secure Boot V2

---

## Common Gotchas / Notes

1. **TinyGo not yet supported** — The ESP32-C5 is not currently supported by TinyGo; use Arduino or ESP-IDF
2. **JTAG pin restrictions** — D4/D5/D6/D7 bottom pads (MTDO/MTDI/MTCK/MTMS) are JTAG pins; do not use as deep sleep wake-up sources
3. **External antenna only** — Uses U.FL connector; an external antenna must be connected for WiFi/BLE
4. **Limited analog pins on edges** — Only D0 (GPIO1) has ADC on the edge pins; additional ADC on bottom JTAG pads
5. **Boot button** — GPIO28 is the BOOT button; hold during reset to enter download mode
6. **Strapping pins** — Some GPIO pins affect boot behavior; check ESP32-C5 datasheet for strapping pin details
7. **SDIO on D3** — GPIO7 (D3) has SDIO_DATA1 alternate function; avoid conflicts if using SDIO
8. **Touch sensing** — D8/D9/D10 support capacitive touch but this may not be available in TinyGo
9. **3.3V logic only** — Do NOT connect 5V signals directly to GPIO pins
10. **WiFi 6 dual-band** — Full WiFi 6 features require ESP-IDF or Arduino; TinyGo WiFi support is limited

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/xiao_esp32c5_getting_started/
- **ESP32-C5 Datasheet:** https://www.espressif.com/sites/default/files/documentation/esp32-c5_datasheet_en.pdf
- **ESP-IDF:** https://github.com/espressif/esp-idf
- **TinyGo (check for future support):** https://tinygo.org/docs/reference/microcontrollers/
- **Schematic:** https://files.seeedstudio.com/wiki/SeeedStudio-XIAO-ESP32C5/res/XIAO_ESP32-C5_Schematic.pdf
