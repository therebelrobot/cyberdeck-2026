---
name: xiao-accessory-6chrelay
description: >
  Provides comprehensive reference for using the XIAO 6-Channel Wi-Fi 5V DC Relay module
  with Seeed Studio XIAO microcontrollers. Covers GPIO relay control, ESPHome/Home Assistant
  integration, Wi-Fi setup, and Grove expansion ports. Includes Arduino and ESPHome configuration
  examples. Use when integrating the 6-channel relay for DC load switching, home automation,
  or IoT control applications. DC ONLY — NOT for AC power.
  Keywords: XIAO, relay, 6-channel, Wi-Fi, ESPHome, Home Assistant, GPIO, DC, switch,
  automation, IoT, smart home, ESP32C6, Grove.
---

# XIAO 6-Channel Wi-Fi 5V DC Relay — XIAO Accessory Guide

Provides comprehensive reference for using the XIAO 6-Channel Wi-Fi 5V DC Relay module with Seeed Studio XIAO microcontrollers.

## When to Use

- Integrating the 6-channel relay for DC load switching
- Setting up ESPHome/Home Assistant control for relay channels
- Writing Arduino firmware for direct GPIO relay control
- Configuring Wi-Fi connectivity for remote relay operation
- Checking pin usage and GPIO mapping

## When NOT to Use

- **⚠ NEVER use for AC power** — this relay is DC ONLY
- For standalone XIAO board pinouts → use the corresponding board skill
- For other XIAO accessories → use the corresponding accessory skill

---

## ⚠ SAFETY WARNING

> **DC OPERATION ONLY — Do NOT connect to AC power.**
> Voltages exceeding 24V may cause electric shock.
> Always disconnect power before wiring.

---

## Accessory Overview

| Parameter | Value |
|---|---|
| **Type** | 6-channel Wi-Fi DC relay module |
| **Interface** | GPIO (relay control) + Wi-Fi (remote control) |
| **Input Voltage** | DC 5V (for XIAO) |
| **DC Withstand Voltage** | DC 0–30V |
| **Maximum Load** | 10A per channel |
| **Channels** | 6 (independent control) |
| **Connection Type** | Wi-Fi (ESPHome) |
| **Electrical Ports** | NO (Normally Open), COM (Common), NC (Normally Closed) |
| **Grove Expansion** | I2C × 1, UART × 1 |
| **Pre-flashed Firmware** | ESPHome for XIAO ESP32C6 |

### Compatible XIAO Boards

| Board | Status | Notes |
|-------|--------|-------|
| XIAO ESP32C6 | ✅ Primary | Pre-flashed with ESPHome firmware |
| Other Wi-Fi XIAO | ⚠️ | Requires custom firmware; GPIO mapping may differ |
| Non-Wi-Fi XIAO | ❌ | No wireless control capability |

---

## Pin Usage Diagram

```
XIAO GPIO   | Relay Channel  | Function
------------|----------------|------------------
GPIO2       | Channel 1      | Relay 1 control
GPIO21      | Channel 2      | Relay 2 control
GPIO1       | Channel 3      | Relay 3 control
GPIO0       | Channel 4      | Relay 4 control
GPIO19      | Channel 5      | Relay 5 control
GPIO18      | Channel 6      | Relay 6 control
```

> **Note:** GPIO numbers are for XIAO ESP32C6. These are raw GPIO numbers, not D-pin labels.

---

## Pin Conflict Warning

### Pins OCCUPIED by 6-Ch Relay
- **GPIO0** — Relay 4
- **GPIO1** — Relay 3
- **GPIO2** — Relay 1
- **GPIO18** — Relay 6
- **GPIO19** — Relay 5
- **GPIO21** — Relay 2

### Pins remaining FREE
- Limited — most GPIO pins are occupied by relay channels
- Grove I2C and UART ports provide expansion capability

### Conflicts with other accessories
- **Most accessories** — conflicts likely due to heavy GPIO usage ❌
- **reSpeaker Lite** — no conflict ✅ (separate board)

> **Note:** The 6-Ch Relay uses most available GPIO pins. It is designed as a dedicated relay controller, not for use with multiple accessories simultaneously.

---

## Power Requirements

| Parameter | Value |
|-----------|-------|
| XIAO Input | DC 5V via USB |
| Relay Load Voltage | DC 0–30V |
| Max Current per Channel | 10A |
| Total Max Load | Check power supply capacity |

---

## ESPHome Setup (Primary Method)

The relay module comes **pre-flashed with ESPHome firmware** for XIAO ESP32C6.

### Initial Wi-Fi Setup

1. Power up the relay module via USB
2. Module creates Wi-Fi access point: **SSID:** `seeedstudio-6-channel-relay`
3. Connect to the AP from your phone/computer
4. Navigate to `http://192.168.4.1`
5. Enter your home Wi-Fi SSID and password
6. Module connects to your home network
7. Module appears in Home Assistant under **Settings → Devices & Services**

### Home Assistant Integration

Once connected to Wi-Fi:
1. Open Home Assistant
2. Go to **Settings → Devices & Services**
3. The relay module should auto-discover
4. Click **Configure** to add it
5. Six switches appear on your dashboard (one per relay channel)
6. Control each relay independently from the Home Assistant UI

### ESPHome YAML Configuration

If you need to customize the ESPHome firmware:

```yaml
esphome:
  name: xiao-6ch-relay
  platform: ESP32
  board: esp32-c6-devkitc-1

wifi:
  ssid: "YOUR_WIFI_SSID"
  password: "YOUR_WIFI_PASSWORD"
  ap:
    ssid: "seeedstudio-6-channel-relay"

api:
  encryption:
    key: "YOUR_API_KEY"

ota:
  password: "YOUR_OTA_PASSWORD"

switch:
  - platform: gpio
    name: "Relay 1"
    pin:
      number: GPIO2
      inverted: false

  - platform: gpio
    name: "Relay 2"
    pin:
      number: GPIO21
      inverted: false

  - platform: gpio
    name: "Relay 3"
    pin:
      number: GPIO1
      inverted: false

  - platform: gpio
    name: "Relay 4"
    pin:
      number: GPIO0
      inverted: false

  - platform: gpio
    name: "Relay 5"
    pin:
      number: GPIO19
      inverted: false

  - platform: gpio
    name: "Relay 6"
    pin:
      number: GPIO18
      inverted: false
```

### Re-flashing Firmware

Firmware can be re-flashed via:
- **ESPHome Web Tool** (Chrome/Edge only — Firefox NOT supported)
- **ESPHome Dashboard** in Home Assistant
- **USB DFU** mode

---

## Arduino Setup & Usage (Direct GPIO Control)

### Initialization

```cpp
// GPIO pins for each relay channel (XIAO ESP32C6)
const int RELAY_PINS[] = {2, 21, 1, 0, 19, 18};
const int NUM_RELAYS = 6;

void setup() {
    Serial.begin(115200);

    // Configure all relay pins as outputs
    for (int i = 0; i < NUM_RELAYS; i++) {
        pinMode(RELAY_PINS[i], OUTPUT);
        digitalWrite(RELAY_PINS[i], LOW); // All relays OFF
    }

    Serial.println("6-Channel Relay initialized");
}
```

### Complete Working Example — Sequential Relay Control

```cpp
const int RELAY_PINS[] = {2, 21, 1, 0, 19, 18};
const int NUM_RELAYS = 6;

void setup() {
    Serial.begin(115200);

    for (int i = 0; i < NUM_RELAYS; i++) {
        pinMode(RELAY_PINS[i], OUTPUT);
        digitalWrite(RELAY_PINS[i], LOW);
    }

    Serial.println("6-Channel Relay - Sequential Test");
}

void loop() {
    // Turn on each relay sequentially
    for (int i = 0; i < NUM_RELAYS; i++) {
        Serial.print("Relay ");
        Serial.print(i + 1);
        Serial.println(" ON");
        digitalWrite(RELAY_PINS[i], HIGH);
        delay(1000);
    }

    // Turn off each relay sequentially
    for (int i = 0; i < NUM_RELAYS; i++) {
        Serial.print("Relay ");
        Serial.print(i + 1);
        Serial.println(" OFF");
        digitalWrite(RELAY_PINS[i], LOW);
        delay(1000);
    }
}
```

### Wi-Fi Web Server Control (Arduino)

```cpp
#include <WiFi.h>
#include <WebServer.h>

const char* ssid = "YOUR_SSID";
const char* password = "YOUR_PASSWORD";

const int RELAY_PINS[] = {2, 21, 1, 0, 19, 18};
const int NUM_RELAYS = 6;
bool relayState[6] = {false};

WebServer server(80);

void setup() {
    Serial.begin(115200);

    for (int i = 0; i < NUM_RELAYS; i++) {
        pinMode(RELAY_PINS[i], OUTPUT);
        digitalWrite(RELAY_PINS[i], LOW);
    }

    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.println();
    Serial.print("IP: ");
    Serial.println(WiFi.localIP());

    // Route: /relay?ch=1&state=on
    server.on("/relay", handleRelay);
    server.on("/status", handleStatus);
    server.begin();
}

void handleRelay() {
    int ch = server.arg("ch").toInt();
    String state = server.arg("state");

    if (ch >= 1 && ch <= 6) {
        bool on = (state == "on");
        digitalWrite(RELAY_PINS[ch - 1], on ? HIGH : LOW);
        relayState[ch - 1] = on;
        server.send(200, "text/plain", "Relay " + String(ch) + " " + state);
    } else {
        server.send(400, "text/plain", "Invalid channel (1-6)");
    }
}

void handleStatus() {
    String json = "{";
    for (int i = 0; i < NUM_RELAYS; i++) {
        json += "\"relay" + String(i + 1) + "\":" + (relayState[i] ? "true" : "false");
        if (i < NUM_RELAYS - 1) json += ",";
    }
    json += "}";
    server.send(200, "application/json", json);
}

void loop() {
    server.handleClient();
}
```

---

## TinyGo Setup & Usage

### TinyGo GPIO Relay Control

```go
package main

import (
    "fmt"
    "machine"
    "time"
)

func main() {
    // Define relay pins (ESP32C6 GPIO numbers)
    relayPins := []machine.Pin{
        machine.GPIO2,  // Relay 1
        machine.GPIO21, // Relay 2
        machine.GPIO1,  // Relay 3
        machine.GPIO0,  // Relay 4
        machine.GPIO19, // Relay 5
        machine.GPIO18, // Relay 6
    }

    // Configure all pins as outputs
    for i, pin := range relayPins {
        pin.Configure(machine.PinConfig{Mode: machine.PinOutput})
        pin.Low() // Start with all relays OFF
        fmt.Printf("Relay %d configured on GPIO%d\n", i+1, pin)
    }

    println("6-Channel Relay initialized (TinyGo)")

    // Sequential test
    for {
        for i, pin := range relayPins {
            fmt.Printf("Relay %d ON\n", i+1)
            pin.High()
            time.Sleep(1 * time.Second)
        }
        for i, pin := range relayPins {
            fmt.Printf("Relay %d OFF\n", i+1)
            pin.Low()
            time.Sleep(1 * time.Second)
        }
    }
}
```

> **⚠ TinyGo Limitation:** TinyGo Wi-Fi support for ESP32C6 is experimental. For Wi-Fi-based relay control, ESPHome or Arduino is recommended. TinyGo is suitable for direct GPIO control without Wi-Fi.

---

## Communication Protocol Details

### GPIO Control

| Parameter | Value |
|-----------|-------|
| Logic Level | 3.3V |
| Relay ON | GPIO HIGH |
| Relay OFF | GPIO LOW |
| Relay Type | Electromechanical |
| Contact Types | NO (Normally Open), COM (Common), NC (Normally Closed) |

### Relay Contact Wiring

```
For Normally Open (NO) operation:
  COM ──── Load+ ──── Power+
  NO  ──── Load- ──── Power-
  (Circuit closed when relay ON)

For Normally Closed (NC) operation:
  COM ──── Load+ ──── Power+
  NC  ──── Load- ──── Power-
  (Circuit closed when relay OFF)
```

### Grove Expansion Ports

| Port | Type | Pins |
|------|------|------|
| Grove 1 | I2C | SDA, SCL |
| Grove 2 | UART | TX, RX |

---

## Common Gotchas / Notes

1. **⚠ CRITICAL: DC ONLY** — This relay module is designed for DC loads ONLY. Do NOT connect to AC mains power. Voltages exceeding 24V may cause electric shock.
2. **Always disconnect power before wiring** — Never wire relay connections while the module is powered
3. **Pre-flashed firmware** — Comes with ESPHome firmware for XIAO ESP32C6; re-flashing erases the default firmware
4. **Browser compatibility** — Web-based firmware flashing requires Chrome or Edge; Firefox is NOT supported
5. **10A per channel** — Maximum 10A per relay channel; exceeding this can damage the relay contacts
6. **GPIO mapping** — The GPIO numbers listed are for ESP32C6; other XIAO boards may have different GPIO mappings
7. **Heavy pin usage** — Uses 6 GPIO pins, leaving very few free for other peripherals
8. **Grove ports** — I2C and UART Grove ports provide expansion capability for sensors despite heavy GPIO usage
9. **ESPHome preferred** — For Home Assistant integration, ESPHome is the recommended approach over custom Arduino firmware
10. **Wi-Fi AP fallback** — If the module can't connect to configured Wi-Fi, it falls back to AP mode (`seeedstudio-6-channel-relay`)

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/6_channel_wifi_relay/
- **ESPHome:** https://esphome.io/
- **Home Assistant:** https://www.home-assistant.io/
- **Seeed Product Page:** https://www.seeedstudio.com/XIAO-6-Channel-Relay-p-6094.html
