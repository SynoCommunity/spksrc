---
title: SynoCli Kernel Tools
description: Kernel and device utilities for Synology NAS
tags:
  - cli
  - kernel
  - modules
  - drivers
---

# SynoCli Kernel Tools

The `synocli-kernel` package provides lower-level USB helpers and scripts to help with kernel module loading and unloading. This package should normally be a hard dependency for any other kernel module related package.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | synocli-kernel |
| License | GPL |

To add as a dependency in `spk/<package>/Makefile`:
```makefile
SPK_DEPENDS = synocli-kernel
```

## Kernel Module Helper Script

The module loading helper script can be called with `--help --verbose` for details:

```bash
./synocli-kernelmodule.sh --spk synokernel-usbserial --config synokernel-usbserial.cfg:ch341,cp210x --verbose --udev 60-synokernel-usbserial.rules status --help

# Output:
#              SynoCommunity kernel driver package name (SPK) [synokernel-usbserial]
#                  SynoCommunity configuration file (SPK_CFG) [synokernel-usbserial.cfg]
#             SynoCommunity configuration path (SPK_CFG_PATH) [/var/packages/synokernel-usbserial/target/etc]
#            SynoCommunity configuration option (SPK_CFG_OPT) [ch341,cp210x]
#                                    Synology NAS arch (ARCH) [apollolake]
#                          Synology DSM version (DSM_VERSION) [6.2.4]
#                               Running kernel version (KVER) [4.4.59+]
#           Module action insmod|rmmod|reload|status (ACTION) [status]
#                                 Kernel modules path (MPATH) [/var/packages/synokernel-usbserial/target/lib/modules]
#                                   udev rules.d path (UPATH) [/var/packages/synokernel-usbserial/target/rules.d]
#                                   udev rules.d file (URULE) [60-synokernel-usbserial.rules]
#                               Kernel objects list (KO_LIST) [usbserial ch341 cp210x]

# Usage:
#   ./synocli-kernelmodule.sh [-s|--spk <package>] [<insmod,start|rmmod,stop|reload,restart|status>] module1.ko module2.ko ...
#   Optional: [-c|--config <file>:<option1>,<option2>,...]
#             [-u|--udev <file>]
```

### Examples

```bash
# Check status of CD-ROM modules
./synocli-kernelmodule.sh --spk synokernel-cdrom --verbose cdrom sr_mod status

# Load CD-ROM modules using config file
./synocli-kernelmodule.sh --spk synokernel-cdrom --config synokernel-cdrom.cfg:default insmod

# Load USB serial modules with udev rules
./synocli-kernelmodule.sh --spk synokernel-usbserial --udev 60-synokernel-usbserial.rules usbserial ch341 cp210x start

# Load USB serial using config
./synocli-kernelmodule.sh --spk synokernel-usbserial --config synokernel-usbserial.cfg:ch341,cp210x start
```

## Related Kernel Module Packages

### synokernel-cdrom

A basic kernel module package that provides `cdrom.ko` and `sr_mod.ko` kernel modules for USB CD-ROM devices:

```bash
# Load CD-ROM modules
./synocli-kernelmodule.sh --spk synokernel-cdrom --config synokernel-cdrom.cfg:default insmod
```

`dmesg` output should show:
```
[3553418.051365] usb 2-1: new SuperSpeed USB device number 2 using xhci_hcd
[3553418.077353] usb-storage 2-1:1.0: USB Mass Storage device detected
[3553418.084541] scsi host6: usb-storage 2-1:1.0
[3553419.104008] scsi 6:0:0:0: CD-ROM            PIONEER  BD-RW   BDR-XD05
[3790953.029269] sr 6:0:0:0: [sr0] scsi3-mmc drive: 62x/62x writer dvd-ram cd/rw xa/form2 cdda tray
[3790953.039237] cdrom: Uniform CD-ROM driver Revision: 3.20
[3790953.045785] sr 6:0:0:0: Attached scsi CD-ROM sr0
```

Unloading:
```bash
./synocli-kernelmodule.sh --spk synokernel-cdrom --config synokernel-cdrom.cfg:default rmmod
```

### synokernel-usbserial

Provides USB serial adapter support with `udev` rules for device file permissions. Includes:

- `usbserial.ko` - USB Serial core
- `ch341.ko` - Winchiphead CH341 adapters
- `cp210x.ko` - Silicon Labs CP210x adapters
- `pl2303.ko` - Prolific PL2303 adapters
- `ti_usb3410_5052.ko` - Texas Instruments adapters
- `ftdi_sio.ko` - FTDI adapters

```bash
# Load ch341 and cp210x with udev rules
./synocli-kernelmodule.sh --spk synokernel-usbserial --config synokernel-usbserial.cfg:ch341,cp210x --udev 60-synokernel-usbserial.rules start
```

`dmesg` output:
```
[3994283.661384] usbcore: registered new interface driver usbserial
[3994283.695707] usbcore: registered new interface driver ch341
[3994283.702615] usbserial: USB Serial support registered for ch341-uart
[3994283.731617] usbcore: registered new interface driver cp210x
[3994283.738064] usbserial: USB Serial support registered for cp210x
```

See [SynoKernel USB Serial](synokernel-usbserial.md) for detailed configuration.

### synokernel-linuxtv

Provides LinuxTV media drivers for TV tuners and capture cards. Complex module dependency ordering and extensive configuration options.

## Building Kernel Module Packages

### Configuration

Kernel dependency usage is enabled with `REQUIRE_KERNEL = 1`.

Automated building of modules uses `REQUIRE_KERNEL_MODULE`:
```makefile
REQUIRE_KERNEL_MODULE  = CONFIG_USB_SERIAL_OPTION:drivers/usb/serial:usbserial
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_CH341:drivers/usb/serial:ch341
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_CP210X:drivers/usb/serial:cp210x
```

Each configuration option consists of 3 sub-variables:

1. **Kernel configuration option** - `CONFIG_*` symbol
2. **Kernel directory tree** - Path where the module source is located
3. **Module name** - Without `.ko` extension

### Module Installation Structure

When `REQUIRE_KERNEL_MODULE` is not empty, kernel modules are compiled and installed by `spksrc.kernel.mk`. The installation location reflects the default kernel path:

```
modules
└── 4.4.59+
    └── kernel
        └── drivers
            └── usb
                ├── class
                │   └── cdc-acm.ko
                └── serial
                    ├── ch341.ko
                    ├── cp210x.ko
                    └── ftdi_sio.ko
```

### Installation Wizard with Module Selection

The `synokernel-usbserial` package demonstrates an installation wizard for module selection. Configuration files:

1. **`src/synokernel-usbserial.cfg`** - Lists all modules with their directory paths
2. **`src/synokernel-usbserial.ini`** - Module enable/disable status (`true`/`false`)
3. **`src/wizard/install_uifile`** - DSM GUI checkbox configuration
4. **`src/wizard/upgrade_uifile.sh`** - Preserves previous selections during upgrade
5. **`src/service-setup.sh`** - Writes GUI selections to `.ini` file

Variable names must match across all configuration files for the wizard to work properly.

## Troubleshooting

### Finding the Right Module Order

For complex drivers like LinuxTV:

1. Use the helper script to test loading order:
   ```bash
   ./synocli-kernelmodule.sh --spk synokernel-linuxtv --verbose i2c-mux-gpio dvb-usb-cxusb start
   ```

2. Check `dmesg` for module dependency messages

3. Once the correct order is found, STOP the package from Package Center

4. Update the configuration file:
   `/var/packages/synokernel-linuxtv/target/etc/synokernel-linuxtv.cfg`

5. Set corresponding variables to `true` in:
   `/var/packages/synokernel-linuxtv/target/etc/synokernel-linuxtv.ini`

6. Test START/STOP from Package Center

7. Check logs: `/tmp/synocli-kernelmodule-synokernel-linuxtv.log`

## Related Packages

- [SynoKernel USB Serial](synokernel-usbserial.md) - USB serial drivers
- [SynoCli Misc Tools](synocli-misc.md) - System utilities
