PKG_NAME = libmicrohttpd
PKG_VERS = 1.0.7
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/libmicrohttpd
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.gnu.org/software/libmicrohttpd/
COMMENT = GNU libmicrohttpd is a small C library that is supposed to make it easy to run an HTTP server as part of another application.
LICENSE = LGPLv2.1

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --disable-examples
CONFIGURE_ARGS += --disable-doc

include ../../mk/spksrc.cross-cc.mk
