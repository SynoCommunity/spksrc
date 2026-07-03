PKG_NAME = squid
PKG_VERS = 5.0.4
PKG_EXT = tar.gz
PKG_DIST_NAME = SQUID_$(subst .,_,$(PKG_VERS)).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/squid-cache/squid/archive
PKG_DIR = $(PKG_NAME)-SQUID_$(subst .,_,$(PKG_VERS))

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

include ../../mk/spksrc.common.mk

# Toolchains lacking c++11 in conjunction with
# march=native compiler are not supported
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
ADDITIONAL_CXXFLAGS  = -mfloat-abi=hard
ADDITIONAL_CXXFLAGS += -mfpu=neon
endif

# Use native g++ compiler to build a
# host compatible working cf_gen binary
ENV += BUILDCXX=g++
ENV += BUILDCXXFLAGS=-march=native

PRE_CONFIGURE_TARGET = squid_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: squid_pre_configure
squid_pre_configure:
	$(RUN) ./bootstrap.sh
