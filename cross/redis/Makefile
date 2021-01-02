PKG_NAME = redis
PKG_VERS = 5.0.7
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.redis.io/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://redis.io
COMMENT  = Redis is an open source, advanced key-value store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets and sorted sets.
LICENSE  = BSD

include ../../mk/spksrc.archs.mk

GNU_CONFIGURE = 1

# Link to atomic library for QorIQ architecture
ifneq ($(findstring $(ARCH),qoriq),)
CONFIGURE_TARGET = redis_patch_makefile_to_use_atomic_library
else
CONFIGURE_TARGET = nop
endif

INSTALL_TARGET = redis_install

# use jemalloc for intel archs
ifeq ($(findstring $(ARCH),$(x64_ARCHS) $(i686_ARCHS)),$(ARCH))
ENV += USE_JEMALLOC=yes
else
ENV += USE_JEMALLOC=no
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: redis_patch_makefile_to_use_atomic_library
redis_patch_makefile_to_use_atomic_library:
	$(RUN) sed -i 's/^FINAL_LIBS=-lm/FINAL_LIBS=-lm -latomic/' $(WORK_DIR)/$(PKG_DIR)/src/Makefile

.PHONY: redis_install
redis_install:
	$(RUN) $(MAKE) install PREFIX=$(STAGING_INSTALL_PREFIX)
