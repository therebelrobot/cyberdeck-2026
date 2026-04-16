#!/usr/bin/env bash
# =============================================================================
# build.sh — Build firmware for a target board
# =============================================================================
#
# Usage:
#   ./scripts/build.sh <board-name> <language>
#
# Examples:
#   ./scripts/build.sh xiao-esp32s3 tinygo
#   ./scripts/build.sh arduino-uno arduino
#
# =============================================================================

set -euo pipefail

BOARD="${1:?Usage: build.sh <board-name> <language>}"
LANGUAGE="${2:?Usage: build.sh <board-name> <language>}"

FIRMWARE_DIR="firmware/boards/${BOARD}/${LANGUAGE}"

if [ ! -d "${FIRMWARE_DIR}" ]; then
  echo "Error: Firmware directory not found: ${FIRMWARE_DIR}"
  echo "Available boards:"
  ls firmware/boards/ 2>/dev/null || echo "  (none)"
  exit 1
fi

echo "Building ${BOARD} (${LANGUAGE})..."

case "${LANGUAGE}" in
  tinygo)
    echo "TODO: Add TinyGo build command for ${BOARD}"
    # Example: tinygo build -target=<target> -o build/${BOARD}.uf2 ${FIRMWARE_DIR}/main.go
    ;;
  arduino)
    echo "TODO: Add Arduino CLI build command for ${BOARD}"
    # Example: arduino-cli compile --fqbn <fqbn> ${FIRMWARE_DIR}/
    ;;
  *)
    echo "Error: Unknown language '${LANGUAGE}'. Supported: tinygo, arduino"
    exit 1
    ;;
esac

echo "Build complete."
