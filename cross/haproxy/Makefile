PKG_NAME = haproxy
PKG_VERS = 2.2.4
PKG_MAIN_VERS=$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.haproxy.org/download/$(PKG_MAIN_VERS)/src
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl cross/lua cross/pcre2

MAINTAINER = SynoCommunity
HOMEPAGE   = https://www.haproxy.org
COMMENT    = HAProxy is a free, very fast and reliable solution offering high availability, load balancing, and proxying for TCP and HTTP-based applications.
LICENSE    = GPLv2

CONFIGURE_TARGET = nop
INSTALL_TARGET = haproxy_install

BUILD_OPTIONS = USE_TPROXY=1 USE_PTHREAD_PSHARED=1 USE_OPENSSL=1 USE_ZLIB=1
BUILD_OPTIONS += USE_PCRE2=1 PCRE2_INC=$(INSTALL_DIR)$(INSTALL_PREFIX)/include PCRE2_LIB=$(INSTALL_DIR)$(INSTALL_PREFIX)/lib
BUILD_OPTIONS += USE_LUA=1 LUA_INC=$(INSTALL_DIR)$(INSTALL_PREFIX)/include LUA_LIB=$(INSTALL_DIR)$(INSTALL_PREFIX)/lib

include ../../mk/spksrc.archs.mk

ARCH_OPTIONS =

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
# ARMv5 and PPC archs (except QorIQ) have older kernels and need rt library for clock_gettime()
BUILD_OPTIONS += USE_RT=1
ADDITIONAL_CFLAGS += -DLUA_32BITS
endif
ifeq ($(findstring $(ARCH), qoriq),$(ARCH))
BUILD_OPTIONS += ADDLIB=-latomic
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
ARCH_OPTIONS = ARCH=x86_64
endif

COMPILE_MAKE_OPTIONS += TARGET=generic $(ARCH_OPTIONS) $(BUILD_OPTIONS) SPKSRC_CFLAGS="$(CFLAGS)" SPKSRC_LDFLAGS="$(LDFLAGS)"

include ../../mk/spksrc.cross-cc.mk

.PHONY: haproxy_install
# define PREFIX (upper case letters)
haproxy_install:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)
