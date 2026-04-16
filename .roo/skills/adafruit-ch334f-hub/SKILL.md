---
name: adafruit-ch334f-hub
description: >
  Provides comprehensive guide for the Adafruit CH334F Mini 4-Port USB Hub Breakout board.
  Covers hardware specifications (31.6×20.4×4.8mm), upstream connection via USB-C or micro-USB to Pi OTG,
  downstream pad configuration for 4 ports using Adafruit USB breakout cables, power handling from PiSugar,
  mounting options with 4 holes for laser-cut panel mounting, and LED status indicators.
  Use when integrating USB hub functionality into cyberdeck projects, connecting multiple USB peripherals,
  or managing USB power distribution. Keywords: CH334F, USB hub, USB-C, micro-USB, 4-port, Adafruit,
  USB 2.0, hub, power switching, status LED.
---

# Adafruit CH334F Mini 4-Port USB Hub — Integration Guide

Provides comprehensive reference for integrating the Adafruit CH334F Mini 4-Port USB Hub Breakout into embedded projects.

## When to Use

- Adding multiple USB ports to a Raspberry Pi Zero 2W (which has only one USB port)
- Connecting USB peripherals that must be simultaneously attached (keyboard, mouse, LTE, etc.)
- Managing USB power distribution for multiple devices
- Designing compact USB hub integration into custom enclosures
- Using USB-C or micro-USB upstream connection

## When NOT to Use

- For USB 3.0 SuperSpeed connections → CH334F is USB 2.0 only (480Mbps)
- For powered USB hubs with dedicated power supplies → use external supply instead
- For applications requiring USB OTG on the hub itself → hub is not OTG-capable
- For more than 4 downstream ports → use a different hub chip or cascaded hubs

---

## Hub Overview

| Parameter | Value |
|---|---|
| **Chip** | CH334F (WCH Jiangsu) |
| **USB Version** | USB 2.0 (High-Speed) |
| **Speed** | 480 Mbps |
| **Ports** | 4 downstream ports |
| **Upstream** | 1 upstream port |
| **Power** | 5V via VBUS from host |
| **Voltage Regulator** | None (passes through) |
| **Dimensions** | 31.6mm × 20.4mm × 4.8mm |
| **Mounting Holes** | 4 × M2 holes |

### Key Features

- **Self-powered operation** — Draws power from upstream host
- **Per-port power switching** — Individual port power control (CH334F feature)
- **LED indicators** — Per-port status LEDs
- **Compact size** — Fits in space-constrained projects
- **USB-C upstream** — Modern connector option
- **I2C interface** — None on CH334F (pure USB hub)

---

## Hardware Specifications

### Board Dimensions

```
     31.6mm
┌────────────────────────┐
│  ┌──┐           ┌──┐   │
│  │  │           │  │   │  ▲
│  └──┘           └──┘   │  │ 20.4mm
│                        │  │
│    CH334F              │  │
│    ┌────┐              │  │
│    │    │              │  │
│    └────┘              │  ▼
│                        │
│  ●  ●  ●  ●  ●  ●  ●  │  ← Downstream pads
│                        │
│    [USB-C]             │  ← Upstream connector
│                        │
└────────────────────────┘
         ▲
         │
     4.8mm thickness
```

### Mounting Hole Positions

| Hole | X Position | Y Position | Diameter |
|------|------------|------------|----------|
| 1 | 3.0mm | 3.0mm | M2 (2mm) |
| 2 | 28.6mm | 3.0mm | M2 (2mm) |
| 3 | 3.0mm | 17.4mm | M2 (2mm) |
| 4 | 28.6mm | 17.4mm | M2 (2mm) |

> **Design Note:** These 4 holes are suitable for laser-cut panel mounting or PCB standoffs.

---

## Pinout and Connections

### Upstream Connection Options

The CH334F breakout supports two upstream connection methods:

#### Option 1: USB-C Upstream

```
┌─────────────────────────────────────┐
│                                     │
│         [USB-C RECEPTACLE]          │
│              ───────                │
│            ┌──┴──┴──┐               │
│            │  USB-C  │               │
│            └─────────┘               │
│                                     │
└─────────────────────────────────────┘
```

| USB-C Pin | Function | Connection |
|-----------|----------|------------|
| A4/A9 | VBUS (5V) | Connect to host 5V |
| A1/A12 | D+ | Connect to host D+ |
| A2/A11 | D- | Connect to host D- |
| GND | Ground | Connect to host GND |

#### Option 2: Micro-USB Upstream

If using micro-USB instead:

```
┌─────────────────────────────────────┐
│                                     │
│         [Micro-USB RECEPTACLE]       │
│              ───────                │
│            ┌──┴──┴──┐               │
│            │ micro │               │
│            └─────────┘               │
│                                     │
└─────────────────────────────────────┘
```

| Micro-USB Pin | Function | Connection |
|---------------|----------|------------|
| 1 | VBUS (5V) | Connect to host 5V |
| 2 | D- | Connect to host D- |
| 3 | D+ | Connect to host D+ |
| 4 | ID (NC) | Not connected |
| 5 | GND | Connect to host GND |

#### Option 3: Direct Solder Pads

For compact integration, solder directly to the upstream pads:

```
┌─────────────────────────────────────┐
│                                     │
│    [UPSTREAM PADS]                  │
│     VBUS  D-  D+  GND               │
│                                     │
└─────────────────────────────────────┘
```

---

### Downstream Port Connections

The 4 downstream ports are exposed as solder pads:

```
┌─────────────────────────────────────┐
│                                     │
│   ┌───┐ ┌───┐ ┌───┐ ┌───┐         │
│   │ 1 │ │ 2 │ │ 3 │ │ 4 │         │
│   └───┘ └───┘ └───┘ └───┘         │
│                                     │
│   DS1  DS2  DS3  DS4               │
│                                     │
└─────────────────────────────────────┘
```

Each downstream port has 4 pads:

| Pad | Function | Description |
|-----|----------|-------------|
| VBUS | 5V Power | Power to downstream device |
| D- | USB D- | USB differential data (negative) |
| D+ | USB D+ | USB differential data (positive) |
| GND | Ground | Common ground |

### LED Status Indicators

The CH334F typically includes per-port LEDs:

| LED | State | Meaning |
|-----|-------|---------|
| Port LED (green) | ON | Device connected and enumerated |
| Port LED (green) | BLINK | Data activity |
| Port LED (green) | OFF | No device connected |
| Power LED (red) | ON | Upstream power present |

> **Note:** LED configuration may vary by specific Adafruit breakout revision. Check your board's silkscreen.

---

## Power Handling

### Power from PiSugar

For cyberdeck projects, the CH334F draws power from the PiSugar 3 via USB:

```
┌─────────────┐     USB      ┌─────────────────┐
│  PiSugar 3  │──────────────│  CH334F Hub     │
│  (Battery)  │   5V @ ~1A   │  (Upstream)     │
└─────────────┘              └─────────────────┘
                                    │
                                    │ Power distribution
                    ┌───────────────┼───────────────┬───────────────┐
                    ▼               ▼               ▼               ▼
               ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐
               │ Port 1  │    │ Port 2  │    │ Port 3  │    │ Port 4  │
               │ LTE     │    │ CardKB  │    │ Reserved│    │ Meshtastic│
               └─────────┘    └─────────┘    └─────────┘    └─────────┘
```

### Power Budget

| Device | Typical Current | Notes |
|--------|----------------|-------|
| Pi Zero 2W | 500mA (normal), 1000mA (peak) | Main system |
| CH334F Hub | ~50mA | Hub controller |
| LTE Modem | 200mA (idle), 500mA (tx burst) | Cellular |
| CardKB | ~20mA | Keyboard |
| Wio-SX1262 | ~120mA (tx) | LoRa |
| **Total** | ~1-2A | Combined system |

### Power Recommendations

1. **Use quality USB cables** with adequate gauge (22-24AWG for 5V)
2. **Add bulk capacitance** near hub (100µF + 100nF)
3. **Consider separate power domains** if any device exceeds 500mA
4. **Monitor voltage drop** under load (target >4.8V at hub)

---

## Wiring to Raspberry Pi Zero 2W

### Upstream Connection

For connection to Pi Zero 2W OTG port:

```
┌─────────────────┐         USB-C/         ┌─────────────────┐
│                 │         Micro-USB      │                 │
│   Raspberry     │─────────────────────────│   CH334F Hub    │
│   Pi Zero 2W    │                         │                 │
│   (OTG port)    │         (Upstream)     │                 │
│                 │                         │                 │
└─────────────────┘                         └─────────────────┘
```

### Cable Options

| Cable Type | Adapter Needed | Notes |
|------------|----------------|-------|
| USB-C to USB-C | None | If hub has USB-C upstream |
| USB-C to Micro-USB | OTG adapter | If hub has micro-USB upstream |
| Direct solder | Custom cable | Most compact, requires soldering |

### USB OTG Configuration

Ensure the Pi Zero 2W is configured for USB OTG gadget mode:

```bash
# In /boot/config.txt
dtoverlay=dwc2,dr_mode=peripheral

# Ensure dr_mode is set correctly
cat /sys/kernel/debug/usb/ci_hdrc.0/role  # Should show "peripheral"
```

---

## Adafruit USB Breakout Cables

For connecting downstream devices, Adafruit provides USB breakout boards:

### Adafruit USB Type A Breakout Board

| Product | Description |
|---------|-------------|
| [ID: 1827](https://www.adafruit.com/product/1827) | USB Type A socket with breadboard-friendly pins |

### Pinout for USB Breakout

```
┌──────────────────────┐
│   USB Type A Socket  │
│                      │
│   ┌────────────────┐ │
│   │ 1 2 3 4       │ │
│   └────────────────┘ │
│                      │
└──────────────────────┘
        │
        ▼
   ┌────┴────┐
   │ VBUS   │ ─── Yellow/Red
   │ D-     │ ─── White
   │ D+     │ ─── Green
   │ GND    │ ─── Black
   └─────────┘
```

### Soldering to CH334F Downstream Pads

Wire colors typically follow USB standard:

| Wire Color | Function | CH334F Pad |
|------------|----------|------------|
| Red | VBUS (5V) | VBUS |
| White | D- | D- |
| Green | D+ | D+ |
| Black | GND | GND |

> **⚠️ Polarity Matters:** Ensure correct orientation. Reversed VBUS/GND can damage devices.

---

## Mechanical Mounting

### Laser-Cut Panel Mounting

The 4 × M2 mounting holes allow integration into laser-cut panels:

```
┌──────────────────────────────────────────┐
│          Laser-Cut Panel                 │
│                                          │
│         ┌─────────────────┐              │
│         │                 │              │
│         │   ┌─────────┐   │              │
│         │   │ CH334F  │   │              │
│         │   │  Hub    │   │              │
│         │   └─────────┘   │              │
│         │                 │              │
│         └─────────────────┘              │
│                                          │
│  M2 screws go through panel into hub     │
│                                          │
└──────────────────────────────────────────┘
```

### Standoff Height Recommendation

| Component | Recommended Height |
|-----------|-------------------|
| M2 standoff | 5-8mm |
| Total panel thickness | 2-3mm |
| Hub PCB | 1.6mm |

### Panel Cutout

For USB-C upstream:
```
┌──────────────────────────────────────┐
│          Panel Cutout                │
│                                      │
│      ┌──────────────────┐           │
│      │                  │           │
│      │   USB-C Opening  │           │
│      │   (12mm × 6mm)  │           │
│      │                  │           │
│      └──────────────────┘           │
│                                      │
└──────────────────────────────────────┘
```

---

## Enclosure Integration

### Recommended Enclosure Design

1. **Separate compartments** for hub and cables
2. **USB-C passthrough** for upstream connection
3. **4 × USB-A ports** or breakouts for downstream
4. **Ventilation** for heat dissipation
5. **Access panel** for maintenance

### Cable Management

- Use short, rigid USB cables for permanent connections
- Consider right-angle connectors for tight spaces
- Add strain relief to prevent cable pull-out

---

## I2C Interface Notes

> **⚠️ No I2C on CH334F**
>
> The CH334F does **not** have an I2C configuration interface. It is a pure USB hub with no programmability.

### Alternative Hubs with I2C

If I2C configurability is required:

| Chip | Manufacturer | I2C |
|------|-------------|-----|
| USB2514B | Microchip | Yes (I2C) |
| USB2512 | Microchip | Yes (I2C) |
| GL850G | Genesys | No |

### Power Monitoring

For power monitoring without I2C hub control:
- Use INA219/INA3221 on power rails
- Monitor via Pi Zero 2W ADC or I2C

---

## Status LED Reference

### Typical LED Behavior

| Condition | LED State | Color |
|-----------|-----------|-------|
| No upstream power | All LEDs off | - |
| Upstream connected, no devices | Power LED on | Red/Green |
| Device connected to Port 1 | Port 1 LED on | Green |
| Device connected to Port 2 | Port 2 LED on | Green |
| Device connected to Port 3 | Port 3 LED on | Green |
| Device connected to Port 4 | Port 4 LED on | Green |
| Data transfer | LED blinks | Green |

> **Note:** LED behavior may vary by board revision. Check Adafruit product page for your specific breakout.

---

## Troubleshooting

### Issue: Hub Not Enumerating

**Diagnosis:**
```bash
# Check USB devices
lsusb
lsusb -t  # Tree view

# Check kernel messages
dmesg | grep -i usb
dmesg | grep -i hub
```

**Solutions:**
1. Verify USB cable is data-capable (not charge-only)
2. Check upstream connection is secure
3. Try different USB cable
4. Verify Pi OTG mode is configured

### Issue: Devices Not Recognized

**Diagnosis:**
```bash
# Check device recognition
dmesg | tail -50

# Test each port individually
lsusb -d 0000:0000  # Hub itself
```

**Solutions:**
1. Test each downstream port separately
2. Check device compatibility (USB 2.0 vs 3.0)
3. Verify power is reaching downstream devices
4. Try powered USB hub externally if devices need more power

### Issue: Intermittent Connection

**Diagnosis:**
```bash
# Check for undervoltage
vcgencmd pmu_show_adc

# Monitor power events
dmesg | grep -i undervolt
```

**Solutions:**
1. Check power supply capability
2. Use thicker power cables
3. Add capacitance at hub power input
4. Reduce number of high-power devices

### Issue: Hub Gets Hot

**Normal:** Hub chip may be warm to touch (40-50°C)
**Concerning:** Too hot to touch (>60°C)

**Solutions:**
1. Ensure adequate ventilation
2. Reduce power load
3. Check for short circuits
4. Add small heatsink if persistent

---

## References

- [Adafruit CH334F Product Page](https://www.adafruit.com/product/)
- [WCH CH334F Datasheet](http://www.wch-ic.com/downloads/CH334DS1_PDF.html)
- [USB 2.0 Specification](https://www.usb.org/document-library/usb-20-specification)
- [Adafruit USB Breakout Guide](https://learn.adafruit.com/usb-additions)
