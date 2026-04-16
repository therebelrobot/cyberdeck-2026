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
        # PiSugar server handles battery monitoring
        # This is just for initialization verification
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
        # CardKB uses standard I2C polling - no special init needed
        # The pi-kbd or similar driver handles key events
    else
        log "  CardKB not detected on I2C"
    fi
}

# =============================================================================
# ANO Rotary Encoder (I2C via seesaw)
# =============================================================================

init_rotary_encoder() {
    log "Initializing ANO Rotary Encoder..."
    
    # ANO encoder uses seesaw firmware, typically at 0x3A or 0x49
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
    
    # Common touch controller I2C addresses
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
    
    # CH334F hub should enumerate automatically
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
    
    # Quectel modems typically appear as /dev/ttyUSB0-3
    if ls /dev/ttyUSB* &>/dev/null; then
        log "  LTE modem detected"
        # ModemManager or chat script handles initialization
    else
        log "  LTE modem not detected"
    fi
}

# =============================================================================
# LoRa Radio (via XIAO ESP32-S3)
# =============================================================================

init_lora_radio() {
    log "Initializing LoRa radio (XIAO ESP32-S3)..."
    
    # LoRa radio communicates via serial
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
