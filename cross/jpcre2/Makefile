PKG_NAME = jpcre2
PKG_VERS = 10.32.01
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/jpcre2/jpcre2/archive
PKG_DIST_FILE=$(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/pcre2

HOMEPAGE = https://docs.neurobin.org/jpcre2/
COMMENT = C++ wrapper for PCRE2 library.
LICENSE = BSD

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-test

PRE_CONFIGURE_TARGET = jpcre2_pre_configure_target

include ../../mk/spksrc.cross-cc.mk

.PHONY: jpcre2_pre_configure_target
jpcre2_pre_configure_target:
	$(RUN) ./autogen.sh
