PKG_NAME = php
PKG_VERS = 7.3.33
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.php.net/distributions
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://www.php.net/
COMMENT  = PHP is a popular general-purpose scripting language that is especially suited to web development.
LICENSE  = PHP License, version 3.01

GNU_CONFIGURE = 1
ENV += INSTALL_ROOT=$(INSTALL_DIR)

DEPENDS = cross/berkeleydb-5.3
CONFIGURE_ARGS = --with-db4=$(STAGING_INSTALL_PREFIX)

DEPENDS += cross/bzip2
CONFIGURE_ARGS += --with-bz2=shared,$(STAGING_INSTALL_PREFIX)

DEPENDS += cross/curl
CONFIGURE_ARGS += --with-curl=shared,$(STAGING_INSTALL_PREFIX)

DEPENDS += cross/freetype
CONFIGURE_ARGS += --with-freetype-dir=$(STAGING_INSTALL_PREFIX)

DEPENDS += cross/gdbm
CONFIGURE_ARGS += --with-gdbm=$(STAGING_INSTALL_PREFIX)

DEPENDS += cross/gmp
CONFIGURE_ARGS += --with-gmp=shared,$(STAGING_INSTALL_PREFIX)

DEPENDS += cross/libjpeg
CONFIGURE_ARGS += --with-jpeg-dir=$(STAGING_INSTALL_PREFIX)

DEPENDS += cross/libexpat
CONFIGURE_ARGS += --with-libexpat-dir=$(STAGING_INSTALL_PREFIX)

DEPENDS += cross/libpng
CONFIGURE_ARGS += --with-png-dir=$(STAGING_INSTALL_PREFIX)

DEPENDS += cross/libxml2
CONFIGURE_ARGS += --with-libxml-dir=$(STAGING_INSTALL_PREFIX)

DEPENDS += cross/openssl
CONFIGURE_ARGS += --with-openssl=shared,$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-openssl-dir=$(STAGING_INSTALL_PREFIX)

DEPENDS += cross/pcre2
CONFIGURE_ARGS += --with-pcre-dir=$(STAGING_INSTALL_PREFIX)

#DEPENDS += cross/readline
#CONFIGURE_ARGS += --with-readline=$(STAGING_INSTALL_PREFIX)

DEPENDS += cross/sqlite
CONFIGURE_ARGS += --with-sqlite3=shared,$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --without-pdo-sqlite

DEPENDS += cross/libwebp
CONFIGURE_ARGS += --with-webp-dir=$(STAGING_INSTALL_PREFIX)

#DEPENDS += cross/xmlrpc-c
#CONFIGURE_ARGS += --with-xmlrpc=$(STAGING_INSTALL_PREFIX)

DEPENDS += cross/zlib
CONFIGURE_ARGS += --with-zlib=shared,$(STAGING_INSTALL_PREFIX)

CONFIGURE_ARGS += --enable-bcmath
CONFIGURE_ARGS += --enable-calendar
CONFIGURE_ARGS += --enable-dba=shared
CONFIGURE_ARGS += --enable-ftp
CONFIGURE_ARGS += --with-gettext
CONFIGURE_ARGS += --enable-mbstring

include ../../mk/spksrc.cross-cc.mk
