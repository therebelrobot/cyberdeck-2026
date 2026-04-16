---
name: pisugar-3
description: >
  Comprehensive guide for the PiSugar 3 battery hat add-on for Raspberry Pi. Covers hardware
  specifications, I2C interface for battery monitoring, pushbutton functionality, safe shutdown
  integration, and pisugar-server setup. Use when integrating battery power into Raspberry Pi
  Zero/3B/4B/5 projects, reading battery status via I2C or HTTP API, implementing safe power-off
  behavior, or configuring wake alarms. Keywords: PiSugar 3, battery hat, LiPo 900mAh, I2C 0x57,
  Raspberry Pi UPS, portable power, pisugar-server, battery monitoring, safe shutdown, RTC wake.
---

# PiSugar 3 — Battery Hat for Raspberry Pi

Comprehensive guide for the PiSugar 3 battery hat add-on board.

## When to Use

- Adding battery backup or portable power to Raspberry Pi Zero, Zero W, Zero 2W, 3B/3B+, 4B, or 5
- Monitoring battery voltage and charge level via I2C
- Implementing safe shutdown when battery is low
- Using the pushbutton for power on/off control
- Configuring wake alarms for scheduled operation
- Setting up the HTTP/WebSocket API server for battery telemetry

## When NOT to Use

- For non-Raspberry Pi boards → this is specific to the PiSugar ecosystem
- For projects with static power (wall adapter) → use a standard UPS or power supply
- For 5V-sensitive loads beyond the hat's 5V/2A output capability → check power requirements
- For primary computing on RPi 5 → consider a more robust UPS solution (PiSugar 3 is designed for Zero form factor)

---

## Hardware Overview

The PiSugar 3 is a compact LiPo battery hat designed specifically for the Raspberry Pi Zero form factor. It sits directly on the GPIO header and provides battery power, I2C battery monitoring, and a programmable pushbutton.

### Key Specifications

| Parameter | Value |
|---|---|
| **Battery Capacity** | 900mAh LiPo (3.7V nominal) |
| **Output Voltage** | 5V USB power output to Raspberry Pi |
| **I2C Address** | 0x57 (default, configurable) |
| **I2C Bus** | 0x01 (configurable via firmware) |
| **Charging Port** | Micro USB (5V/1A charging) |
| **Pushbutton** | Tactile button with single/double/long-press modes |
| **Dimensions** | 65mm × 30mm (matches Pi Zero footprint) |
| **Weight** | ~25g with battery |
| **Operating Temp** | -10°C to 50°C |
| **Price** | ~$20-25 |

### Board Layout

```
    ┌─────────────────────────────┐
    │      PiSugar 3 Hat          │
    │                             │
    │  [PWR] [BAT] [I2C]          │
    │                             │
    │      ┌─────────┐            │
    │      │  BATT   │            │
    │      │  LiPo   │            │
    │      │  3.7V   │            │
    │      │  900mAh │            │
    │      └─────────┘            │
    │                             │
    │   [●] Pushbutton            │
    │                             │
    │  ┌──────────────────────┐   │
    │  │  40-pin GPIO header  │   │
    │  │  (passes through)    │   │
    │  └──────────────────────┘   │
    └─────────────────────────────┘
         │   │   │
         └───┴───┘
            │
         RPi GPIO
```

### Safety Features

- Over-discharge protection (auto-shutoff at ~3.0V per cell)
- Overcharge protection (4.2V±0.05V cutoff)
- Short circuit protection
- Temperature monitoring and thermal shutdown
- Software-controlled safe shutdown via GPIO signaling

---

## I2C Interface

The PiSugar 3 communicates via I2C on bus 1 at address `0x57`. This allows direct battery monitoring without the pisugar-server daemon.

### I2C Register Map

| Register | Name | Description | Access |
|---|---|---|---|
| `0x2A` | Battery Level | Battery percentage (0-100) | Read (1 byte) |
| `0x22` | Battery Voltage | Battery voltage in millivolts | Read (2 bytes, big-endian) |
| `0x21` | Temperature | Board temperature in °C | Read (1 byte) |
| `0x7E` | Reset | Write `0xB6` to trigger soft reset | Write |
| `0x34` | Shutdown | Write `0x01` to trigger safe shutdown | Write |
| `0x35` | Power State | Power on/off status | Read (1 byte) |
| `0x36` | Button Event | Last button press event | Read (1 byte) |
| `0x37` | Wake Alarm | RTC wake alarm (seconds since epoch) | Read/Write (4 bytes) |

### Direct I2C Reading with Python

```python
#!/usr/bin/env python3
import smbus2

BUS = 1
ADDR = 0x57

bus = smbus2.SMBus(BUS)

def read_battery_level():
    return bus.read_byte_data(ADDR, 0x2A)

def read_battery_voltage():
    data = bus.read_i2c_block_data(ADDR, 0x22, 2)
    return (data[0] << 8) | data[1]  # big-endian

def read_temperature():
    return bus.read_byte_data(ADDR, 0x21)

def trigger_shutdown():
    bus.write_byte_data(ADDR, 0x34, 0x01)

# Example usage
print(f'Battery: {read_battery_level()}%')
print(f'Voltage: {read_battery_voltage()} mV')
print(f'Temp: {read_temperature()}°C')
```

---

## Pushbutton Operations

The PiSugar 3 features a multi-function pushbutton accessible via I2C register `0x36`:

| Action | Behavior |
|---|---|
| **Single tap** | Turn on power (if off) |
| **Double tap** | Turn off power (graceful shutdown) |
| **Long press (3s)** | Configurable — default triggers shutdown |
| **Long press (6s)** | Force power off (bypass graceful shutdown) |

### Reading Button Events

```python
import smbus2

BUS = 1
ADDR = 0x57

bus = smbus2.SMBus(BUS)

# Read button event register
button_event = bus.read_byte_data(ADDR, 0x36)

# Event codes:
# 0x01 = Single tap
# 0x02 = Double tap
# 0x03 = Long press
# 0x00 = No event (idle)

button_names = {0x00: 'idle', 0x01: 'single_tap', 0x02: 'double_tap', 0x03: 'long_press'}
print(f'Button event: {button_names.get(button_event, f'unknown({button_event:#x})')}')
```

### Power Control

```python
import smbus2

BUS = 1
ADDR = 0x57

bus = smbus2.SMBus(BUS)

def get_power_state():
    return bus.read_byte_data(ADDR, 0x35)

def is_power_on():
    return get_power_state() == 0x01

def is_power_off():
    return get_power_state() == 0x00

def initiate_shutdown():
    # Triggers graceful shutdown via PiSugar firmware
    bus.write_byte_data(ADDR, 0x34, 0x01)
```

---

## Compatibility

The PiSugar 3 is designed for the Raspberry Pi Zero form factor but works with all 40-pin GPIO Raspberry Pi models:

| Model | Compatibility | Notes |
|---|---|---|
| **Raspberry Pi Zero** | ✅ Full support | Original 512MB version |
| **Raspberry Pi Zero W** | ✅ Full support | WiFi/Bluetooth enabled |
| **Raspberry Pi Zero 2 W** | ✅ Full support | 4-core @ 1GHz, recommended |
| **Raspberry Pi 3B** | ✅ Full support | Works with 40-pin header |
| **Raspberry Pi 3B+** | ✅ Full support | Faster variant of 3B |
| **Raspberry Pi 4B** | ✅ Full support | Requires GPIO passthrough |
| **Raspberry Pi 5** | ✅ Full support | With GPIO header adapter |

### Physical Fit Notes

- **Pi Zero / Zero W / Zero 2W**: Direct fit — hat mounts flush
- **Pi 3B/3B+/4B**: Hat hangs off the edge — works but may need mounting
- **Pi 5**: Requires standoffs or adapter cable for secure mounting

---

## Installation

### Hardware Assembly

1. **Power off the Raspberry Pi** completely (not just shutdown)
2. **Align the PiSugar 3** with the 40-pin GPIO header
3. **Press down gently** until the header seats firmly
4. **Connect the battery** connector (if not pre-installed)
5. **Power on** by pressing the pushbutton once

### Enable I2C

```bash
# Add I2C to /boot/config.txt
echo 'dtparam=i2c_vc=on' | sudo tee -a /boot/config.txt
echo 'dtparam=i2c_arm=on' | sudo tee -a /boot/config.txt

# Or via raspi-config
sudo raspi-config
# Navigate: Interface Options → I2C → Enable

# Reboot
sudo reboot
```

### Verify I2C Connection

```bash
# Install i2c-tools if needed
sudo apt update && sudo apt install -y i2c-tools

# Scan for PiSugar at 0x57
sudo i2cdetect -y 1

# Expected output:
#      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
# 00:                         -- -- -- -- -- -- -- --
# 10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# 30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# 40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# 50: -- -- -- 57 -- -- -- -- -- -- -- -- -- -- -- --  (0x57 = PiSugar)
# 60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
```

### Test Battery Reading

```bash
# Read battery percentage
python3 -c '
import smbus2
bus = smbus2.SMBus(1)
level = bus.read_byte_data(0x57, 0x2A)
voltage = (bus.read_i2c_block_data(0x57, 0x22, 2)[0] << 8) | bus.read_i2c_block_data(0x57, 0x22, 2)[1]
print(f'Battery: {level}% ({voltage/1000:.2f}V)')
'
```

---

## pisugar-server Setup

The [pisugar-server](https://github.com/PiSugar/pisugar-server) provides an HTTP/WebSocket API for battery monitoring, pushbutton events, and power control.

### Installation

```bash
# Clone the repository
git clone https://github.com/PiSugar/pisugar-server.git
cd pisugar-server

# Install dependencies
sudo apt install -y python3-pip
pip3 install -e .

# Install service (runs on port 8421)
sudo cp extras/pisugar-server.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable pisugar-server
sudo systemctl start pisugar-server
```

### HTTP API Endpoints

| Endpoint | Method | Description |
|---|---|---|
| `http://localhost:8421/battery` | GET | Returns JSON with level, voltage, temp |
| `http://localhost:8421/power` | GET | Returns power state (on/off) |
| `http://localhost:8421/power/off` | POST | Initiates graceful shutdown |
| `http://localhost:8421/button` | GET | Returns last button event |
| `http://localhost:8421/alarm` | GET/POST | Get/set wake alarm |

### Example API Usage

```bash
# Get battery status
curl http://localhost:8421/battery

# Response:
# {
#   \"level\": 85,
#   \"voltage\": 4112,
#   \"temperature\": 32
# }

# Get power state
curl http://localhost:8421/power
# Response: {\"state\": \"on\"}

# Trigger shutdown
curl -X POST http://localhost:8421/power/off

# Set wake alarm (5 minutes from now)
WAKE_TIME=$(date -d '+5 minutes' +%s)
curl -X POST -d $WAKE_TIME http://localhost:8421/alarm
```

### Python Client Library

```python
import requests

BASE_URL = 'http://localhost:8421'

def get_battery():
    return requests.get(f'{BASE_URL}/battery').json()

def shutdown():
    requests.post(f'{BASE_URL}/power/off')

def set_alarm(timestamp):
    requests.post(f'{BASE_URL}/alarm', data=str(timestamp))

# Example: Monitor battery until low, then shutdown
battery = get_battery()
if battery['level'] < 20:
    print(f'Battery low ({battery[\"level\"]}%) — initiating shutdown')
    shutdown()
```

---

## Safe Shutdown Script

This script monitors battery level and triggers a safe shutdown when critically low:

```python
#!/usr/bin/env python3
import smbus2
import time
import subprocess
import signal
import sys

BUS = 1
ADDR = 0x57
LOW_THRESHOLD = 15  # %

bus = smbus2.SMBus(BUS)

def read_battery_level():
    return bus.read_byte_data(ADDR, 0x2A)

def read_battery_voltage():
    data = bus.read_i2c_block_data(ADDR, 0x22, 2)
    return (data[0] << 8) | data[1]

def safe_shutdown():
    print('Battery critically low — safe shutdown initiated')
    # Signal PiSugar to cut power after OS shutdown
    bus.write_byte_data(ADDR, 0x34, 0x01)
    subprocess.run(['sudo', 'shutdown', '-h', 'now'])

def signal_handler(signum, frame):
    print('Received signal, shutting down gracefully...')
    safe_shutdown()
    sys.exit(0)

# Register signal handlers for clean exit
signal.signal(signal.SIGTERM, signal_handler)
signal.signal(signal.SIGINT, signal_handler)

print(f'Monitoring battery (threshold: {LOW_THRESHOLD}%)')

while True:
    level = read_battery_level()
    voltage = read_battery_voltage() / 1000.0
    
    print(f'Battery: {level}% ({voltage:.2f}V)')
    
    if level <= LOW_THRESHOLD:
        safe_shutdown()
    
    time.sleep(60)  # Check every minute
```

### Running as Systemd Service

```bash
# Save the script as /usr/local/bin/battery-monitor.py
sudo cp battery-monitor.py /usr/local/bin/
sudo chmod +x /usr/local/bin/battery-monitor.py

# Create systemd service
sudo tee /etc/systemd/system/battery-monitor.service << 'EOF'
[Unit]
Description=Battery Monitor for PiSugar 3
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 /usr/local/bin/battery-monitor.py
Restart=on-failure
RestartSec=30

[Install]
WantedBy=multi-user.target
EOF

# Enable and start
sudo systemctl enable battery-monitor
sudo systemctl start battery-monitor
```

---

## RTC Wake Alarm Integration

The PiSugar 3 includes an RTC (real-time clock) that can trigger wake-up at a specified time. This is useful for scheduled operation in battery-powered projects.

### Setting a Wake Alarm

```python
import smbus2
import time

BUS = 1
ADDR = 0x57

bus = smbus2.SMBus(BUS)

def set_wake_alarm(seconds_from_now):
    wake_time = int(time.time()) + seconds_from_now
    # Write 4 bytes (big-endian)
    bus.write_i2c_block_data(ADDR, 0x37, [
        (wake_time >> 24) & 0xFF,
        (wake_time >> 16) & 0xFF,
        (wake_time >> 8) & 0xFF,
        wake_time & 0xFF
    ])
    print(f'Wake alarm set for {time.ctime(wake_time)}')

def clear_wake_alarm():
    bus.write_i2c_block_data(ADDR, 0x37, [0, 0, 0, 0])
    print('Wake alarm cleared')

def get_power_state():
    state = bus.read_byte_data(ADDR, 0x35)
    return 'on' if state == 0x01 else 'off'

# Example: Wake in 5 minutes (300 seconds)
set_wake_alarm(300)

# Example: Wake at specific time
import datetime
target = datetime.datetime.now() + datetime.timedelta(hours=2)
wake_timestamp = int(target.timestamp())
bus.write_i2c_block_data(ADDR, 0x37, [
    (wake_timestamp >> 24) & 0xFF,
    (wake_timestamp >> 16) & 0xFF,
    (wake_timestamp >> 8) & 0xFF,
    wake_timestamp & 0xFF
])
```

### Shutdown and Wake Workflow

1. **Set wake alarm** before initiating shutdown
2. **Shutdown OS** — `sudo shutdown -h now`
3. **PiSugar cuts power** to Raspberry Pi after graceful shutdown
4. **At wake time**, PiSugar restores power to Raspberry Pi
5. **Raspberry Pi boots** and resumes operation

This cycle enables ultra-low-power standby with known wake intervals (e.g., sensor reading every hour).

---

## Integration Patterns

### Portable Sensor Node

The PiSugar 3 enables truly portable Raspberry Pi projects:

```
┌─────────────────────────────┐
│      Raspberry Pi Zero 2W   │
│                             │
│  ┌─────────────────────┐    │
│  │      PiSugar 3      │    │
│  │      (900mAh)       │    │
│  └─────────────────────┘    │
│                             │
│  ┌─────────────────────┐    │
│  │   XIAO Sense Board  │    │
│  │   (Sensors + BLE)   │    │
│  └─────────────────────┘    │
│                             │
│  ┌─────────────────────┐    │
│  │    Custom Sensor    │    │
│  │    Hat / Peripherals│    │
│  └─────────────────────┘    │
└─────────────────────────────┘
```

### Power Architecture

- **Primary**: PiSugar 3 battery (5V/2A max)
- **Backup**: Automatic fallback to USB input when battery present
- **Charging**: Micro USB (5V/1A) — charges while running
- **Shutdown**: Graceful OS shutdown → PiSugar cuts power after delay

### Typical Use Cases

1. **Remote monitoring** — Solar/battery powered sensors with scheduled wake
2. **Portable data logger** — Walk-around data collection with periodic upload
3. **Emergency backup** — UPS-like functionality for critical systems
4. **Mobile robot** — Untethered operation with safe shutdown on low battery
5. **Field deployment** — Quick deployment without power infrastructure

---

## Troubleshooting

### I2C Device Not Found

```bash
# Verify I2C is enabled
raspi-config  # → Interface Options → I2C → Enable

# Check kernel loaded
lsmod | grep i2c

# Scan bus
sudo i2cdetect -y 1
```

### Battery Level Stuck at 100%

- Battery may be calibrating on first charge cycle
- Try full charge/discharge cycle
- Check battery connection is secure

### Shutdown Doesn't Cut Power

- Ensure `sudo shutdown -h now` completes fully
- Check `/boot/config.txt` has `dtparam=i2c_vc=on`
- Verify no services holding the system awake

### Pushbutton Not Working

- Check battery is properly connected
- Verify PiSugar firmware is up to date
- Try resetting: write `0xB6` to register `0x7E`

### Server Won't Start

```bash
# Check logs
journalctl -u pisugar-server -f

# Verify port not in use
sudo lsof -i :8421

# Reinstall if needed
pip3 uninstall pisugar-server
pip3 install -e .
```

### High Temperature Readings

- Normal operating range: 25-45°C
- Above 50°C: Reduce load or improve ventilation
- Above 60°C: Thermal throttling active — disconnect non-essential peripherals

---

## Additional Resources

- [PiSugar Official Documentation](https://github.com/PiSugar/pisugar-server)
- [I2C Register Reference](https://github.com/PiSugar/pisugar-server/wiki/I2C-Register-Map)
- [Raspberry Pi I2C Configuration](https://www.raspberrypi.com/documentation/computers/configuration.html#configuring-i2c)

---

## Related Skills

- [`raspberrypi-zero-2w`](raspberrypi-zero-2w/SKILL.md) — RPi Zero 2W GPIO and development guide
- [`raspberrypi-4b`](raspberrypi-4b/SKILL.md) — RPi 4B GPIO and development guide
- [`raspberrypi-5`](raspberrypi-5/SKILL.md) — RPi 5 GPIO and development guide