SPK_NAME = synokernel-usbserial
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/synokernel-usbserial.png
CHANGELOG = "1. Kernel USB serial drivers"

DEPENDS = 

REQUIRED_DSM = 6.2.3
REQUIRE_KERNEL = 1
REQUIRE_KERNEL_MODULE  = CONFIG_USB_SERIAL_OPTION:drivers/usb/serial:usbserial
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_CH341:drivers/usb/serial:ch341
REQUIRE_KERNEL_MODULE += CONFIG_USB_ACM:drivers/usb/class:cdc-acm
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_CP210X:drivers/usb/serial:cp210x
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_FTDI_SIO:drivers/usb/serial:ftdi_sio
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_PL2303:drivers/usb/serial:pl2303
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_TI:drivers/usb/serial:ti_usb_3410_5052

MAINTAINER = th0ma7
DESCRIPTION = "Includes usbserial.ko ch341.ko cp210x.ko pl2303.ko ti_usb3410_5052.ko and ftdi_sio.ko"

RELOAD_UI = no
STARTABLE = yes
DISPLAY_NAME = SynoKernel USB Serial drivers

WIZARDS_DIR = src/wizard/

HOMEPAGE = https://www.kernel.org/
LICENSE  = GPLv2

SPK_DEPENDS = synocli-kernel

SSS_SCRIPT        = src/dsm-control.sh
SERVICE_SETUP     = src/service-setup.sh
STRIP_TARGET      = nop
POST_STRIP_TARGET = usbserial_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: usbserial_extra_install
usbserial_extra_install:
	install -m 755 -d $(STAGING_DIR)/rules.d
	install -m 644 src/60-$(SPK_NAME).rules $(STAGING_DIR)/rules.d/60-$(SPK_NAME).rules
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 644 src/$(SPK_NAME).cfg $(STAGING_DIR)/etc/$(SPK_NAME).cfg
