---
name: xiao-esp32c6-tinygo
description: >
  Provides comprehensive pinout reference, board specifications, and TinyGo development guide
  for the Seeed Studio XIAO ESP32-C6 microcontroller. Use when writing TinyGo firmware for the
  XIAO ESP32-C6, wiring peripherals, or configuring pins. Keywords: XIAO, ESP32-C6, TinyGo,
  Espressif, RISC-V, WiFi 6, BLE, Bluetooth, Zigbee, Thread, Matter, 802.15.4, pinout, GPIO,
  I2C, SPI, UART, analog, digital, PWM, deep sleep, battery, low-power.
---

# XIAO ESP32-C6 — TinyGo Development Guide

Provides comprehensive reference for developing TinyGo firmware for the Seeed Studio XIAO ESP32-C6.

## When to Use

- Writing TinyGo firmware targeting the XIAO ESP32-C6
- Looking up XIAO ESP32-C6 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO ESP32-C6 and need GPIO reference
- Configuring I2C, SPI, UART, or analog I/O on the XIAO ESP32-C6 in TinyGo

## When NOT to Use

- For Arduino/C++ development on the XIAO ESP32-C6 → use the `XIAO-ESP32C6-Arduino` skill
- For the XIAO ESP32-C3 (different MCU) → use the `XIAO-ESP32C3-TinyGo` skill
- For other XIAO boards → use the corresponding board skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Espressif ESP32-C6 |
| **Architecture** | Dual 32-bit RISC-V (HP: up to 160 MHz, LP: up to 20 MHz) |
| **Clock Speed** | 160 MHz (HP core), 20 MHz (LP core) |
| **Flash** | 4 MB |
| **RAM** | 512 KB SRAM |
| **Wireless** | WiFi 6 (802.11ax), Bluetooth 5.0 (BLE), Zigbee, Thread (IEEE 802.15.4) |
| **USB** | USB Type-C |
| **Operating Voltage** | 3.3V logic; 5V input (Type-C), 3.7V (BAT) |
| **Dimensions** | 21 × 17.8 mm |
| **Working Temp** | -40°C to 85°C |
| **GPIO Count** | 11 digital/PWM, 7 analog/ADC |
| **Deep Sleep** | ~15 μA |
| **Antenna** | Onboard ceramic + U.FL connector (RF switch via GPIO14/GPIO3) |
| **Battery** | Supports LiPo charge/discharge (3.7V BAT pads) |

---

## Pinout Diagram

```
                      [USB-C]
                ┌───────────────┐
      D0/A0   ──┤ 1          14 ├── 5V
      D1/A1   ──┤ 2          13 ├── GND
      D2/A2   ──┤ 3          12 ├── 3V3
        D3    ──┤ 4          11 ├── D10/MOSI
     D4/SDA   ──┤ 5          10 ├── D9/MISO
     D5/SCL   ──┤ 6           9 ├── D8/SCK
      D6/TX   ──┤ 7           8 ├── D7/RX
                └───────────────┘
         Bottom pads: BAT+, BAT-, GND
         JTAG pads: MTDO(GPIO7), MTDI(GPIO5),
                    MTCK(GPIO6), MTMS(GPIO4)
```

---

## Pin Reference Table

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|--------|-----|-----|-----|------|-------|
| D0  | GPIO0    | ✓       | ADC    | ✓   | —   | —   | —    | LP_GPIO0 |
| D1  | GPIO1    | ✓       | ADC    | ✓   | —   | —   | —    | LP_GPIO1 |
| D2  | GPIO2    | ✓       | ADC    | ✓   | —   | —   | —    | LP_GPIO2 |
| D3  | GPIO21   | ✓       | —      | ✓   | —   | —   | —    | SDIO_DATA1 |
| D4  | GPIO22   | ✓       | —      | ✓   | **SDA** | — | —  | SDIO_DATA2 |
| D5  | GPIO23   | ✓       | —      | ✓   | **SCL** | — | —  | SDIO_DATA3 |
| D6  | GPIO16   | ✓       | —      | ✓   | —   | —   | **TX** | — |
| D7  | GPIO17   | ✓       | —      | ✓   | —   | —   | **RX** | — |
| D8  | GPIO19   | ✓       | —      | ✓   | —   | **SCK** | — | SPI_CLK |
| D9  | GPIO20   | ✓       | —      | ✓   | —   | **MISO** | — | SPI_MISO |
| D10 | GPIO18   | ✓       | —      | ✓   | —   | **MOSI** | — | SPI_MOSI |

### Bottom JTAG Pads

| Pin | Chip Pin | Description |
|-----|----------|-------------|
| MTDO | GPIO7 | JTAG |
| MTDI | GPIO5 | JTAG, ADC |
| MTCK | GPIO6 | JTAG, ADC |
| MTMS | GPIO4 | JTAG, ADC |

### Internal / Special Pins

| Name | Chip Pin | Description |
|------|----------|-------------|
| Reset | CHIP_PU | Reset |
| Boot | GPIO9 | Enter bootloader |
| USER_LED | GPIO15 | User LED |
| RF Switch Select | GPIO14 | Toggle onboard/UFL antenna |
| RF Switch Power | GPIO3 | Power for RF switch (set LOW first) |

---

## TinyGo Setup

### Target Name

```
xiao-esp32c6
```

### Installation

1. Install TinyGo (≥ 0.32.0 recommended): https://tinygo.org/getting-started/install/
2. Verify the target is available:
   ```bash
   tinygo info -target=xiao-esp32c6
   ```

### Build and Flash

```bash
# Build only
tinygo build -target=xiao-esp32c6 -o firmware.bin ./main.go

# Build and flash via USB serial
tinygo flash -target=xiao-esp32c6 ./main.go

# Enter bootloader mode: hold BOOT button, press RESET, release BOOT
```

### TinyGo Support Status

- **Status:** Experimental / evolving — ESP32-C6 support is newer in TinyGo
- **USB CDC:** Supported (serial over USB)
- **ADC:** Supported on D0–D2 and JTAG pads (7 channels total)
- **PWM:** Supported on all digital pins
- **I2C:** Supported (`machine.I2C0`)
- **SPI:** Supported (`machine.SPI0`)
- **UART:** Supported (`machine.UART0`)
- **WiFi 6:** ❌ Not yet supported in TinyGo (requires ESP-IDF)
- **BLE:** ❌ Not yet supported in TinyGo
- **Zigbee/Thread:** ❌ Not yet supported in TinyGo
- **LP Core:** ❌ Not accessible from TinyGo

> **⚠ Important:** TinyGo ESP32-C6 support is evolving. WiFi 6, BLE, Zigbee, Thread, and the LP core are not available. For wireless/Matter features, use the Arduino skill instead.

### Example: Blink (TinyGo)

```go
package main

import (
    "machine"
    "time"
)

func main() {
    led := machine.LED // GPIO15 — User LED
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

- **SDA:** D4 (GPIO22)
- **SCL:** D5 (GPIO23)
- **TinyGo bus:** `machine.I2C0`

```go
i2c := machine.I2C0
err := i2c.Configure(machine.I2CConfig{
    SDA:       machine.SDA_PIN, // D4 / GPIO22
    SCL:       machine.SCL_PIN, // D5 / GPIO23
    Frequency: 400000,          // 400 kHz
})
if err != nil {
    println("I2C init failed:", err)
}
```

### SPI

- **SCK:** D8 (GPIO19)
- **MISO:** D9 (GPIO20)
- **MOSI:** D10 (GPIO18)
- **CS:** Any GPIO (user-defined)
- **TinyGo bus:** `machine.SPI0`

```go
spi := machine.SPI0
err := spi.Configure(machine.SPIConfig{
    SCK:       machine.SPI0_SCK_PIN,  // D8 / GPIO19
    SDO:       machine.SPI0_SDO_PIN,  // D10 / GPIO18 (MOSI)
    SDI:       machine.SPI0_SDI_PIN,  // D9 / GPIO20 (MISO)
    Frequency: 4000000,               // 4 MHz
})
if err != nil {
    println("SPI init failed:", err)
}
```

### UART

- **TX:** D6 (GPIO16)
- **RX:** D7 (GPIO17)
- **TinyGo bus:** `machine.UART0`

```go
uart := machine.UART0
uart.Configure(machine.UARTConfig{
    TX:       machine.UART_TX_PIN, // D6 / GPIO16
    RX:       machine.UART_RX_PIN, // D7 / GPIO17
    BaudRate: 115200,
})
uart.Write([]byte("Hello from XIAO ESP32-C6\r\n"))
```

### Analog Read (ADC)

```go
adc := machine.ADC{Pin: machine.ADC0} // D0 / GPIO0
adc.Configure(machine.ADCConfig{
    Resolution: 12, // 12-bit (0–4095)
})
value := adc.Get() // Returns 16-bit scaled value
```

> **Note:** Only D0–D2 (GPIO0–2) have ADC on the edge pins. Additional ADC channels are on the bottom JTAG pads (GPIO4–6). D3–D10 edge pins are digital only.

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **5V output:** From USB VBUS
- **3.3V output:** Regulated from onboard LDO
- **Deep sleep:** ~15 μA

### Battery Support

- **Battery pads:** Solder LiPo battery to BAT+ and BAT- pads on the bottom
- **Charge LED:** Indicates charging status
- **Input:** 3.7V LiPo battery

### Deep Sleep

TinyGo deep sleep support on ESP32-C6 is limited:

```go
import "machine"

machine.Sleep()
```

> **Note:** Full deep sleep with GPIO wake-up requires ESP-IDF APIs not yet exposed in TinyGo. D0 (GPIO0) supports external wake-up from deep sleep in hardware.

---

## Special Features

### WiFi 6 (802.11ax)

The ESP32-C6 supports WiFi 6 (802.11ax) for improved efficiency and range. **Not available in TinyGo** — requires ESP-IDF. Use the Arduino variant for WiFi projects.

### Zigbee / Thread / Matter

The ESP32-C6 supports IEEE 802.15.4 for Zigbee and Thread protocols, enabling Matter smart home interoperability. **Not available in TinyGo** — requires ESP-IDF. Use the Arduino variant for smart home projects.

### Dual RISC-V Processors

- **HP core:** Up to 160 MHz — main application processor
- **LP core:** Up to 20 MHz — low-power coprocessor for background tasks

TinyGo uses only the HP core. The LP core is not accessible from TinyGo.

### Low-Power Peripherals

The ESP32-C6 has LP_UART and LP_I2C peripherals that can run on the LP core. These are not accessible from TinyGo.

### RF Switch (Antenna Selection)

The board has both an onboard ceramic antenna and a U.FL connector. To switch to the external antenna:
- Set GPIO3 LOW (RF switch power)
- Set GPIO14 to select antenna (HIGH = external, LOW = onboard)

This requires direct GPIO control, which is possible in TinyGo:

```go
rfPower := machine.GPIO3
rfPower.Configure(machine.PinConfig{Mode: machine.PinOutput})
rfPower.Low() // Enable RF switch

rfSelect := machine.GPIO14
rfSelect.Configure(machine.PinConfig{Mode: machine.PinOutput})
rfSelect.High() // Select external U.FL antenna
```

> **Note:** Antenna switching is a hardware feature independent of WiFi stack support.

---

## Common Gotchas / Notes

1. **WiFi/BLE/Zigbee/Thread not available in TinyGo** — All wireless features require ESP-IDF; use Arduino
2. **Only 3 analog pins on edge** — D0–D2 (GPIO0–2) have ADC; additional ADC on bottom JTAG pads
3. **D3 is digital only** — Unlike other XIAO boards, D3 (GPIO21) has no ADC
4. **LP core not accessible** — TinyGo uses only the HP RISC-V core
5. **Boot mode** — Hold BOOT, press RESET, release BOOT to enter bootloader
6. **User LED on GPIO15** — Check active level for your board revision
7. **RF switch control** — GPIO3 and GPIO14 are used internally for antenna selection
8. **3.3V logic only** — Do NOT connect 5V signals directly to GPIO pins
9. **JTAG pads have ADC** — GPIO4, GPIO5, GPIO6 on bottom pads support analog input
10. **Wide temperature range** — -40°C to 85°C (wider than most XIAO boards)

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/xiao_esp32c6_getting_started/
- **TinyGo target docs:** https://tinygo.org/docs/reference/microcontrollers/
- **ESP32-C6 datasheet:** https://www.espressif.com/sites/default/files/documentation/esp32-c6_datasheet_en.pdf
- **ESP32-C6 technical reference:** https://www.espressif.com/sites/default/files/documentation/esp32-c6_technical_reference_manual_en.pdf
- **Schematic:** https://files.seeedstudio.com/wiki/SeeedStudio-XIAO-ESP32C6/XIAO_ESP32-C6_v1.0_SCH.pdf
