#!/usr/bin/env bash
# =============================================================================
# flash.sh — Flash firmware to a connected board
# =============================================================================
#
# Usage:
#   ./scripts/flash.sh <board-name> <language>
#
# Examples:
#   ./scripts/flash.sh xiao-esp32s3 tinygo
#   ./scripts/flash.sh arduino-uno arduino
#
# =============================================================================

set -euo pipefail

BOARD="${1:?Usage: flash.sh <board-name> <language>}"
LANGUAGE="${2:?Usage: flash.sh <board-name> <language>}"

FIRMWARE_DIR="firmware/boards/${BOARD}/${LANGUAGE}"

if [ ! -d "${FIRMWARE_DIR}" ]; then
  echo "Error: Firmware directory not found: ${FIRMWARE_DIR}"
  echo "Available boards:"
  ls firmware/boards/ 2>/dev/null || echo "  (none)"
  exit 1
fi

echo "Flashing ${BOARD} (${LANGUAGE})..."

case "${LANGUAGE}" in
  tinygo)
    echo "TODO: Add TinyGo flash command for ${BOARD}"
    # Example: tinygo flash -target=<target> ${FIRMWARE_DIR}/main.go
    ;;
  arduino)
    echo "TODO: Add Arduino CLI upload command for ${BOARD}"
    # Example: arduino-cli upload --fqbn <fqbn> --port <port> ${FIRMWARE_DIR}/
    ;;
  *)
    echo "Error: Unknown language '${LANGUAGE}'. Supported: tinygo, arduino"
    exit 1
    ;;
esac

echo "Flash complete."
