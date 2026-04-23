# Wiring Diagram

Document physical wiring connections between boards and components here.

## Board Connections

<!-- Add your inter-board wiring here. Example format: -->

<!--
### Controller ↔ Left Arm (I2C)

| Signal | Controller Pin | Left Arm Pin |
|--------|---------------|--------------|
| SDA    | GPIO5         | GPIO4        |
| SCL    | GPIO6         | GPIO5        |
| GND    | GND           | GND          |
-->

### Raspberry Pi Zero 2W → Waveshare 3.5" DPI Display (DPI18)

The Waveshare 3.5" DPI display uses the **DPI18 (18-bit)** interface, claiming 22 GPIOs
for display data, clock, and sync signals. Verified by decompiling `waveshare-35dpi-3b-4b.dtbo`.

> **Note**: This is DPI18 (6-6-6 color), NOT DPI24. GPIOs 10, 11, 18, 19, 26, 27 are
> **NOT claimed** by the display and remain available for other uses.

| DPI Signal | GPIO Pin | Function |
|------------|----------|----------|
| DOTCLK | GPIO0 | Pixel clock |
| VSYNC | GPIO1 | Vertical sync |
| R0 | GPIO2 | Red data bit 0 (⚠️ conflicts with I2C1 SDA) |
| R1 | GPIO3 | Red data bit 1 (⚠️ conflicts with I2C1 SCL) |
| R2 | GPIO4 | Red data bit 2 |
| HSYNC | GPIO5 | Horizontal sync |
| DE/R3 | GPIO6 | Data enable / Red data bit 3 |
| R4 | GPIO7 | Red data bit 4 |
| G0 | GPIO8 | Green data bit 0 |
| G1 | GPIO9 | Green data bit 1 |
| G2 | GPIO12 | Green data bit 2 |
| G3 | GPIO13 | Green data bit 3 |
| G4 | GPIO14 | Green data bit 4 |
| G5 | GPIO15 | Green data bit 5 |
| B0 | GPIO16 | Blue data bit 0 |
| B1 | GPIO17 | Blue data bit 1 |
| B2 | GPIO20 | Blue data bit 2 |
| B3 | GPIO21 | Blue data bit 3 |
| B4 | GPIO22 | Blue data bit 4 |
| B5 | GPIO23 | Blue data bit 5 |
| B6 | GPIO24 | Blue data bit 6 |
| B7 | GPIO25 | Blue data bit 7 |
| 5V | Pin 2, 4 | Power (input to display) |
| 3.3V | Pin 1, 17 | Logic power |
| GND | Pin 6, 9, 14, 20, 25, 30, 34, 39 | Ground |

### GPIOs NOT claimed by DPI display (available for peripherals)

| GPIO | Available For | Used By |
|------|---------------|---------|
| GPIO10 | Bit-banged I2C SDA | DPI overlay creates `i2c-gpio` bus |
| GPIO11 | Bit-banged I2C SCL | DPI overlay creates `i2c-gpio` bus |
| GPIO18 | Backlight control | DPI overlay registers `gpio-backlight` (on/off) |
| GPIO19 | General purpose | Unused |
| GPIO26 | General purpose | Unused |
| GPIO27 | General purpose | Unused |

### Waveshare DPI Display — Backlight Control

| Signal | GPIO Pin | Driver | Notes |
|--------|----------|--------|-------|
| Backlight | GPIO18 | `gpio-backlight` (kernel) | On/off only, NOT PWM. Controlled via `/sys/class/backlight/` |

> The DPI overlay registers GPIO18 as a kernel `gpio-backlight` device with `default-on`.
> Do NOT use wiringPi or direct GPIO manipulation — use the sysfs interface instead.

### Waveshare DPI Display Touch Controller (I2C via bit-banged bus)

The DPI overlay claims GPIO2/GPIO3 (hardware I2C bus 1), so the touch controller
and all other I2C devices use a **bit-banged I2C bus on GPIO10/GPIO11** created by
the overlay. This bus appears as `/dev/i2c-N` (typically i2c-3 or higher).

| Signal | GPIO Pin (Pi) | Notes |
|--------|---------------|-------|
| SDA | GPIO10 | Bit-banged I2C (created by DPI overlay) |
| SCL | GPIO11 | Bit-banged I2C (created by DPI overlay) |
| 3.3V | Pin 1 or 17 | Logic power |
| GND | Ground | |

> **Touch controller**: GT911 capacitive, I2C address `0x5D` (default) or `0x14` (alternate).
> Detected automatically by `init-peripherals.sh` which scans all available I2C buses.

## Sensor Connections

### ANO Rotary Encoder → XIAO SAMD21 (I2C)

| Signal | ANO Encoder | XIAO SAMD21 Pin |
|--------|------------|-----------------|
| GND | GND | GND |
| 3.3V | 3V3 | 3V3 |
| SDA | SDA | A4/SDA |
| SCL | SCL | A5/SCL |
| INT | INT (optional) | D2 or D3 (interrupt) |

> **Note**: ANO encoder connects to XIAO SAMD21 via I2C (default address `0x49`), not directly to Pi.

### WIO-SX1262 LoRa Module → XIAO ESP32-S3 (SPI)

| Signal | WIO-SX1262 | XIAO ESP32-S3 Pin |
|--------|-----------|------------------|
| CS | CS | D7 |
| SCK | SCK | D8 |
| MISO | MISO | D9 |
| MOSI | MOSI | D10 |
| RST | RST | D3 |
| BUSY | BUSY | D2 |

> **Note**: Uses RadioLib library for LoRa communication.

## Power Distribution

### USB Power Chain

```
┌─────────────────────────────────────────────────────────────┐
│ PiSugar 3 Plus (5000mAh LiPo) — POWER-ONLY MODE             │
│ ├── I2C: 0x57 (battery monitor) — UNAVAILABLE (GPIO2/3      │
│ │        conflict with DPI display)                          │
│ └── I2C: 0x68 (RTC/timestamp)  — UNAVAILABLE (same reason)  │
│                                                              │
│     └── Pogo pins ──────────────────────────────────────────►│ Raspberry Pi Zero 2W
│                                                                │
│         └── USB OTG port ────────────────────────────────────│
│                                                              │
│             └── ChenYang right-angle micro-USB adapter       │
│                                                              │
│                 └── Adafruit CH334F 4-Port USB Hub          │
│                             │                                │
│         ┌────────────────────┼────────────────────┐          │
│         ▼                    ▼                    ▼          │
│    Port 1: XIAO SAMD21  Port 2: XIAO ESP32-S3  Port 3: LTE  │
│    (HID bridge)          (Meshtastic)           USB Dongle   │
│                                                            │
│                             └── Port 4: CardKB or spare     │
└─────────────────────────────────────────────────────────────┘
```

### Power Rail Summary

| Component | Voltage | Current Draw | Power Source |
|-----------|---------|-------------|--------------|
| Raspberry Pi Zero 2W | 5V | ~250mA | PiSugar 3 Plus (pogo, power-only) |
| Waveshare DPI Display | 5V | ~200mA | Pi GPIO (via Pi) |
| XIAO SAMD21 | 3.3V/5V | ~50mA | USB Hub (Port 1) |
| XIAO ESP32-S3 | 3.3V/5V | ~150mA | USB Hub (Port 2) |
| LTE USB Dongle | 5V | ~500mA | USB Hub (Port 3) |
| CardKB | 5V | ~20mA | USB Hub (Port 4) |
| WIO-SX1262 | 3.3V | ~40mA | XIAO ESP32-S3 |

## I2C Bus Devices

### Raspberry Pi Zero 2W I2C Bus (bit-banged, GPIO10/GPIO11)

> **Important**: Hardware I2C bus 1 (GPIO2/GPIO3) is unavailable when the DPI display
> overlay is active. All I2C devices share the bit-banged bus created by the overlay
> on GPIO10 (SDA) / GPIO11 (SCL). The bus number varies (typically `/dev/i2c-3` or higher).
> Use `init-peripherals.sh` auto-detection or scan with `ls /dev/i2c-*`.

| Device | I2C Address | Status | Notes |
|--------|------------|--------|-------|
| PiSugar 3 Plus | `0x57` | **UNAVAILABLE** | Pogo pins hard-wired to GPIO2/3 (claimed by DPI). Power-only mode. |
| PiSugar 3 Plus | `0x68` | **UNAVAILABLE** | RTC — same GPIO2/3 conflict |
| Waveshare DPI Touch | `0x5D` | Available | GT911 capacitive touch (default addr) |
| Waveshare DPI Touch | `0x14` | Available | GT911 capacitive touch (alternate addr) |

> **PiSugar Power-Only Mode**: The PiSugar 3 pogo pins hard-wire I2C to GPIO2/GPIO3,
> which are claimed by the DPI display. The PiSugar still provides 5V power, USB-C
> charging, and the physical power button — but battery level, charging status, and
> RTC are unavailable. To restore I2C: solder jumper wires from PiSugar SDA/SCL pads
> to GPIO10 (pin 19) / GPIO11 (pin 23).

### XIAO SAMD21 I2C Bus

| Device | I2C Address | Notes |
|--------|-------------|-------|
| ANO Rotary Encoder | `0x49` | Seesaw firmware |

### XIAO ESP32-S3

| Device | Interface | Notes |
|--------|----------|-------|
| WIO-SX1262 | SPI | LoRa radio (RadioLib) |
| Raspberry Pi | USB Serial | Meshtastic bridge |

## Serial Communication

### XIAO ESP32-S3 ↔ Raspberry Pi Zero 2W

- **Interface**: USB Serial (via CH334F hub)
- **Protocol**: Meshtastic serial protocol
- **Pi Software**: `@meshtastic/js`
- **ESP32 Software**: Meshtastic firmware

> **Note**: The XIAO ESP32-S3 runs Meshtastic firmware and bridges to the Pi via USB serial. The Pi runs the Meshtastic JS client to communicate with the ESP32-S3 radio module.

## Notes

- Refer to `config/project.yaml` for board roles and protocol assignments
- Pin mappings for each board are in `firmware/boards/<board>/config.yaml`
- Add wiring diagrams as images in `docs/images/`
