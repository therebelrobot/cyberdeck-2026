# XIAO SAMD21 HID Bridge Firmware

TinyGo firmware for the Seeed Studio XIAO SAMD21 microcontroller, providing HID bridge functionality between USB peripherals (keyboard/mouse) and the Raspberry Pi Zero 2W host.

## Overview

The XIAO SAMD21 acts as a USB HID device, collecting keyboard/mouse input and forwarding it to the RPi over I2C or UART.

```
┌─────────────┐    USB HID     ┌─────────────┐    I2C/UART    ┌─────────────┐
│   Keyboard  │◄──────────────►│  XIAO SAMD21 │◄──────────────►│   RPi Zero  │
│   / Mouse   │                │  (HID Bridge)│                │      2W     │
└─────────────┘                └─────────────┘                └─────────────┘
```

## Hardware

- **Board**: Seeed Studio XIAO SAMD21
- **Interface**: USB Native (HID device), I2C (host communication)
- **Status LED**: Built-in LED for status indication

## Pin Usage

| Pin | Function | Notes |
|-----|----------|-------|
| PA01 | UART TX | Debug console |
| PA00 | UART RX | Debug console |
| PA22 | I2C SDA | Host communication |
| PA23 | I2C SCL | Host communication |
| LED  | Status LED | Built-in, active HIGH |

## Build

```bash
# Install TinyGo (macOS)
brew install tinygo

# Build for XIAO SAMD21
cd firmware/boards/xiao-samd21/tinygo
tinygo build -target=seeed-xiao -o firmware.bin ./main.go

# Or use the makefile
make firmware.bin
```

## Flash

```bash
# Using bossac (native)
bossac -d --port=/dev/ttyACM0 -U true -w firmware.bin -R

# Or using BOSSA via arduino-cli
arduino-cli upload -b seeed:avr:xiaosamd21 -p /dev/ttyACM0 --input-file firmware.bin
```

## Protocol

### I2C Communication

- **Slave Address**: 0x5A
- **Register Map**:
  - 0x00: Device type (0x01 = keyboard)
  - 0x01: Firmware version major
  - 0x02: Firmware version minor
  - 0x03: Status flags
  - 0x10-0x1F: Keyboard state buffer

### Host Commands

| Command | Data | Description |
|---------|------|-------------|
| 0x01 | - | Get device status |
| 0x02 | [state] | Set LED state |
| 0x03 | - | Get current key report |
| 0x10 | [6 bytes] | Set keyboard LEDs (NumLock, CapsLock, etc.) |

## Features

- USB HID keyboard interface
- USB HID mouse interface  
- I2C slave for host communication
- UART debug console (115200 baud)
- LED status indication

## TODO

- [ ] Implement TinyUSB HID device stack
- [ ] Add keyboard matrix scanning
- [ ] Add mouse protocol support
- [ ] Implement I2C slave protocol
- [ ] Add interrupt-driven input handling

## References

- [TinyGo](https://tinygo.org/)
- [Seeed XIAO SAMD21](https://wiki.seeedstudio.com/Seeeduino-Xiao/)
- [TinyUSB](https://github.com/tinygo-org/tinyusb)