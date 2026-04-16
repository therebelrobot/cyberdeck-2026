#!/bin/bash
#
# bootstrap-pi-kiosk.sh - Idempotent Raspberry Pi OS Kiosk Bootstrap Script
#
# This script configures a Raspberry Pi Zero 2W running Raspberry Pi OS
# (Debian Trixie with Wayland + labwc) for kiosk mode operation.
#
# The kiosk runs a local Next.js server with Chromium browser connecting
# to localhost:3000.
#
# Usage:
#   curl -L https://raw.githubusercontent.com/therebelrobot/cyberdeck-2026/main/firmware/boards/raspberry-pi-zero-2w/scripts/bootstrap/bootstrap-pi-kiosk.sh | bash
#   curl -L ... | bash -s -- --force
#
set -e

# =============================================================================
# CONFIGURATION
# =============================================================================

LOGFILE="/var/log/kiosk-bootstrap.log"
BOOT_CONFIG="/boot/firmware/config.txt"
BOOT_CMDLINE="/boot/firmware/cmdline.txt"
LIGHTDM_CONF="/etc/lightdm/lightdm.conf"
KIOSK_SERVICE="/etc/systemd/system/kiosk.service"
PERIPHERAL_SERVICE="/etc/systemd/system/peripheral-init.service"
INIT_PERIPHERALS="/usr/local/bin/init-peripherals.sh"
START_KIOSK="/usr/local/bin/start-kiosk.sh"
AUTOSTART_DIR="$HOME/.config/labwc"
AUTOSTART_FILE="$AUTOSTART_DIR/autostart"
KIOSK_DIR="/home/pi/cyberdeck-2026/firmware/boards/raspberry-pi-zero-2w/kiosk"
MARKER_FILE="/var/lib/kiosk-bootstrapped"
NVM_DIR="/home/pi/.nvm"
NODE_VERSION="v22.14.0"

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

log() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] $*"
    echo "$msg" | tee -a "$LOGFILE" 2>/dev/null || echo "$msg"
}

log_step() {
    log "==> $*"
}

backup_file() {
    local file="$1"
    if [[ -f "$file" ]] && [[ ! -f "${file}.bak" ]]; then
        cp "$file" "${file}.bak"
        log "Backed up $file to ${file}.bak"
    fi
}

is_configured() {
    [[ -f "$MARKER_FILE" ]]
}

mark_configured() {
    touch "$MARKER_FILE"
    log "Marked system as configured"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log "ERROR: This script must be run as root (use sudo)"
        exit 1
    fi
}

# =============================================================================
# PARSE ARGUMENTS
# =============================================================================

FORCE=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --force)
            FORCE=true
            shift
            ;;
        --kiosk-dir)
            KIOSK_DIR="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [--force] [--kiosk-dir <path>]"
            echo "  --force       Re-run even if already configured"
            echo "  --kiosk-dir   Path to kiosk directory (default: /home/pi/cyberdeck-2026/firmware/boards/raspberry-pi-zero-2w/kiosk)"
            exit 0
            ;;
        *)
            shift
            ;;
    esac
done

# =============================================================================
# NODE.JS INSTALLATION
# =============================================================================

install_nvm() {
    log "Installing NVM and Node.js ${NODE_VERSION}..."

    # Create .nvm directory
    mkdir -p "$NVM_DIR"
    chown -R pi:pi "$NVM_DIR"

    # Download and install NVM
    sudo -u pi bash -c '
        export NVM_DIR="/home/pi/.nvm"
        if [ ! -d "$NVM_DIR/.git" ]; then
            git clone -q https://github.com/nvm-sh/nvm.git "$NVM_DIR"
            cd "$NVM_DIR"
            git checkout -q v0.39.7
        fi
    '

    # Install Node.js using NVM
    sudo -u pi bash -c "
        export NVM_DIR=\"/home/pi/.nvm\"
        export PATH=\"$NVM_DIR/versions/node/${NODE_VERSION}/bin:\$PATH\"

        [ -s \"$NVM_DIR/nvm.sh\" ] && source \"$NVM_DIR/nvm.sh\"

        if [ ! -d \"$NVM_DIR/versions/node/${NODE_VERSION}\" ]; then
            nvm install ${NODE_VERSION}
            nvm alias default ${NODE_VERSION}
        fi
    "

    log "Node.js installation complete"
}

check_node_installed() {
    if [ -x "$NVM_DIR/versions/node/${NODE_VERSION}/bin/node" ]; then
        return 0
    elif command -v node &>/dev/null; then
        # Check if system node is new enough
        local node_version
        node_version=$(node --version 2>/dev/null || echo "v0.0.0")
        if [[ "$node_version" =~ ^v(2[0-9]|[3-9][0-9])\. ]]; then
            return 0
        fi
    fi
    return 1
}

# =============================================================================
# KIOKS APP SETUP
# =============================================================================

setup_kiosk_app() {
    log "Setting up kiosk application..."

    # Check if kiosk directory exists
    if [[ ! -d "$KIOSK_DIR" ]]; then
        log "ERROR: Kiosk directory not found: $KIOSK_DIR"
        log "Please ensure the cyberdeck-2026 repo is cloned to /home/pi/"
        exit 1
    fi

    chown -R pi:pi "$KIOSK_DIR"

    # Check if node_modules exists, if not install dependencies
    if [[ ! -d "$KIOSK_DIR/node_modules" ]]; then
        log "Installing kiosk dependencies..."
        cd "$KIOSK_DIR"
        sudo -u pi bash -c "
            export NVM_DIR=\"/home/pi/.nvm\"
            [ -s \"$NVM_DIR/nvm.sh\" ] && source \"$NVM_DIR/nvm.sh\"
            npm install
        "
    fi

    # Check if Next.js is built
    if [[ ! -d "$KIOSK_DIR/.next" ]] || [[ "$FORCE" == "true" ]]; then
        log "Building Next.js application..."
        cd "$KIOSK_DIR"
        sudo -u pi bash -c "
            export NVM_DIR=\"/home/pi/.nvm\"
            export PATH=\"$NVM_DIR/versions/node/${NODE_VERSION}/bin:\$PATH\"
            [ -s \"$NVM_DIR/nvm.sh\" ] && source \"$NVM_DIR/nvm.sh\"
            npm run build
        "
        log "Next.js build complete"
    else
        log "Next.js already built, skipping build step"
    fi
}

# =============================================================================
# MAIN BOOTSTRAP
# =============================================================================

main() {
    # Initialize log
    touch "$LOGFILE" 2>/dev/null || true
    chmod 644 "$LOGFILE" 2>/dev/null || true
    
    log "=========================================="
    log "Raspberry Pi Kiosk Bootstrap Starting"
    log "=========================================="
    
    check_root
    
    # Check if already configured (unless --force)
    if is_configured && [[ "$FORCE" != "true" ]]; then
        log "System already configured. Use --force to re-run."
        exit 0
    fi
    
    # If --force, remove marker and start fresh
    if [[ "$FORCE" == "true" ]]; then
        log "Force flag set - proceeding with full reconfiguration"
        rm -f "$MARKER_FILE"
    fi
    
    # -------------------------------------------------------------------------
    log_step "Step 1: Configure boot splash settings"
    # -------------------------------------------------------------------------
    
    # Disable rainbow splash in config.txt
    if grep -q "^disable_splash=1" "$BOOT_CONFIG" 2>/dev/null; then
        log "  - disable_splash already set in $BOOT_CONFIG"
    else
        backup_file "$BOOT_CONFIG"
        echo "" >> "$BOOT_CONFIG"
        echo "# Added by kiosk bootstrap - disable rainbow splash" >> "$BOOT_CONFIG"
        echo "disable_splash=1" >> "$BOOT_CONFIG"
        log "  - Added disable_splash=1 to $BOOT_CONFIG"
    fi
    
    # Modify cmdline.txt to hide boot text
    if [[ -f "$BOOT_CMDLINE" ]]; then
        backup_file "$BOOT_CMDLINE"
        
        # Read current content
        local cmdline_content
        cmdline_content=$(cat "$BOOT_CMDLINE")
        
        # Check if modifications are already applied
        if echo "$cmdline_content" | grep -q "loglevel=0"; then
            log "  - cmdline.txt already modified for quiet boot"
        else
            # Remove existing boot parameters we might be adding
            cmdline_content=$(echo "$cmdline_content" | sed 's/loglevel=[0-9]//g')
            cmdline_content=$(echo "$cmdline_content" | sed 's/logo\.nologo//g')
            cmdline_content=$(echo "$cmdline_content" | sed 's/quiet//g')
            cmdline_content=$(echo "$cmdline_content" | sed 's/splash//g')
            cmdline_content=$(echo "$cmdline_content" | sed 's/vt\.global_cursor_default=[0-9]//g')
            
            # Trim extra spaces
            cmdline_content=$(echo "$cmdline_content" | tr -s ' ')
            
            # Add our parameters at the end (before any trailing whitespace)
            cmdline_content="${cmdline_content} loglevel=0 logo.nologo quiet splash vt.global_cursor_default=0"
            
            # Write back
            echo "$cmdline_content" > "$BOOT_CMDLINE"
            log "  - Modified $BOOT_CMDLINE for quiet boot"
        fi
    else
        log "  - WARNING: $BOOT_CMDLINE not found"
    fi
    
    # -------------------------------------------------------------------------
    log_step "Step 2: Install Plymouth splash configuration"
    # -------------------------------------------------------------------------
    
    if command -v plymouth-set-default-theme &>/dev/null; then
        log "  - Plymouth already installed"
    else
        apt-get update -qq
        apt-get install -y -qq plymouth plymouth-themes
        log "  - Installed Plymouth"
    fi
    
    # Set a simple theme (falls back gracefully if theme not available)
    if plymouth-set-default-theme --list 2>/dev/null | grep -q "spinfinity"; then
        plymouth-set-default-theme spinfinity 2>/dev/null || true
        log "  - Set Plymouth theme to spinfinity"
    fi
    
    # -------------------------------------------------------------------------
    log_step "Step 3: Configure auto-login via LightDM"
    # -------------------------------------------------------------------------
    
    if [[ -f "$LIGHTDM_CONF" ]]; then
        backup_file "$LIGHTDM_CONF"
        
        # Check if autologin is already configured
        if grep -q "^autologin-user=pi" "$LIGHTDM_CONF" 2>/dev/null; then
            log "  - Auto-login already configured for user pi"
        else
            # Enable autologin for pi user
            if grep -q "^\[Seat:\*\]$" "$LIGHTDM_CONF" 2>/dev/null; then
                # Seat:* section exists, add autologin after it
                sed -i '/^\[Seat:\*\]$/a autologin-user=pi\nautologin-user-timeout=0' "$LIGHTDM_CONF"
            else
                # Add Seat:* section
                echo "" >> "$LIGHTDM_CONF"
                echo "[Seat:*]" >> "$LIGHTDM_CONF"
                echo "autologin-user=pi" >> "$LIGHTDM_CONF"
                echo "autologin-user-timeout=0" >> "$LIGHTDM_CONF"
            fi
            log "  - Configured LightDM autologin for user pi"
        fi
    else
        log "  - WARNING: $LIGHTDM_CONF not found, skipping autologin"
    fi
    
    # -------------------------------------------------------------------------
    log_step "Step 4: Create labwc autostart configuration"
    # -------------------------------------------------------------------------
    
    mkdir -p "$AUTOSTART_DIR"
    chmod 755 "$AUTOSTART_DIR"
    
    # Create autostart file content
    local autostart_content="# Labwc autostart - kiosk configuration
# Generated by bootstrap-pi-kiosk.sh

# Disable DPMS (display power management)
xset -dpms

# Disable screen saver
xset s off

# Disable screen blanking
xset s noblank
"
    
    if [[ -f "$AUTOSTART_FILE" ]]; then
        # Check if it has our kiosk config
        if grep -q "# Labwc autostart - kiosk configuration" "$AUTOSTART_FILE"; then
            log "  - $AUTOSTART_FILE already configured"
        else
            backup_file "$AUTOSTART_FILE"
            echo "$autostart_content" > "$AUTOSTART_FILE"
            log "  - Updated $AUTOSTART_FILE"
        fi
    else
        echo "$autostart_content" > "$AUTOSTART_FILE"
        chmod 644 "$AUTOSTART_FILE"
        log "  - Created $AUTOSTART_FILE"
    fi
    
    # -------------------------------------------------------------------------
    log_step "Step 5: Install Node.js and setup kiosk app"
    # -------------------------------------------------------------------------
    
    if ! check_node_installed; then
        install_nvm
    else
        log "  - Node.js already installed"
    fi
    
    setup_kiosk_app
    
    # -------------------------------------------------------------------------
    log_step "Step 6: Install and configure systemd services"
    # -------------------------------------------------------------------------
    
    # Create init-peripherals.sh script
    create_init_peripherals_script
    
    # Create peripheral-init.service
    create_peripheral_service
    
    # Copy and create kiosk.service
    create_kiosk_service
    
    # Copy start-kiosk.sh launcher
    create_start_kiosk_script
    
    # Enable services
    log "  - Enabling systemd services..."
    systemctl enable peripheral-init.service 2>/dev/null || true
    systemctl enable kiosk.service 2>/dev/null || true
    log "  - Services enabled"
    
    # -------------------------------------------------------------------------
    log_step "Step 7: Enable PiSugar server (if installed)"
    # -------------------------------------------------------------------------
    
    if [[ -f "/usr/local/bin/pisugar-server" ]] || [[ -f "/usr/bin/pisugar-server" ]]; then
        systemctl enable pisugar-server 2>/dev/null || true
        systemctl enable pisugar-offical 2>/dev/null || true
        log "  - PiSugar server enabled"
    elif command -v pisugar-server &>/dev/null; then
        systemctl enable pisugar-server 2>/dev/null || true
        log "  - PiSugar server enabled"
    else
        log "  - PiSugar server not detected, skipping"
    fi
    
    # Mark as configured
    mark_configured
    
    log "=========================================="
    log "Bootstrap Complete!"
    log "=========================================="
    log "IMPORTANT: Reboot required for changes to take effect:"
    log "  sudo reboot"
    log ""
    log "To break out of kiosk:"
    log "  - SSH in and run: sudo systemctl stop kiosk"
    log "  - Or use: Ctrl+Alt+F2 to switch to tty2"
    log ""
    log "Kiosk directory: $KIOSK_DIR"
    log "Log file: $LOGFILE"
}

# =============================================================================
# SERVICE CREATION FUNCTIONS
# =============================================================================

create_init_peripherals_script() {
    log "  - Creating $INIT_PERIPHERALS"
    
    cat > "$INIT_PERIPHERALS" << 'SCRIPT_EOF'
#!/bin/bash
#
# init-peripherals.sh - Peripheral Initialization Script
#
# This script initializes all peripherals connected to the Raspberry Pi
# including I2C devices, USB peripherals, and any custom hardware.
#
# Exit codes:
#   0 - All peripherals initialized successfully
#   1 - Partial initialization (some devices not found)
#   2 - Critical error
#

set -e

LOGFILE="/var/log/peripheral-init.log"
I2C_BUS="${I2C_BUS:-1}"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOGFILE" 2>/dev/null
}

wait_for_i2c() {
    local device_addr="$1"
    local max_attempts="${2:-30}"
    local attempt=0
    
    log "Waiting for I2C device at address 0x${device_addr}..."
    
    while [[ $attempt -lt $max_attempts ]]; do
        if i2cdetect -y "$I2C_BUS" 0x"${device_addr}" 2>/dev/null | grep -q "$device_addr"; then
            log "  Found device at 0x${device_addr}"
            return 0
        fi
        sleep 0.5
        attempt=$((attempt + 1))
    done
    
    log "  WARNING: Device at 0x${device_addr} not found after ${max_attempts} attempts"
    return 1
}

# =============================================================================
# PiSugar 3 Battery Management (I2C 0x57)
# =============================================================================

init_pisugar() {
    log "Initializing PiSugar 3 battery management..."
    
    if ! command -v i2cdetect &>/dev/null; then
        log "  Installing i2c-tools..."
        apt-get install -y -qq i2c-tools
    fi
    
    if wait_for_i2c "57" 10; then
        log "  PiSugar 3 detected"
    else
        log "  PiSugar 3 not detected on I2C"
    fi
}

# =============================================================================
# CardKB QWERTY Keyboard (I2C 0x5F)
# =============================================================================

init_cardkb() {
    log "Initializing CardKB QWERTY Keyboard..."
    
    if wait_for_i2c "5F" 10; then
        log "  CardKB detected"
    else
        log "  CardKB not detected on I2C"
    fi
}

# =============================================================================
# ANO Rotary Encoder (I2C via seesaw)
# =============================================================================

init_rotary_encoder() {
    log "Initializing ANO Rotary Encoder..."
    
    local seesaw_addrs=("3A" "49" "4B")
    
    for addr in "${seesaw_addrs[@]}"; do
        if wait_for_i2c "$addr" 5; then
            log "  Rotary encoder detected at 0x${addr}"
            return 0
        fi
    done
    
    log "  Rotary encoder not detected"
    return 1
}

# =============================================================================
# Display Touch Controller
# =============================================================================

init_display_touch() {
    log "Initializing display touch controller..."
    
    local touch_addrs=("38" "39" "3A" "48")
    
    for addr in "${touch_addrs[@]}"; do
        if wait_for_i2c "$addr" 5; then
            log "  Touch controller detected at 0x${addr}"
            return 0
        fi
    done
    
    log "  Touch controller not detected (may be SPI)"
    return 1
}

# =============================================================================
# USB Hub (CH334F)
# =============================================================================

init_usb_hub() {
    log "Initializing USB hub..."
    
    if lsusb | grep -q "1a40"; then
        log "  USB hub (1a40) detected"
    else
        log "  USB hub not detected"
    fi
}

# =============================================================================
# LTE Modem
# =============================================================================

init_lte_modem() {
    log "Initializing LTE modem..."
    
    if ls /dev/ttyUSB* &>/dev/null; then
        log "  LTE modem detected"
    else
        log "  LTE modem not detected"
    fi
}

# =============================================================================
# LoRa Radio (via XIAO ESP32-S3)
# =============================================================================

init_lora_radio() {
    log "Initializing LoRa radio (XIAO ESP32-S3)..."
    
    if ls /dev/serial0 &>/dev/null || ls /dev/ttyAMA0 &>/dev/null; then
        log "  LoRa radio serial port detected"
    else
        log "  LoRa radio not detected on serial"
    fi
}

# =============================================================================
# MAIN INITIALIZATION
# =============================================================================

main() {
    mkdir -p "$(dirname "$LOGFILE")"
    touch "$LOGFILE" 2>/dev/null || true
    
    log "=========================================="
    log "Peripheral Initialization Starting"
    log "=========================================="
    
    # Enable I2C
    if ! lsmod | grep -q i2c_dev; then
        modprobe i2c-dev
    fi
    
    local failed=0
    
    # Initialize each peripheral
    init_pisugar || failed=$((failed + 1))
    init_cardkb || failed=$((failed + 1))
    init_rotary_encoder || failed=$((failed + 1))
    init_display_touch || failed=$((failed + 1))
    init_usb_hub || failed=$((failed + 1))
    init_lte_modem || failed=$((failed + 1))
    init_lora_radio || failed=$((failed + 1))
    
    log "=========================================="
    if [[ $failed -eq 0 ]]; then
        log "All peripherals initialized successfully"
    else
        log "Initialization complete with $failed device(s) not found"
    fi
    log "=========================================="
    
    return $failed
}

main "$@"
SCRIPT_EOF

    chmod +x "$INIT_PERIPHERALS"
    chown root:root "$INIT_PERIPHERALS"
    log "  - Created $INIT_PERIPHERALS"
}

create_peripheral_service() {
    log "  - Creating $PERIPHERAL_SERVICE"
    
    cat > "$PERIPHERAL_SERVICE" << 'SERVICE_EOF'
[Unit]
Description=Peripheral Initialization
After=basic.target
Before=graphical.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/init-peripherals.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
SERVICE_EOF

    log "  - Created $PERIPHERAL_SERVICE"
}

create_start_kiosk_script() {
    log "  - Creating $START_KIOSK"
    
    cat > "$START_KIOSK" << 'LAUNCHER_EOF'
#!/bin/bash
#
# start-kiosk.sh - Launcher script for Cyberdeck Kiosk
#
# This script starts the Next.js server, waits for it to be ready,
# then launches Chromium in kiosk mode.
#

set -e

KIOSK_DIR="${KIOSK_DIR:-/home/pi/cyberdeck-2026/firmware/boards/raspberry-pi-zero-2w/kiosk}"
KIOSK_PORT="${KIOSK_PORT:-3000}"
KIOSK_URL="http://localhost:${KIOSK_PORT}"
NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
NODE_VERSION="v22.14.0"
MAX_WAIT=30

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [kiosk-launcher] $*"
}

find_node() {
    if [[ -x "$NVM_DIR/versions/node/${NODE_VERSION}/bin/node" ]]; then
        echo "$NVM_DIR/versions/node/${NODE_VERSION}/bin/node"
    elif [[ -x "$NVM_DIR/versions/node/v22.12.0/bin/node" ]]; then
        echo "$NVM_DIR/versions/node/v22.12.0/bin/node"
    elif command -v node &>/dev/null; then
        command -v node
    else
        log "ERROR: Node.js not found"
        exit 1
    fi
}

wait_for_server() {
    local node_bin="$1"
    local max_attempts="$2"
    local attempt=1

    log "Waiting for Next.js server at $KIOSK_URL..."

    while [[ $attempt -le $max_attempts ]]; do
        if curl -s -o /dev/null -w "%{http_code}" "$KIOSK_URL" 2>/dev/null | grep -q "200"; then
            log "Server is ready after ${attempt}s"
            return 0
        fi
        log "  Attempt $attempt/$max_attempts - server not ready, waiting..."
        sleep 1
        attempt=$((attempt + 1))
    done

    log "ERROR: Server failed to start within ${max_attempts}s"
    return 1
}

main() {
    log "=========================================="
    log "Cyberdeck Kiosk Launcher Starting"
    log "=========================================="
    log "Kiosk directory: $KIOSK_DIR"
    log "Kiosk port: $KIOSK_PORT"

    if [[ ! -d "$KIOSK_DIR" ]]; then
        log "ERROR: Kiosk directory not found: $KIOSK_DIR"
        exit 1
    fi

    cd "$KIOSK_DIR"

    local node_bin
    node_bin=$(find_node)
    log "Using Node.js: $node_bin"

    if [[ ! -d "$KIOSK_DIR/.next" ]]; then
        log "Next.js not built, building..."
        export NVM_DIR="$NVM_DIR"
        [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
        npm run build
        log "Build complete"
    fi

    log "Starting Next.js server..."
    export PORT="$KIOSK_PORT"
    export NVM_DIR="$NVM_DIR"
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    npm start &
    local next_pid=$!

    if ! wait_for_server "$node_bin" "$MAX_WAIT"; then
        log "ERROR: Failed to start Next.js server"
        kill $next_pid 2>/dev/null || true
        exit 1
    fi

    log "Starting Chromium browser..."
    chromium-browser \
        --kiosk \
        --ozone-platform=wayland \
        --start-maximized \
        --password-store=basic \
        --noerrdialogs \
        --disable-infobars \
        --disable-session-crashed-bubble \
        --disable-dev-shm-usage \
        "$KIOSK_URL" &

    local chromium_pid=$!

    log "=========================================="
    log "Kiosk is running"
    log "  - Next.js PID: $next_pid"
    log "  - Chromium PID: $chromium_pid"
    log "=========================================="

    wait $chromium_pid 2>/dev/null || true

    log "Chromium exited, stopping Next.js server..."
    kill $next_pid 2>/dev/null || true

    log "Kiosk launcher finished"
}

main "$@"
LAUNCHER_EOF

    chmod +x "$START_KIOSK"
    chown root:root "$START_KIOSK"
    log "  - Created $START_KIOSK"
}

create_kiosk_service() {
    log "  - Creating $KIOSK_SERVICE"
    
    cat > "$KIOSK_SERVICE" << SERVICE_EOF
[Unit]
Description=Cyberdeck Kiosk - Next.js + Chromium
After=network.target peripheral-init.service
Wants=peripheral-init.service

[Service]
Type=simple
User=pi
Restart=always
RestartSec=5
ExecStartPre=/bin/sleep 10
ExecStart=/usr/local/bin/start-kiosk.sh
Environment=HOME=/home/pi
Environment=KIOSK_DIR=/home/pi/cyberdeck-2026/firmware/boards/raspberry-pi-zero-2w/kiosk

[Install]
WantedBy=multi-user.target
SERVICE_EOF

    log "  - Created $KIOSK_SERVICE"
}

# =============================================================================
# RUN MAIN
# =============================================================================

main "$@"
