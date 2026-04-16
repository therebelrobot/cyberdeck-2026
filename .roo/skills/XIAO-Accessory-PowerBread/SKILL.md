---
name: xiao-accessory-powerbread
description: >
  Provides reference for using the XIAO PowerBread power supply and breadboard integration board
  with Seeed Studio XIAO microcontrollers. Covers pin passthrough, power regulation, and breadboard
  connectivity. Use when integrating a XIAO board onto a breadboard with regulated power rails.
  Keywords: XIAO, PowerBread, breadboard, power supply, 3.3V, 5V, passthrough, prototyping, breakout.
---

# XIAO PowerBread — XIAO Accessory Guide

Provides comprehensive reference for using the XIAO PowerBread with Seeed Studio XIAO microcontrollers.

## When to Use

- Integrating a XIAO board onto a standard breadboard
- Looking up PowerBread power regulation capabilities
- Checking pin passthrough behavior for breadboard prototyping

## When NOT to Use

- For standalone XIAO board pinouts → use the corresponding board skill
- For other XIAO accessories → use the corresponding accessory skill

---

## ⚠️ Limited Documentation Notice

**No official Seeed Studio wiki page exists for this product.** The product page was not accessible during research. The information below is based on available product descriptions and may be incomplete. Check the [Seeed Studio product page](https://www.seeedstudio.com/XIAO-PowerBread-p-6318.html) for the latest specifications.

---

## Accessory Overview

| Parameter | Value |
|---|---|
| **Type** | Power supply / breadboard integration board |
| **Interface** | Direct pin passthrough |
| **Power Input** | USB-C (via XIAO) or external |
| **Voltage Output** | 3.3V and 5V regulated rails |
| **Dimensions** | Not available |

### Compatible XIAO Boards

All Seeed Studio XIAO form-factor boards (standard XIAO pinout).

---

## Pin Usage Diagram

```
XIAO Pin    | Accessory Function       | Protocol
------------|--------------------------|----------
All pins    | Passthrough to breadboard | Direct
3V3         | 3.3V power rail          | Power
5V          | 5V power rail            | Power
GND         | Ground rail              | Power
```

> The PowerBread passes through all XIAO pins to breadboard-compatible rows. No pins are consumed by the board itself.

---

## Pin Conflict Warning

### Pins OCCUPIED by PowerBread
- **None** — All pins are passed through, not consumed

### Pins remaining FREE
- All XIAO pins (D0–D10, A0, SDA, SCL, TX, RX)

### Conflicts with other accessories
- **No conflicts** — The PowerBread is a passive passthrough board. Other accessories can be wired on the breadboard using the broken-out pins.

---

## Power Requirements

| Parameter | Value |
|-----------|-------|
| Power Source | USB-C via XIAO or external power input |
| Output Rails | 3.3V and 5V regulated |

---

## Arduino Setup & Usage

No libraries or special setup required. The PowerBread is a passive power/breakout board.

### Basic Usage

```cpp
// No special code needed for PowerBread
// Simply use XIAO pins as normal — they are passed through to the breadboard

void setup() {
    Serial.begin(115200);
    pinMode(D0, OUTPUT);  // Example: use any pin on the breadboard
}

void loop() {
    digitalWrite(D0, HIGH);
    delay(500);
    digitalWrite(D0, LOW);
    delay(500);
}
```

---

## TinyGo Setup & Usage

No special drivers or setup required. Use XIAO pins as normal.

```go
package main

import (
    "machine"
    "time"
)

func main() {
    led := machine.D0
    led.Configure(machine.PinConfig{Mode: machine.PinOutput})

    for {
        led.High()
        time.Sleep(500 * time.Millisecond)
        led.Low()
        time.Sleep(500 * time.Millisecond)
    }
}
```

---

## Communication Protocol Details

No communication protocol — the PowerBread is a passive passthrough board with power regulation.

---

## Common Gotchas / Notes

1. **No official wiki** — Documentation is limited. Check the product page for updates.
2. **Passive board** — No firmware, libraries, or drivers needed.
3. **Power rails** — Ensure your breadboard circuits do not exceed the current capacity of the regulated rails.
4. **Orientation** — Ensure the XIAO is inserted in the correct orientation on the PowerBread socket.

---

## Reference Links

- **Product Page:** https://www.seeedstudio.com/XIAO-PowerBread-p-6318.html
