
PKG_NAME = tinyproxy
PKG_VERS = 1.8.3
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://banu.com/pub/tinyproxy/1.8
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

MAINTAINER = packages@packages.nas-forum.com
HOMEPAGE   = https://banu.com/tinyproxy/
COMMENT    = Tinyproxy is a light-weight HTTP/HTTPS proxy daemon for POSIX operating systems.
LICENSE    = GNU GPL 2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-regexcheck ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes 

ADDITIONAL_CFLAGS =

include ../../mk/spksrc.cross-cc.mk
