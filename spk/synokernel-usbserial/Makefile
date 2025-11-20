SPK_NAME = synokernel-usbserial
SPK_VERS = 1.2
SPK_REV = 9
SPK_ICON = src/synokernel-usbserial.png

DEPENDS =

REQUIRE_KERNEL ?= 1
REQUIRE_KERNEL_MODULE  = CONFIG_USB_SERIAL_OPTION:drivers/usb/serial:usbserial
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_CH341:drivers/usb/serial:ch341
REQUIRE_KERNEL_MODULE += CONFIG_USB_ACM:drivers/usb/class:cdc-acm
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_CP210X:drivers/usb/serial:cp210x
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_FTDI_SIO:drivers/usb/serial:ftdi_sio
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_PL2303:drivers/usb/serial:pl2303
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_TI:drivers/usb/serial:ti_usb_3410_5052

MAINTAINER = th0ma7
DESCRIPTION = "Provides usbserial.ko ch341.ko cp210x.ko pl2303.ko ti_usb3410_5052.ko and ftdi_sio.ko"
CHANGELOG = "1. Support DSM-7.1 and DSM-7.2"

UNSUPPORTED_ARCHS = $(PPC_ARCHS)
# archs with kernel 5.x fail to build
# error: Cannot generate ORC metadata for CONFIG_UNWINDER_ORC=y, please install libelf-dev, libelf-devel or elfutils-libelf-devel
# with installation of elfutils and libelf-dev to the development environment,
# it further fails with error: pointer may be used after ‘realloc’ [-Werror=use-after-free]
UNSUPPORTED_ARCHS += epyc7002 rtd1619b
# we only have ipq806x for SRM 1.2, but this fails with:
# /usr/bin/ld: scripts/dtc/dtc-parser.tab.o:(.bss+0x10): multiple definition of `yylloc'; scripts/dtc/dtc-lexer.lex.o:(.bss+0x0): first defined here
REQUIRED_MIN_SRM = 1.3

STARTABLE = no
DISPLAY_NAME = SynoKernel USB Serial drivers

HOMEPAGE = https://www.kernel.org/
LICENSE  = GPLv2

SPK_DEPENDS = synocli-kernel

STRIP_TARGET = nop
POST_STRIP_TARGET = usbserial_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: usbserial_extra_install
usbserial_extra_install:
	install -m 755 -d $(STAGING_DIR)/rules.d
	install -m 644 src/60-$(SPK_NAME).rules $(STAGING_DIR)/rules.d/60-$(SPK_NAME).rules
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 644 src/$(SPK_NAME).cfg $(STAGING_DIR)/etc/$(SPK_NAME).cfg
