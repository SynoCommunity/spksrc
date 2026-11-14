PKG_NAME = cups
# 2.4.20 fails without DNS-SD: dest.c uses members its _cups_dnssd_data_t declares only
# with HAVE_DNSSD. 2.4.19 is the latest that builds without avahi.
PKG_VERS = 2.4.19
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-source.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/OpenPrinting/cups/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://openprinting.github.io/cups/
COMMENT  = CUPS printing system.
LICENSE  = GPLv2

PRE_CONFIGURE_TARGET = cups_pre_configure
GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --with-cupsd-file-perm=0755
CONFIGURE_ARGS += --with-log-file-perm=0600
CONFIGURE_ARGS += --enable-relro
CONFIGURE_ARGS += --with-tls=no
CONFIGURE_ARGS += --enable-webif
CONFIGURE_ARGS += --with-xinetd=no
CONFIGURE_ARGS += --with-access-log-level=actions
CONFIGURE_ARGS += --enable-page-logging
CONFIGURE_ARGS += --with-components=core
CONFIGURE_ARGS += --libdir=$(INSTALL_PREFIX)/lib

include ../../mk/spksrc.cross-cc.mk

.PHONY: cups_pre_configure
cups_pre_configure:
	@$(RUN) aclocal -I config-scripts
	@$(RUN) autoconf -f -I config-scripts
