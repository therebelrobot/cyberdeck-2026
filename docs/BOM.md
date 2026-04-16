# Bill of Materials — Cyberdeck 2026

Estimated total: **$140–230** (excluding enclosure)

---

## Compute & Power

| Component | Qty | Purpose | Est. Cost | Source/Notes |
|-----------|-----|---------|-----------|--------------|
| Raspberry Pi Zero 2 WH | 1 | Primary SBC — runs main OS, display, networking | ~$15 | Raspberry Pi Foundation |
| PiSugar 3 Plus (5000mAh) | 1 | Battery hat — attaches via pogo pins, I2C (0x57), up to 3A, USB-C charging | ~$40–50 | PiSugar |
| Adafruit CH334F Mini 4-Port USB Hub Breakout | 1 | Internal USB hub — upstream via ChenYang micro-USB adapter to Pi OTG | ~$10–15 | Adafruit |
| ChenYang right-angle micro-USB male/female adapter | 1 | OTG connection from Pi to USB hub | ~$3–5 | Amazon/eBay |
| Adafruit simple USB breakout cables | 2–3 | Hub downstream ports — keyboard, debug, cellular | ~$2–4 ea. | Adafruit |

---

## Display

| Component | Qty | Purpose | Est. Cost | Source/Notes |
|-----------|-----|---------|-----------|--------------|
| Waveshare 3.5" Capacitive Touch DPI IPS LCD (640×480, up to 60Hz) | 1 | Primary display — connects via 40-pin GPIO DPI666 interface, 5-point capacitive touch via I2C, consumes full GPIO header | ~$35–45 | Waveshare |
| Eanetf 90°/270° micro-HDMI adapter | 1 | Debug only — not in final enclosure | ~$5–8 | Amazon — bench only |

---

## Input — Rotary Encoder

| Component | Qty | Purpose | Est. Cost | Source/Notes |
|-----------|-----|---------|-----------|--------------|
| Adafruit ANO Directional Navigation + Scroll Wheel Encoder | 1 | iPod-style 5-directional buttons + rotary encoder, I2C (0x49) | ~$15–20 | Adafruit |
| ANO breakout PCB | 1 | Mechanical support + I2C wiring for ANO | ~$5 | Adafruit |
| Seeed XIAO SAMD21 | 1 | Dedicated HID bridge for ANO encoder — runs TinyGo | ~$4–6 | Seeed Studio |

---

## Input — Keyboard

| Component | Qty | Purpose | Est. Cost | Source/Notes |
|-----------|-----|---------|-----------|--------------|
| M5Stack CardKB V1.1 | 1 | Compact 50-key QWERTY keyboard, I2C (0x5F) — placeholder for eventual BBQ20 | ~$8–12 | M5Stack |

---

## Networking — Cellular

| Component | Qty | Purpose | Est. Cost | Source/Notes |
|-----------|-----|---------|-----------|--------------|
| USB LTE Dongle (SIM7600 series or equivalent) | 1 | Cellular connectivity — plugs into CH334F hub, standard network interface | ~$30–50 | Various |

---

## Networking — LoRa / Meshtastic

| Component | Qty | Purpose | Est. Cost | Source/Notes |
|-----------|-----|---------|-----------|--------------|
| Seeed XIAO ESP32-S3 | 1 | Dedicated Meshtastic node — runs Meshtastic firmware | ~$6–10 | Seeed Studio |
| WIO-SX1262 LoRa wing | 1 | LoRa module (433/868/915MHz), SPI interface — connects to XIAO ESP32-S3 | ~$20–30 | Seeed Studio / Wio Terminal |

---

## Enclosure (TBD)

| Component | Qty | Purpose | Est. Cost | Source/Notes |
|-----------|-----|---------|-----------|--------------|
| Thrifted container | 1 | Outer enclosure — not yet sourced | TBD | Thrift stores / salvage |
| Internal mounting panels/brackets | — | Laser-cut acrylic or 3D printed — Flashforge, conveyor belt printer, Ender 3 | TBD | Local makerspace / DIY |
| Panel-mounted USB-C port | 1 | PiSugar charging access from enclosure exterior | ~$5–10 | Amazon / electronics supplier |

---

## Wiring & Adapters Summary

| Component | Qty | Purpose | Est. Cost | Source/Notes |
|-----------|-----|---------|-----------|--------------|
| ChenYang right-angle micro-USB male/female adapter | 1 | OTG host connection | ~$3–5 | Amazon/eBay |
| Adafruit USB breakout cables (M/M, M/F) | 3 | Hub downstream, keyboard, spare | ~$6–12 | Adafruit |
| Jumper wires / ribbon cables | — | I2C/SPI/UART connections between boards | ~$5 | Amazon / local electronics |
| Micro-USB cable (USB-C to micro-USB) | 1 | PiSugar charging | ~$3–5 | Amazon |
| SPI header pins | 4–6 | WIO-SX1262 to XIAO ESP32-S3 | ~$1–2 | Amazon |

---

## Estimated Total by Category

| Category | Est. Cost |
|----------|-----------|
| Compute & Power | ~$65–84 |
| Display | ~$40–53 |
| Input — Rotary | ~$24–31 |
| Input — Keyboard | ~$8–12 |
| Networking — Cellular | ~$30–50 |
| Networking — LoRa | ~$26–40 |
| **Total (excluding enclosure)** | **~$140–230** |
