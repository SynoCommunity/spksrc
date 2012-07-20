PKG_NAME = asterisk-gui
PKG_VERS = 2.1.0-rc1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.asterisk.org/pub/telephony/asterisk-gui/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/asterisk

HOMEPAGE = http://www.asterisk.org/
COMMENT  = 
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = ASTETCDIR=$(STAGING_INSTALL_PREFIX)/var/etc
INSTALL_TARGET = myInstall
POST_INSTALL_TARGET = myPostInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) make install DESTDIR=$(STAGING_INSTALL_PREFIX) ASTVARLIBDIR=$(STAGING_INSTALL_PREFIX)/share/asterisk

.PHONY: myPostInstall
myPostInstall:
	@sed -i -e 's|/etc/asterisk|$(INSTALL_PREFIX)/var/etc|g' $(STAGING_INSTALL_PREFIX)/share/asterisk/scripts/*
	@sed -i -e 's|/var/lib/|$(INSTALL_PREFIX)/share/|g' $(STAGING_INSTALL_PREFIX)/share/asterisk/scripts/*
	@sed -i -e 's|/var/spool/|$(INSTALL_PREFIX)/var/spool/|g' $(STAGING_INSTALL_PREFIX)/share/asterisk/scripts/*
	@for f in `find $(STAGING_INSTALL_PREFIX)/share/asterisk/static-http/config -name '*.html' -o -name '*.js' -o -name '*.svgz'`; do \
		sed -i -e 's|/etc/asterisk|$(INSTALL_PREFIX)/var/etc|g' $$f; \
		sed -i -e 's|/var/lib/|$(INSTALL_PREFIX)/share/|g' $$f; \
		sed -i -e 's|/var/spool|/$(INSTALL_PREFIX)/var/spool/|g' $$f; \
	done
