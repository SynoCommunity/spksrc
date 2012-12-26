PKG_NAME = lirc
PKG_VERS = 0.8.7
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/lirc/LIRC/0.8.7
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
MOD_DIR = /lib/modules

#DEPENDS = cross/lirc/source/linux-2.6.32
DEPENDS = 

HOMEPAGE = http://www.lirc.org/
COMMENT  = LIRC daemon decodes infrared signals and provides them on a Unix domain socket
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-transmitter --with-driver=all --with-moduledir=${MOD_DIR} --enable-sandboxed  --with-kerneldir=/home/build/spksrc/cross/lirc/source/linux-2.6.32

POST_CONFIGURE_TARGET = lirc_kill_wpc8769l
INSTALL_TARGET = lirc_custom_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: lirc_custom_install lirc_kill_wpc8769l
lirc_custom_install:
	$(RUN) $(MAKE) install DESTDIR=$(STAGING_INSTALL_PREFIX) prefix=""
lirc_kill_wpc8769l:
	echo -e ".PHONY: all install\nall:\ninstall:\n" > $(WORK_DIR)/$(PKG_DIR)/drivers/lirc_wpc8769l/Makefile
