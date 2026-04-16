# Cyberdeck Pi - Raspberry Pi Zero 2W TypeScript Application

Primary SBC running Linux. Hosts display, receives HID input via USB, interfaces with Meshtastic node via @meshtastic/js over USB serial, and manages LTE network interface.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Cyberdeck Pi (RPi Zero 2W)               │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │  Display     │  │   Input      │  │    Cellular      │   │
│  │  Manager     │  │   Manager    │  │    Manager       │   │
│  │  (HDMI/DSI)  │  │  (HID/USB)   │  │  (LTE Dongle)   │   │
│  └──────┬───────┘  └──────┬───────┘  └────────┬─────────┘   │
│         │                │                   │             │
│         └────────────────┼───────────────────┘             │
│                          │                                 │
│                    ┌─────▼─────┐                          │
│                    │   index   │                          │
│                    │   (App)   │                          │
│                    └─────┬─────┘                          │
│                          │                                 │
│         ┌────────────────┼────────────────┐               │
│         │                │                │               │
│  ┌──────▼──────┐  ┌──────▼──────┐  ┌──────▼──────┐       │
│  │  Meshtastic  │  │   Cell     │  │   Input     │       │
│  │  (USB Serial)│  │   (eth1)   │  │   (evdev)   │       │
│  └──────┬───────┘  └──────┬─────┘  └──────┬──────┘       │
│         │                 │                │               │
└─────────┼─────────────────┼────────────────┼───────────────┘
          │                 │                │
     ┌────▼────┐      ┌────▼────┐     ┌─────▼─────┐
     │ XIAO    │      │   LTE   │     │ XIAO      │
     │ ESP32S3 │      │ Dongle  │     │ SAMD21    │
     │ (Mesh)  │      │ (WAN)   │     │ (HID)     │
     └─────────┘      └─────────┘     └───────────┘
```

## Prerequisites

- **Hardware**: Raspberry Pi Zero 2W
- **OS**: Raspberry Pi OS (64-bit recommended, 32-bit supported)
- **Node.js**: v20 or higher
- **Dependencies**: 
  - `evtest` (for input event debugging, optional)
  - `NetworkManager` or `ModemManager` (for LTE monitoring)

### Installing Node.js on Raspberry Pi OS

```bash
# Using NodeSource repository (recommended)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify installation
node --version  # Should output v20.x.x or higher
npm --version
```

## Setup

### 1. Clone and install dependencies

```bash
cd firmware/boards/raspberry-pi-zero-2w/typescript
npm install
```

### 2. Configure environment

Create a `.env` file or set environment variables:

```bash
# Meshtastic device serial path
export MESHTASTIC_DEVICE=/dev/serial/by-id/usb-Meshtastic_Meshtastic_12345678-if00

# Cellular network interface (check with ip link)
export CELLULAR_INTERFACE=eth1

# HID input device
export INPUT_DEVICE=/dev/input/event0

# Logging level
export LOG_LEVEL=info

# Display configuration
export DISPLAY_DEVICE=/dev/dri/card0
export DISPLAY_WIDTH=1920
export DISPLAY_HEIGHT=1080
export DISPLAY_ROTATION=0
export DISPLAY_IDLE_TIMEOUT=300000
```

### 3. Build the application

```bash
npm run build
```

This produces compiled JavaScript in `dist/`.

### 4. Run in development mode

```bash
npm run dev
```

This runs TypeScript directly using `tsx` without needing a build step.

### 5. Run in production

```bash
npm start
```

## Subsystems

### Meshtastic (`meshtastic.ts`)

Interfaces with Meshtastic radio device over USB serial. Uses `@meshtastic/js` library.

**Configuration:**
- `MESHTASTIC_DEVICE`: Serial device path (default: `/dev/serial/by-id/*`)

**API:**
```typescript
const client = new MeshtasticClient(devicePath, logger);
await client.initialize();
await client.sendPacket({ destination: 0xffffffff, channel: 0, text: "Hello mesh" });
client.onMessage((msg) => console.log("Received:", msg.text));
await client.shutdown();
```

### Cellular (`cellular.ts`)

Monitors LTE dongle network interface status using ModemManager and standard Linux networking tools.

**Configuration:**
- `CELLULAR_INTERFACE`: Network interface name (default: `eth1`)

**API:**
```typescript
const cellular = new CellularManager("eth1", logger);
await cellular.initialize();
cellular.onStatusChange((status) => {
  console.log("Network:", status.connected ? `Connected (${status.ip})` : "Disconnected");
});
cellular.startMonitoring();
```

### Input (`input.ts`)

Listens for HID events from XIAO SAMD21 HID bridge via `/dev/input/event*`.

**Configuration:**
- `INPUT_DEVICE`: Input event device path (default: `/dev/input/event0`)

**API:**
```typescript
const input = new InputManager("/dev/input/event0", logger);
await input.initialize();
input.onInput((event) => {
  if (event.type === InputEventType.KEY_DOWN) {
    console.log("Key:", event.key);
  }
});
input.onActivity(() => display.resetIdleTimeout());
input.startListening();
```

### Display (`display.ts`)

Stub for display/UI management. Provides notification system and idle timeout management.

**Configuration:**
- `DISPLAY_DEVICE`: DRM device path
- `DISPLAY_WIDTH`, `DISPLAY_HEIGHT`: Resolution
- `DISPLAY_ROTATION`: Rotation in degrees
- `DISPLAY_IDLE_TIMEOUT`: Idle timeout in ms

**API:**
```typescript
const display = new DisplayManager(logger);
await display.initialize();
display.showNotification("Hello!", NotificationLevel.INFO, 3000);
display.resetIdleTimeout();
```

## Running on Boot

### Systemd Service

Create `/etc/systemd/system/cyberdeck-pi.service`:

```ini
[Unit]
Description=Cyberdeck Pi Controller
After=network-online.target
Wants=network-online.target
StartLimitIntervalSec=60
StartLimitBurst=5

[Service]
Type=simple
User=root
WorkingDirectory=/opt/cyberdeck-pi
Environment=NODE_ENV=production
EnvironmentFile=/opt/cyberdeck-pi/.env
ExecStart=/usr/bin/node dist/index.js
Restart=on-failure
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

Enable and start:

```bash
sudo systemctl enable cyberdeck-pi
sudo systemctl start cyberdeck-pi

# Check status
sudo systemctl status cyberdeck-pi

# View logs
journalctl -u cyberdeck-pi -f
```

### Update script for deployments

```bash
#!/bin/bash
cd /opt/cyberdeck-pi
git pull
npm ci --production
npm run build
sudo systemctl restart cyberdeck-pi
```

## Troubleshooting

### Meshtastic device not found

```bash
# List available serial devices
ls -la /dev/serial/by-id/
ls -la /dev/ttyUSB*

# Check device permissions
ls -la /dev/ttyUSB0
# If needed: sudo chmod 666 /dev/ttyUSB0
```

### Cellular interface not detected

```bash
# Check network interfaces
ip link show
ip addr show eth1

# Check ModemManager
mmcli -L  # List modems
mmcli -m 0 --signal-quality  # Signal info
```

### Input device not responding

```bash
# List input devices
evtest --list-devices

# Test device directly
sudo evtest /dev/input/event0
```

### View logs

```bash
# Systemd journal
journalctl -u cyberdeck-pi -f

# Direct output (dev mode)
npm run dev
```

## Development

### Type checking

```bash
npm run typecheck
```

### Debug logging

Set `LOG_LEVEL=debug` to see verbose output:

```bash
LOG_LEVEL=debug npm run dev
```

## License

MIT