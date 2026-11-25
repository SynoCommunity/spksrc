PKG_NAME = redis
PKG_VERS = 8.12.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.redis.io/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# 8.12's bundled hdr_histogram needs GCC 4.8; GCC 4.7 x86 builds fail
# on its SSE intrinsics/builtins.
MIN_GCC_VERSION = 4.8

HOMEPAGE = https://redis.io
COMMENT  = Redis is an open source, advanced key-value store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets and sorted sets.
LICENSE  = RSALv2 / SSPLv1 / AGPLv3

include ../../mk/spksrc.common.mk

# Link to atomic library for QorIQ architecture
ifneq ($(findstring $(ARCH),qoriq),)
CONFIGURE_TARGET = redis_patch_makefile_to_use_atomic_library
else
CONFIGURE_TARGET = nop
endif

# Redis 8.12 builds bundled modules by default. Pass none to both build and
# install/deploy so this package ships the server core only.
INSTALL_ARGS = install none PREFIX=$(STAGING_INSTALL_PREFIX)
COMPILE_ARGS += build none

# Use jemalloc on Intel architectures.
ifeq ($(findstring $(ARCH),$(x64_ARCHS) $(i686_ARCHS)),$(ARCH))
ENV += USE_JEMALLOC=yes
else
ENV += USE_JEMALLOC=no
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: redis_patch_makefile_to_use_atomic_library
redis_patch_makefile_to_use_atomic_library:
	@$(RUN) sed -i 's/^FINAL_LIBS=-lm/FINAL_LIBS=-lm -latomic/' $(WORK_DIR)/$(PKG_DIR)/src/Makefile
