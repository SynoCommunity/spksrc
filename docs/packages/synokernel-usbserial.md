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

!!! warning "Experimental, at your own risk"
    The kernel modules of SynoCommunity packages are outside of what Synology
    supports: a module that does not suit the kernel can crash the NAS, and DSM
    updates may break them. Support is limited: read this documentation, and
    check the issues already open, before opening one. Do not use them on a NAS
    you cannot afford to restart or recover.

Provides kernel modules for USB serial device support on Synology NAS devices.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | synokernel-usbserial |
| License | GPL |
| Dependencies | [SynoCli Kernel Tools](synocli-kernel.md) 2.0 or newer (module loading and device profiles) |

## Included Drivers

The USB serial core (`usbserial`), `cdc-acm` for ACM devices (modems, Arduino,
Z-Wave sticks), and the USB serial drivers of adapters, modems, GPS receivers
and barcode readers the kernel of the NAS offers: the list grows with the
kernel, `f81534` coming with 5.10 for instance. Among them:

| Module | Devices |
|--------|---------|
| `ch341` | WinChipHead CH340/CH341 adapters |
| `cp210x` | Silicon Labs CP210x adapters (many Zigbee sticks) |
| `ftdi_sio` | FTDI adapters |
| `pl2303` | Prolific PL2303 adapters |
| `option`, `qcserial`, `sierra` | 3G/4G USB modems |
| `ti_usb_3410_5052` | Texas Instruments TUSB3410/5052 adapters |
| `mos7720`, `mos7840`, `f81534` | multi-port adapters |

Drivers of devices a NAS does not serve are left out: PDAs and players, IrDA,
smart card readers (they go through CCID), and adapters whose firmware the
package does not provide (`keyspan`, `io_edgeport`, `whiteheat`).

## Usage

The modules are not loaded on installation: load those of your adapter, as
root, with `sudo -i` in front (`sudo` alone does not find the commands of packages), with the
`synocli-kernelmodule` helper of
[SynoCli Kernel Tools](synocli-kernel.md), which holds the profiles. Each
driver has a profile of its name, which also installs the udev rule that opens
`/dev/ttyUSB*` and `/dev/ttyACM*` to every user:

```bash
sudo -i synocli-kernelmodule list
sudo -i synocli-kernelmodule --profile cp210x start
sudo -i synocli-kernelmodule --profile ch341,cdc-acm status
```

To load them at every startup, see
[Loading modules at boot](synocli-kernel.md#loading-modules-at-boot).

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
2. Check the profile is loaded: `synocli-kernelmodule --profile <driver> status`
3. Find the driver of the adapter from its USB id (`usb-devices`)

### Permission Denied

Load the profile of the driver: it installs the udev rule of its profiles,
which opens `/dev/ttyUSB*` and `/dev/ttyACM*` to every user.

## Related Packages

- SynoKernel CD-ROM - CD-ROM drivers
- [SynoCli Kernel Tools](synocli-kernel.md) - Kernel utilities
- [Home Assistant](homeassistant.md) - Uses serial devices
