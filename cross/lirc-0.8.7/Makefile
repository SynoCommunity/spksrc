PKG_NAME = lirc
PKG_VERS = 0.8.7
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/lirc/LIRC/0.8.7
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
MOD_DIR = /lib/modules

REQ_KERNEL = 1

HOMEPAGE = http://www.lirc.org/
COMMENT  = LIRC daemon decodes infrared signals and provides them on a Unix domain socket
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-transmitter --with-driver=all --with-moduledir=$(MOD_DIR) --enable-sandboxed  --with-kerneldir=$(KERNEL_DIR)

POST_CONFIGURE_TARGET = lirc_kill_drivers

# These drivers would not make and are likely un-needed anyway
KILL_DRIVERS = lirc_wpc8769l

# i2c functions not availble in ppc854x kernel configuration
ifeq ($(ARCH),ppc854x)
KILL_DRIVERS += lirc_i2c
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: lirc_kill_drivers
lirc_kill_drivers:
	@for DRIVER in $(KILL_DRIVERS); do \
	    echo -e ".PHONY: all install\nall:\ninstall:\n" > $(WORK_DIR)/$(PKG_DIR)/drivers/$$DRIVER/Makefile; \
	done
