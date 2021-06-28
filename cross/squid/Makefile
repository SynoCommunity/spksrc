PKG_NAME = squid
PKG_VERS = 5.0.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(shell echo '$(PKG_NAME)' | tr '[:lower:]' '[:upper:]')_$(subst .,_,$(PKG_VERS)).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/squid-cache/squid/archive
PKG_DIR = $(PKG_NAME)-$(shell echo '$(PKG_NAME)' | tr '[:lower:]' '[:upper:]')_$(subst .,_,$(PKG_VERS))

DEPENDS = cross/openssl

HOMEPAGE = http://www.squid-cache.org/
COMMENT  = Squid is a fully-featured HTTP/1.0 proxy which is almost HTTP/1.1 compliant.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = $(TC_CONFIGURE_ARGS)
CONFIGURE_ARGS += --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --enable-icap-client
CONFIGURE_ARGS += --disable-strict-error-checking
CONFIGURE_ARGS += --enable-ssl
CONFIGURE_ARGS += --enable-arp-acl
CONFIGURE_ARGS += --enable-delay-pools
CONFIGURE_ARGS += squid_cv_check_marchnative=yes

# Toolchains lacking c++11 in conjunction with
# march=native compiler are not supported
include ../../mk/spksrc.common.mk
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
UNSUPPORTED_ARCHS += $(PPC_ARCHS)
UNSUPPORTED_ARCHS += $(ARM_ARCHS)
endif

PRE_CONFIGURE_TARGET = squid_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: squid_pre_configure
squid_pre_configure:
	$(RUN) ./bootstrap.sh
