PKG_NAME = squid
PKG_VERS = 3.1.22
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.squid-cache.org/Versions/v$(word 1,$(subst ., ,$(PKG_VERS)))/$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = http://www.squid-cache.org
COMMENT  = Squid is a fully-featured HTTP/1.0 proxy which is almost HTTP/1.1 compliant.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = $(TC_CONFIGURE_ARGS) --prefix=$(INSTALL_PREFIX) --enable-icap-client --disable-strict-error-checking

COMPILE_TARGET = squid_native_compile
INSTALL_TARGET = nop

include ../../mk/spksrc.native-cc.mk

.PHONY: squid_native_compile
squid_native_compile:
	$(RUN) ;cd src;$(MAKE) cf_gen_defines.cci cf_gen
