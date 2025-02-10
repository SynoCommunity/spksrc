PKG_NAME = cups
PKG_VERS = 2.3.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-source.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/apple/cups/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://www.cups.org/
COMMENT  = CUPS printing system.
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
CONFIGURE_ARGS += --with-components=core
CONFIGURE_ARGS += --libdir=$(INSTALL_PREFIX)/lib

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
ADDITIONAL_LDFLAGS += -lrt
endif
ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
ADDITIONAL_CFLAGS = -DIP_FREEBIND=15
endif

PATCHES_LEVEL = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: cups_pre_configure
cups_pre_configure:
	@$(RUN) aclocal -I config-scripts
	@$(RUN) autoconf -f -I config-scripts
