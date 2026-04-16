---
name: xiao-accessory-cobleddriver
description: >
  Provides comprehensive reference for using the COB LED Driver Board with Seeed Studio XIAO
  microcontrollers. Covers 7-channel LED control (3 high-power 300mA + 4 PWM 80mA), active LOW
  logic, battery management, and Grove I2C expansion. Includes Arduino and TinyGo setup, wiring,
  pin usage, and code examples. Use when building compact wireless lighting setups with COB LED
  strips on any XIAO board.
  Keywords: XIAO, COB, LED, driver, PWM, lighting, strip, brightness, dimming, active LOW,
  battery, PMIC, Grove, I2C, wireless, high-power.
---

# COB LED Driver Board — XIAO Accessory Guide

Provides comprehensive reference for using the COB LED Driver Board with Seeed Studio XIAO microcontrollers.

## When to Use

- Integrating the COB LED Driver Board for LED strip control
- Looking up which XIAO pins the LED driver occupies
- Writing Arduino or TinyGo firmware to control COB LED strips
- Configuring PWM dimming with active LOW logic
- Checking pin conflicts with other XIAO accessories

## When NOT to Use

- For standalone XIAO board pinouts → use the corresponding board skill
- For other XIAO accessories → use the corresponding accessory skill

---

## Accessory Overview

| Parameter | Value |
|---|---|
| **Type** | 7-channel COB LED driver dock |
| **LED Power Support** | DC 3V |
| **Power Input** | 5V USB (via XIAO) or 3.7V Li-Po Battery |
| **High-Power Ports** | 3 channels, max 300mA/channel, ON/OFF only |
| **Low-Power/PWM Ports** | 4 channels, max 80mA/channel, PWM dimmable |
| **Grove Connector** | I²C ×1 |
| **Power Switch** | ×1 |
| **Battery Connector** | ×1 (JST) |
| **Dimensions** | 30mm × 41mm × 16mm (with XIAO) |

### Compatible XIAO Boards

| Board | Status | Notes |
|-------|--------|-------|
| XIAO RP2040 | ✅ | Full support |
| XIAO RP2350 | ✅ | Full support |
| XIAO nRF52840 | ✅ | Full support |
| XIAO ESP32-C3 | ✅ | Full support |
| XIAO ESP32-C6 | ✅ | Full support |
| XIAO ESP32-S3 | ✅ | Full support |
| XIAO RA4M1 | ✅ | Full support |
| XIAO MG24 | ✅ | Full support |
| XIAO SAMD21 | ⚠️ | USB-C power only, no battery |
| XIAO nRF54L15 | ⚠️ | USB-C power only, no battery, no Arduino support |

---

## Pin Usage Diagram

```
XIAO Pin    | Accessory Function         | Protocol
------------|----------------------------|----------
D0          | High-Power Port            | GPIO (ON/OFF only, 300mA max)
D1          | High-Power Port            | GPIO (ON/OFF only, 300mA max)
D2          | Low-Power Port (PWM)       | GPIO/PWM (Active LOW, 80mA max)
D3          | Low-Power Port (PWM)       | GPIO/PWM (Active LOW, 80mA max)
D8          | Low-Power Port (PWM)       | GPIO/PWM (Active LOW, 80mA max)
D9          | Low-Power Port (PWM)       | GPIO/PWM (Active LOW, 80mA max)
SDA         | I²C Grove connector        | I2C
SCL         | I²C Grove connector        | I2C
VCC         | Always-On Port             | Power (300mA max, not switch-controlled)
```

---

## Pin Conflict Warning

### Pins OCCUPIED by COB LED Driver
- **D0** — High-Power Port
- **D1** — High-Power Port
- **D2** — Low-Power PWM Port
- **D3** — Low-Power PWM Port
- **D8** — Low-Power PWM Port
- **D9** — Low-Power PWM Port
- **SDA/SCL** — I²C Grove connector

### Pins remaining FREE
- D4 (if not using I2C Grove), D5 (if not using I2C Grove), D6, D7, D10, A0

### Conflicts with other accessories
- **ePaper Driver Board** — conflicts on D0, D1, D2, D3, D8 ❌
- **Expansion Board Base** — conflicts on D1 (button), D2 (SD CS), D3 (buzzer), D8 (SPI SCK), D9 (SPI MISO) ❌
- **RS485 Board** — conflicts on D2 (enable) ❌
- **CAN Bus Board** — conflicts on D8, D9 (SPI) ❌
- **Grove Vision AI V2** — can share I2C bus ✅ (uses SDA/SCL only)

> **Note:** This board uses 6 GPIO pins plus I2C. It is designed to be used as the primary accessory, not stacked with other GPIO-heavy boards.

---

## Power Requirements

| Parameter | Value |
|-----------|-------|
| Power Source | 5V USB via XIAO (5V/2A+ wall adapter recommended for full load) |
| Battery | 3.7V Li-Po via onboard JST connector |
| LED Voltage | DC 3V COB LED strips |

> ⚠️ **Do NOT use USB and battery simultaneously with peripherals connected.**

---

## Arduino Setup & Usage

### Required Libraries

None — direct GPIO control, no extra libraries needed.

### Initialization

```cpp
// High-Power Ports (D0, D1) — Active HIGH, ON/OFF only, 300mA max
// Low-Power Ports (D2, D3, D8, D9) — Active LOW, PWM capable, 80mA max

void setup() {
    // High-Power ports
    pinMode(D0, OUTPUT);
    pinMode(D1, OUTPUT);

    // Low-Power PWM ports
    pinMode(D2, OUTPUT);
    pinMode(D3, OUTPUT);
    pinMode(D8, OUTPUT);
    pinMode(D9, OUTPUT);
}
```

### Complete Working Example — High-Power Port Control

```cpp
// Control high-power LED ports (D0, D1)
// Active HIGH: HIGH = ON, LOW = OFF
// Max 300mA per channel, NO PWM support

void setup() {
    pinMode(D0, OUTPUT);
    pinMode(D1, OUTPUT);
}

void loop() {
    // Turn on both high-power channels
    digitalWrite(D0, HIGH);  // LED ON
    digitalWrite(D1, HIGH);  // LED ON
    delay(2000);

    // Turn off both high-power channels
    digitalWrite(D0, LOW);   // LED OFF
    digitalWrite(D1, LOW);   // LED OFF
    delay(1000);
}
```

### Complete Working Example — Low-Power PWM Dimming

```cpp
// Control low-power LED ports with PWM dimming
// Active LOW: LOW = full brightness, HIGH = OFF
// Max 80mA per channel

void setLedBrightness(int pin, int brightness) {
    brightness = constrain(brightness, 0, 255);
    int pwmValue = 255 - brightness;  // Active LOW inversion
    analogWrite(pin, pwmValue);
}

void setup() {
    pinMode(D2, OUTPUT);
    pinMode(D3, OUTPUT);
    pinMode(D8, OUTPUT);
    pinMode(D9, OUTPUT);
}

void loop() {
    // Breathing effect on D2
    for (int i = 0; i <= 255; i++) {
        setLedBrightness(D2, i);
        delay(5);
    }
    for (int i = 255; i >= 0; i--) {
        setLedBrightness(D2, i);
        delay(5);
    }
}
```

### Complete Working Example — All Channels

```cpp
void setLedBrightness(int pin, int brightness) {
    brightness = constrain(brightness, 0, 255);
    int pwmValue = 255 - brightness;  // Active LOW inversion
    analogWrite(pin, pwmValue);
}

void setup() {
    // High-Power ports (ON/OFF only)
    pinMode(D0, OUTPUT);
    pinMode(D1, OUTPUT);

    // Low-Power PWM ports
    pinMode(D2, OUTPUT);
    pinMode(D3, OUTPUT);
    pinMode(D8, OUTPUT);
    pinMode(D9, OUTPUT);

    // Turn on high-power channels
    digitalWrite(D0, HIGH);
    digitalWrite(D1, HIGH);
}

void loop() {
    // Cycle through PWM channels
    int pwmPins[] = {D2, D3, D8, D9};

    for (int ch = 0; ch < 4; ch++) {
        setLedBrightness(pwmPins[ch], 200);  // ~80% brightness
        delay(500);
        setLedBrightness(pwmPins[ch], 0);    // OFF
    }
}
```

---

## TinyGo Setup & Usage

No special drivers needed — direct GPIO/PWM control.

### TinyGo High-Power Port Example

```go
package main

import (
    "machine"
    "time"
)

func main() {
    // High-Power ports: Active HIGH, ON/OFF only
    d0 := machine.D0
    d1 := machine.D1
    d0.Configure(machine.PinConfig{Mode: machine.PinOutput})
    d1.Configure(machine.PinConfig{Mode: machine.PinOutput})

    for {
        d0.High() // LED ON
        d1.High() // LED ON
        time.Sleep(2 * time.Second)

        d0.Low()  // LED OFF
        d1.Low()  // LED OFF
        time.Sleep(1 * time.Second)
    }
}
```

### TinyGo PWM Dimming Example

```go
package main

import (
    "machine"
    "time"
)

func main() {
    // Low-Power ports: Active LOW, PWM capable
    // Configure PWM for D2
    pwm := machine.PWM0 // Adjust PWM peripheral for your XIAO board
    err := pwm.Configure(machine.PWMConfig{
        Period: 1e6, // 1ms period (1kHz)
    })
    if err != nil {
        println("PWM config error:", err.Error())
        return
    }

    ch, err := pwm.Channel(machine.D2)
    if err != nil {
        println("PWM channel error:", err.Error())
        return
    }

    // Breathing effect (Active LOW: 0 = full brightness, max = OFF)
    top := pwm.Top()
    for {
        // Fade in (decrease duty for active LOW)
        for i := uint32(0); i < top; i += top / 256 {
            pwm.Set(ch, top-i) // Invert for active LOW
            time.Sleep(5 * time.Millisecond)
        }
        // Fade out (increase duty for active LOW)
        for i := uint32(0); i < top; i += top / 256 {
            pwm.Set(ch, i) // Invert for active LOW
            time.Sleep(5 * time.Millisecond)
        }
    }
}
```

> **Note:** PWM peripheral assignment varies by XIAO board. Check the board-specific skill for correct PWM peripheral mappings.

---

## Communication Protocol Details

### GPIO Control

| Port Type | Logic | Control | Max Current |
|-----------|-------|---------|-------------|
| High-Power (D0, D1, VCC) | Active HIGH | ON/OFF only (no PWM) | 300mA |
| Low-Power (D2, D3, D8, D9) | **Active LOW** | PWM dimmable | 80mA |

### Active LOW Behavior (Low-Power Ports)

| Pin State | LED State |
|-----------|-----------|
| `LOW` / `0` | **ON** (full brightness) |
| `HIGH` / `255` | **OFF** |
| PWM duty cycle | Inverted brightness (255 - desired_brightness) |

### I2C (Grove Connector)

| Parameter | Value |
|-----------|-------|
| SDA | XIAO SDA pin |
| SCL | XIAO SCL pin |
| Purpose | Sensor expansion via Grove I2C |

---

## Common Gotchas / Notes

1. **⚠️ Hot-plugging is strictly prohibited!** Assemble XIAO and driver board first, then plug USB cable.
2. **⚠️ Do not connect peripherals during charging** — Disconnect LED strips before plugging USB-C for charging.
3. **⚠️ When debugging via USB-C, battery holder must be empty.**
4. **Active LOW on PWM ports** — Pull pin LOW to turn strip ON. This is the opposite of typical LED control. Use `255 - brightness` for PWM values.
5. **High-Power ports are ON/OFF only** — D0 and D1 do NOT support PWM dimming.
6. **VCC port is always on** — The VCC port (300mA) is not switch-controlled and cannot be turned off in software.
7. **Heat dissipation** — For full load currents >1A total, ensure heat dissipation holes in any housing.
8. **ESD risk** — Never touch the PMIC area on the back of the board (ESD risk, high temperature during operation).
9. **ESPHome support** — Also supports ESPHome for Home Assistant integration.

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/getting_started_with_cob_led_dirver_board/
- **Product Page:** https://www.seeedstudio.com/COB-LED-Driver-Board-for-Seeed-Studio-XIAO-p-6602.html
