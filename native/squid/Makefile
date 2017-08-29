PKG_NAME = squid
PKG_VERS_MAJOR = 3.5
PKG_VERS_MINOR = 27
PKG_VERS = $(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.squid-cache.org/Versions/v3/$(PKG_VERS_MAJOR)/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/berkeleydb

HOMEPAGE = http://www.squid-cache.org/
COMMENT  = Squid is a fully-featured HTTP/1.0 proxy which is almost HTTP/1.1 compliant.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = $(TC_CONFIGURE_ARGS) --prefix=$(INSTALL_PREFIX) --enable-icap-client --disable-strict-error-checking

COMPILE_TARGET = myCompile
INSTALL_TARGET = noop

include ../../mk/spksrc.native-cc.mk

myCompile:
	$(RUN) ;cd src;$(MAKE) cf_gen_defines.cci cf_gen

