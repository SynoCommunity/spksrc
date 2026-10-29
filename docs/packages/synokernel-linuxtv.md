---
title: SynoKernel LinuxTV
description: LinuxTV media drivers for USB TV tuners on Synology NAS
tags:
  - kernel
  - drivers
  - usb
  - dvb
  - tv
---

# SynoKernel LinuxTV

!!! warning "Experimental, at your own risk"
    The kernel modules of SynoCommunity packages are outside of what Synology
    supports: a module that does not suit the kernel can crash the NAS, and DSM
    updates may break them. Support is limited: read this documentation, and
    check the issues already open, before opening one. Do not use them on a NAS
    you cannot afford to restart or recover.

Provides the LinuxTV media drivers -- DVB, ATSC and analog TV tuners, remote
controls and USB video devices -- built for the kernel of each Synology model,
with the firmware files many tuners load at startup.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | synokernel-linuxtv |
| License | GPLv2 |
| Dependencies | [SynoCli Kernel Tools](synocli-kernel.md) (module loading) |

## Before you start

The drivers of this package replace the DVB modules DSM loads itself for
VideoStation's DTV support. Disable DTV in VideoStation (*Settings* > *DTV* >
*Advanced* > *Disable the DTV function*), or uninstall VideoStation, then reboot
so that no DSM media module stays in memory.

## Driver versions

LinuxTV stopped maintaining `media_build`, the tool that builds its drivers
outside of the kernel tree, in October 2022. Each Synology kernel gets the last
`media_build` that still supported it, and the media drivers of that time:

| Kernels | media_build | Media drivers of | Synology models |
|---------|-------------|------------------|-----------------|
| 4.4 and newer, with gcc 5.1 or newer | 2022-05-24 | Linux 5.19-rc1 | DSM 7.x on 4.4 and 5.10 kernels, SRM 1.3 |
| 3.10 and newer, with gcc 4.9 or newer | 2021-01-13 | Linux 5.11-rc | DSM 6.x and 7.x on 3.10 kernels, DSM 6.x on 4.4 kernels |
| 3.2 to 3.9 | 2018-08-08 | Linux 4.19-rc | armada370/375/xp, comcerto2k, evansport, hi3535 |

Each kernel gets the first row it matches. Kernels 2.6.32 (88f6281, qoriq)
are not supported: no `media_build` that builds for them still applies to a
media tree.

On a kernel built without DMA-BUF, videobuf2 gets stubs of it: everything
works but the sharing of buffers between devices (DMABUF). On a kernel without
the regmap core, such as the 3.2 kernel of the armada370, the demodulators that
use regmap do not load.

Drivers of PCIe cards are built for the platforms of which a model has a PCIe
slot (`KERNEL_PCI_SLOT` of the kernel), and left out elsewhere.

## Usage

Modules are installed under
`/var/packages/synokernel-linuxtv/target/lib/modules/<arch>/<kernel>/` and loaded
with the `synocli-kernelmodule` helper of SynoCli Kernel Tools, as root:

```bash
# The device profiles of the package
synocli-kernelmodule list

# Load the modules of a device, with the modules they depend on
sudo synocli-kernelmodule --profile hauppauge-wintv-dualhd-atsc start
sudo synocli-kernelmodule --profile hauppauge-wintv-dualhd-atsc stop
```

| Profile | Device | Tested |
|---------|--------|--------|
| `hauppauge-wintv-dualhd-atsc` | Hauppauge WinTV-dualHD 01595, ATSC/QAM (2040:026d) | DS115j, kernel 3.2.101 |
| `hauppauge-wintv-dualhd-dvb` | Hauppauge WinTV-dualHD, DVB-T2/C (2040:0265) | no |
| `hauppauge-wintv-solohd` | Hauppauge WinTV-soloHD, PCTV 292e, DVB-T2/C (2040:0264, 2040:8264, 2040:8268, 2013:025f) | no |
| `hauppauge-wintv-hvr-955q` | Hauppauge WinTV-HVR-955Q, ATSC/QAM (2040:b123, b124, b151) | no |
| `pctv-461e` | PCTV 461e, DVB-S2 (2013:0258) | no |
| `dvbsky-s960` | DVBSky S960/S860, DVB-S2 (0572:6831) | no |
| `mygica-t230` | MyGica T230/T230C, DVB-T2/C (0572:c688, 0572:c689) | no |
| `rtl2832u-r820t` | RTL2832U DVB-T sticks with an R820T tuner (0bda:2838) | no |
| `astrometa-dvb-t2` | Astrometa DVB-T2/C (15f4:0131) | no |
| `siano-mdtv` | Siano sms1xxx receivers | no |

`synocli-kernelmodule list` tells which this kernel can load: the DVB-S2
demodulators and the RTL2832U use regmap, which the 3.2 kernel of the armada370
lacks.

A device without a profile gets one by following
[Writing a profile](synocli-kernel.md#writing-a-profile). To load a device at every
startup, see [Loading modules at boot](synocli-kernel.md#loading-modules-at-boot).

Firmware files are in `/var/packages/synokernel-linuxtv/target/lib/firmware`,
which the helper points the kernel firmware loader at: the LinuxTV set of 2018
(`driver/dvb-firmwares`), then the larger one LibreELEC maintains
(`driver/dvb-firmwares-libreelec`: si2168, si2157/2158/2141, m88ds3103,
mn8847x and others), whose files replace those of the same name.

Once loaded, a tuner appears as `/dev/dvb/adapterN`:

```bash
ls -l /dev/dvb/
dmesg | grep -i -E 'dvb|em28xx|si2168'
```

## Troubleshooting

### A module fails to load

`dmesg` names the cause. `Unknown symbol` means a module it needs is not loaded:
a tuner or demodulator chip of the device missing from its profile. `disagrees
about version of symbol` or `invalid module format` means the package does not
match the running kernel, typically after a DSM update that changed it.

### No `/dev/dvb` device

Check that DSM's own DVB modules are gone (`lsmod | grep dvb`): with VideoStation
DTV enabled they claim the tuner first. See [Before you start](#before-you-start).

## Related Packages

- [SynoCli Kernel Tools](synocli-kernel.md) - Kernel module loading
- [SynoKernel USB Serial](synokernel-usbserial.md) - USB serial adapter drivers
- Tvheadend - TV streaming server
