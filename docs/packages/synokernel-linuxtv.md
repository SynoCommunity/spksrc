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

On a kernel without DMA-BUF, regmap or rational support, such as the 3.2
kernel of the armada370, the drivers that need them do not load: analog
capture, webcams and SDR (videobuf2), and the demodulators that use regmap.
DVB tuners work.

## Usage

Modules are installed under
`/var/packages/synokernel-linuxtv/target/lib/modules/<arch>/<kernel>/` and loaded
with the `synocli-kernelmodule` helper of SynoCli Kernel Tools, as root:

```bash
# Core modules, then the ones of a device
sudo synocli-kernelmodule --spk synokernel-linuxtv --config synokernel-linuxtv.cfg:default status
sudo synocli-kernelmodule --spk synokernel-linuxtv --config synokernel-linuxtv.cfg:HAUPPAUGE_WINTV_DUALHD start
```

Firmware files are in `/var/packages/synokernel-linuxtv/target/lib/firmware`,
which the helper points the kernel firmware loader at.

Once loaded, a tuner appears as `/dev/dvb/adapterN`:

```bash
ls -l /dev/dvb/
dmesg | grep -i -E 'dvb|em28xx|si2168'
```

## Troubleshooting

### A module fails to load

`dmesg` names the cause. `Unknown symbol` means a module it depends on is not
loaded yet: load the core modules of the `default` profile first. `disagrees
about version of symbol` or `invalid module format` means the package does not
match the running kernel, typically after a DSM update that changed it.

### No `/dev/dvb` device

Check that DSM's own DVB modules are gone (`lsmod | grep dvb`): with VideoStation
DTV enabled they claim the tuner first. See [Before you start](#before-you-start).

## Related Packages

- [SynoCli Kernel Tools](synocli-kernel.md) - Kernel module loading
- [SynoKernel USB Serial](synokernel-usbserial.md) - USB serial adapter drivers
- Tvheadend - TV streaming server
