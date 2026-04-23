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
# WAVESHARE 3.5" DPI LCD CONFIGURATION
# =============================================================================
# Configuration for Waveshare 3.5" DPI LCD (640x480, IPS display)
# Hardware: https://www.waveshare.com/3.5inch-DPI-LCD.htm
# User Guide: docs/waveshare_user_guide.pdf
#
# Pinout:
#   - Display: DPI interface (uses 40-pin GPIO)
#   - Touch: I2C (SDA=SDA, SCL=SCL)
#   - Backlight: PWM on GPIO 18

WAVESHARE_DTBO_URL="https://files.waveshare.com/wiki/3.5inch-DPI-LCD/3.5inch-DPI-LCD_dtbo.tar.gz"
WAVESHARE_DTBO_DIR="/boot/overlays"
WAVESHARE_OVERLAY="waveshare-35dpi-3b-4b"
WAVESHARE_BACKLIGHT_GPIO=18

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

    # -------------------------------------------------------------------------
    log_step "Step 2: Configure Waveshare 3.5inch DPI LCD display"
    # -------------------------------------------------------------------------
    
    # Install Waveshare device tree overlays
    install_waveshare_dtbo || log "  - Warning: DTBO installation had issues"
    
    # Configure display in config.txt
    configure_waveshare_display
    
    # Configure display rotation (default: 0 degrees, can be changed later)
    # Pass rotation as argument if you want different default: configure_display_rotation 90
    configure_display_rotation 0
    
    # Configure touch panel calibration for the rotation
    configure_touch_calibration 0
    
    # Configure backlight PWM control
    configure_backlight_pwm || log "  - Note: Backlight PWM optional, display works without it"
    
    fi
    
    # -------------------------------------------------------------------------
    log_step "Step 3: Install Plymouth splash configuration"
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
    log_step "Step 4: Configure auto-login via LightDM"
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

        # Disable display power saving per Waveshare user guide
        if grep -q "^xserver-command=" "$LIGHTDM_CONF" 2>/dev/null; then
            # Update existing xserver-command to disable power saving
            sed -i "s/^xserver-command=.*/xserver-command=X -s 0 -dpms/" "$LIGHTDM_CONF"
            log "  - Updated xserver-command to disable power saving"
        elif grep -q "^#xserver-command=X" "$LIGHTDM_CONF" 2>/dev/null; then
            # Uncomment and modify existing xserver-command
            sed -i "s/^#xserver-command=X$/xserver-command=X -s 0 -dpms/" "$LIGHTDM_CONF"
            log "  - Enabled xserver-command to disable power saving"
        else
            # Add xserver-command to [SeatDefaults] section
            if grep -q "^\[SeatDefaults\]$" "$LIGHTDM_CONF" 2>/dev/null; then
                sed -i "/^\[SeatDefaults\]$/a xserver-command=X -s 0 -dpms" "$LIGHTDM_CONF"
            else
                echo "" >> "$LIGHTDM_CONF"
                echo "[SeatDefaults]" >> "$LIGHTDM_CONF"
                echo "xserver-command=X -s 0 -dpms" >> "$LIGHTDM_CONF"
            fi
            log "  - Added xserver-command to disable display power saving"
        fi
        fi
    else
        log "  - WARNING: $LIGHTDM_CONF not found, skipping autologin"
    fi
    
    # -------------------------------------------------------------------------
    log_step "Step 5: Create labwc autostart configuration"
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
    log_step "Step 6: Install Node.js and setup kiosk app"
    # -------------------------------------------------------------------------
    
    if ! check_node_installed; then
        install_nvm
    else
        log "  - Node.js already installed"
    fi
    
    setup_kiosk_app
    
    # -------------------------------------------------------------------------
    log_step "Step 7: Install and configure systemd services"
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
    log_step "Step 8: Enable PiSugar server (if installed)"
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

# =============================================================================
# WAVESHARE 3.5" DPI LCD CONFIGURATION FUNCTIONS
# =============================================================================

#raspi-config is not available on the Pi Zero 2 W in the same way
#We use the dtoverlay approach

install_waveshare_dtbo() {
    log "Installing Waveshare 3.5inch DPI LCD device tree overlays..."
    
    # Create overlays directory if it doesn't exist
    mkdir -p "$WAVESHARE_DTBO_DIR"
    
    # Local DTBO source directory (included in repo)
    local local_dtbo_src="/home/pi/cyberdeck-2026/firmware/boards/raspberry-pi-zero-2w/3.5DPI-dtbo"
    
    # Check if already installed
    local dtbo_file="${WAVESHARE_DTBO_DIR}/${WAVESHARE_OVERLAY}.dtbo"
    if [[ -f "$dtbo_file" ]]; then
        log "  - DTBO files already installed"
    elif [[ -d "$local_dtbo_src" ]]; then
        log "  - Copying DTBO files from local repo: $local_dtbo_src"
        cp -u "$local_dtbo_src"/*.dtbo "$WAVESHARE_DTBO_DIR/" 2>/dev/null || cp "$local_dtbo_src"/*.dtbo "$WAVESHARE_DTBO_DIR/" 2>/dev/null
        log "  - DTBO files copied to $WAVESHARE_DTBO_DIR"
    else
        log "  - WARNING: Local DTBO files not found at $local_dtbo_src"
        log "  - Attempting to download from Waveshare..."
        local tmp_dir=$(mktemp -d)
        
        if curl -L --fail --silent --show-error -o "${tmp_dir}/dtbo.tar.gz" "$WAVESHARE_DTBO_URL" 2>/dev/null; then
            tar -xzf "${tmp_dir}/dtbo.tar.gz" -C "$WAVESHARE_DTBO_DIR" 2>/dev/null || true
            log "  - DTBO files downloaded and installed"
        else
            log "  - ERROR: Failed to download DTBO files"
        fi
        
        rm -rf "$tmp_dir"
    fi
    
    # Verify at least one DTBO file exists
    if ls "${WAVESHARE_DTBO_DIR}"/waveshare-35-dpi*.dtbo 2>/dev/null | head -1 | grep -q dtbo || \
       ls "${WAVESHARE_DTBO_DIR}"/waveshare-35dpi*.dtbo 2>/dev/null | head -1 | grep -q dtbo; then
        log "  - Waveshare DTBO files verified"
        return 0
    else
        log "  - WARNING: No Waveshare DTBO files found in $WAVESHARE_DTBO_DIR"
        return 1
    fi
}

configure_waveshare_display() {
    log "Configuring Waveshare 3.5inch DPI LCD in $BOOT_CONFIG..."
    
    backup_file "$BOOT_CONFIG"
    
    # Check if already configured (check for both old and new naming)
    if grep -q "dtoverlay=waveshare-35dpi\|dtoverlay=waveshare-35-dpi" "$BOOT_CONFIG" 2>/dev/null; then
        log "  - Waveshare display already configured"
        return 0
    fi
    
    # Detect Raspberry Pi model for appropriate overlay
    local pi_model=$(tr -d '\0' < /proc/device-tree/model 2>/dev/null || echo "Unknown")
    local selected_overlay=""
    
    if echo "$pi_model" | grep -q "Pi 3"; then
        selected_overlay="waveshare-35dpi-3b"
        log "  - Detected Pi 3/3B/3B+, using ${selected_overlay} overlay"
    elif echo "$pi_model" | grep -q "Pi 4"; then
        selected_overlay="waveshare-35dpi-4b"
        log "  - Detected Pi 4, using ${selected_overlay} overlay"
    elif echo "$pi_model" | grep -q "Pi Zero 2"; then
        # Pi Zero 2 W uses the same overlay as 3B+
        selected_overlay="waveshare-35dpi-3b-4b"
        log "  - Detected Pi Zero 2 W, using ${selected_overlay} overlay"
    elif echo "$pi_model" | grep -q "Pi Zero"; then
        selected_overlay="waveshare-35dpi-3b"
        log "  - Detected Pi Zero, using ${selected_overlay} overlay"
    else
        # Default to 3b-4b overlay (most compatible)
        selected_overlay="waveshare-35dpi-3b-4b"
        log "  - Unknown Pi model ($pi_model), using default ${selected_overlay} overlay"
    fi
    
    # Add configuration to config.txt
    cat >> "$BOOT_CONFIG" << BOOT_EOF

# =============================================================================
# Waveshare 3.5inch DPI LCD Configuration
# =============================================================================
# Display: 640x480 IPS, 60Hz refresh
# Touch: 5-point capacitive via I2C
# Backlight: PWM control on GPIO 18
# Reference: docs/waveshare_user_guide.pdf

# Enable VC4 KMS driver (required for Bullseye+)
dtoverlay=vc4-kms-v3d

# DPI LCD overlay (640x480 @ 60Hz)
dtoverlay=${selected_overlay}

# Force LCD as default display
display_default_lcd=1

# Disable power saving to keep display on
# (Also configured in lightdm.conf via xserver-command)
BOOT_EOF
    
    log "  - Added Waveshare display configuration to $BOOT_CONFIG"
    log "  - Using overlay: $selected_overlay"
    
    return 0
}

configure_display_rotation() {
    local rotation="${1:-0}"
    
    log "Configuring display rotation: ${rotation} degrees..."
    
    # For KMS/FKMS drivers, we use xrandr for display rotation
    # The autostart file already has xset commands, we add rotation here
    
    # Map rotation value to xrandr orientation
    case "$rotation" in
        0)
            local xrandr_mode="normal"
            ;;
        90)
            local xrandr_mode="right"
            ;;
        180)
            local xrandr_mode="inverted"
            ;;
        270)
            local xrandr_mode="left"
            ;;
        *)
            log "  - Unknown rotation: $rotation, using 0 (normal)"
            local xrandr_mode="normal"
            rotation=0
            ;;
    esac
    
    # Add rotation command to autostart if not already present
    if [[ -f "$AUTOSTART_FILE" ]]; then
        if grep -q "xrandr -o" "$AUTOSTART_FILE" 2>/dev/null; then
            # Update existing rotation
            sed -i "s/xrandr -o .*/xrandr -o ${rotation}/" "$AUTOSTART_FILE"
            log "  - Updated existing rotation in $AUTOSTART_FILE"
        else
            # Add rotation command
            echo "" >> "$AUTOSTART_FILE"
            echo "# Display rotation (0=normal, 1=90, 2=180, 3=270)" >> "$AUTOSTART_FILE"
            echo "xrandr -o $rotation" >> "$AUTOSTART_FILE"
            log "  - Added rotation command to $AUTOSTART_FILE"
        fi
    else
        mkdir -p "$AUTOSTART_DIR"
        echo "# Labwc autostart - kiosk configuration with rotation" > "$AUTOSTART_FILE"
        echo "xrandr -o $rotation" >> "$AUTOSTART_FILE"
        log "  - Created $AUTOSTART_FILE with rotation"
    fi
    
    log "  - Display rotation set to ${rotation} degrees"
}

configure_touch_calibration() {
    local rotation="${1:-0}"
    
    log "Configuring touch panel calibration for ${rotation} degree rotation..."
    
    # Install libinput if not present
    if ! command -v xinput &>/dev/null; then
        log "  - Installing xinput/libinput..."
        apt-get install -y -qq xinput xserver-xorg-input-libinput 2>/dev/null || true
    fi
    
    # Create X11 config directory if needed
    local xorg_conf_dir="/etc/X11/xorg.conf.d"
    mkdir -p "$xorg_conf_dir"
    
    # Matrix based on rotation:
    # 0°:   "1 0 0 0 1 0 0 0 1"
    # 90°:  "0 1 0 -1 0 1 0 0 1"
    # 180°: "-1 0 1 0 -1 1 0 0 1"
    # 270°: "0 -1 1 1 0 0 0 0 1"
    local matrix
    case "$rotation" in
        0)
            matrix="1 0 0 0 1 0 0 0 1"
            ;;
        90)
            matrix="0 1 0 -1 0 1 0 0 1"
            ;;
        180)
            matrix="-1 0 1 0 -1 1 0 0 1"
            ;;
        270)
            matrix="0 -1 1 1 0 0 0 0 1"
            ;;
        *)
            matrix="1 0 0 0 1 0 0 0 1"
            rotation=0
            ;;
    esac
    
    # Create or update the touch calibration config
    local touch_conf="${xorg_conf_dir}/40-libinput.conf"
    
    if [[ -f "$touch_conf" ]]; then
        backup_file "$touch_conf"
        
        # Update existing calibration matrix
        if grep -q 'Option "CalibrationMatrix"' "$touch_conf"; then
            sed -i "s/Option \"CalibrationMatrix\" \"[^\"]*\"/Option \"CalibrationMatrix\" \"$matrix\"/" "$touch_conf"
            log "  - Updated calibration matrix in $touch_conf"
        else
            # Add matrix after touchscreen section
            sed -i '/Identifier "libinput pointer catchall"/,/EndSection/ {
                /EndSection/i\        Option "CalibrationMatrix" "'"$matrix"'"
            }' "$touch_conf"
            log "  - Added calibration matrix to $touch_conf"
        fi
    else
        # Copy from system directory
        if [[ -f "/usr/share/X11/xorg.conf.d/40-libinput.conf" ]]; then
            cp /usr/share/X11/xorg.conf.d/40-libinput.conf "$touch_conf"
            
            # Add calibration matrix
            sed -i '/Identifier "libinput pointer catchall"/,/EndSection/ {
                /EndSection/i\        Option "CalibrationMatrix" "'"$matrix"'"
            }' "$touch_conf"
            log "  - Created $touch_conf with calibration matrix"
        else
            log "  - WARNING: System 40-libinput.conf not found, touch calibration may be incomplete"
        fi
    fi
    
    log "  - Touch calibration configured for ${rotation} degree rotation"
}

configure_backlight_pwm() {
    log "Configuring backlight PWM control on GPIO ${WAVESHARE_BACKLIGHT_GPIO}..."
    
    # Install wiringPi for PWM control if needed
    if ! command -v gpio &>/dev/null; then
        log "  - Installing wiringPi..."
        local tmp_dir=$(mktemp -d)
        cd "$tmp_dir"
        curl -L --fail --silent --show-error -o wiringpi.deb https://project-downloads.drogon.net/wiringpi-latest.deb 2>/dev/null || true
        if [[ -f wiringpi.deb ]]; then
            dpkg -i wiringpi.deb 2>/dev/null || true
        fi
        rm -rf "$tmp_dir"
        cd - >/dev/null
    fi
    
    # Check if gpio command works
    if command -v gpio &>/dev/null; then
        # Configure GPIO 18 as PWM mode
        gpio -g mode ${WAVESHARE_BACKLIGHT_GPIO} pwm 2>/dev/null || true
        gpio pwmc 100 2>/dev/null || true
        
        # Set backlight to maximum (brightest)
        gpio -g pwm ${WAVESHARE_BACKLIGHT_GPIO} 0 2>/dev/null || true
        
        log "  - Backlight PWM configured on GPIO ${WAVESHARE_BACKLIGHT_GPIO}"
        log "  - Backlight set to maximum brightness"
        
        # Add to init-peripherals script for persistence
        if [[ -f "$INIT_PERIPHERALS" ]] && ! grep -q "gpio.*pwm.*backlight" "$INIT_PERIPHERALS" 2>/dev/null; then
            cat >> "$INIT_PERIPHERALS" << 'BACKLIGHT_EOF'

# Configure Waveshare LCD backlight PWM
if command -v gpio &>/dev/null; then
    gpio -g mode ${WAVESHARE_BACKLIGHT_GPIO} pwm 2>/dev/null || true
    gpio pwmc 100 2>/dev/null || true
    gpio -g pwm ${WAVESHARE_BACKLIGHT_GPIO} 0 2>/dev/null || true
fi
BACKLIGHT_EOF
            log "  - Added backlight PWM config to $INIT_PERIPHERALS"
        fi
        
        return 0
    else
        log "  - WARNING: gpio command not available, skipping backlight PWM config"
        return 1
    fi
}


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
