# ⚡ Circuits — Custom PCB Design with Atopile

This directory contains custom circuit board designs using [atopile](https://atopile.io/), a code-first PCB design tool. Atopile uses `.ato` files with Python-inspired syntax to define circuits as code, enabling version control, reuse, and collaboration on hardware designs.

---

## 📑 Table of Contents

- [Why Atopile?](#-why-atopile)
- [Installation](#-installation)
- [Directory Structure](#-directory-structure)
- [Workflow](#-workflow)
- [Common CLI Commands](#-common-cli-commands)
- [Language Basics](#-language-basics)
- [Integration with This Project](#-integration-with-this-project)
- [Resources](#-resources)

---

## 💡 Why Atopile?

- **Code-first design** — Define circuits in `.ato` files using a readable, Python-inspired syntax
- **Version control** — Track circuit changes with Git just like firmware
- **Package ecosystem** — Reuse community components via `ato add <package>`
- **KiCad integration** — Outputs KiCad schematics and PCB layouts for physical design
- **Tolerance-aware** — Specify component values with tolerances (e.g., `10kohm +/- 5%`)
- **Assertion-based validation** — Add `assert` statements to verify electrical constraints

---

## 🔧 Installation

```bash
# Install atopile (requires Python 3.11+)
pip install atopile

# Verify installation
ato --version
```

> **Note:** Atopile requires Python 3.11 or later. Consider using a virtual environment or [pipx](https://pipx.pypa.io/) for isolated installation.

---

## 📁 Directory Structure

```
circuits/
├── README.md          # This file
├── ato.yaml           # Atopile project manifest
├── elec/
│   └── src/
│       └── main.ato   # Main circuit entry point
├── layouts/           # KiCad layout files (.kicad_pcb)
│   └── .gitkeep
└── build/             # Build outputs (auto-generated)
    └── .gitkeep
```

| Directory | Purpose |
|-----------|---------|
| `elec/src/` | Source `.ato` files defining your circuit modules |
| `layouts/` | KiCad PCB layout files for physical board design |
| `build/` | Generated outputs — Gerber files, BOMs, pick-and-place files |

> **Note:** The `.ato/` directory (atopile cache) and `build/` outputs are git-ignored.

---

## 🔄 Workflow

The typical atopile workflow:

### 1. Define your circuit

Edit `.ato` files in `elec/src/` to define your circuit modules:

```ato
from "generics/resistors.ato" import Resistor

module LEDCircuit:
    signal vcc
    signal gnd

    led = new LED
    resistor = new Resistor
    resistor.value = 220ohm +/- 10%

    vcc ~ resistor.p1
    resistor.p2 ~ led.anode
    led.cathode ~ gnd
```

### 2. Add component packages

Install component packages from the atopile registry:

```bash
cd circuits
ato add generics        # Generic components (resistors, capacitors, etc.)
ato add <package-name>  # Specific component packages
```

### 3. Build the project

Compile your `.ato` files into KiCad schematics:

```bash
cd circuits
ato build
```

### 4. Layout the PCB

Open the generated KiCad project to arrange components and route traces. After layout, sync changes back:

```bash
cd circuits
ato sync
```

### 5. Export manufacturing files

Build outputs include:
- **Gerber files** — For PCB fabrication
- **Bill of Materials (BOM)** — Component list for ordering
- **Pick-and-place files** — For automated assembly

---

## 🛠 Common CLI Commands

All commands should be run from the `circuits/` directory:

| Command | Description |
|---------|-------------|
| `ato build` | Compile `.ato` files and generate KiCad outputs |
| `ato add <package>` | Add a component package dependency |
| `ato sync` | Sync KiCad layout changes back to the project |
| `ato create` | Create a new atopile project (already done for this template) |
| `ato install` | Install all dependencies from `ato.yaml` |
| `ato --help` | Show all available commands |

---

## 📝 Language Basics

Atopile uses a Python-inspired syntax. Here are the key concepts:

### Modules

Modules are the building blocks of circuits (like classes in Python):

```ato
module PowerSupply:
    signal vin
    signal vout
    signal gnd
```

### Components

Instantiate components with `new`:

```ato
resistor = new Resistor
resistor.value = 10kohm +/- 5%
```

### Connections

Connect signals and pins with `~`:

```ato
vcc ~ resistor.p1
resistor.p2 ~ led.anode
```

### Imports

Import from installed packages:

```ato
from "generics/resistors.ato" import Resistor
from "generics/capacitors.ato" import Capacitor
```

### Assertions

Validate electrical constraints:

```ato
assert resistor.value within 1kohm to 100kohm
```

---

## 🔗 Integration with This Project

The `circuits/` directory complements the rest of the microcontroller project template:

- **Firmware** (`firmware/`) — The code running on your microcontroller
- **Circuits** (`circuits/`) — The custom PCB that your microcontroller connects to or is part of
- **Models** (`models/`) — 3D-printable enclosures for your custom PCB
- **Wiring** (`docs/WIRING.md`) — Document connections between your PCB and microcontrollers
- **BOM** (`docs/BOM.md`) — Reference the circuit BOM for component ordering

### Typical use cases

- **Breakout boards** — Custom PCBs that break out microcontroller pins to connectors
- **Sensor boards** — PCBs with sensors, conditioning circuits, and microcontroller footprints
- **Motor drivers** — Power electronics boards controlled by your microcontroller
- **Carrier boards** — Main PCBs that host XIAO or Arduino modules

---

## 📚 Resources

- [Atopile Documentation](https://docs.atopile.io/) — Official docs
- [Atopile GitHub](https://github.com/atopile/atopile) — Source code and issues
- [Atopile Packages](https://packages.atopile.io/) — Component package registry
- [KiCad](https://www.kicad.org/) — PCB layout editor (used for physical design)
- [Language Reference](https://docs.atopile.io/atopile-0.14.x/language) — Complete `.ato` syntax guide
