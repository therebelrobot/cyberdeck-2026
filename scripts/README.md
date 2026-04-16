# Scripts

Build, flash, and utility scripts for firmware development.

## Available Scripts

### `build.sh`

Build firmware for a specific board and language.

```bash
./scripts/build.sh <board-name> <language>

# Examples
./scripts/build.sh xiao-esp32s3 tinygo
./scripts/build.sh arduino-uno arduino
```

### `flash.sh`

Flash compiled firmware to a connected board.

```bash
./scripts/flash.sh <board-name> <language>

# Examples
./scripts/flash.sh xiao-esp32s3 tinygo
./scripts/flash.sh arduino-uno arduino
```

## Making Scripts Executable

After cloning, ensure scripts are executable:

```bash
chmod +x scripts/*.sh
```

## Customization

These scripts are templates — edit them to match your toolchain setup. Each script includes TODO comments indicating where to add board-specific build/flash commands.

### TinyGo

Requires [TinyGo](https://tinygo.org/) installed. The build/flash commands use `tinygo build` and `tinygo flash` with the appropriate `-target` flag for your board.

### Arduino

Requires [Arduino CLI](https://arduino.github.io/arduino-cli/) installed. The build/flash commands use `arduino-cli compile` and `arduino-cli upload` with the appropriate `--fqbn` for your board.
