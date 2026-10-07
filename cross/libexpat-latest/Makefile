PKG_NAME = libexpat
PKG_VERS = 2.8.5
PKG_EXT = tar.gz
PKG_DIST_NAME = R_$(subst .,_,$(PKG_VERS)).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libexpat/libexpat/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-R_$(subst .,_,$(PKG_VERS))/expat

DEPENDS =

# Needs gcc >= 4.5: __deprecated__ with message (expat.h) rejected below.
MIN_GCC_VERSION = 4.5

HOMEPAGE = https://libexpat.github.io/
COMMENT  = Expat is an XML parser library written in C. It is a stream-oriented parser in which an application registers handlers for things the parser might find in the XML document (like start tags).
LICENSE  = MIT

CONFIGURE_ARGS  = -DEXPAT_BUILD_TESTS=OFF
CONFIGURE_ARGS += -DEXPAT_BUILD_EXAMPLES=OFF
CONFIGURE_ARGS += -DEXPAT_BUILD_TOOLS=OFF
CONFIGURE_ARGS += -DEXPAT_SHARED_LIBS=ON
# /dev/urandom exists on all DSM versions: real entropy for the hash
# secret where getrandom/getentropy are missing, not the weak fallback
CONFIGURE_ARGS += -DEXPAT_DEV_URANDOM=ON

include ../../mk/spksrc.common.mk

# 2.8.5 dropped the `#ifndef O_CLOEXEC / #define O_CLOEXEC 0` fallback 2.8.4 still had,
# and lib/random_dev_urandom.c asks for the flag through _POSIX_C_SOURCE 200809L. eglibc
# 2.8 predates that: it keeps O_CLOEXEC under __USE_GNU, where 2.10 moved it to
# __USE_XOPEN2K8. Only ppc853x-5.2 is that old, and only it needs the wider namespace.
ifeq ($(call version_lt,$(TC_GLIBC),2.10),1)
ADDITIONAL_CFLAGS += -D_GNU_SOURCE
endif

include ../../mk/spksrc.cross-cmake.mk
