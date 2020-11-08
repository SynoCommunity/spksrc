PKG_NAME = lirc
PKG_VERS = 0.9.0
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/project/lirc/LIRC/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
MOD_DIR = /lib/modules

REQUIRE_KERNEL = 1

HOMEPAGE = https://www.lirc.org/
COMMENT  = LIRC daemon decodes infrared signals and provides them on a Unix domain socket
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-transmitter --with-driver=userspace --with-moduledir=$(MOD_DIR) --enable-sandboxed  --with-kerneldir=$(KERNEL_DIR)

include ../../mk/spksrc.cross-cc.mk
