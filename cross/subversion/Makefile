PKG_NAME = subversion
PKG_VERS = 1.14.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://dlcdn.apache.org/subversion
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# http://yylam.blogspot.com/2016/01/cross-compile-subversion-server.html

DEPENDS  = cross/apr
DEPENDS += cross/apr-util
#DEPENDS += cross/serf
DEPENDS += cross/sqlite
DEPENDS += cross/cyrus-sasl
DEPENDS += cross/lz4
DEPENDS += cross/file

HOMEPAGE = https://subversion.apache.org/
COMMENT  = Subversion is an open source version control system.
LICENSE  = Apache 2.0

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --with-apr=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-apr-util=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-zlib=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --without-berkeley-db
CONFIGURE_ARGS += --with-utf8proc=internal

include ../../mk/spksrc.cross-cc.mk
