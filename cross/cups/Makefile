PKG_NAME = cups
PKG_VERS = 2.3.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-source.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/apple/$(PKG_NAME)/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://www.cups.org/
COMMENT  = CUPS printing system
LICENSE  = GPLv2

PRE_CONFIGURE_TARGET = cups_pre_configure
GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --with-cupsd-file-perm=0755
CONFIGURE_ARGS += --with-log-file-perm=0600
CONFIGURE_ARGS += --enable-relro
CONFIGURE_ARGS += --enable-threads
CONFIGURE_ARGS += --enable-webif
CONFIGURE_ARGS += --with-xinetd=no
CONFIGURE_ARGS += --with-access-log-level=actions
CONFIGURE_ARGS += --enable-page-logging
CONFIGURE_ARGS += --with-components=libcups
# Disable multilib
CONFIGURE_ARGS += --libdir=$(INSTALL_PREFIX)/lib
ADDITIONAL_LDFLAGS = -Wl,-rpath,$(INSTALL_DIR)/var/packages/$(PKG_NAME)/target/lib
# 88f6281 might need this
ADDITIONAL_LDFLAGS += -lrt

PATCHES_LEVEL = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: cups_pre_configure
cups_pre_configure:
	$(RUN) aclocal -I config-scripts ; \
	$(RUN) autoconf -f -I config-scripts ; \
