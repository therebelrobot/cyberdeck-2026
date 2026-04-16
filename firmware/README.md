# Firmware

All firmware source code for this project, organized by board and language.

## Directory Structure

```
firmware/
├── boards/          # Per-board firmware directories
│   └── <board-name>/
│       ├── tinygo/      # TinyGo implementation
│       ├── arduino/     # Arduino implementation
│       └── config.yaml  # Board-specific pin map and config
│
├── shared/          # Shared libraries and utilities
│   ├── tinygo/      # Go packages shared across boards
│   └── arduino/     # Arduino libraries shared across boards
│
└── protocols/       # Inter-board communication implementations
    ├── i2c/
    ├── spi/
    ├── uart/
    └── wifi/
```

## Adding a New Board

1. Create a directory under `firmware/boards/` using lowercase-kebab-case (e.g., `xiao-esp32s3`)
2. Add language subdirectories (`tinygo/`, `arduino/`, or both)
3. Add a `config.yaml` with pin mappings and board features
4. Register the board in `config/project.yaml`

## Building

```bash
# Build firmware for a specific board
./scripts/build.sh <board-name> <language>

# Example
./scripts/build.sh xiao-esp32s3 tinygo
```

## Flashing

```bash
# Flash firmware to a connected board
./scripts/flash.sh <board-name> <language>

# Example
./scripts/flash.sh xiao-esp32s3 tinygo
```

## Shared Libraries

Place reusable code in `firmware/shared/<language>/`. These modules can be imported by any board's firmware to ensure consistency across the project.

## Communication Protocols

When boards communicate with each other, shared protocol implementations in `firmware/protocols/` ensure consistent message formats. See the project manifest (`config/project.yaml`) for connection definitions.
