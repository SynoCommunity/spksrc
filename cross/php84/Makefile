PKG_NAME = php
PKG_VERS = 8.4.15
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.php.net/distributions
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# Core dependencies
DEPENDS  = cross/zlib
DEPENDS += cross/openssl3
DEPENDS += cross/libxml2
DEPENDS += cross/sqlite
DEPENDS += cross/curl
DEPENDS += cross/oniguruma
DEPENDS += cross/libzip
DEPENDS += cross/icu
DEPENDS += cross/freetype
DEPENDS += cross/libpng
DEPENDS += cross/libjpeg
DEPENDS += cross/libgd
DEPENDS += cross/bzip2
DEPENDS += cross/libsodium
DEPENDS += cross/readline
DEPENDS += cross/ncurses
DEPENDS += cross/gmp
DEPENDS += cross/libffi

HOMEPAGE = https://www.php.net
COMMENT  = PHP Hypertext Preprocessor
LICENSE  = PHP-3.01

GNU_CONFIGURE = 1
ADDITIONAL_CFLAGS = -I$(STAGING_INSTALL_PREFIX)/include
ADDITIONAL_LDFLAGS = -L$(STAGING_INSTALL_PREFIX)/lib

# PHP Configure arguments
CONFIGURE_ARGS  = --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --sysconfdir=$(INSTALL_PREFIX)/etc
CONFIGURE_ARGS += --with-config-file-path=$(INSTALL_PREFIX)/etc
CONFIGURE_ARGS += --with-config-file-scan-dir=$(INSTALL_PREFIX)/etc/conf.d

# SAPI modules
CONFIGURE_ARGS += --enable-fpm
CONFIGURE_ARGS += --disable-cgi
CONFIGURE_ARGS += --enable-cli

# Core extensions (built-in)
CONFIGURE_ARGS += --enable-bcmath
CONFIGURE_ARGS += --enable-calendar
CONFIGURE_ARGS += --enable-ctype
CONFIGURE_ARGS += --enable-exif
CONFIGURE_ARGS += --enable-fileinfo
CONFIGURE_ARGS += --enable-filter
CONFIGURE_ARGS += --enable-ftp
CONFIGURE_ARGS += --enable-intl
CONFIGURE_ARGS += --enable-mbstring
CONFIGURE_ARGS += --enable-opcache
CONFIGURE_ARGS += --enable-pcntl
CONFIGURE_ARGS += --enable-pdo
CONFIGURE_ARGS += --enable-phar
CONFIGURE_ARGS += --enable-posix
CONFIGURE_ARGS += --enable-session
CONFIGURE_ARGS += --enable-shmop
CONFIGURE_ARGS += --enable-soap
CONFIGURE_ARGS += --enable-sockets
CONFIGURE_ARGS += --enable-sysvmsg
CONFIGURE_ARGS += --enable-sysvsem
CONFIGURE_ARGS += --enable-sysvshm
CONFIGURE_ARGS += --enable-tokenizer
CONFIGURE_ARGS += --enable-xml

# Extensions with dependencies
CONFIGURE_ARGS += --with-bz2=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-curl=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-ffi=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-freetype=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-gd=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --enable-gd
CONFIGURE_ARGS += --with-jpeg=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-gmp=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-libxml=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-mhash
CONFIGURE_ARGS += --with-openssl=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-readline=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-sodium=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-zip=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-zlib=$(STAGING_INSTALL_PREFIX)

# Database extensions
CONFIGURE_ARGS += --enable-mysqlnd
CONFIGURE_ARGS += --with-mysqli=mysqlnd
CONFIGURE_ARGS += --with-pdo-mysql=mysqlnd
CONFIGURE_ARGS += --with-pdo-sqlite=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-sqlite3=$(STAGING_INSTALL_PREFIX)

# Disable problematic features for cross-compilation
CONFIGURE_ARGS += --disable-phpdbg
CONFIGURE_ARGS += --without-valgrind

include ../../mk/spksrc.cross-cc.mk
