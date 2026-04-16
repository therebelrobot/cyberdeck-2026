# 🔌 cyberdeck-2026

> Battery-powered portable Linux cyberdeck in a thrifted enclosure. Solarpunk-oriented, off-grid-capable personal computing device with cellular and LoRa/Meshtastic networking.

---

## 📑 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [Architecture Overview](#-architecture-overview)
- [Hardware Stack](#-hardware-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Key Constraints](#-key-constraints)
- [Development Status](#-development-status)
- [License](#-license)

---

## 🎯 Overview

cyberdeck-2026 is a handheld cyberdeck device designed for portable, off-grid computing. Built around a Raspberry Pi Zero 2W, it features a 3.5" DPI capacitive touch display, cellular LTE connectivity, and Meshtastic LoRa mesh networking—all powered by a 5000mAh battery in a thrifted enclosure.

This is a **solarpunk-inspired** project: sustainable, repairable, and designed for resilience in disconnected scenarios.

---

## ✨ Key Features

| Feature | Details |
|---------|---------|
| **Primary SBC** | Raspberry Pi Zero 2W (ARM Cortex-A53, 512MB RAM) |
| **Display** | Waveshare 3.5" DPI capacitive touch (640×480) |
| **Battery** | PiSugar 3 Plus 5000mAh LiPo |
| **USB Hub** | Adafruit CH334F 4-port USB hub |
| **Keyboard** | M5Stack CardKB QWERTY keyboard (I2C) |
| **Navigation** | ANO rotary encoder + Seeed Studio XIAO SAMD21 HID bridge |
| **Cellular** | LTE modem with ModemManager integration |
| **Mesh Networking** | Meshtastic LoRa (XIAO ESP32-S3 + WIO-SX1262) |
| **Power Management** | PiSugar 3 I2C monitoring, safe shutdown |
| **Connectivity** | WiFi, Bluetooth, LTE, LoRa mesh |

---

## 🏗 Architecture Overview

### Power Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Power Bus (5V)                        │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │   Pi     │  │  USB Hub  │  │   LTE    │  │  LoRa    │  │
│  │ Zero 2W  │  │ (CH334F)  │  │  Modem   │  │  Module  │  │
│  │ ~500mA   │  │ ~100mA    │  │ 200-500mA│  │  ~120mA  │  │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘  │
│       │              │              │              │       │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │  Display  │  │ Keyboard │  │  SAMD21  │  │ ESP32-S3 │  │
│  │ ~300-500mA│  │   (I2C)  │  │  (HID)   │  │ (Mesht.) │  │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                    ┌─────────┴─────────┐
                    │    PiSugar 3       │
                    │    5000mAh LiPo    │
                    │    I2C (0x57)      │
                    └───────────────────┘
```

### Communication Paths

| Path | Protocol | Purpose |
|------|----------|---------|
| Pi → SAMD21 | USB Serial | Keyboard HID input |
| Pi → ESP32-S3 | USB Serial | Meshtastic message handling |
| SAMD21 → CardKB | I2C (0x5F) | Keyboard key scanning |
| Pi → PiSugar | I2C (0x57) | Battery monitoring |
| ESP32-S3 → WIO-SX1262 | SPI | LoRa radio transmission |

### Firmware Boards

| Board | Language | Location | Purpose |
|-------|----------|----------|---------|
| **Raspberry Pi Zero 2W** | TypeScript | `firmware/boards/raspberry-pi-zero-2w/typescript/` | Main system control, cellular, display |
| **XIAO SAMD21** | TinyGo | `firmware/boards/xiao-samd21/tinygo/` | Keyboard HID bridge, rotary encoder |
| **XIAO ESP32-S3** | Meshtastic | `firmware/boards/xiao-esp32s3/` | LoRa mesh networking |

---

## 🔧 Hardware Stack

### Major Components

| Component | Part Number | Est. Cost | Source |
|-----------|-------------|-----------|--------|
| Single Board Computer | Raspberry Pi Zero 2W | $25 | Raspberry Pi Foundation |
| Display | Waveshare 3.5" DPI (B) | $45 | Waveshare |
| Battery | PiSugar 3 Plus | $30 | PiSugar |
| USB Hub | Adafruit CH334F | $8 | Adafruit |
| Keyboard | M5Stack CardKB | $12 | M5Stack |
| Rotary Encoder | ANO Rotary Encoder | $15 | TBD |
| LoRa Main | Seeed Studio XIAO ESP32-S3 | $10 | Seeed Studio |
| LoRa Radio | Wio-SX1262 | $20 | Seeed Studio |
| Aux Controller | Seeed Studio XIAO SAMD21 | $5 | Seeed Studio |
| LTE Modem | Quectel/EC20 | $30 | TBD |
| **Total** | | **~$200** | |

> ⚠️ **Note**: Final cost depends on enclosure (thrifted/3D printed) and individual component sourcing.

---

## 📁 Project Structure

```
cyberdeck-2026/
├── firmware/
│   ├── boards/
│   │   ├── raspberry-pi-zero-2w/
│   │   │   └── typescript/          # TypeScript firmware for Pi
│   │   ├── xiao-samd21/
│   │   │   └── tinygo/              # TinyGo firmware for SAMD21
│   │   └── xiao-esp32s3/            # Meshtastic firmware for ESP32-S3
│   ├── protocols/                   # Shared protocol definitions
│   │   ├── i2c/
│   │   ├── spi/
│   │   ├── uart/
│   │   └── wifi/
│   └── shared/                      # Cross-board libraries
│
├── docs/
│   ├── ARCHITECTURE.md              # Detailed system architecture
│   ├── BOM.md                       # Bill of materials
│   ├── WIRING.md                    # Physical wiring diagrams
│   ├── images/                      # Documentation images
│   └── research/                    # Component research & datasheets
│
├── config/
│   ├── project.yaml                 # Project configuration
│   └── pins/                       # Pin mapping definitions
│
├── circuits/
│   ├── ato.yaml                     # Atopile PCB project manifest
│   ├── elec/src/                    # Atopile source files
│   └── layouts/                     # PCB layouts
│
├── models/
│   ├── enclosures/                  # 3D printable enclosures
│   ├── mounts/                      # Component mounts/brackets
│   ├── jigs/                        # Assembly jigs
│   └── _source/                     # Original CAD sources
│
├── scripts/
│   ├── build.sh                    # Firmware build script
│   ├── flash.sh                    # Firmware flash script
│   └── fix-skill-names.sh          # Development utilities
│
├── tests/                          # Test fixtures and harnesses
│
└── .roo/
    ├── skills/                      # Project-specific AI agent skills
    │   ├── raspberrypi-zero-2w/
    │   ├── pisugar-3/
    │   ├── meshtastic-integration/
    │   ├── lte-cellular-modem/
    │   ├── htlnuzd-m5stack-cardkb/
    │   ├── ano-rotary-encoder/
    │   └── wio-sx1262-for-xiao/
    └── rules/                       # Project-specific rules
```

---

## 🚀 Getting Started

### Prerequisites

- Node.js 20+ (for TypeScript on Pi Zero 2W)
- [TinyGo](https://tinygo.org/getting-started/) 0.35+
- [Meshtastic firmware](https://meshtastic.org/) for XIAO ESP32-S3
- Rust (for atopile PCB design, optional)

### Documentation

| Document | Purpose |
|----------|---------|
| [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) | Full system architecture and design decisions |
| [`docs/BOM.md`](docs/BOM.md) | Complete bill of materials with part numbers |
| [`docs/WIRING.md`](docs/WIRING.md) | Physical wiring and connection diagrams |
| [`config/project.yaml`](config/project.yaml) | Project configuration and pin mappings |

### Firmware Setup

#### Raspberry Pi Zero 2W (TypeScript)

```bash
cd firmware/boards/raspberry-pi-zero-2w/typescript
npm install
npm run build
```

#### XIAO SAMD21 (TinyGo)

```bash
cd firmware/boards/xiao-samd21/tinygo
tinygo build -target=xiao -w
tinygo flash -target=xiao -c /dev/ttyACM0
```

#### XIAO ESP32-S3 (Meshtastic)

Follow the [Meshtastic XIAO ESP32-S3 guide](firmware/boards/xiao-esp32s3/README.md) to flash Meshtastic firmware via USB or OTA.

---

## ⚠️ Key Constraints

> **Important**: These constraints affect all development decisions.

### GPIO Availability

**GPIO is fully consumed by the DPI display interface.** All peripherals must connect via:
- **USB hub** — keyboard, LTE modem, development connections
- **I2C bus** — PiSugar battery monitor (0x57), CardKB keyboard (0x5F), display touch controller

### Power Budget

| Component | Typical | Peak |
|-----------|---------|------|
| Raspberry Pi Zero 2W | 500mA | 1000mA |
| LTE Modem (transmit) | 200mA | 500mA |
| LoRa (transmit) | — | 120mA |
| Display (backlight) | 300mA | 500mA |
| USB Hub | 100mA | 200mA |

**Total estimated peak**: ~2.5A at 5V

### Firmware Languages

| Board | Language | Toolchain |
|-------|----------|-----------|
| Raspberry Pi Zero 2W | TypeScript | Node.js |
| XIAO SAMD21 | TinyGo | TinyGo |
| XIAO ESP32-S3 | Meshtastic (C++) | PlatformIO/esp-idf |

---

## 📊 Development Status

| Subsystem | Status | Notes |
|-----------|--------|-------|
| Hardware Selection | ✅ Complete | See [`docs/BOM.md`](docs/BOM.md) |
| Wiring Design | 🔄 In Progress | See [`docs/WIRING.md`](docs/WIRING.md) |
| Enclosure | 🔴 TBD | Thrifted or 3D printed |
| TypeScript Firmware | 🔄 In Progress | Basic modules exist |
| TinyGo Firmware | 🔄 In Progress | Basic structure exists |
| Meshtastic | 🔄 In Progress | Requires radio calibration |
| PCB Design | 🔄 In Progress | Atopile project started |
| Battery Integration | 🔄 In Progress | PiSugar I2C monitoring |
| LTE Integration | 🔄 In Progress | ModemManager setup |

---

## 📜 License

This project is open hardware and software. See [`LICENSE`](LICENSE) for details.
