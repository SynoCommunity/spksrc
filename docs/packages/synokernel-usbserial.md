---
title: SynoKernel USB Serial
description: USB serial device drivers for Synology NAS
tags:
  - kernel
  - drivers
  - usb
  - serial
---

# SynoKernel USB Serial

Provides kernel modules for USB serial device support on Synology NAS devices.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | synokernel-usbserial |
| License | GPL |

## Included Drivers

| Module | Devices |
|--------|---------|  
| usbserial.ko | Base USB serial support |
| ch341.ko | CH340/CH341 USB-UART adapters |
| cp210x.ko | Silicon Labs CP210x adapters |
| pl2303.ko | Prolific PL2303 adapters |
| ftdi_sio.ko | FTDI USB-serial adapters |
| ti_usb3410_5052.ko | Texas Instruments USB serial |

## Installation

1. Install SynoKernel USB Serial from Package Center
2. Modules are loaded automatically
3. Connect your USB serial device

## Usage

### Verify Module Loading

```bash
lsmod | grep -E "usbserial|ch341|cp210x|pl2303|ftdi"
```

### Find Connected Devices

```bash
ls -la /dev/ttyUSB*
dmesg | grep ttyUSB
```

### Common Use Cases

**USB-to-Serial Adapters:**
- Arduino programming
- Serial console access
- Industrial equipment
- Smart home devices (Zigbee sticks, Z-Wave)

**Home Automation Integration:**

For [Home Assistant](homeassistant.md), USB serial devices appear at `/dev/ttyUSB0` (or similar).

## Troubleshooting

### Device Not Detected

1. Check kernel messages: `dmesg | tail -50`
2. Verify module is loaded: `lsmod | grep usbserial`
3. Try reloading modules after package install

### Permission Denied

Service accounts need access to `/dev/ttyUSB*` devices. Add appropriate udev rules or run services with elevated permissions.

## Related Packages

- SynoKernel CD-ROM - CD-ROM drivers
- [SynoCli Kernel Tools](synocli-kernel.md) - Kernel utilities
- [Home Assistant](homeassistant.md) - Uses serial devices
