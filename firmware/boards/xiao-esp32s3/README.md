# XIAO ESP32-S3 Meshtastic Configuration

Notes and configuration for the Seeed Studio XIAO ESP32-S3 running Meshtastic firmware.

## Hardware

- **Board**: Seeed Studio XIAO ESP32-S3
- **Function**: Meshtastic radio node with LoRa and WiFi/Bluetooth
- **Display**: Optional 0.96" OLED (SSD1306) via I2C
- **Antenna**: U.FL connector for LoRa (433/915MHz depending on variant)

## Pinout

| Pin | Function | Notes |
|-----|----------|-------|
| GPIO44 | USB DM | Native USB for flashing/programming |
| GPIO43 | USB DP | Native USB for flashing/programming |
| GPIO1  | UART TX | Serial debug |
| GPIO3  | UART RX | Serial debug |
| GPIO5  | I2C SDA | OLED display (if connected) |
| GPIO6  | I2C SCL | OLED display (if connected) |
| GPIO2  | LoRa IRQ | DIO0 interrupt |
| GPIO8  | LoRa CS  | SPI chip select |
| GPIO9  | LoRa RESET | Reset line |
| GPIO7  | LoRa CLK | SPI clock |
| GPIO6  | LoRa MISO | SPI data in |
| GPIO4  | LoRa MOSI | SPI data out |

## Meshtastic Firmware

### Install via Web Flasher

1. Navigate to [web.flasher.meshtastic.org](https://web.flasher.meshtastic.org/)
2. Select "Seeed Studio XIAO ESP32-S3" as target
3. Connect device via USB while holding BOOT button
4. Flash the latest stable firmware

### Install via CLI

```bash
# Install meshtastic python package
pip install meshtastic

# Flash firmware
meshtastic --firmware-version stable --port /dev/ttyACM0 --upload

# Or use esptool
esptool.py --chip esp32s3 --port /dev/ttyACM0 write_flash 0x0 firmware.bin
```

### Configuration

```bash
# Initial setup
meshtastic --port /dev/ttyUSB0 --set-owner "Cyberdeck Node"

# Set channel name
meshtastic --port /dev/ttyUSB0 --set channel.name "cyberdeck-mesh"

# Configure region (US=915, EU=433, CN=470, etc.)
meshtastic --port /dev/ttyUSB0 --set region US

# Enable GPS
meshtastic --port /dev/ttyUSB0 --set gps True

# Set display type (if using OLED)
meshtastic --port /dev/ttyUSB0 --set display-type ssd1306

# Set node name and short name
meshtastic --port /dev/ttyUSB0 --set owner "Cyberdeck-01" --set owner-short "CD1"
```

## USB Serial Connection to RPi

The XIAO ESP32-S3 connects to the Raspberry Pi Zero 2W via USB:

```
┌─────────────┐         USB         ┌─────────────┐
│  XIAO       │◄──────────────►│     RPi      │
│  ESP32-S3   │   /dev/ttyUSB0  │   Zero 2W   │
│  (Meshtastic)│               │             │
└─────────────┘                └─────────────┘
```

### Device Path

After connecting via USB, the device typically appears as:
- `/dev/ttyUSB0` - First USB serial device
- `/dev/serial/by-id/usb-Seeed_Studio_XIAO_ESP32S3_*-if00` - Stable path

### Meshtastic Python Library

```python
import meshtastic
import meshtastic.serial

# Connect to device
interface = meshtastic.serial.SerialInterface("/dev/ttyUSB0")

# Send message
interface.sendText("Hello mesh!")

# Get node info
nodes = interface.getNodes()
for node in nodes.values():
    print(f"Node: {node['shortName']} - SNR: {node['snr']}")

# Receive messages
def onReceive(packet):
    print(f"From: {packet['from']}, Msg: {packet['decoded']['text']}")

interface.setReceiveCallback(onReceive)

# Close
interface.close()
```

## Interfacing with Node.js

The Raspberry Pi uses `@meshtastic/js` library (see `firmware/boards/raspberry-pi-zero-2w/typescript/src/meshtastic.ts`):

```typescript
import { MeshtasticClient } from './meshtastic.js';

const client = new MeshtasticClient('/dev/ttyUSB0', logger);
await client.initialize();

client.onMessage((msg) => {
  console.log('Received:', msg.text);
});

await client.broadcast('Hello from cyberdeck!');
```

## I2C Protocol

The XIAO ESP32-S3 can also communicate with the host via I2C for low-power operation:

- **I2C Address**: 0x5C (configurable)
- **Registers**:
  - 0x00-0x0F: Node status and position
  - 0x10-0x1F: Message buffer
  - 0x20-0x2F: Configuration

## Power Management

The XIAO ESP32-S3 supports various power states:

- **Active**: Full operation, WiFi/BT available
- **Light Sleep**: Reduced power, LoRa still receive
- **Deep Sleep**: Minimal current (~10µA), only wake on LoRa

### Deep Sleep Configuration

```python
# Configure deep sleep (via Meshtastic)
meshtastic --port /dev/ttyUSB0 --set is_low_power True
meshtastic --port /dev/ttyUSB0 --set wake_on_motion 0
```

## LED Status

| State | LED Pattern |
|-------|-------------|
| Booting | Yellow flash |
| Connected to mesh | Green blink |
| Sending/Receiving | Blue flash |
| Error | Red blink |
| Low battery | Orange slow blink |

## Troubleshooting

### Device not detected

```bash
# Check USB
lsusb
dmesg | tail

# Check serial devices
ls -la /dev/ttyUSB*
ls -la /dev/serial/by-id/
```

### Permission denied

```bash
# Add user to dialout group
sudo usermod -a -G dialout $USER
# Log out and back in
```

### Flash failed

```bash
# Put device in bootloader mode:
# 1. Hold BOOT button
# 2. Press and release RESET button
# 3. Release BOOT button

# Then flash
esptool.py --chip esp32s3 --port /dev/ttyACM0 erase_flash
esptool.py --chip esp32s3 --port /dev/ttyACM0 write_flash 0x0 firmware.bin
```

## References

- [Meshtastic Documentation](https://meshtastic.org/)
- [Meshtastic Python CLI](https://meshtastic.org/docs/cli/)
- [XIAO ESP32-S3 Pinout](https://wiki.seeedstudio.com/XIAO_ESP32S3/)
- [@meshtastic/js](https://www.npmjs.com/package/@meshtastic/js)