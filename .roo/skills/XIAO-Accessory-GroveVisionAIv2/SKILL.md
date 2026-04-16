---
name: xiao-accessory-grovevisionaiv2
description: >
  Provides comprehensive reference for using the Grove Vision AI Module V2 with Seeed Studio XIAO
  microcontrollers. Covers WiseEye2 HX6538 processor (dual Cortex-M55 + Ethos-U55 NPU), I2C
  communication via Grove cable, CSI camera interface, SenseCraft AI platform, YOLOv5/v8 and
  MobileNet model deployment, and Seeed_Arduino_SSCMA library usage. Includes Arduino and TinyGo
  setup, wiring, pin usage, and code examples. Use when integrating AI vision capabilities such
  as object detection, image classification, or person detection on any XIAO board.
  Keywords: XIAO, Grove, Vision AI, V2, AI, ML, machine learning, object detection, YOLO, YOLOv5,
  YOLOv8, MobileNet, camera, NPU, Ethos-U55, Cortex-M55, WiseEye2, SenseCraft, SSCMA, I2C,
  inference, image classification, person detection.
---

# Grove Vision AI Module V2 — XIAO Accessory Guide

Provides comprehensive reference for using the Grove Vision AI Module V2 with Seeed Studio XIAO microcontrollers.

## When to Use

- Integrating the Grove Vision AI V2 for AI-powered vision applications
- Looking up which XIAO pins the Vision AI module occupies
- Writing Arduino or TinyGo firmware to receive inference results via I2C
- Deploying ML models (YOLOv5/v8, MobileNet) to the Vision AI module
- Checking pin conflicts with other XIAO accessories

## When NOT to Use

- For standalone XIAO board pinouts → use the corresponding board skill
- For other XIAO accessories → use the corresponding accessory skill
- For on-board XIAO AI processing (e.g., ESP32-S3 TensorFlow Lite) → this is a separate AI module

---

## Accessory Overview

| Parameter | Value |
|---|---|
| **Type** | Standalone AI vision module (MCU-based) |
| **Processor** | WiseEye2 HX6538 |
| **CPU** | Dual-core Arm Cortex-M55 |
| **NPU** | Arm Ethos-U55 |
| **Camera Interface** | CSI (22-pin FPC) |
| **Supported Cameras** | OV5647 series (62°, 67°, 160° FOV) |
| **Microphone** | PDM digital microphone (onboard) |
| **Storage** | SD card slot |
| **USB** | Type-C (for flashing/SenseCraft) |
| **Grove Interface** | I2C (4-pin) |
| **USB-Serial Chip** | CH343 |
| **AI Frameworks** | TensorFlow, PyTorch |
| **Supported Models** | MobileNet V1/V2, EfficientNet-lite, YOLOv5, YOLOv8 |

### Compatible XIAO Boards

| Board | Status | Notes |
|-------|--------|-------|
| All XIAO boards | ✅ | Via Grove I2C connector |
| XIAO ESP32 series | ✅ | Best for wireless features |

> Also compatible with Arduino boards, Raspberry Pi, and ESP dev boards via I2C.

---

## Pin Usage Diagram

```
XIAO Pin    | Accessory Function       | Protocol
------------|--------------------------|----------
SDA (D4)    | I2C Data                 | I2C (Grove 4-pin cable)
SCL (D5)    | I2C Clock                | I2C (Grove 4-pin cable)
3V3         | Power                    | Power
GND         | Ground                   | Power
```

> **Note:** The Grove Vision AI V2 connects via a Grove 4-pin cable — it does NOT plug directly onto the XIAO. It is a standalone module with its own MCU.

---

## Pin Conflict Warning

### Pins OCCUPIED by Grove Vision AI V2
- **SDA (D4)** — I2C Data
- **SCL (D5)** — I2C Clock

### Pins remaining FREE
- D0, D1, D2, D3, D6, D7, D8, D9, D10, A0, TX, RX

### Conflicts with other accessories
- **Expansion Board Base** — can share I2C bus ✅ (different I2C addresses)
- **COB LED Driver** — can share I2C bus ✅ (Grove I2C connector)
- **RS485 Board** — conflicts on D4/D5 if RS485 uses these as UART ❌
- **CAN Bus Board** — no conflict ✅ (uses D7/D8/D9/D10)
- **ePaper Driver Board** — no conflict ✅ (uses D0/D1/D2/D3/D8/D10)

> **Note:** I2C is a shared bus. The Vision AI V2 can coexist with other I2C devices as long as there are no address conflicts.

---

## Power Requirements

| Parameter | Value |
|-----------|-------|
| Power Source (via XIAO) | 3.3V via Grove connector |
| Power Source (standalone) | 5V via USB-C |

---

## Arduino Setup & Usage

### Required Libraries

```bash
# Seeed_Arduino_SSCMA library:
# https://github.com/Seeed-Studio/Seeed_Arduino_SSCMA
#
# Install via Arduino Library Manager: search "Seeed_Arduino_SSCMA"
# Or download ZIP from GitHub and install manually

# CH343 USB Driver (for direct USB connection to Vision AI V2):
# Windows: https://files.seeedstudio.com/wiki/grove-vision-ai-v2/res/CH343SER.EXE
# macOS: https://files.seeedstudio.com/wiki/grove-vision-ai-v2/res/CH341SER_MAC.ZIP
```

### Initialization

```cpp
#include <Seeed_Arduino_SSCMA.h>
#include <Wire.h>

SSCMA AI;

void setup() {
    Serial.begin(115200);
    Wire.begin();

    // Initialize the AI module via I2C
    AI.begin();

    Serial.println("Grove Vision AI V2 initialized");
}
```

### Complete Working Example — Object Detection

```cpp
#include <Seeed_Arduino_SSCMA.h>
#include <Wire.h>

SSCMA AI;

void setup() {
    Serial.begin(115200);
    while (!Serial) delay(100);

    Wire.begin();
    AI.begin();

    Serial.println("Grove Vision AI V2 — Object Detection");
    Serial.println("Waiting for inference results...");
}

void loop() {
    // Request inference from the AI module
    if (!AI.invoke()) {
        // Process detected objects
        Serial.print("Detections: ");
        Serial.println(AI.boxes().size());

        for (int i = 0; i < AI.boxes().size(); i++) {
            Serial.print("  Object ");
            Serial.print(i);
            Serial.print(": score=");
            Serial.print(AI.boxes()[i].score);
            Serial.print(" target=");
            Serial.print(AI.boxes()[i].target);
            Serial.print(" x=");
            Serial.print(AI.boxes()[i].x);
            Serial.print(" y=");
            Serial.print(AI.boxes()[i].y);
            Serial.print(" w=");
            Serial.print(AI.boxes()[i].w);
            Serial.print(" h=");
            Serial.println(AI.boxes()[i].h);
        }
    }

    delay(100);
}
```

### Complete Working Example — Image Classification

```cpp
#include <Seeed_Arduino_SSCMA.h>
#include <Wire.h>

SSCMA AI;

void setup() {
    Serial.begin(115200);
    while (!Serial) delay(100);

    Wire.begin();
    AI.begin();

    Serial.println("Grove Vision AI V2 — Classification");
}

void loop() {
    if (!AI.invoke()) {
        for (int i = 0; i < AI.classes().size(); i++) {
            Serial.print("Class ");
            Serial.print(AI.classes()[i].target);
            Serial.print(": score=");
            Serial.println(AI.classes()[i].score);
        }
    }

    delay(500);
}
```

### SenseCraft AI (No-Code Deployment)

1. Connect Grove Vision AI V2 to computer via USB-C
2. Open [SenseCraft AI](https://sensecraft.seeed.cc/) in Chrome or Edge
3. Select a pre-trained model (e.g., person detection, gesture recognition)
4. Click "Deploy" to flash the model to the module
5. View inference results in the browser

### Bootloader Recovery (via I2C)

If the module becomes unresponsive:
1. Connect Grove Vision AI V2 to any Arduino board via I2C
2. Install Seeed_Arduino_SSCMA library
3. Open: File → Examples → Seeed_Arduino_SSCMA → `we2_iic_bootloader_recover`
4. Upload and follow serial monitor instructions

---

## TinyGo Setup & Usage

### TinyGo I2C Communication

The Seeed_Arduino_SSCMA library is Arduino-only. For TinyGo, communicate with the Vision AI V2 directly via I2C:

```go
package main

import (
    "machine"
    "time"
    "fmt"
)

const visionAIAddr = 0x62 // Default I2C address (verify from SSCMA docs)

func main() {
    i2c := machine.I2C0
    i2c.Configure(machine.I2CConfig{
        SDA:       machine.SDA_PIN,
        SCL:       machine.SCL_PIN,
        Frequency: 400000,
    })

    println("Grove Vision AI V2 — TinyGo I2C")

    buf := make([]byte, 64)
    for {
        // Read inference results from the AI module
        // The exact I2C protocol depends on the SSCMA firmware version
        err := i2c.Tx(uint16(visionAIAddr), []byte{0x00}, buf)
        if err != nil {
            fmt.Printf("I2C error: %s\n", err.Error())
        } else {
            // Parse response according to SSCMA protocol
            // See: https://github.com/Seeed-Studio/Seeed_Arduino_SSCMA
            fmt.Printf("Raw data: %v\n", buf[:16])
        }

        time.Sleep(500 * time.Millisecond)
    }
}
```

> **Note:** TinyGo support is limited. The SSCMA I2C protocol is complex — refer to the [Seeed_Arduino_SSCMA source code](https://github.com/Seeed-Studio/Seeed_Arduino_SSCMA) for the I2C command/response format. Arduino is the recommended platform for this module.

---

## Communication Protocol Details

### I2C Configuration (XIAO ↔ Vision AI V2)

| Parameter | Value |
|-----------|-------|
| SDA Pin | D4 (XIAO SDA) |
| SCL Pin | D5 (XIAO SCL) |
| Speed | Up to 400kHz |
| Connection | Grove 4-pin cable |
| Protocol | SSCMA I2C protocol |

### Vision AI V2 Onboard Interfaces

| Interface | Purpose |
|-----------|---------|
| CSI (22-pin FPC) | Camera connection |
| USB-C | Firmware flashing, SenseCraft AI |
| SD card slot | Model storage |
| PDM microphone | Audio input |
| Grove I2C | Communication with host MCU |

### Model Deployment Flow

```
1. Train model (TensorFlow/PyTorch) or use pre-trained
2. Convert to TFLite/ONNX format
3. Deploy via SenseCraft AI (USB-C) or custom firmware
4. Vision AI V2 runs inference on-device
5. Results sent to XIAO via I2C (SSCMA protocol)
```

---

## Common Gotchas / Notes

1. **⚠️ This is a standalone AI module with its own MCU** — It is NOT just an expansion board. It has its own processor (WiseEye2 HX6538) and runs inference independently.
2. **⚠️ Camera NOT included** — Recommend OV5647-62 FOV Camera Module for Raspberry Pi (compatible with CSI connector).
3. **⚠️ Cannot simultaneously output live video AND send inference results to XIAO** — Choose one mode at a time.
4. **Boot mode** — Hold BOOT button while connecting USB-C, then release, to enter bootloader mode for firmware flashing.
5. **Reset** — Press the Reset button to restart the device.
6. **CH343 driver required** — Install the CH343 USB driver for direct USB connection to the Vision AI V2 module.
7. **Linux udev rules** — Linux users need udev rules for USB access to the module.
8. **I2C bus sharing** — The Vision AI V2 can share the I2C bus with other devices (OLED, RTC, sensors) as long as addresses don't conflict.
9. **Home Assistant** — Supports Home Assistant integration for smart home vision applications.
10. **Open source** — Fully open source (codes, design files, schematics). SDK: https://github.com/HimaxWiseEyePlus/Seeed_Grove_Vision_AI_Module_V2

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/grove_vision_ai_v2/
- **Product Page:** https://www.seeedstudio.com/Grove-Vision-AI-Module-V2-p-5851.html
- **Seeed_Arduino_SSCMA Library:** https://github.com/Seeed-Studio/Seeed_Arduino_SSCMA
- **SenseCraft AI Platform:** https://sensecraft.seeed.cc/
- **SDK:** https://github.com/HimaxWiseEyePlus/Seeed_Grove_Vision_AI_Module_V2
- **3D Model (STP):** https://files.seeedstudio.com/wiki/grove-vision-ai-v2/grove_vision_ai_v2_kit_case.stp
- **CH343 Driver (Windows):** https://files.seeedstudio.com/wiki/grove-vision-ai-v2/res/CH343SER.EXE
- **CH343 Driver (macOS):** https://files.seeedstudio.com/wiki/grove-vision-ai-v2/res/CH341SER_MAC.ZIP
