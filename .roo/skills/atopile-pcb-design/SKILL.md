---
name: atopile-pcb-design
description: >
  Provides comprehensive reference for designing custom circuit boards using atopile,
  a code-first electronic design tool with Python-inspired syntax. Use when writing .ato
  source files, configuring ato.yaml manifests, using atopile CLI commands, designing
  PCB modules with constraints/assertions, or integrating with KiCad and JLCPCB manufacturing.
  Covers language syntax, project structure, package management, build workflow, and
  component selection.
---

# Atopile — Code-First PCB Design Guide

Provides comprehensive reference for designing custom circuit boards using atopile, a code-first electronic design tool with Python-inspired syntax.

## When to use

- Writing or editing `.ato` source files
- Configuring `ato.yaml` project manifests
- Running atopile CLI commands (`ato build`, `ato add`, etc.)
- Designing circuit modules with constraints and assertions
- Selecting components from the JLCPCB parts library
- Integrating atopile output with KiCad for layout
- Preparing manufacturing files (Gerber, BOM, pick-and-place)
- Creating reusable atopile packages

## When NOT to use

- Pure KiCad layout/routing questions with no atopile involvement — use KiCad documentation instead
- Firmware or software development — use the appropriate firmware skill
- Mechanical/enclosure design — use CAD tools

---

## 1. Overview

**Atopile** designs electronic circuit boards using code, bringing software development workflows to hardware design.

**Key features:**
- **Code-first hardware design** — capture design intelligence and constraints directly in code
- **Auto-selection of components** — the compiler picks resistors, capacitors, etc. from the JLCPCB parts library to meet your specs
- **Embedded calculations** — assertions and math checked on every build
- **Reusable modules** — reliable, configurable design blocks with inheritance
- **Version control** — git-based workflow for hardware, just like software
- **Package management** — share and reuse circuit modules via the registry

**Integration:**
- Uses **KiCad** (open source) for PCB layout and routing
- Component auto-selection uses the **JLCPCB parts library**
- Manufacturing export generates files ready for **JLCPCB upload**

**Output formats:**

| Output | Format | Purpose |
|--------|--------|---------|
| KiCad PCB | `.kicad_pcb` | Layout and routing |
| Gerber files | `.zip` | PCB fabrication |
| BOM | `.csv` | Component procurement |
| Pick and place | `.csv` | Assembly placement data |

---

## 2. Installation

### Primary: VS Code Extension

1. Install VS Code (or Cursor / Google Antigravity)
2. Install the **atopile extension** from the marketplace
3. Install **KiCad** for PCB layout:
   - macOS: `brew install kicad`
   - Other platforms: see [docs](https://docs.atopile.io/atopile-0.14.x/quickstart/1-installation)

### Alternative: Homebrew (macOS)

```bash
brew install atopile/tap/atopile
```

### Alternative: uv (cross-platform)

```bash
# Install uv first: https://docs.astral.sh/uv/getting-started/installation/
uv tool install atopile
ato --version
```

### Online Playground

Try without installing: https://playground.atopile.io/

---

## 3. Project Structure

```
<project_name>/
├── ato.yaml              # Project manifest
├── elec/
│   ├── src/              # .ato source files
│   │   ├── main.ato      # Main project file
│   │   └── parts/        # Part definitions (pinout, footprint, 3D model)
│   └── layouts/          # KiCad layout files
├── build/                # Build outputs (gitignored)
└── .ato/                 # Cached dependencies (gitignored)
```

| Path | Purpose |
|------|---------|
| `ato.yaml` | Central manifest for compiler and package manager |
| `elec/src/` | Pure `.ato` source files; one module per file where possible |
| `elec/layouts/` | KiCad footprints, STEP models, board layout tweaks |
| `elec/src/parts/` | Part definitions (pinout, footprint, 3D model files) |
| `.ato/` | Cached dependencies (like `node_modules`) — gitignore |
| `build/` | Generated outputs — gitignore |

---

## 4. ato.yaml Configuration

```yaml
requires-atopile: "^0.10.8"

paths:
  src: ./src
  layout: ./layout

builds:
  default:
    entry: main.ato:App
    hide_designators: true
    exclude_checks: ["PCB.requires_drc_check"]

dependencies:
  - type: registry
    identifier: atopile/ti-ads1115
    release: 0.1.6
```

### Sections

| Field | Description |
|-------|-------------|
| `requires-atopile` | Version constraint for the atopile compiler |
| `paths.src` | Location of `.ato` source files (default: `./src`) |
| `paths.layout` | Location of layout files (default: `./layout`) |
| `builds.<name>.entry` | Entry point module (`filename.ato:ModuleName`) |
| `builds.<name>.hide_designators` | Hide component designators on board |
| `builds.<name>.exclude_checks` | Skip specific checks |
| `dependencies` | Registry, git, or local packages (managed by `ato add`) |

### Dependency types

```yaml
# Registry package
- type: registry
  identifier: atopile/buttons
  release: 0.2.2

# Git package
# Added via: ato add git://{git-url}

# Local package
# Added via: ato add file://./path/to/package
```

---

## 5. Language Reference

The `.ato` language is a DSL for describing electronic circuits, inspired by Python syntax.

### 5.1 Types

| Type | Description |
|------|-------------|
| `module` | Primary building block — represents a circuit module |
| `component` | Subclass of `module` — represents a single physical component |
| `interface` | Connection point / signal interface |
| `Electrical` | Built-in interface type for a single electrical net |

### 5.2 Defining Modules

```ato
module SomeModule:
    some_signal = new ElectricSignal
    gnd = new Electrical
    some_signal.reference.lv ~ gnd
    some_variable = "some value"
```

### 5.3 Inheritance

```ato
module SubclassedModule from SomeModule:
    # Inherits all signals and variables from SomeModule
    some_variable = "some other value"

# Components can subclass modules (but not the reverse)
component Texas_Instruments_NE5532DR from LDO:
    # component-specific definitions
```

> You can subclass a `module` as a `component`, but NOT the other way around.

### 5.4 Creating Instances (`new`)

```ato
module Test:
    gnd = new Electrical
    subclassed_module = new SubclassedModule
    subclassed_module.gnd ~ gnd
```

### 5.5 Connections (`~` operator)

Any `interface` connects to another interface of the same type using `~`:

```ato
some_signal ~ another
power.hv ~ r_top.p1; r_top.p2 ~ output.line
```

Multiple connections can be chained on one line with `;`.

### 5.6 Signals and Pins

```ato
signal IN1neg ~ pin 2    # Create signal and map to footprint pad
signal OUT1 ~ pin 1
```

The `pin` keyword creates a signal and connects it to a pad on the footprint.

### 5.7 Attributes and Units

Assign values with units (no space between number and unit):

```ato
some_instance.value = 100ohm +/- 10%
resistor.package = "0402"
```

Supported units:

| Unit | Syntax |
|------|--------|
| Resistance | `ohm`, `Ω`, `Kohm`, `Mohm` |
| Capacitance | `F`, `uF`, `nF`, `pF` |
| Voltage | `V`, `mV` |
| Current | `A`, `mA`, `uA` |

### 5.8 Tolerances

```ato
1V to 2V           # Range
3uF +/- 1uF        # Absolute tolerance
4Kohm +/- 1%       # Percentage tolerance
3V +/- 10mV        # Absolute tolerance on voltage
4.7uF +/- 20%      # Generic capacitor spec
```

### 5.9 Variable Declarations

```ato
v_in: voltage
v_out: voltage
max_current: current
total_resistance: resistance
ratio: dimensionless
```

### 5.10 Assertions and Math

```ato
a = 1 ± 0.1
b = 2 ± 0.2
c: resistance

assert a < b                     # Comparison
assert c within 1Kohm to 10Kohm  # Range constraint (solved then checked)
```

The `assert ... is` form links variables and creates equations:

```ato
assert v_out is v_in * r_bottom.resistance / r_total
assert v_out is output.reference.voltage
```

Supported operators: `<`, `>`, `within` (all inclusive of bounds).

The compiler **automatically solves systems of constraints** for free variables and checks that values are within tolerances.

### 5.11 Imports

```ato
# From a specific file (path relative to project root or .ato/modules/)
from "where.ato" import What, Why, Wow

# Shorthand for standard library
import Resistor
import Resistor, ElectricPower, ElectricSignal
```

> **Warning**: Legacy syntax `import XYZ from "abc.ato"` is deprecated.

### 5.12 Specialization (`->` operator)

```ato
some_instance -> AnotherModuleType
```

### 5.13 Docstrings

```ato
module VoltageDivider:
    """
    A voltage divider using two resistors.
    Connect to the `power` and `output` interfaces.
    """
```

### 5.14 Comments

```ato
# This is a comment
r1 = new Resistor  # Inline comment
```

### 5.15 Configuring Blocks

Unlike Python, no `self.` needed — assignments within a block scope are automatically assigned to the block:

```ato
some_instance.value = 100ohm +/- 10%
```

Setting `package` constrains component selection:

```ato
resistor.package = "0402"
```

### 5.16 Traits

Metadata annotations on components (experimental):

```ato
#pragma experiment("TRAITS")
import has_datasheet_defined, has_designator_prefix, has_part_picked
import is_atomic_part, is_auto_generated

component MyPart:
    trait is_atomic_part<manufacturer="Texas Instruments", partnumber="NE5532DR",
        footprint="SOIC-8_L4.9-W3.9-P1.27-LS6.0-BL.kicad_mod",
        symbol="NE5532DR.kicad_sym",
        model="SOIC-8_L4.9-W3.9-H1.7-LS6.0-P1.27.step">
    trait has_part_picked::by_supplier<supplier_id="lcsc", supplier_partno="C7426",
        manufacturer="Texas Instruments", partno="NE5532DR">
    trait has_designator_prefix<prefix="U">
    trait has_datasheet_defined<datasheet="https://...">
```

---

## 6. Standard Library Types

### Common Imports

```ato
import Resistor
import Capacitor
import Inductor
import ElectricPower
import ElectricSignal
import Electrical
```

### Interface Types

| Type | Description | Key Attributes |
|------|-------------|----------------|
| `Electrical` | Single electrical net | — |
| `ElectricSignal` | Signal with reference | `.line`, `.reference` |
| `ElectricPower` | Power interface | `.hv` (high voltage), `.lv` (low voltage) |

### Component Types

| Type | Key Attributes |
|------|----------------|
| `Resistor` | `.resistance`, `.package`, `.p1`, `.p2` |
| `Capacitor` | `.capacitance`, `.package` |
| `Inductor` | `.inductance`, `.package` |

---

## 7. Common Component Patterns

### Resistor

```ato
import Resistor

r1 = new Resistor
r1.resistance = 10kohm +/- 5%
r1.package = "0402"
```

### Capacitor

```ato
import Capacitor

c1 = new Capacitor
c1.capacitance = 4.7uF +/- 20%
c1.package = "0402"
```

### Using a Microcontroller Package (e.g., RP2040)

```bash
ato add atopile/rp2040
```

```ato
from "rp2040/RP2040Kit.ato" import RP2040Kit

module App:
    uc = new RP2040Kit
```

### Using an ADC Package

```bash
ato add atopile/ti-ads1115
```

```ato
from "ti-ads1115.ato" import TI_ADS1115

module ExampleADCProject:
    adc = new TI_ADS1115
```

### Adding a Specific Part via CLI

```bash
ato create part
# Enter JLCPCB part number (e.g., C7426) or exact MPN (e.g., NE5532DR)
```

This generates a `.ato` file with pinout, footprint, and 3D model references.

---

## 8. CLI Commands Reference

| Command | Description |
|---------|-------------|
| `ato build` | Build code to update PCB |
| `ato -v build` | Build with verbose output |
| `ato add <package>` | Add a package dependency |
| `ato remove <package>` | Remove a package dependency |
| `ato sync` | Install all dependencies from `ato.yaml` |
| `ato create project` | Create a new project |
| `ato create part` | Fetch a part (pinout, footprint, 3D model) |
| `ato create component` | Create a new component (interactive) |
| `ato create build` | Add a new build config to `ato.yaml` |
| `ato configure` | Re-install KiCad plugin and configure |
| `ato --help` | Show help |
| `ato --version` | Show version |

Command structure:

```
ato [app-options] command [command-options] arguments
```

The `-v` flag increases verbosity (placed after `ato`, before the command).

---

## 9. Build & Manufacturing Workflow

### Build Process

```bash
ato build
```

When you run `ato build`:

1. Compiler reads `.ato` source files
2. Resolves imports and dependencies
3. Solves constraint systems (assertions, tolerances)
4. Auto-selects components from the JLCPCB parts library
5. Generates a KiCad project file (`.kicad_pcb`)
6. Opens KiCad if building a single target

### Full Workflow

1. **Design** — Write `.ato` code defining modules, connections, and constraints
2. **Search packages** — Check https://packages.atopile.io and GitHub for existing modules
3. **Add dependencies** — `ato add <package>` to install reusable modules
4. **Build** — `ato build` to compile, select components, generate KiCad files
5. **Layout** — Open KiCad to place components and route traces
6. **Iterate** — Repeat steps 1–5 until satisfied
7. **Export** — Use the manufacturing export wizard to generate Gerber, BOM, and pick-and-place files
8. **Manufacture** — Upload exported files to JLCPCB or other manufacturer
9. **Version control** — Push changes to git; CI can automatically build and generate manufacturing files

---

## 10. Integration with Microcontroller Projects

Atopile fits into the broader microcontroller project workflow for:

- **Custom carrier boards** — Design PCBs that host XIAO or other microcontroller modules, with exact connectors and power regulation
- **Sensor breakout boards** — Create boards with specific sensor ICs, pull-up resistors, and decoupling capacitors defined in code
- **Power distribution boards** — Design voltage regulators and power routing with assertions to validate voltage/current constraints
- **Firmware integration** — The PCB design in `circuits/` complements firmware in `firmware/`; pin assignments in `.ato` files correspond to firmware pin definitions

### Example: XIAO Carrier Board Pattern

```ato
import ElectricPower, ElectricSignal, Resistor, Capacitor

module XIAOCarrier:
    """Carrier board for Seeed XIAO modules."""
    # Power
    power = new ElectricPower
    assert power.voltage within 3.0V to 3.6V

    # I2C pull-ups
    sda = new ElectricSignal
    scl = new ElectricSignal
    r_sda = new Resistor
    r_scl = new Resistor
    r_sda.resistance = 4.7kohm +/- 5%
    r_scl.resistance = 4.7kohm +/- 5%

    # Pull-up connections
    power.hv ~ r_sda.p1; r_sda.p2 ~ sda.line
    power.hv ~ r_scl.p1; r_scl.p2 ~ scl.line

    # Decoupling
    c_dec = new Capacitor
    c_dec.capacitance = 100nF +/- 20%
    power.hv ~ c_dec.p1; c_dec.p2 ~ power.lv
```

---

## 11. Package Management

### Finding Packages

- **Registry**: https://packages.atopile.io/
- **Community**: GitHub repositories

### Adding Dependencies

```bash
# From registry
ato add atopile/ti-ads1115

# From git
ato add git://{git-url}

# From local directory
ato add file://./path/to/package
```

### Managing Dependencies

| Command | Action |
|---------|--------|
| `ato sync` | Install all dependencies from `ato.yaml` (run when pulling a new project) |
| `ato add <package>` | Add to `ato.yaml`, install locally, sync all |
| `ato remove <package>` | Remove from `ato.yaml`, remove locally, sync remaining |

Dependencies are cached in `.ato/` (similar to `node_modules`).

> You cannot publish a package that depends on unpublished packages.

---

## 12. Common Gotchas / Tips

- **Build before layout** — Always run `ato build` before opening KiCad; the build generates/updates the KiCad project
- **KiCad plugin** — Run `ato configure` if the KiCad plugin isn't working; it re-installs the sync plugin
- **Git integration** — Gitignore `.ato/` and `build/`; commit `ato.yaml`, `elec/src/`, and `elec/layouts/`
- **Assertions are checked every build** — Use them liberally to catch constraint violations early
- **No `self.` needed** — Unlike Python, assignments within a block scope are automatically scoped to the block
- **Import paths** — File paths in imports are relative to the project root (where `ato.yaml` is) or within `.ato/modules/`
- **Legacy import syntax** — `import XYZ from "abc.ato"` is deprecated; use `from "abc.ato" import XYZ`
- **Component subclassing** — You can subclass a `module` as a `component`, but NOT the reverse
- **Package attribute** — Setting `.package = "0402"` constrains auto-selection to that package size

---

## 13. Complete Examples

### Minimal Hello World

```ato
import Resistor

module App:
    r1 = new Resistor
    r1.resistance = 50kohm +/- 10%
```

### Simple Voltage Divider

```ato
import Resistor

module VoltageDivider:
    r_top = new Resistor
    r_bottom = new Resistor
    r_top.p2 ~ r_bottom.p1

module App:
    my_vdiv = new VoltageDivider
    my_vdiv.r_top.resistance = 10kohm +/- 10%
    my_vdiv.r_bottom.resistance = 4.7kohm +/- 10%
```

### Production Voltage Divider with Constraints

```ato
import Resistor, ElectricPower, ElectricSignal

module VoltageDivider:
    """
    A voltage divider using two resistors.
    Connect to the `power` and `output` interfaces.
    Configure via:
    - `power.voltage`
    - `output.reference.voltage`
    - `max_current`
    """
    power = new ElectricPower
    output = new ElectricSignal

    r_bottom = new Resistor
    r_top = new Resistor

    v_in: voltage
    v_out: voltage
    max_current: current
    r_total: resistance
    ratio: dimensionless

    # Connections
    power.hv ~ r_top.p1; r_top.p2 ~ output.line
    output.line ~ r_bottom.p1; r_bottom.p2 ~ power.lv

    # Link interface voltages
    assert v_out is output.reference.voltage
    assert v_in is power.voltage

    # Equations
    assert r_top.resistance is (v_in - v_out) / max_current
    assert r_bottom.resistance is v_out / max_current
    assert r_total is r_top.resistance + r_bottom.resistance
    assert v_out is v_in * r_bottom.resistance / r_total
    assert v_out is v_in * ratio
    assert max_current is v_in / r_total
    assert ratio is r_bottom.resistance / r_total

module App:
    my_vdiv = new VoltageDivider
    assert my_vdiv.power.voltage is 10V +/- 1%
    assert my_vdiv.output.reference.voltage within 3.3V +/- 10%
    assert my_vdiv.max_current within 10uA to 100uA
```

---

## 14. Reference Links

| Resource | URL |
|----------|-----|
| Official docs | https://docs.atopile.io/ |
| Package registry | https://packages.atopile.io/ |
| GitHub | https://github.com/atopile/atopile |
| Discord community | https://discord.gg/CRe5xaDBr3 |
| Blog | https://blog.atopile.io |
| YouTube | https://www.youtube.com/@atopile_io |
| Online playground | https://playground.atopile.io/ |
