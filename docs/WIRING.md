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

### Raspberry Pi Zero 2W → Waveshare 3.5" DPI Display (DPI666)

The Waveshare 3.5" DPI display consumes the **FULL 40-pin GPIO header** via DPI666 interface.

| DPI Signal | GPIO Pin | Function |
|------------|----------|----------|
| R0 | GPIO2 | Data bit 0 |
| R1 | GPIO3 | Data bit 1 |
| R2 | GPIO4 | Data bit 2 |
| R3 | GPIO14 | Data bit 3 |
| R4 | GPIO15 | Data bit 4 |
| R5 | GPIO18 | Data bit 5 |
| R6 | GPIO17 | Data bit 6 |
| R7 | GPIO27 | Data bit 7 |
| G0 | GPIO22 | Data bit 0 |
| G1 | GPIO23 | Data bit 1 |
| G2 | GPIO24 | Data bit 2 |
| G3 | GPIO10 | Data bit 3 |
| G4 | GPIO9 | Data bit 4 |
| G5 | GPIO25 | Data bit 5 |
| G6 | GPIO11 | Data bit 6 |
| G7 | GPIO8 | Data bit 7 |
| B0 | GPIO21 | Data bit 0 |
| B1 | GPIO26 | Data bit 1 |
| B2 | GPIO20 | Data bit 2 |
| B3 | GPIO19 | Data bit 3 |
| B4 | GPIO16 | Data bit 4 |
| B5 | GPIO13 | Data bit 5 |
| B6 | GPIO12 | Data bit 6 |
| B7 | GPIO6 | Data bit 7 |
| DOTCLK | GPIO0 | Pixel clock |
| DE | GPIO7 | Data enable |
| VSYNC | GPIO1 | Vertical sync |
| HSYNC | GPIO5 | Horizontal sync |
| 5V | Pin 2, 4 | Power (input to display) |
| 3.3V | Pin 1, 17 | Logic power |
| GND | Pin 6, 9, 14, 20, 25, 30, 34, 39 | Ground |

### Waveshare DPI Display Touch Controller (I2C)

| Signal | Display Pin | GPIO Pin (Pi) |
|--------|-------------|---------------|
| SDA | TBD | GPIO2 (SDA) |
| SCL | TBD | GPIO3 (SCL) |
| 3.3V | TBD | Pin 1 or 17 |
| GND | TBD | Ground |

> **⚠️ VERIFY_REQUIRED**: Touch controller I2C address needs verification from Waveshare wiki.

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
│ PiSugar 3 Plus (5000mAh LiPo)                               │
│ ├── I2C: 0x57 (battery monitor)                              │
│ └── I2C: 0x68 (RTC/timestamp)                               │
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
| Raspberry Pi Zero 2W | 5V | ~250mA | PiSugar 3 Plus (pogo) |
| Waveshare DPI Display | 5V | ~200mA | Pi GPIO (via Pi) |
| XIAO SAMD21 | 3.3V/5V | ~50mA | USB Hub (Port 1) |
| XIAO ESP32-S3 | 3.3V/5V | ~150mA | USB Hub (Port 2) |
| LTE USB Dongle | 5V | ~500mA | USB Hub (Port 3) |
| CardKB | 5V | ~20mA | USB Hub (Port 4) |
| WIO-SX1262 | 3.3V | ~40mA | XIAO ESP32-S3 |

## I2C Bus Devices

### Raspberry Pi Zero 2W I2C Bus

| Device | I2C Address | Notes |
|--------|------------|-------|
| PiSugar 3 Plus | `0x57` | Battery monitoring |
| PiSugar 3 Plus | `0x68` | RTC/timestamp |
| Waveshare DPI Touch | `VERIFY_REQUIRED` | Needs verification from Waveshare wiki |

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
