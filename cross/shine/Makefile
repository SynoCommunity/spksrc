PKG_NAME = shine
PKG_VERS = 3.1.1
PKG_EXT = tar.gz
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/toots/shine/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = https://github.com/toots/shine
COMMENT  = Super fast fixed-point MP3 encoder
LICENSE  = GPLv2

PRE_CONFIGURE_TARGET = shine_pre_configure
#POST_INSTALL_TARGET = shine_post_install
CONFIGURE_ARGS = --includedir=$(INSTALL_DIR)/$(INSTALL_PREFIX)/include
CONFIGURE_ARGS += --enable-shared
CONFIGURE_ARGS += --disable-static

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: shine_pre_configure

shine_pre_configure: 
	$(RUN) ./bootstrap

#.PHONY: shine_post_install
#
# Fix location of include files
#shine_post_install: 
#	$(RUN) sed '/^Cflags:/ s/$/\\\\/shine/' $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/pkgconfig/shine.pc
#	cd $(PKG_WORK_DIR) && env $(ENV) sed '/^Cflags:/ s/$/\/shine/' $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/pkgconfig/shine.pc
