#!/bin/bash
#
# start-kiosk.sh - Launcher script for Cyberdeck Kiosk
#
# This script starts the Next.js server, waits for it to be ready,
# then launches Chromium in kiosk mode.
#
# Usage:
#   ./start-kiosk.sh              # Uses default paths
#   KIOSK_DIR=/path/to/kiosk ./start-kiosk.sh
#

set -e

# Configuration
KIOSK_DIR="${KIOSK_DIR:-/home/pi/cyberdeck-2026/firmware/boards/raspberry-pi-zero-2w/kiosk}"
KIOSK_PORT="${KIOSK_PORT:-3000}"
KIOSK_URL="http://localhost:${KIOSK_PORT}"
NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
MAX_WAIT=30

# Logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [kiosk-launcher] $*"
}

# Find Node.js binary
find_node() {
    if [[ -x "$NVM_DIR/versions/node/v22.14.0/bin/node" ]]; then
        echo "$NVM_DIR/versions/node/v22.14.0/bin/node"
    elif [[ -x "$NVM_DIR/versions/node/v22.12.0/bin/node" ]]; then
        echo "$NVM_DIR/versions/node/v22.12.0/bin/node"
    elif command -v node &>/dev/null; then
        command -v node
    else
        log "ERROR: Node.js not found"
        exit 1
    fi
}

# Wait for server to be ready
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

# Main
main() {
    log "=========================================="
    log "Cyberdeck Kiosk Launcher Starting"
    log "=========================================="
    log "Kiosk directory: $KIOSK_DIR"
    log "Kiosk port: $KIOSK_PORT"

    # Verify kiosk directory exists
    if [[ ! -d "$KIOSK_DIR" ]]; then
        log "ERROR: Kiosk directory not found: $KIOSK_DIR"
        exit 1
    fi

    cd "$KIOSK_DIR"

    # Find Node.js
    local node_bin
    node_bin=$(find_node)
    log "Using Node.js: $node_bin"

    # Check if Next.js is built, if not build it
    if [[ ! -d "$KIOSK_DIR/.next" ]]; then
        log "Next.js not built, building..."
        npm run build
        log "Build complete"
    fi

    # Start Next.js server in background
    log "Starting Next.js server..."
    PORT="$KIOSK_PORT" npm start &
    local next_pid=$!

    # Wait for server to be ready
    if ! wait_for_server "$node_bin" "$MAX_WAIT"; then
        log "ERROR: Failed to start Next.js server"
        kill $next_pid 2>/dev/null || true
        exit 1
    fi

    log "Starting Chromium browser..."
    # Launch Chromium in kiosk mode
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

    # Wait for Chromium to exit
    wait $chromium_pid 2>/dev/null || true

    log "Chromium exited, stopping Next.js server..."
    kill $next_pid 2>/dev/null || true

    log "Kiosk launcher finished"
}

main "$@"
