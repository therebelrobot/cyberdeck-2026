# Cyberdeck-2026 Project Context

This file provides a reference index to the existing project documentation. **Do not duplicate information from these sources.**

## Project Structure Overview

The cyberdeck-2026 is a handheld cyberdeck device with:
- **Raspberry Pi Zero 2W** as the main processor
- **Seeed Studio XIAO SAMD21** for keyboard/auxiliary control
- **Seeed Studio XIAO ESP32-S3** for Meshtastic mesh networking
- **PiSugar 3** for battery management
- **DPI display** with capacitive touch
- **LTE cellular** connectivity
- **LoRa** radio for off-grid mesh
- **CardKB** QWERTY keyboard input
- **ANO Rotary Encoder** for navigation

## Core Documentation

| Document | Purpose |
|----------|---------|
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | System architecture and design decisions |
| [docs/BOM.md](docs/BOM.md) | Bill of materials with part numbers and sources |
| [docs/WIRING.md](docs/WIRING.md) | Physical wiring and connection diagrams |
| [config/project.yaml](config/project.yaml) | Project configuration and pin mappings |
| [firmware/README.md](firmware/README.md) | Firmware overview and build instructions |

## Firmware Boards

| Board | Language | Location | Documentation |
|-------|----------|----------|---------------|
| Raspberry Pi Zero 2W | TypeScript | `firmware/boards/raspberry-pi-zero-2w/typescript/` | [firmware/boards/raspberry-pi-zero-2w/typescript/README.md](firmware/boards/raspberry-pi-zero-2w/typescript/README.md) |
| XIAO SAMD21 | TinyGo | `firmware/boards/xiao-samd21/tinygo/` | [firmware/boards/xiao-samd21/tinygo/README.md](firmware/boards/xiao-samd21/tinygo/README.md) |
| XIAO ESP32-S3 | Meshtastic | `firmware/boards/xiao-esp32s3/` | [firmware/boards/xiao-esp32s3/README.md](firmware/boards/xiao-esp32s3/README.md) |

## Component Skills

Skills are located in [.roo/skills/](.roo/skills/) and provide detailed integration guides:

### Core Components
| Component | Skill | Key Topics |
|-----------|-------|------------|
| Raspberry Pi Zero 2W | [raspberrypi-zero-2w/SKILL.md](.roo/skills/raspberrypi-zero-2w/SKILL.md) | GPIO pinout, I2C, SPI, USB |
| PiSugar 3 | [pisugar-3/SKILL.md](.roo/skills/pisugar-3/SKILL.md) | Battery monitoring, I2C (0x57), safe shutdown |
| LTE Modem | [lte-cellular-modem/SKILL.md](.roo/skills/lte-cellular-modem/SKILL.md) | ModemManager, AT commands, NetworkManager |
| Meshtastic | [meshtastic-integration/SKILL.md](.roo/skills/meshtastic-integration/SKILL.md) | @meshtastic/js, serial, message handling |

### Input/Output Devices
| Component | Skill | Key Topics |
|-----------|-------|------------|
| CardKB Keyboard | [htlnuzd-m5stack-cardkb/SKILL.md](.roo/skills/htlnuzd-m5stack-cardkb/SKILL.md) | I2C (0x5F), key scanning |
| Display | [waveshare-3.5inch-capacitive-touch-screen-lcd/SKILL.md](.roo/skills/waveshare-3.5inch-capacitive-touch-screen-lcd/SKILL.md) | DPI interface, touch I2C |
| Rotary Encoder | [ano-rotary-encoder/SKILL.md](.roo/skills/ano-rotary-encoder/SKILL.md) | seesaw firmware, I2C, NeoPixel |

### Communication Modules
| Component | Skill | Key Topics |
|-----------|-------|------------|
| LoRa (Wio-SX1262) | [wio-sx1262-for-xiao/SKILL.md](.roo/skills/wio-sx1262-for-xiao/SKILL.md) | SPI, 433/868/915MHz, RadioLib |

### XIAO Boards
| Board | Skill | Key Topics |
|-------|-------|------------|
| XIAO SAMD21 | [XIAO-SAMD21-TinyGo/SKILL.md](.roo/skills/XIAO-SAMD21-TinyGo/SKILL.md) | TinyGo on XIAO, GPIO, I2C, SPI |

## Research Documentation

Located in [docs/research/](docs/research/):
- [arduino-pinouts.md](docs/research/arduino-pinouts.md) - Arduino reference pinouts
- [raspberry-pi-pinouts.md](docs/research/raspberry-pi-pinouts.md) - RPi GPIO reference
- [xiao-batch*-pinouts.md](docs/research/xiao-batch1-pinouts.md) - XIAO board pinouts
- [xiao-accessories-batch*.md](docs/research/xiao-accessories-batch1.md) - XIAO accessory details
- [atopile-docs.md](docs/research/atopile-docs.md) - PCB design with atopile

## Key Constraints

1. **GPIO is fully consumed** by DPI display - all peripherals via USB hub or I2C
2. **I2C addresses**: PiSugar (0x57), CardKB (0x5F), Display Touch (verify)
3. **Power budget**: ~2.5A total; LTE transmit spikes to 200-500mA
4. **Firmware languages**: Pi=TypeScript, SAMD21=TinyGo, ESP32-S3=Meshtastic
5. **Fabrication**: 3D printing primary (Flashforge, conveyor belt, Ender 3); no Glowforge

## Quick Reference

### I2C Device Addresses (Verify Before Adding)
```
0x57 - PiSugar 3 (battery/ RTC)
0x5F - CardKB Keyboard
TBD  - Display Touch
```

### USB Hub (CH334F)
All USB peripherals connect through the CH334F hub - GPIO is unavailable.

### Power Budget Distribution
```
Pi Zero 2W:  ~500mA normal, 1000mA peak
LTE Modem:   ~200mA idle, 200-500mA transmit
LoRa:        ~120mA transmit
Display:     ~300-500mA
USB Hub:     ~100-200mA
```

### Build Commands
```bash
# TypeScript (Pi Zero 2W)
cd firmware/boards/raspberry-pi-zero-2w/typescript && npm install && npm run build

# TinyGo (XIAO SAMD21)
cd firmware/boards/xiao-samd21/tinygo && tinygo build

# Meshtastic (XIAO ESP32-S3)
# Use pre-built firmware - see meshtastic-integration skill
```
