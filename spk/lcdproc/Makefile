SPK_NAME = lcdproc
SPK_VERS = 0.5.6
SPK_REV = 1
SPK_ICON = src/lirc.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = LCDproc is a piece of open source software that displays real-time system information from your Linux/*BSD box on a LCD. Various clients are available that display things like CPU load, system load, memory usage, uptime, and a lot more. Please note: Currently only the common display driver hd44780 with libftdi and usb support is compiled into this package. A setup guide is available at https://michaelrogger.wordpress.com.
RELOAD_UI = no
DISPLAY_NAME = LCDProc
CHANGELOG = "LCDProc with hd44780 and libftdi"

HOMEPAGE = http://www.lcdproc.org
LICENSE  =

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk
