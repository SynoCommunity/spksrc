PKG_NAME = lirc
PKG_VERS = 0.9.0
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/lirc/LIRC/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
MOD_DIR = /lib/modules

REQ_KERNEL = 1

HOMEPAGE = http://www.lirc.org/
COMMENT  = LIRC daemon decodes infrared signals and provides them on a Unix domain socket
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-transmitter --with-driver=userspace --with-moduledir=$(MOD_DIR) --enable-sandboxed  --with-kerneldir=$(KERNEL_DIR)

#POST_CONFIGURE_TARGET = lirc_kill_wpc8769l

include ../../mk/spksrc.cross-cc.mk

.PHONY: lirc_kill_wpc8769l
lirc_kill_wpc8769l:
	echo -e ".PHONY: all install\nall:\ninstall:\n" > $(WORK_DIR)/$(PKG_DIR)/drivers/lirc_wpc8769l/Makefile
