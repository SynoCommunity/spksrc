PKG_NAME = re2c
PKG_VERS = 3.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/skvadrik/re2c/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = http://re2c.org/
COMMENT  = re2c is a free and open-source lexer generator for C/C++, Go and Rust with a focus on generating fast code.
LICENSE  = PHP License, version 3.01

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = re2c_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: re2c_pre_configure
re2c_pre_configure:
	$(RUN) ./autogen.sh
