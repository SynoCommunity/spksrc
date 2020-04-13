SPK_NAME = UsbSerialDrivers
SPK_VERS = 6
SPK_REV = 8
SPK_ICON = src/usb.png
DSM_UI_DIR = app
CHANGELOG = "USB drivers and USB utils, including HGI80 and usbserial.ko"

DEPENDS = cross/usbutils cross/ch341 cross/cp210x cross/pl2303 cross/ti_usb_3410_5052

REQUIRED_DSM = 5.2
REQ_KERNEL = 1

MAINTAINER = SynoCommunity
DESCRIPTION = "USBSerialDrivers includes usbserial.ko ch341.ko cp210x.ko pl2303.ko ti_usb3410_5052.ko and ftdi_sio.ko. USB utils: Log in to your Synology with Telnet or ssh and type: lsusb -v or usb-devices. If you use my driver package, you might consider a donation with paypal. https://www.paypal.me/jumbotroll."


RELOAD_UI = no
STARTABLE = no
DISPLAY_NAME = UsbSerialDrivers

HOMEPAGE = http://www.jadahl.com/
LICENSE  = GPL

SSS_SCRIPT    = src/dsm-control.sh
SERVICE_SETUP = src/service-setup.sh
POST_STRIP_TARGET = usbserial_extra_install

SPK_COMMANDS = bin/usb-devices bin/usbhid-dump

include ../../mk/spksrc.spk.mk

.PHONY: usbserial_extra_install
usbserial_extra_install:
	install -m 755 -d $(STAGING_DIR)/rules.d
	install -m 644 src/60-jadahl.usbserial.rules $(STAGING_DIR)/rules.d/60-jadahl.usbserial.rules
