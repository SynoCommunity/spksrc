PKG_NAME = squid
PKG_VERS = 5.0.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(shell echo '$(PKG_NAME)' | tr '[:lower:]' '[:upper:]')_$(subst .,_,$(PKG_VERS)).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/squid-cache/squid/archive
PKG_DIR = $(PKG_NAME)-$(shell echo '$(PKG_NAME)' | tr '[:lower:]' '[:upper:]')_$(subst .,_,$(PKG_VERS))

DEPENDS = 

HOMEPAGE = http://www.squid-cache.org
COMMENT  = Squid is a fully-featured HTTP/1.0 proxy which is almost HTTP/1.1 compliant.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = $(TC_CONFIGURE_ARGS) --prefix=$(INSTALL_PREFIX) --enable-icap-client --disable-strict-error-checking

PRE_CONFIGURE_TARGET = squid_native_pre_configure
COMPILE_TARGET = squid_native_compile
INSTALL_TARGET = nop

include ../../mk/spksrc.native-cc.mk

.PHONY: squid_native_pre_configure
squid_native_pre_configure:
	$(RUN) ./bootstrap.sh

.PHONY: squid_native_compile
squid_native_compile:
	$(RUN) ;cd src;$(MAKE) cf_gen_defines.cci cf_gen
