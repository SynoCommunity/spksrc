SPK_NAME = synokernel-usbserial
SPK_VERS = 1.2
SPK_REV = 13
SPK_ICON = src/synokernel-usbserial.png

DEPENDS =

REQUIRE_KERNEL ?= 1
# The USB serial core, ACM devices, then the USB serial drivers of adapters and
# devices a NAS can serve, leaving out PDAs, IrDA, smart card readers and those
# needing firmware; a kernel builds those it offers
REQUIRE_KERNEL_MODULE  = CONFIG_USB_SERIAL:drivers/usb/serial:usbserial
REQUIRE_KERNEL_MODULE += CONFIG_USB_ACM:drivers/usb/class:cdc-acm
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_ARK3116:drivers/usb/serial:ark3116
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_BELKIN:drivers/usb/serial:belkin_sa
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_CH341:drivers/usb/serial:ch341
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_CP210X:drivers/usb/serial:cp210x
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_CYPRESS_M8:drivers/usb/serial:cypress_m8
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_DIGI_ACCELEPORT:drivers/usb/serial:digi_acceleport
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_F81232:drivers/usb/serial:f81232
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_F8153X:drivers/usb/serial:f81534
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_FTDI_SIO:drivers/usb/serial:ftdi_sio
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_GARMIN:drivers/usb/serial:garmin_gps
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_IPW:drivers/usb/serial:ipw
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_KLSI:drivers/usb/serial:kl5kusb105
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_MCT_U232:drivers/usb/serial:mct_u232
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_METRO:drivers/usb/serial:metro-usb
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_MOS7720:drivers/usb/serial:mos7720
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_MOS7840:drivers/usb/serial:mos7840
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_MXUPORT:drivers/usb/serial:mxuport
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_NAVMAN:drivers/usb/serial:navman
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_OPTICON:drivers/usb/serial:opticon
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_OPTION:drivers/usb/serial:option
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_OTI6858:drivers/usb/serial:oti6858
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_PL2303:drivers/usb/serial:pl2303
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_QCAUX:drivers/usb/serial:qcaux
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_QT2:drivers/usb/serial:quatech2
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_QUALCOMM:drivers/usb/serial:qcserial
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_SIERRAWIRELESS:drivers/usb/serial:sierra
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_SIMPLE:drivers/usb/serial:usb-serial-simple
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_SPCP8X5:drivers/usb/serial:spcp8x5
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_SSU100:drivers/usb/serial:ssu100
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_SYMBOL:drivers/usb/serial:symbolserial
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_TI:drivers/usb/serial:ti_usb_3410_5052
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_WWAN:drivers/usb/serial:usb_wwan
# The copy of usb_wwan the GSM modem driver of some Synology kernels uses
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_WWAN_SYNO:drivers/usb/serial:usb_wwan_syno
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_XSENS_MT:drivers/usb/serial:xsens_mt
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_ZTE:drivers/usb/serial:zte_ev

MAINTAINER = th0ma7
DESCRIPTION = "Provides the USB serial drivers of the Linux kernel: usbserial, cdc-acm, and the USB serial drivers of adapters, modems, GPS and barcode readers the kernel of the NAS offers: ch341, cp210x, ftdi_sio, pl2303, option and others."
CHANGELOG = "1. Add DSM-7.3 support. <br/>2. Add support for older DSM-7.0 and DSM-6.1<br/>3. Kernel modules stripped by the framework<br/>4. Add qoriq, ipq806x SRM-1.2 and epyc7003 DSM-7.4<br/>5. Add the USB serial drivers of adapters, modems, GPS and barcode readers<br/>6. Modules loaded by device profile with synocli-kernelmodule"

STARTABLE = no
WIZARDS_DIR = src/wizard/
DISPLAY_NAME = SynoKernel USB Serial drivers

HOMEPAGE = https://www.kernel.org/
LICENSE  = GPLv2

# The device profiles moved to synocli-kernel 1.3-11
SPK_DEPENDS = "synocli-kernel>=1.3-11"

include ../../mk/spksrc.spk.mk

# These use tty flip buffer helpers that 2.6.32 kernels lack (qoriq, 88f6281)
ifeq ($(call version_lt,$(TC_KERNEL),3.0),1)
REQUIRE_KERNEL_MODULE := $(filter-out %:cypress_m8 %:digi_acceleport %:spcp8x5,$(REQUIRE_KERNEL_MODULE))
endif
