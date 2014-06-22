PKG_NAME = postgresql
PKG_VERS = 9.3.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.postgresql.org/pub/source/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl cross/readline

HOMEPAGE = http://www.postgresql.org
COMMENT  = 
LICENSE  =


PRE_CONFIGURE_TARGET = myPreConfigure
GNU_CONFIGURE = 1
CONFIGURE_ARGS = XML2_CONFIG=$(STAGING_INSTALL_PREFIX)/bin/xml2-config --with-readline --with-openssl --enable-thread-safety

include ../../mk/spksrc.cross-cc.mk


.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) ./configure $(REAL_CONFIGURE_ARGS) 
