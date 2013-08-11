PKG_NAME = lcdproc
PKG_VERS = 0.5.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/lcdproc/files/lcdproc/0.5.6
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libftdi1 

HOMEPAGE = http://www.lcdproc.org/
COMMENT  = LCDproc is a piece of open source software that displays real-time system information from your Linux/*BSD box on a LCD. The server supports several serial and USB devices from Matrix Orbital and CrystalFontz as well as some devices connected to the LPT port: HD44780, T6963, SED1520 and SED1330. Various clients are available that display things like CPU load, system load, memory usage, uptime, and a lot more.
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-drivers=hd44780 --enable-ftdi=yes

PRE_CONFIGURE_TARGET = myPreConfigure

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	cd $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/pkgconfig/ && ln -s libftdi1.pc libftdi.pc
