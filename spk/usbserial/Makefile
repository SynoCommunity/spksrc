SPK_NAME = UsbSerialDrivers
SPK_VERS = 6
SPK_REV = 8
SPK_ICON = src/usb.png
DSM_UI_DIR = app
CHANGELOG = "USB drivers and USB utils, including HGI80 and usbserial.ko"

DEPENDS = 
#DEPENDS = cross/usbutils
#module/ch341
#module/cp210x module/pl2303 module/ti_usb_3410_5052

REQUIRED_DSM = 6.2.3
REQUIRE_KERNEL = 1
REQUIRE_KERNEL_MODULE  = CONFIG_USB_SERIAL_OPTION:drivers/usb/serial:usbserial
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_CH341:drivers/usb/serial:ch341
REQUIRE_KERNEL_MODULE += CONFIG_USB_ACM:drivers/usb/class:cdc-acm
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_CP210X:drivers/usb/serial:cp210x
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_FTDI_SIO:drivers/usb/serial:ftdi_sio
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_PL2303:drivers/usb/serial:pl2303
REQUIRE_KERNEL_MODULE += CONFIG_USB_SERIAL_TI:drivers/usb/serial:ti_usb_3410_5052

MAINTAINER = SynoCommunity
DESCRIPTION = "USBSerialDrivers includes usbserial.ko ch341.ko cp210x.ko pl2303.ko ti_usb3410_5052.ko and ftdi_sio.ko. USB utils: Log in to your Synology with Telnet or ssh and type: lsusb -v or usb-devices. If you use my driver package, you might consider a donation with paypal. https://www.paypal.me/jumbotroll."

RELOAD_UI = no
STARTABLE = no
DISPLAY_NAME = UsbSerialDrivers

HOMEPAGE = http://www.jadahl.com/
LICENSE  = GPL

SSS_SCRIPT    = src/dsm-control.sh
SERVICE_SETUP = src/service-setup.sh
STRIP_TARGET = nop
POST_STRIP_TARGET = usbserial_extra_install

SPK_COMMANDS = bin/usb-devices bin/usbhid-dump

include ../../mk/spksrc.spk.mk

.PHONY: usbserial_extra_install
usbserial_extra_install:
	install -m 755 -d $(STAGING_DIR)/rules.d
	install -m 644 src/60-jadahl.usbserial.rules $(STAGING_DIR)/rules.d/60-jadahl.usbserial.rules
