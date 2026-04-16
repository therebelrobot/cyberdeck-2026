---
name: meshtastic-integration
description: >
  Provides comprehensive reference for integrating Meshtastic mesh networking with embedded
  systems and single-board computers. Covers Meshtastic protocol, @meshtastic/js integration,
  serial communication with Meshtastic devices, message handling, and node management.
  Use when working with Meshtastic radio firmware on XIAO ESP32-S3, configuring mesh
  networking, sending/receiving messages via LoRa radio, or integrating Meshtastic with
  host systems. Keywords: Meshtastic, mesh networking, LoRa, @meshtastic/js, serialport,
  XIAO ESP32-S3, radio, mesh node, emergency communication, off-grid.
---

# Meshtastic Integration Guide

Comprehensive guide for integrating Meshtastic mesh networking with embedded systems and host computers.

## When to Use

- Integrating Meshtastic devices with host systems (Raspberry Pi, etc.)
- Writing code to send/receive mesh messages using @meshtastic/js
- Configuring XIAO ESP32-S3 running Meshtastic firmware
- Setting up serial communication with Meshtastic radios
- Building applications that use mesh networking for emergency/off-grid communication
- Managing Meshtastic node configuration programmatically

## When NOT to Use

- For general LoRa radio configuration without Meshtastic → refer to LoRa module documentation
- For Arduino/TinyGo firmware development → use corresponding MCU skills
- For Meshtastic device flashing → use web.flasher.meshtastic.org or meshtastic CLI
- For hardware design → use PCB design skills

---

## Overview

Meshtastic is an open-source, GPS-enabled mesh networking platform that runs on affordable LoRa radios. The system consists of:

| Component | Role |
|-----------|------|
| **Meshtastic Device** | XIAO ESP32-S3 or similar running Meshtastic firmware |
| **LoRa Radio** | SX1262-based module for long-range mesh communication |
| **Host System** | Raspberry Pi or other SBC that queries/configures the device |
| **Mesh Network** | Peer-to-peer network of all Meshtastic nodes in range |

### Architecture

```
                    Internet (optional)
                         ▲
                         │ (via WiFi/Bluetooth)
                    ┌────┴─────┐
                    │ XIAO     │
                    │ ESP32-S3 │
                    │(Meshtastic)│
                    └────┬─────┘
                         │ LoRa
                    ┌────┴─────┐
                    │ Another  │
                    │ Mesh Node│
                    └──────────┘
```

---

## Meshtastic Protocol

Meshtastic uses Protocol Buffers (protobuf) over serial (or BLE/WiFi). The protocol defines:

- **Device-to-Device**: Node-to-node communication via LoRa
- **Device-to-Host**: Serial/BLE/WiFi interface for configuration and messaging

### Serial Protocol

The device communicates over USB serial at 115200 baud using JSON or protobuf.

**JSON Format (simpler, used for debugging):**
```json
{
  "from": 1234567890,
  "to": 4294967295,
  "channel": 0,
  "decoded": {
    "portnum": 1,
    "text": "Hello mesh"
  },
  "rxRssi": -42,
  "rxSnr": 8.5
}
```

### Message Types (Port Numbers)

| Port | Application |
|------|-------------|
| 0 | Unknown |
| 1 | TEXT_MESSAGE_APP |
| 2 | WAYPOINT_APP |
| 3 | NODEINFO_APP |
| 4 | POSITION_APP |
| 5 | INFO_APP |

---

## Node.js/JavaScript Integration

### Install Dependencies

```bash
npm install @meshtastic/js serialport
```

### Connect to Device

```typescript
import { SerialConnection } from '@meshtastic/meshtasticjs';
import { SerialPort } from 'serialport';

async function connect(): Promise<void> {
  const port = new SerialPort({
    path: '/dev/ttyUSB0',
    baudRate: 115200,
  });
  
  const connection = new SerialConnection(port);
  
  connection.on('message', (packet) => {
    console.log('Received:', packet);
  });
  
  // Connect and wait for acknowledgment
  await connection.connect();
  console.log('Connected to Meshtastic device');
}
```

### Send Text Message

```typescript
import { TextPacket } from '@meshtastic/meshtasticjs';

async function sendMessage(connection: SerialConnection, text: string): Promise<void> {
  const packet = new TextPacket({
    to: 0xffffffff,  // Broadcast
    text: text,
  });
  
  await connection.send(packet);
  console.log('Message sent:', text);
}
```

### Receive Messages

```typescript
connection.on('text', (packet: TextPacket) => {
  console.log(`From: ${packet.from}, Message: ${packet.text}`);
});
```

---

## Python Integration

### Install

```bash
pip install meshtastic
```

### Connect and Send

```python
import meshtastic
import meshtastic.serial

# Connect to device
interface = meshtastic.serial.SerialInterface("/dev/ttyUSB0")

# Send message
interface.sendText("Hello from cyberdeck!")

# Receive messages
def on_receive(packet):
    print(f"From: {packet['from']}, Msg: {packet['decoded']['text']}")

interface.setReceiveCallback(on_receive)

# Keep running
while True:
    time.sleep(1)
```

### Get Node Information

```python
# Get all visible nodes
nodes = interface.getNodes()
for node_id, node in nodes.items():
    print(f"Node: {node.get('shortName', 'Unknown')}")
    print(f"  SNR: {node.get('snr', 'N/A')}")
    print(f"  Distance: {node.get('distance', 'N/A')}m")
```

---

## Configuration

### Common Settings

```bash
# Set node name
meshtastic --port /dev/ttyUSB0 --set owner "Cyberdeck-01"

# Set region (US=915MHz, EU=433MHz, CN=470MHz)
meshtastic --port /dev/ttyUSB0 --set region US

# Enable GPS
meshtastic --port /dev/ttyUSB0 --set gps True

# Set display type
meshtastic --port /dev/ttyUSB0 --set display-type ssd1306

# Set LoRa channel (Hz)
meshtastic --port /dev/ttyUSB0 --set ch-set 903.0
```

### Device Paths

| OS | Path |
|----|------|
| Linux | `/dev/ttyUSB0`, `/dev/serial/by-id/*` |
| macOS | `/dev/cu.usbserial-*` |
| Windows | `COM3` |

**Using stable symlink:**
```bash
# Find device ID
ls -la /dev/serial/by-id/

# Use stable path
meshtastic --port /dev/serial/by-id/usb-Meshtastic_Meshtastic_12345678-if00
```

---

## Error Handling

### Device Not Detected

```bash
# Check USB permissions
ls -la /dev/ttyUSB*
dmesg | tail

# Add user to dialout group
sudo usermod -a -G dialout $USER
# Log out and back in
```

### Connection Timeout

- Verify device is running Meshtastic firmware
- Check USB cable supports data (not just power)
- Try different USB port
- Press RESET button on device

### Permission Denied

```bash
# Temporarily use sudo
sudo meshtastic --port /dev/ttyUSB0 --info

# Or fix permissions permanently
sudo chmod 666 /dev/ttyUSB0
```

---

## Use Cases for Cyberdeck

### Emergency Communication

When cellular/LTE is unavailable, the mesh network provides peer-to-peer communication:

```typescript
// Check if mesh has connectivity
const nodes = meshtasticClient.getNodes();
if (nodes.length > 0) {
  // Mesh is active, can relay messages
  meshtasticClient.broadcast("Emergency: Need assistance");
}
```

### Data Collection

Sensors connected to mesh nodes can report data:

```python
# Each node can send sensor readings
interface.sendText(f"Sensor data: temp=22.5, humidity=65%")
```

### Message Relay

Messages can hop through multiple nodes, extending range:

```
Node A ←→ Node B ←→ Node C (internet gateway)
```

---

## See Also

- [@meshtastic/js](https://.npmjs.com/package/@meshtastic/js)
- [Meshtastic Python CLI](https://meshtastic.org/docs/cli/)
- [Meshtastic Web Flasher](https://web.flasher.meshtastic.org/)
- [XIAO ESP32-S3 Skill](../XIAO-ESP32S3-Arduino/SKILL.md)