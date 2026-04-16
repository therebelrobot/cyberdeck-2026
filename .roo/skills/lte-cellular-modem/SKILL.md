---
name: lte-cellular-modem
description: >
  Provides comprehensive reference for configuring and managing LTE/4G cellular modems on
  Linux systems (Raspberry Pi, etc.). Covers ModemManager integration, NetworkManager
  configuration, AT command handling, signal quality monitoring, and connection management.
  Use when setting up cellular internet on embedded Linux systems, configuring LTE dongles
  for off-grid projects, monitoring cellular connection state, or managing mobile broadband
  interfaces. Keywords: LTE, 4G, 5G, ModemManager, NetworkManager, AT commands, PPP,
  usb0, eth1, wwan0, cellular, mobile broadband, Quectel, SIM7600.
---

# LTE Cellular Modem Configuration Guide

Comprehensive guide for configuring and managing LTE/4G cellular modems on Linux systems.

## When to Use

- Configuring LTE dongle on Raspberry Pi for internet connectivity
- Setting up mobile broadband for off-grid/remote projects
- Monitoring cellular signal strength and connection state
- Managing cellular interfaces with ModemManager/NetworkManager
- Troubleshooting cellular connectivity issues
- Integrating cellular with embedded Linux projects (cyberdeck, etc.)

## When NOT to Use

- For WiFi/Bluetooth configuration → use appropriate wireless skills
- For LoRa/mesh networking → use meshtastic-integration skill
- For hardware design → use PCB design skills
- For non-Linux systems → vendor-specific documentation applies

---

## Overview

Cellular connectivity for embedded Linux projects typically uses:

| Component | Function |
|-----------|----------|
| **LTE Dongle** | Quectel/SIMCom module with SIM card slot |
| **USB Interface** | Presents as network interface (eth1, usb0, wwan0) |
| **ModemManager** | Controls modem, handles AT commands, monitors signal |
| **NetworkManager** | Manages network connections including cellular |

### Common Modem Types

| Model | Interface | Notes |
|-------|-----------|-------|
| Quectel EC25/EC20 | QMI over USB | Common, well-supported |
| SIM7600 | AT over USB | Also supports GNSS |
| Quectel EG25 | LTE Cat M1/Cat NB | For IoT applications |
| Sierra HL7600 | LTE Cat 1 | Reliable, industrial |

---

## Installation

### Install ModemManager

```bash
# Debian/Raspbian
sudo apt update
sudo apt install modemmanager modemmanager-gobject

# Check service is running
sudo systemctl status ModemManager

# Enable on boot
sudo systemctl enable ModemManager
```

### Install NetworkManager

```bash
# Usually pre-installed on Raspberry Pi OS
sudo apt install network-manager

# Enable
sudo systemctl enable NetworkManager
```

### Install AT Command Tool

```bash
# For direct modem communication
sudo apt install modemmanager-cli  # mmcli
sudo apt install at  # atinout for scripts
```

---

## Modem Detection

### Check USB

```bash
# List USB devices
lsusb

# Expected output (Quectel EC25):
# Bus 001 Device 004: ID 2c7c:0125 Quectel Wireless Solutions Co., Ltd EC25 LTE modem
```

### Check Interface

```bash
# List network interfaces
ip link show

# Usually shows as eth1, usb0, or wwan0 when connected
```

### Check ModemManager

```bash
# List available modems
sudo mmcli --list-modems

# Output example:
# /org/freedesktop/ModemManager1/Modem/0 [Quectel] EC25
```

---

## Configuration

### Basic Connection

```bash
# Scan for available operators
sudo mmcli -m 0 --location-scan

# Get SIM status
sudo mmcli -m 0 --sim

# Check signal quality
sudo mmcli -m 0 --signal-quality

# Expected output:
# signal: 72 (good)
```

### Connect to Network

```bash
# Enable modem
sudo mmcli -m 0 --enable

# Connect to carrier
sudo mmcli -m 0 --operator=select

# Or use automatic
sudo mmcli -m 0 --3gpp-scan

# Check registration
sudo mmcli -m 0 --location
```

### NetworkManager Setup

```bash
# Create cellular connection
nmcli connection add type gsm ifname cdc-wdm0 con-name "LTE" apn "internet"

# Or use interactive setup
nmcli connection edit type gsm

# Modify existing
nmcli connection modify "LTE" gsm.apn "internet"
nmcli connection modify "LTE" gsm.pin "1234"

# Activate
nmcli connection up "LTE"

# Check status
nmcli connection show
nmcli device show
```

---

## Monitoring

### Signal Quality

```bash
# Continuous monitoring
watch -n 5 'sudo mmcli -m 0 --signal-quality'

# Parse for scripting
signal=$(sudo mmcli -m 0 --signal-quality | grep "signal" | awk '{print $NF}')
echo "Signal: $signal dBm"
```

### Connection State

```bash
# Check if interface has IP
ip addr show eth1

# Check routing
ip route show

# Check DNS
cat /etc/resolv.conf
```

### Modem Info

```bash
# Full modem information
sudo mmcli -m 0

# Operating mode
sudo mmcli -m 0 --modes

# Band selection
sudo mmcli -m 0 --allowed-bands
```

---

## AT Commands

Direct modem communication when ModemManager isn't suitable:

### Interactive Mode

```bash
# Connect to modem
sudo minicom -D /dev/ttyUSB2

# Common commands:
AT+CSQ          # Signal quality
AT+COPS?        # Current operator
AT+CNMP?        # Network mode
AT+SIM?         # SIM status
AT+CPIN?        # SIM PIN status

# Exit minicom: Ctrl+A, then X
```

### Script AT Commands

```bash
# Using atinout
echo "AT+CSQ" | sudo atinout /dev/ttyUSB2 - -

# Using echo with redirect
echo -e "AT+CSQ\r" > /dev/ttyUSB2
cat /dev/ttyUSB2
```

---

## Troubleshooting

### Modem Not Detected

```bash
# Check USB kernel messages
dmesg | grep -i usb
dmesg | grep -i tty

# Try different USB mode
# Some modems need switching from modem mode to NMEA mode
sudo usb_modeswitch -v 0x2c7c -p 0x0125
```

### SIM Not Recognized

```bash
# Check SIM status
sudo mmcli -m 0 --sim

# Try different APN
nmcli connection modify "LTE" gsm.apn "wholesale"

# Check PIN
sudo mmcli -m 0 --sim-pin="1234"
```

### No IP Address

```bash
# Restart modem
sudo mmcli -m 0 --disable
sleep 2
sudo mmcli -m 0 --enable

# Force reconnection
sudo nmcli connection down "LTE"
sudo nmcli connection up "LTE"

# Check DHCP
sudo dhclient -v eth1
```

### Poor Signal

| Issue | Solution |
|-------|----------|
| No signal | Check antenna connection, try near window |
| Weak signal | Add external antenna (uFL connector) |
| Intermittent | Check cable, ensure stable power supply |
| No data | Verify APN, check data plan |

---

## Cyberdeck Integration

### Environment Variables

```bash
# Configure in systemd service
Environment=CELLULAR_INTERFACE=eth1
Environment=CELLULAR_APN=internet
```

### Connection Check Script

```bash
#!/bin/bash
# check_cellular.sh - Verify cellular is working

INTERFACE="${CELLULAR_INTERFACE:-eth1}"

# Check interface exists
if ! ip link show "$INTERFACE" > /dev/null 2>&1; then
    echo "Error: Interface $INTERFACE not found"
    exit 1
fi

# Check has IP
if ! ip addr show "$INTERFACE" | grep "inet " > /dev/null; then
    echo "Error: No IP address on $INTERFACE"
    exit 1
fi

# Check route
if ! ip route show | grep -q "$INTERFACE"; then
    echo "Warning: No route via $INTERFACE"
fi

echo "Cellular connection OK"
```

### Automatic Failover

For projects requiring reliable connectivity, set up routing rules:

```bash
# Default route priority
ip route add default via $GW dev $INTERFACE metric 100

# WiFi as backup
ip route add default via $WIFI_GW dev wlan0 metric 200
```

---

## Performance

### Optimize Speed

```bash
# Check current speed
sudo mmcli -m 0 --messaging

# Force LTE only (faster than 3G)
sudo mmcli -m 0 --set-allowed-modes=lte

# Force band (if supported)
sudo mmcli -m 0 --set-allowed-bands=7  # Band 7 (AWS/FDD)
```

### Reduce Latency

```bash
# Disable power saving on modem
AT+NCONFIG="airplane_power_save","disable"

# Or via ModemManager
sudo mmcli -m 0 --set-power-state=on
```

---

## See Also

- [ModemManager Documentation](https://modemmanager.org/)
- [NetworkManager CLI](https://developer.gnome.org/NetworkManager/stable/nmcli.html)
- [Raspberry Pi Zero 2W Skill](../raspberrypi-zero-2w/SKILL.md)
- [Cyberdeck Pi TypeScript App](../../firmware/boards/raspberry-pi-zero-2w/typescript/)