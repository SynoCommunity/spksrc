PKG_NAME = haproxy
PKG_VERS = 3.0.15
PKG_MAIN_VERS=$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.haproxy.org/download/$(PKG_MAIN_VERS)/src
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl3 cross/lua cross/pcre2

MAINTAINER = SynoCommunity
HOMEPAGE   = https://www.haproxy.org
COMMENT    = HAProxy is a free, very fast and reliable solution offering high availability, load balancing, and proxying for TCP and HTTP-based applications.
LICENSE    = GPLv2

CONFIGURE_TARGET = nop
INSTALL_TARGET = haproxy_install

# OpenSSL paths
SSL_INC = $(INSTALL_DIR)$(INSTALL_PREFIX)/include
SSL_LIB = $(INSTALL_DIR)$(INSTALL_PREFIX)/lib

BUILD_OPTIONS = USE_TPROXY=1 USE_PTHREAD_PSHARED=1 USE_OPENSSL=1 USE_ZLIB=1
BUILD_OPTIONS += USE_PCRE2=1 PCRE2_INC=$(INSTALL_DIR)$(INSTALL_PREFIX)/include PCRE2_LIB=$(INSTALL_DIR)$(INSTALL_PREFIX)/lib
BUILD_OPTIONS += USE_LUA=1 LUA_INC=$(INSTALL_DIR)$(INSTALL_PREFIX)/include LUA_LIB=$(INSTALL_DIR)$(INSTALL_PREFIX)/lib
BUILD_OPTIONS += SSL_INC=$(SSL_INC) SSL_LIB=$(SSL_LIB)

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
# ARMv5 and PPC archs (except QorIQ) have older kernels and need rt library for clock_gettime()
BUILD_OPTIONS += USE_RT=1
ADDITIONAL_CFLAGS += -DLUA_32BITS
endif

ifeq ($(findstring $(ARCH), qoriq),$(ARCH))
BUILD_OPTIONS += ADDLIB=-latomic
endif

# Use linux-glibc-legacy target for older glibc compatibility (DSM 7.1 has glibc 2.26)
# Pass explicit CC and LD for cross-compilation
COMPILE_MAKE_OPTIONS += TARGET=linux-glibc-legacy $(BUILD_OPTIONS)
COMPILE_MAKE_OPTIONS += CC=$(TC_PATH)$(TC_PREFIX)gcc LD=$(TC_PATH)$(TC_PREFIX)gcc
COMPILE_MAKE_OPTIONS += CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"

include ../../mk/spksrc.cross-cc.mk

.PHONY: haproxy_install
haproxy_install:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)
