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

# I2C bus number — auto-detected at startup.
# The Waveshare DPI overlay (waveshare-35dpi-3b-4b) claims GPIO2/GPIO3 for
# display data, making hardware I2C bus 1 unavailable. The overlay creates a
# bit-banged I2C bus on GPIO10 (SDA) / GPIO11 (SCL) which appears as a
# different /dev/i2c-N device. We detect the correct bus at runtime.
I2C_BUS="${I2C_BUS:-}"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOGFILE" 2>/dev/null
}

# =============================================================================
# Detect the correct I2C bus for peripherals.
#
# When the DPI display overlay is active, hardware I2C (bus 1) is unavailable.
# The overlay creates a bit-banged i2c-gpio bus on GPIO10/GPIO11. We find it
# by scanning all available buses for known devices (PiSugar at 0x57).
# Falls back to bus 1 if no DPI overlay is active.
# =============================================================================

detect_i2c_bus() {
    # If explicitly set via environment, use that
    if [[ -n "$I2C_BUS" ]]; then
        log "Using I2C bus $I2C_BUS (set via environment)"
        return 0
    fi

    log "Auto-detecting I2C bus..."

    # Find all available I2C buses
    local buses
    buses=$(ls /dev/i2c-* 2>/dev/null | sed 's|/dev/i2c-||' | sort -n)

    if [[ -z "$buses" ]]; then
        log "  WARNING: No I2C buses found. Defaulting to bus 1."
        I2C_BUS=1
        return 1
    fi

    log "  Available I2C buses: $(echo $buses | tr '\n' ' ')"

    # Try to find any known device on each bus to identify the working one.
    # PiSugar I2C is unavailable in power-only mode (GPIO2/3 conflict),
    # so probe for the GT911 touch controller (0x5D) instead.
    for bus in $buses; do
        if i2cdetect -y "$bus" 0x5D 0x5D 2>/dev/null | grep -q "5D"; then
            log "  Found GT911 touch controller (0x5D) on bus $bus"
            I2C_BUS="$bus"
            return 0
        fi
    done

    # No known device found — pick the highest-numbered bus as a
    # heuristic (the bit-banged bus from the DPI overlay is typically
    # assigned a higher number than hardware I2C).
    I2C_BUS=$(echo "$buses" | tail -1)
    log "  No known I2C devices found. Using highest bus: $I2C_BUS"
    return 0
}

wait_for_i2c() {
    local device_addr="$1"
    local max_attempts="${2:-30}"
    local attempt=0
    
    log "Waiting for I2C device at address 0x${device_addr} on bus ${I2C_BUS}..."
    
    while [[ $attempt -lt $max_attempts ]]; do
        if i2cdetect -y "$I2C_BUS" "0x${device_addr}" "0x${device_addr}" 2>/dev/null | grep -q "$device_addr"; then
            log "  Found device at 0x${device_addr} on bus ${I2C_BUS}"
            return 0
        fi
        sleep 0.5
        attempt=$((attempt + 1))
    done
    
    log "  WARNING: Device at 0x${device_addr} not found on bus ${I2C_BUS} after ${max_attempts} attempts"
    return 1
}

# =============================================================================
# PiSugar 3 Battery Management — POWER-ONLY MODE
# =============================================================================
# The PiSugar 3 pogo pins hard-wire I2C to GPIO2/GPIO3, which are claimed
# by the Waveshare DPI display overlay for R0/R1 data lines. I2C
# communication with the PiSugar is unavailable in this configuration.
#
# The PiSugar still provides:
#   - 5V power delivery to the Pi (via pogo pins)
#   - USB-C charging passthrough
#   - Physical power button
#
# NOT available without I2C:
#   - Battery level / voltage / current readings
#   - Charging status
#   - RTC (0x68)
#
# To restore I2C: solder jumper wires from PiSugar SDA/SCL pads to
# GPIO10 (pin 19) / GPIO11 (pin 23) — the bit-banged I2C bus created
# by the DPI overlay.
# =============================================================================

init_pisugar() {
    log "PiSugar 3 — power-only mode (I2C unavailable, GPIO2/3 used by DPI display)"
    log "  Power delivery: active (pogo pins)"
    log "  Battery monitoring: disabled (no I2C)"
    log "  To enable I2C: jumper SDA/SCL to GPIO10/GPIO11"
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
    
    # GT911 capacitive touch controller: 0x5D (default) or 0x14 (alternate)
    # Also check common resistive/other touch controller addresses
    local touch_addrs=("5D" "14" "38" "39" "3A" "48")
    
    for addr in "${touch_addrs[@]}"; do
        if wait_for_i2c "$addr" 5; then
            log "  Touch controller detected at 0x${addr}"
            return 0
        fi
    done
    
    log "  Touch controller not detected (may be SPI or I2C unavailable due to DPI)"
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
    
    # Load I2C kernel modules
    if ! lsmod | grep -q i2c_dev; then
        modprobe i2c-dev
    fi
    if ! lsmod | grep -q i2c_gpio; then
        modprobe i2c-gpio 2>/dev/null || true
    fi
    
    # Wait briefly for bit-banged I2C bus to enumerate
    sleep 1
    
    # Auto-detect the correct I2C bus (DPI overlay moves it from bus 1)
    detect_i2c_bus
    log "Using I2C bus: ${I2C_BUS}"
    
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
    
    # Always exit 0 — missing optional peripherals should not fail the service.
    # Individual init functions log warnings for devices not found.
    return 0
}

main "$@"
