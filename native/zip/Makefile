PKG_NAME = zip
PKG_VERS = 30
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://altushost-swe.dl.sourceforge.net/project/infozip/Zip%203.x%20%28latest%29/3.0
PKG_DIR = $(PKG_NAME)$(PKG_VERS)

HOMEPAGE = https://rsync.samba.org/
COMMENT  = Rsync is a fast and extraordinarily versatile file copying tool. It can copy locally, to/from another host over any remote shell, or to/from a remote rsync daemon. It offers a large number of options that control every aspect of its behavior and permit very flexible specification of the set of files to be copied. It is famous for its delta-transfer algorithm, which reduces the amount of data sent over the network by sending only the differences between the source files and the existing files in the destination. Rsync is widely used for backups and mirroring and as an improved copy command for everyday use. 
LICENSE  = GPLv3

CONFIGURE_TARGET = nop
COMPILE_TARGET = native_zip_compile
INSTALL_TARGET = native_zip_install

include ../../mk/spksrc.native-cc.mk

.PHONY: native_zip_compile
native_zip_compile:
	$(RUN) $(MAKE) -f unix/Makefile generic

.PHONY: native_zip_install
native_zip_install:
	$(RUN) $(MAKE) -f unix/Makefile prefix=$(INSTALL_DIR)$(INSTALL_PREFIX) install
	cd $(INSTALL_DIR)$(INSTALL_PREFIX)/bin && ln -s zip unzip
