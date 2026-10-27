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

The USB serial core (`usbserial`), `cdc-acm` for ACM devices (modems, Arduino,
Z-Wave sticks), and every USB serial adapter driver the kernel of the NAS
offers: the list grows with the kernel, `f81534` and `upd78f0730` coming with
5.10 for instance. Among them:

| Module | Devices |
|--------|---------|
| `ch341` | WinChipHead CH340/CH341 adapters |
| `cp210x` | Silicon Labs CP210x adapters (many Zigbee sticks) |
| `ftdi_sio` | FTDI adapters |
| `pl2303` | Prolific PL2303 adapters |
| `option`, `qcserial`, `sierra` | 3G/4G USB modems |
| `ti_usb_3410_5052` | Texas Instruments TUSB3410/5052 adapters |
| `mos7720`, `mos7840`, `f81534` | multi-port adapters |

Some drivers need a firmware file the package does not provide (`keyspan`,
`io_edgeport`, `whiteheat`).

## Usage

The modules are not loaded on installation: load those of your adapter, as
root, with the `synocli-kernelmodule` helper of
[SynoCli Kernel Tools](synocli-kernel.md). Each driver has a profile of its
name, which also installs the udev rule that opens `/dev/ttyUSB*` and
`/dev/ttyACM*` to every user:

```bash
synocli-kernelmodule list
sudo synocli-kernelmodule --profile cp210x start
sudo synocli-kernelmodule --profile ch341,cdc-acm status
```

`usb-devices` (SynoCli Kernel Tools) gives the USB id of an adapter, and `dmesg`, once
it is plugged in, the driver that claimed it.

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
2. Check the profile is loaded: `sudo synocli-kernelmodule --profile <driver> status`
3. Find the driver of the adapter from its USB id (`usb-devices`)

### Permission Denied

Load the profile of the driver: it installs the udev rule of the package, which
opens `/dev/ttyUSB*` and `/dev/ttyACM*` to every user.

## Related Packages

- SynoKernel CD-ROM - CD-ROM drivers
- [SynoCli Kernel Tools](synocli-kernel.md) - Kernel utilities
- [Home Assistant](homeassistant.md) - Uses serial devices
