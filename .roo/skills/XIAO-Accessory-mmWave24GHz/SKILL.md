---
name: xiao-accessory-mmwave24ghz
description: >
  Provides comprehensive reference for using the 24GHz mmWave Human Static Presence Sensor
  with Seeed Studio XIAO microcontrollers. Covers FMCW radar detection, UART serial communication,
  Bluetooth configuration via HLKRadarTool app, and secondary development. Includes Arduino and
  TinyGo setup, wiring, pin usage, and code examples. Use when integrating the mmWave presence
  sensor for human detection, occupancy sensing, or motion detection on any XIAO board.
  Keywords: XIAO, mmWave, 24GHz, radar, FMCW, presence, human detection, static, motion,
  occupancy, UART, serial, HLKRadarTool, Bluetooth, sensor.
---

# 24GHz mmWave Human Static Presence Sensor — XIAO Accessory Guide

Provides comprehensive reference for using the 24GHz mmWave Human Static Presence Sensor with Seeed Studio XIAO microcontrollers.

## When to Use

- Integrating the 24GHz mmWave sensor for human presence/motion detection
- Looking up which XIAO pins the mmWave sensor occupies
- Writing Arduino or TinyGo firmware to read presence data via UART
- Configuring detection parameters via Bluetooth or serial commands
- Checking pin conflicts with other XIAO accessories

## When NOT to Use

- For standalone XIAO board pinouts → use the corresponding board skill
- For other XIAO accessories → use the corresponding accessory skill

---

## Accessory Overview

| Parameter | Value |
|---|---|
| **Type** | FMCW radar human presence sensor |
| **Interface** | Software Serial (UART) on D2/D3 |
| **Operating Frequency** | 24GHz–24.25GHz |
| **Modulation** | FMCW (Frequency Modulated Continuous Wave) |
| **Detection Distance** | 0.75m–6m (adjustable) |
| **Detection Angle** | ±60° |
| **Distance Resolution** | 0.75m |
| **Sweep Bandwidth** | 250MHz |
| **Dimensions** | 18 × 22 mm |
| **Operating Temperature** | -40°C to 85°C |

### Compatible XIAO Boards

All XIAO boards are compatible — the sensor plugs directly onto XIAO headers.

---

## Pin Usage Diagram

```
XIAO Pin    | Accessory Function       | Protocol
------------|--------------------------|----------
D2          | Sensor TX                | Soft Serial
D3          | Sensor RX                | Soft Serial
3V3         | Power Supply             | Power
GND         | Ground                   | Power
```

> **Note:** Only D2, D3, 3V3, and GND are used. All other XIAO pins remain free.

---

## Pin Conflict Warning

### Pins OCCUPIED by mmWave Sensor
- **D2** — Sensor TX (soft serial)
- **D3** — Sensor RX (soft serial)

### Pins remaining FREE
- D0, D1, D4, D5, D6, D7, D8, D9, D10, A0

### Conflicts with other accessories
- **Logger HAT** — conflicts on D2 (RTC interrupt) ❌
- **ePaper Breakout** — conflicts on D3 (DC pin) ❌
- **L76K GNSS** — no conflict ✅ (uses D6/D7)
- **CAN Bus** — no conflict ✅ (uses D7–D10)
- **reSpeaker Lite** — no conflict ✅ (separate board)
- **6-Ch Relay** — check GPIO mapping per board

---

## Power Requirements

| Parameter | Value |
|-----------|-------|
| Operating Voltage | DC 5V |
| Power Supply Capacity | >200mA |
| Average Operating Current | 79mA |

> **⚠ Important:** The sensor requires 5V power. It draws from the XIAO 5V pin (USB VBUS). Battery-only operation may not provide sufficient voltage.

---

## Arduino Setup & Usage

### Required Libraries

No dedicated Arduino library is required for basic operation. Communication is via software serial.

```bash
# SoftwareSerial is built-in for most boards
# No additional library installation needed for basic usage
```

### Configuration Tools

- **HLKRadarTool** app (iOS/Android/Windows) for Bluetooth-based parameter adjustment
- Serial commands for secondary development

### Initialization

```cpp
#include <SoftwareSerial.h>

// mmWave sensor on D2 (TX from sensor) and D3 (RX to sensor)
SoftwareSerial mmWaveSerial(D2, D3); // RX, TX

void setup() {
    Serial.begin(115200);    // USB serial for monitoring
    mmWaveSerial.begin(115200); // mmWave sensor default baud
    Serial.println("mmWave sensor initialized");
}
```

### Complete Working Example — Presence Detection

```cpp
#include <SoftwareSerial.h>

SoftwareSerial mmWaveSerial(D2, D3); // RX=D2, TX=D3

void setup() {
    Serial.begin(115200);
    mmWaveSerial.begin(115200);

    Serial.println("24GHz mmWave Presence Sensor");
    Serial.println("Waiting for data...");
}

void loop() {
    // Read data from mmWave sensor
    if (mmWaveSerial.available()) {
        String data = "";
        while (mmWaveSerial.available()) {
            char c = mmWaveSerial.read();
            data += c;
            delay(2); // Small delay for complete message
        }

        // Parse and display sensor output
        Serial.print("Sensor: ");
        Serial.println(data);
    }

    delay(100);
}
```

### UART Command Format

The sensor accepts serial commands for configuration. Commands use a specific frame format:

```cpp
// Send a command to the mmWave sensor
void sendCommand(uint8_t* cmd, size_t len) {
    mmWaveSerial.write(cmd, len);
    delay(100);

    // Read response
    while (mmWaveSerial.available()) {
        Serial.print((char)mmWaveSerial.read());
    }
    Serial.println();
}

// Example: Query sensor status
void querySensorStatus() {
    // Command format depends on firmware version
    // Refer to HLK-LD2410 or similar protocol documentation
    // for specific command bytes
    Serial.println("Query sent");
}
```

### Reading Presence Data with Parsing

```cpp
#include <SoftwareSerial.h>

SoftwareSerial mmWaveSerial(D2, D3);

// Buffer for incoming data
uint8_t buffer[64];
int bufferIndex = 0;

void setup() {
    Serial.begin(115200);
    mmWaveSerial.begin(115200);
    Serial.println("mmWave Presence Sensor Ready");
}

void loop() {
    while (mmWaveSerial.available()) {
        uint8_t byte = mmWaveSerial.read();
        buffer[bufferIndex++] = byte;

        // Prevent buffer overflow
        if (bufferIndex >= 64) {
            bufferIndex = 0;
        }

        // Check for complete frame (implementation depends on protocol)
        // Parse presence/motion state from frame data
    }

    delay(10);
}
```

---

## TinyGo Setup & Usage

### TinyGo UART Example

TinyGo does not have a dedicated mmWave driver. Use UART directly:

```go
package main

import (
    "fmt"
    "machine"
    "time"
)

func main() {
    // Configure UART for mmWave sensor
    // Note: Software serial is not available in TinyGo
    // Use a hardware UART if available on your XIAO board
    uart := machine.UART1
    uart.Configure(machine.UARTConfig{
        BaudRate: 115200,
        TX:       machine.D3,
        RX:       machine.D2,
    })

    println("mmWave sensor initialized (TinyGo)")

    buf := make([]byte, 64)
    for {
        n, err := uart.Read(buf)
        if err == nil && n > 0 {
            fmt.Printf("Received %d bytes: %x\n", n, buf[:n])
        }
        time.Sleep(100 * time.Millisecond)
    }
}
```

> **⚠ TinyGo Limitation:** Software serial is not available in TinyGo. You must use a hardware UART. On boards with limited hardware UARTs, D2/D3 may not be mappable to a hardware UART — check your specific XIAO board's UART capabilities. Some boards (e.g., ESP32C3) can remap UART pins.

---

## Communication Protocol Details

### UART Configuration

| Parameter | Value |
|-----------|-------|
| Baud Rate | 115200 (default) |
| Data Bits | 8 |
| Stop Bits | 1 |
| Parity | None |
| IO Level | 3.3V |

### Bluetooth Configuration

The sensor supports Bluetooth parameter adjustment without serial connection:

1. Download **HLKRadarTool** app (iOS/Android/Windows)
2. Power on the sensor
3. Open app → scan for device
4. Connect and adjust parameters:
   - Detection distance range
   - Sensitivity thresholds
   - Motion/static detection modes
   - Reporting interval

### Firmware Management

- **OTA firmware upgrade** via Bluetooth (HLKRadarTool app)
- **Firmware recovery** via app Initialize function if sensor becomes unresponsive

---

## Common Gotchas / Notes

1. **⚠ CRITICAL: Antenna orientation** — The antenna MUST face outward when plugging into XIAO. Incorrect orientation can burn the sensor or the XIAO board
2. **5V power required** — The sensor needs 5V and >200mA; ensure USB is connected or sufficient power supply
3. **Software serial limitations** — On some boards, software serial at 115200 baud may be unreliable; consider using hardware UART if available
4. **Bluetooth vs Serial** — Configuration can be done entirely via Bluetooth (HLKRadarTool app) without any serial connection
5. **Detection range** — Default 0.75m–6m; adjustable via app or serial commands
6. **Warm-up time** — Sensor may need a few seconds after power-on to stabilize readings
7. **Interference** — Metal objects and other radar sources near the sensor can affect accuracy
8. **Pin D2/D3** — These pins are also JTAG pins on ESP32-C3 (MTMS/MTDI); no conflict during normal operation

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/mmwave_for_xiao/
- **HLKRadarTool App:** Available on iOS App Store, Google Play, and Windows
- **Seeed Product Page:** https://www.seeedstudio.com/mmWave-Human-Detection-Sensor-Kit-p-5773.html
