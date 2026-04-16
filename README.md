# 🔌 My Microcontroller Project

<!-- 
  ✏️ CUSTOMIZE THIS: Replace the title above and this description with your project name and details.
  Example: # 🤖 Garden Bot — Automated Plant Watering System
-->

> A microcontroller project built from the [microcontroller-base](https://github.com/therebelrobot/microcontroller-base) template. Supports multiple boards, dual-language firmware (TinyGo & Arduino), 3D-printable enclosures, and AI-assisted development.

---

## 📑 Table of Contents

- [Template Usage](#-template-usage)
- [Quick Start](#-quick-start)
- [Supported Boards](#-supported-boards)
- [Getting Started](#-getting-started)
- [Project Structure](#-project-structure)
- [Multi-Board Projects](#-multi-board-projects)
- [Custom Circuit Boards](#-custom-circuit-boards)
- [3D Printing](#-3d-printing)
- [AI Agent Skills](#-ai-agent-skills)
- [Contributing](#-contributing)
- [License](#-license)

---

## 📋 Template Usage

This repository is a **template** for microcontroller projects. To start a new project:

1. **Clone or use as a GitHub template:**
   ```bash
   # Option A: GitHub template (recommended)
   # Click "Use this template" on the GitHub repository page

   # Option B: Clone directly
   git clone https://github.com/therebelrobot/microcontroller-base.git my-project
   cd my-project
   rm -rf .git && git init
   ```

2. **Customize the project:**
   - Edit this [`README.md`](README.md) — replace the title and description with your project details
   - Edit [`config/project.yaml`](config/project.yaml) — declare which boards your project uses
   - Update [`docs/WIRING.md`](docs/WIRING.md) — document your physical wiring
   - Update [`docs/BOM.md`](docs/BOM.md) — list your components and materials

3. **Add your firmware:**
   - Create board directories under [`firmware/boards/`](firmware/boards/)
   - Write firmware in TinyGo (`tinygo/`) or Arduino (`arduino/`) subdirectories
   - Add shared libraries to [`firmware/shared/`](firmware/shared/)

---

## ⚡ Quick Start

The most common workflow — set up a board, write firmware, build, and flash:

```bash
# 1. Declare your board in the project manifest
#    Edit config/project.yaml and add your board entry

# 2. Create the firmware directory for your board
mkdir -p firmware/boards/xiao-esp32s3/tinygo

# 3. Initialize a TinyGo module
cd firmware/boards/xiao-esp32s3/tinygo
go mod init my-project/xiao-esp32s3
cat > main.go << 'EOF'
package main

import (
    "machine"
    "time"
)

func main() {
    led := machine.LED
    led.Configure(machine.PinConfig{Mode: machine.PinOutput})
    for {
        led.High()
        time.Sleep(500 * time.Millisecond)
        led.Low()
        time.Sleep(500 * time.Millisecond)
    }
}
EOF

# 4. Build and flash (from project root)
cd ../../../..
./scripts/build.sh xiao-esp32s3 tinygo
./scripts/flash.sh xiao-esp32s3 tinygo
```

---

## 🛠 Supported Boards

This template includes AI agent skills, pin references, and toolchain support for **22 boards** across three families.

### Seeed Studio XIAO

| Board | MCU | Wireless | Flash | RAM | Voltage |
|-------|-----|----------|-------|-----|---------|
| XIAO SAMD21 | ATSAMD21G18 | — | 256 KB | 32 KB | 3.3V |
| XIAO RP2040 | RP2040 | — | 2 MB | 264 KB | 3.3V |
| XIAO nRF52840 | nRF52840 | BLE 5.0 | 1 MB | 256 KB | 3.3V |
| XIAO nRF52840 Sense | nRF52840 | BLE 5.0 | 1 MB | 256 KB | 3.3V |
| XIAO ESP32-C3 | ESP32-C3 | WiFi + BLE 5.0 | 4 MB | 400 KB | 3.3V |
| XIAO ESP32-S3 | ESP32-S3 | WiFi + BLE 5.0 | 8 MB | 512 KB | 3.3V |
| XIAO ESP32-S3 Sense | ESP32-S3 | WiFi + BLE 5.0 | 8 MB | 512 KB | 3.3V |
| XIAO ESP32-C6 | ESP32-C6 | WiFi 6 + BLE 5.0 + Zigbee | 4 MB | 512 KB | 3.3V |
| XIAO RP2350 | RP2350 | — | 2 MB | 520 KB | 3.3V |
| XIAO RA4M1 | RA4M1 | — | 256 KB | 32 KB | 3.3V |
| XIAO MG24 | EFR32MG24 | BLE 5.3 + Zigbee + Thread | 1536 KB | 256 KB | 3.3V |
| XIAO MG24 Sense | EFR32MG24 | BLE 5.3 + Zigbee + Thread | 1536 KB | 256 KB | 3.3V |
| XIAO nRF54L15 | nRF54L15 | BLE 5.4 | 1.5 MB | 256 KB | 3.3V |
| XIAO nRF54L15 Sense | nRF54L15 | BLE 5.4 | 1.5 MB | 256 KB | 3.3V |
| XIAO ESP32-C5 | ESP32-C5 | WiFi 6 + BLE 5.0 | 4 MB | 512 KB | 3.3V |

### Arduino

| Board | MCU | Wireless | Flash | RAM | Voltage |
|-------|-----|----------|-------|-----|---------|
| Arduino Uno R3 | ATmega328P | — | 32 KB | 2 KB | 5V |
| Arduino Uno R4 Minima | RA4M1 | — | 256 KB | 32 KB | 5V |
| Arduino Uno R4 WiFi | RA4M1 + ESP32-S3 | WiFi + BLE | 256 KB | 32 KB | 5V |
| Arduino Nano | ATmega328P | — | 32 KB | 2 KB | 5V |
| Arduino Mega 2560 | ATmega2560 | — | 256 KB | 8 KB | 5V |

### Raspberry Pi SBCs

| Board | SoC | CPU | RAM | Connectivity | GPIO | Voltage |
|-------|-----|-----|-----|-------------|------|---------|
| Raspberry Pi 4 Model B | BCM2711 | Quad Cortex-A72 @ 1.8GHz | 1/2/4/8 GB | WiFi 5, BT 5.0, GbE | 40-pin (28 GPIO) | 3.3V |
| Raspberry Pi 5 | BCM2712 | Quad Cortex-A76 @ 2.4GHz | 4/8 GB | WiFi 5, BT 5.0, GbE | 40-pin (28 GPIO) | 3.3V |

> **Note:** All XIAO boards share the same ultra-compact form factor (21×17.8mm). Arduino boards use their standard form factors. "Sense" variants include onboard IMU and/or microphone. Raspberry Pi SBCs are full single-board computers with Linux support.

---

## 🚀 Getting Started

### Prerequisites

Install the toolchains for your chosen language(s):

#### TinyGo

```bash
# macOS (Homebrew)
brew install tinygo

# Linux — see https://tinygo.org/getting-started/install/
# Windows — see https://tinygo.org/getting-started/install/

# Verify installation
tinygo version
```

#### Arduino CLI

```bash
# macOS (Homebrew)
brew install arduino-cli

# Linux / Windows — see https://arduino.github.io/arduino-cli/installation/

# Initialize and install board cores
arduino-cli config init
arduino-cli core update-index

# Install cores for your boards (examples):
arduino-cli core install arduino:avr              # Uno R3, Nano, Mega
arduino-cli core install arduino:renesas_uno      # Uno R4
arduino-cli core install Seeeduino:samd           # XIAO SAMD21
arduino-cli core install rp2040:rp2040            # XIAO RP2040
arduino-cli core install esp32:esp32              # XIAO ESP32 boards

# Verify installation
arduino-cli version
```

#### Additional Tools (Optional)

| Tool | Purpose | Install |
|------|---------|---------|
| Go 1.21+ | Required by TinyGo | `brew install go` |
| OpenOCD | On-chip debugging | `brew install openocd` |
| `screen` / `minicom` | Serial monitor | `brew install minicom` |
| OpenSCAD | Parametric 3D modeling | `brew install openscad` |
| PrusaSlicer / Cura | 3D print slicing | Download from website |
| atopile | Code-first PCB design | `pip install atopile` |

### Setting Up a New Board

1. **Add the board to your manifest** — edit [`config/project.yaml`](config/project.yaml):
   ```yaml
   boards:
     - id: main
       board: xiao-esp32s3
       language: tinygo
       role: Main controller
   ```

2. **Create the firmware directory:**
   ```bash
   mkdir -p firmware/boards/xiao-esp32s3/tinygo
   ```

3. **Add a board config** (optional but recommended):
   ```bash
   # Copy pin mappings and features for your board
   touch firmware/boards/xiao-esp32s3/config.yaml
   ```
   See [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for the config format.

4. **Write your firmware** in the language subdirectory:
   ```
   firmware/boards/xiao-esp32s3/
   ├── tinygo/
   │   ├── main.go
   │   ├── go.mod
   │   └── README.md
   └── config.yaml
   ```

### Building and Flashing Firmware

Use the provided scripts from the project root:

```bash
# Build firmware for a specific board and language
./scripts/build.sh <board-name> <language>

# Flash firmware to a connected board
./scripts/flash.sh <board-name> <language>

# Examples:
./scripts/build.sh xiao-esp32s3 tinygo
./scripts/flash.sh xiao-esp32s3 tinygo

./scripts/build.sh arduino-uno arduino
./scripts/flash.sh arduino-uno arduino
```

> **Tip:** Board names use lowercase-kebab-case. See the full naming table in [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md).

---

## 📁 Project Structure

```
.
├── firmware/                  # All firmware source code
│   ├── boards/                # Per-board firmware (by board, then language)
│   ├── shared/                # Shared libraries (tinygo/ and arduino/)
│   └── protocols/             # Inter-board communication (i2c, spi, uart, wifi)
│
├── circuits/                  # Custom PCB design (atopile)
│   ├── ato.yaml               # Project manifest
│   ├── elec/src/              # Source .ato circuit files
│   ├── layouts/               # KiCad PCB layouts
│   └── build/                 # Build outputs (Gerber, BOM, etc.)
│
├── models/                    # 3D printing files
│   ├── enclosures/            # Board cases and housings (STL/3MF)
│   ├── mounts/                # Brackets, standoffs, clips
│   ├── robotics/              # Structural and mechanical parts
│   ├── jigs/                  # Assembly and soldering jigs
│   └── _source/               # Editable CAD source (F3D, STEP, SCAD)
│
├── config/                    # Project configuration
│   ├── project.yaml           # Board manifest — which boards and their roles
│   └── pins/                  # Shared pin mapping references
│
├── scripts/                   # Build, flash, and utility scripts
├── tests/                     # Test files
├── docs/                      # Documentation
│   ├── ARCHITECTURE.md        # Full directory structure and conventions
│   ├── WIRING.md              # Wiring diagrams and pin connections
│   └── BOM.md                 # Bill of materials
│
└── .roo/skills/               # AI agent skills (56 board+language+accessory skills)
```

📖 **For the complete directory tree and all conventions, see [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md).**

---

## 🔗 Multi-Board Projects

This template is designed for projects that use **multiple microcontrollers working together** — for example, a WiFi-enabled controller coordinating several sensor nodes over I2C.

### Declaring Multiple Boards

Define all boards and their connections in [`config/project.yaml`](config/project.yaml):

```yaml
project:
  name: my-robot
  description: A robot with distributed sensor nodes

boards:
  - id: controller
    board: xiao-esp32s3
    language: tinygo
    role: Central controller and WiFi gateway

  - id: left-arm
    board: xiao-rp2040
    language: tinygo
    role: Left arm servo controller
    connection:
      protocol: i2c
      address: 0x10

  - id: sensor-hub
    board: arduino-uno
    language: arduino
    role: Environmental sensor aggregator
    connection:
      protocol: uart
      baud: 115200
```

### Supported Communication Protocols

| Protocol | Config Key | Use Case |
|----------|-----------|----------|
| I2C | `address` (hex) | Short-range, multi-device bus |
| SPI | `cs_pin` | High-speed, point-to-point |
| UART | `baud` | Serial communication |
| WiFi | `port` | Wireless TCP/UDP |

### Inter-Board Communication

Shared protocol implementations live in [`firmware/protocols/`](firmware/protocols/). Each board imports from these shared modules to ensure consistent message formats. Document physical wiring in [`docs/WIRING.md`](docs/WIRING.md).

---

## ⚡ Custom Circuit Boards

This template supports custom PCB design using [atopile](https://atopile.io/), a code-first hardware design tool. Define circuits as code in `.ato` files, then compile to KiCad schematics and PCB layouts.

```
circuits/
├── ato.yaml           # Project manifest
├── elec/src/
│   └── main.ato       # Main circuit entry point
├── layouts/           # KiCad PCB layout files
└── build/             # Generated outputs
```

Atopile outputs:
- **KiCad schematics and PCB layouts** — For physical board design
- **Gerber ZIP files** — For PCB fabrication
- **Bill of Materials (BOM)** — Component ordering list
- **Pick-and-place files** — For automated assembly

📖 **See [`circuits/README.md`](circuits/README.md) for installation, workflow, and CLI commands.**

---

## 🖨 3D Printing

The [`models/`](models/) directory organizes 3D-printable files for your project's physical components:

| Directory | Contents |
|-----------|----------|
| [`models/enclosures/`](models/enclosures/) | Board cases, project housings |
| [`models/mounts/`](models/mounts/) | Brackets, standoffs, DIN rail clips |
| [`models/robotics/`](models/robotics/) | Arms, joints, chassis, gears |
| [`models/jigs/`](models/jigs/) | Assembly and soldering jigs |
| [`models/_source/`](models/_source/) | Editable CAD source files (F3D, STEP, SCAD) |

**Print-ready files** (STL, 3MF) go in the category folders. **Editable source files** go in `_source/`.

File naming convention: `<descriptive-name>[-v<version>].<ext>` (e.g., `xiao-case-v2.stl`)

📖 **See [`models/README.md`](models/README.md) for print settings, material recommendations, and tolerance notes.**

---

## 🤖 AI Agent Skills

This template includes **56 AI agent skills** in [`.roo/skills/`](.roo/skills/) that provide board-specific and accessory-specific reference information for [Roo Code](https://roocode.com/) and compatible AI coding assistants.

### What Skills Provide

Each skill contains a `SKILL.md` file with:
- **Board specifications** — MCU, flash, RAM, voltage
- **Complete pin mapping** — GPIO, analog, PWM, with notes
- **Peripheral details** — I2C, SPI, UART, ADC pin assignments
- **Language-specific guidance** — toolchain targets, required packages, known limitations
- **Minimum blink example** — verified starter code
- **Useful links** — datasheets, schematics, wiki pages

### How Skills Help

When you ask an AI agent to write firmware for a specific board, the relevant skill is automatically loaded, giving the agent accurate pin mappings, correct toolchain identifiers, and board-specific constraints. This eliminates common errors like wrong pin numbers or incompatible library calls.

### Skill Coverage

| Family | Boards | Languages | Skills |
|--------|--------|-----------|--------|
| Seeed Studio XIAO | 15 | TinyGo, Arduino | 30 |
| Arduino | 5 | TinyGo, Arduino | 10 |
| Raspberry Pi | 2 | Python, Go | 2 |
| XIAO Accessories | 14 | — | 14 |
| **Total** | **22 boards + 14 accessories** | **4** | **56** |

Board skills follow the naming pattern `<Family>-<Model>-<Language>` (e.g., `XIAO-ESP32S3-TinyGo`, `Arduino-Uno-Arduino`).

### Raspberry Pi SBCs (2 skills)

| Board | Languages | Skill |
|-------|-----------|-------|
| Raspberry Pi 4 Model B | Python, Go | `raspberrypi-4b` |
| Raspberry Pi 5 | Python, Go | `raspberrypi-5` |

### XIAO Expansion Hats & Accessories (14 skills)

Accessory skills provide wiring guides, interface details, and example code for XIAO-compatible expansion hats and breakout boards. They follow the naming pattern `XIAO-Accessory-<Name>`.

| Accessory | Interface | Skill |
|-----------|-----------|-------|
| XIAO Logger HAT | I2C (SHT40, BH1750, RTC) | `XIAO-Accessory-LoggerHAT` |
| 24GHz mmWave Presence Sensor | UART (D2/D3) | `XIAO-Accessory-mmWave24GHz` |
| L76K GNSS Module | UART (D6/D7) | `XIAO-Accessory-L76K-GNSS` |
| reSpeaker Lite | I2S / USB Audio | `XIAO-Accessory-reSpeakerLite` |
| CAN Bus Breakout Board | SPI (MCP2515) | `XIAO-Accessory-CANBus` |
| 6-Channel Wi-Fi 5V DC Relay | GPIO / ESPHome | `XIAO-Accessory-6ChRelay` |
| ePaper Breakout Board | SPI (24-pin FPC) | `XIAO-Accessory-ePaperBreakout` |
| XIAO PowerBread | Power passthrough | `XIAO-Accessory-PowerBread` |
| COB LED Driver Board | GPIO (PWM) | `XIAO-Accessory-COBLEDDriver` |
| ePaper Driver Board | SPI | `XIAO-Accessory-ePaperDriver` |
| Sound Event Detection D1 | Digital output | `XIAO-Accessory-SoundEventD1` |
| RS485 Breakout Board | UART (RS485) | `XIAO-Accessory-RS485` |
| Expansion Board Base | I2C + SPI + GPIO | `XIAO-Accessory-ExpansionBoard` |
| Grove Vision AI V2 | I2C (SSCMA) | `XIAO-Accessory-GroveVisionAIv2` |

---

## 🤝 Contributing

<!-- ✏️ CUSTOMIZE THIS: Update with your project's contribution guidelines. -->

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes (`git commit -am 'Add my feature'`)
4. Push to the branch (`git push origin feature/my-feature`)
5. Open a Pull Request

Please ensure your firmware compiles cleanly and any new boards include appropriate documentation.

---

## 📄 License

This project is released into the public domain under the [Unlicense](LICENSE). See the [`LICENSE`](LICENSE) file for details.
