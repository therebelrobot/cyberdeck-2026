# Raspberry Pi Kiosk Bootstrap

Idempotent bootstrap scripts for configuring Raspberry Pi OS (Wayland + labwc) as a kiosk device for the Cyberdeck 2026.

## Quick Start

Run via SSH on a fresh Raspberry Pi OS installation:

```bash
curl -L https://raw.githubusercontent.com/therebelrobot/cyberdeck-2026/main/firmware/boards/raspberry-pi-zero-2w/scripts/bootstrap/bootstrap-pi-kiosk.sh | bash
```

With a custom kiosk directory:

```bash
curl -L ... | bash -s -- --kiosk-dir /path/to/kiosk
```

Re-run if already configured (force mode):

```bash
curl -L ... | bash -s -- --force
```

## Architecture Overview

The kiosk uses a **local Next.js server** with Chromium connecting to `localhost:3000`:

```
┌─────────────────────────────────────────────────────────────┐
│                    Raspberry Pi Zero 2W                      │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐    ┌──────────────────────────────────┐  │
│  │  Chromium   │───▶│   Next.js Server (localhost:3000) │  │
│  │  (Kiosk)   │    │   ┌────────────────────────────┐  │  │
│  └─────────────┘    │   │   React Dashboard App      │  │  │
│                     │   │   - Status Cards           │  │  │
│                     │   │   - Time/Uptime           │  │  │
│                     │   │   - Battery/Network       │  │  │
│                     │   └────────────────────────────┘  │  │
│                     └──────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Prerequisites

1. **Clone the cyberdeck-2026 repository** to `/home/pi/`:
   ```bash
   cd /home/pi
   git clone https://github.com/therebelrobot/cyberdeck-2026.git
   ```

2. **Run the bootstrap script** (will install Node.js via nvm and build the kiosk)

## Implementation Order

The bootstrap script performs configuration in 9 sequential steps:

### Step 0: SSH & I2C Enablement
- Enables and starts SSH (disabled by default on recent Pi OS)
- Ensures the Pi remains reachable even if display config fails
- Documents that hardware I2C is unavailable (DPI overlay uses GPIO2/3)
- The DPI overlay creates a bit-banged I2C bus on GPIO10/GPIO11

### Step 1: Boot Splash Configuration
- Adds `disable_splash=1` to `/boot/firmware/config.txt` to disable rainbow splash
- Modifies `/boot/firmware/cmdline.txt` to add:
  - `loglevel=0` - Suppresses kernel messages
  - `logo.nologo` - Hides boot logo
  - `quiet` - Suppresses boot messages
  - `splash` - Enables Plymouth splash screen
  - `vt.global_cursor_default=0` - Hides cursor during boot

### Step 2: Waveshare 3.5" DPI LCD Configuration
- Installs Waveshare device tree overlay files (`.dtbo`)
- Configures display in `/boot/firmware/config.txt` (DPI18 mode)
- Sets display rotation (default: 0 degrees)
- Configures touch panel calibration (GT911 controller)
- Configures backlight via sysfs (`/sys/class/backlight/`)

### Step 3: Plymouth Splash Installation
- Installs Plymouth splash screen system
- Sets spinfinity theme (fallback graceful if unavailable)

### Step 4: LightDM Auto-Login
- Configures `/etc/lightdm/lightdm.conf` for automatic login as `pi` user
- Enables boot directly to desktop without login prompt
- Disables display power saving per Waveshare user guide

### Step 5: Labwc Autostart Configuration
- Creates `~/.config/labwc/autostart`
- Disables:
  - DPMS (display power management)
  - Screen saver
  - Screen blanking

### Step 6: Node.js and Kiosk App Setup
- Installs NVM and Node.js v22.14.0 if not present
- Installs Next.js dependencies
- Builds the Next.js kiosk app

### Step 7: Systemd Services
- Copies `init-peripherals.sh` from repo (with I2C bus auto-detection)
- Installs and enables `peripheral-init.service` (runs before graphical target)
- Installs and enables `kiosk.service` (starts Next.js + Chromium)
- Installs `start-kiosk.sh` launcher script

### Step 8: PiSugar 3 — Power-Only Mode
- PiSugar server is **not enabled** (I2C unavailable due to DPI GPIO conflict)
- Power delivery, USB-C charging, and power button still work via pogo pins
- Battery level, charging status, and RTC are unavailable
- To restore I2C: solder PiSugar SDA/SCL to GPIO10/GPIO11

## File Locations

### Generated Files
| File | Purpose |
|------|---------|
| `/var/lib/kiosk-bootstrapped` | Idempotency marker |
| `/var/log/kiosk-bootstrap.log` | Bootstrap log |
| `/var/log/peripheral-init.log` | Peripheral init log |
| `/etc/systemd/system/kiosk.service` | Kiosk systemd service |
| `/etc/systemd/system/peripheral-init.service` | Peripheral init service |
| `/usr/local/bin/init-peripherals.sh` | Peripheral init script |
| `/usr/local/bin/start-kiosk.sh` | Kiosk launcher script |
| `~/.config/labwc/autostart` | Labwc autostart config |

### Source Files
| File | Purpose |
|------|---------|
| `/home/pi/cyberdeck-2026/firmware/boards/raspberry-pi-zero-2w/kiosk/` | Next.js kiosk application |

### Modified Files
| File | Purpose |
|------|---------|
| `/boot/firmware/config.txt` | Boot config (splash disabled) |
| `/boot/firmware/cmdline.txt` | Kernel cmdline (quiet boot) |
| `/etc/lightdm/lightdm.conf` | LightDM autologin |
| `~/.config/labwc/autostart` | Screen blanking disabled |

### Backup Files
| File | Purpose |
|------|---------|
| `/boot/firmware/config.txt.bak` | Original config.txt |
| `/boot/firmware/cmdline.txt.bak` | Original cmdline.txt |
| `/etc/lightdm/lightdm.conf.bak` | Original lightdm.conf |

## Service Dependencies

```
graphical.target
└── kiosk.service
    ├── network.target
    ├── peripheral-init.service
    │   └── basic.target
    └── After: network.target, peripheral-init.service
```

## Breaking Out of Kiosk Mode

### Via SSH (Recommended)
```bash
# Stop kiosk temporarily
sudo systemctl stop kiosk

# Return to kiosk
sudo systemctl start kiosk

# Disable kiosk entirely (for debugging)
sudo systemctl disable kiosk
```

### Via Virtual Terminal
1. Press `Ctrl+Alt+F2` to switch to tty2
2. Login with `pi` user (password: `raspberry` default)
3. Run `sudo systemctl stop kiosk` to stop kiosk
4. Return to kiosk: `sudo systemctl start kiosk`
5. Return to kiosk display: `Ctrl+Alt+F1`

### Via Keyboard (CardKB)
- If CardKB is connected, the above shortcuts may work
- Some setups allow `Ctrl+Alt+F2` through the keyboard directly

## Troubleshooting

### Log Files
All bootstrap actions are logged to `/var/log/kiosk-bootstrap.log`:
```bash
sudo tail -f /var/log/kiosk-bootstrap.log
```

Peripheral initialization logs to `/var/log/peripheral-init.log`:
```bash
sudo tail -f /var/log/peripheral-init.log
```

### Common Issues

#### Black screen after reboot
1. SSH in and check service status:
   ```bash
   sudo systemctl status kiosk
   sudo journalctl -u kiosk -f
   ```
2. Check if Chromium started:
   ```bash
   ps aux | grep chromium
   ```
3. Verify labwc is running:
   ```bash
   ps aux | grep labwc
   ```

#### Kiosk stuck on boot
1. Wait 60 seconds for service startup delay
2. SSH and check logs
3. If using --force, the marker file may have been deleted

#### Display blanking still occurs
- Verify autostart was created: `cat ~/.config/labwc/autostart`
- Manually run: `xset -dpms && xset s off && xset s noblank`

#### Chromium not starting
- Check Wayland environment: `echo $WAYLAND_DISPLAY`
- Try starting Chromium manually: `DISPLAY=:0 chromium-browser --kiosk --ozone-platform=wayland`

#### Next.js server not responding
- Check if Node.js is installed: `node --version`
- Check kiosk app: `ls -la /home/pi/cyberdeck-2026/firmware/boards/raspberry-pi-zero-2w/kiosk/.next`
- Try rebuilding: `cd /home/pi/cyberdeck-2026/firmware/boards/raspberry-pi-zero-2w/kiosk && npm run build`

#### I2C devices not detected
- **Important**: Hardware I2C bus 1 (`/dev/i2c-1`) is unavailable when the DPI display overlay is active.
  The overlay creates a bit-banged I2C bus on GPIO10/GPIO11 with a different device number.
- List available buses: `ls /dev/i2c-*`
- Scan ALL buses for devices:
  ```bash
  for bus in $(ls /dev/i2c-* | sed 's|/dev/i2c-||'); do
    echo "=== Bus $bus ==="; i2cdetect -y "$bus"
  done
  ```
- Expected devices: PiSugar at `0x57`/`0x68`, GT911 touch at `0x5D`
- Check kernel modules: `lsmod | grep i2c`
- The `init-peripherals.sh` script auto-detects the correct bus at startup

### Rollback

To rollback kiosk configuration:

```bash
# Remove marker file
sudo rm -f /var/lib/kiosk-bootstrapped

# Restore backup files
sudo cp /boot/firmware/config.txt.bak /boot/firmware/config.txt
sudo cp /boot/firmware/cmdline.txt.bak /boot/firmware/cmdline.txt
sudo cp /etc/lightdm/lightdm.conf.bak /etc/lightdm/lightdm.conf

# Remove services
sudo systemctl disable kiosk
sudo systemctl disable peripheral-init
sudo rm /etc/systemd/system/kiosk.service
sudo rm /etc/systemd/system/peripheral-init.service
sudo rm /usr/local/bin/start-kiosk.sh
sudo rm /usr/local/bin/init-peripherals.sh

# Reboot
sudo reboot
```

## Supported Hardware

- Raspberry Pi Zero 2W
- Raspberry Pi 3B/3B+/4B/5 (64-bit OS)
- Raspberry Pi OS Bookworm/Trixie (Wayland + labwc)

## Requirements

- Raspberry Pi OS 64-bit (Debian Bookworm or Trixie)
- Wayland compositor (labwc)
- Chromium browser installed
- Git (for cloning repository)
- Internet connection for initial setup
