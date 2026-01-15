PKG_NAME = phc-winner-argon2
PKG_VERS = 20190702
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/P-H-C/phc-winner-argon2/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/P-H-C/phc-winner-argon2/
COMMENT  = The password hash Argon2, winner of PHC.
LICENSE  = Apache 2.0

CONFIGURE_TARGET = nop

ENV += DESTDIR=$(INSTALL_DIR)
ENV += PREFIX=$(INSTALL_PREFIX)
# avoid host machine specific library path:
ENV += LIBRARY_REL=lib

include ../../mk/spksrc.common.mk

# To ensure compatibility with Denverton celeron CPU
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
ADDITIONAL_CFLAGS += -mno-avx -mno-avx2 -mno-sse4.1 -mno-sse4.2
ADDITIONAL_CFLAGS += -mno-bmi -mno-bmi2
ADDITIONAL_CFLAGS += -DARGON2_NO_INTRINSICS -DBLAKE2_USE_PORTABLE
ADDITIONAL_CFLAGS += -march=core2 -mtune=core2
endif

# To ensure compatibility with Evansport i686 CPU
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
ADDITIONAL_CFLAGS += -mno-sse4.1 -mno-sse4.2
ADDITIONAL_CFLAGS += -DARGON2_NO_INTRINSICS -DBLAKE2_USE_PORTABLE
ADDITIONAL_CFLAGS += -march=core2 -mtune=core2
endif

include ../../mk/spksrc.cross-cc.mk
