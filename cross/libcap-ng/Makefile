PKG_NAME = libcap-ng
PKG_VERS = 0.8.5
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/stevegrubb/libcap-ng/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/stevegrubb/libcap-ng/?tab=readme-ov-file#readme
COMMENT  = Libcap-ng is a library for Linux that makes using posix capabilities easy.
LICENSE  = LGPLv2

PRE_CONFIGURE_TARGET = libcap-ng_pre_configure

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static

ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk

.PHONY: libcap-ng_pre_configure
libcap-ng_pre_configure: 
	@$(RUN) ; ./autogen.sh
