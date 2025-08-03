PKG_NAME = liburcu
PKG_REAL_NAME = userspace-rcu
PKG_VERS = 0.13.4
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_REAL_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://lttng.org/files/urcu/
PKG_DIR = $(PKG_REAL_NAME)-$(PKG_VERS)

# liburcu v0.13.4 is the latest version supported by OLD_PPC_ARCHS and ARMv5_ARCHS

DEPENDS =

HOMEPAGE = https://liburcu.org/
COMMENT  = userspace RCU (read-copy-update) library. This data synchronization library provides read-side access which scales linearly with the number of cores.
LICENSE  = LGPLv2.1

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --disable-static

include ../../mk/spksrc.common.mk

# for hi3535-6.2.4 and x86-5.2
ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --disable-compiler-tls
else ifeq ($(ARCH)-$(TCVERSION),x86-5.2)
CONFIGURE_ARGS += --disable-compiler-tls
endif

# avoid optimization for aarch64 with gcc < 5.0 due compiler bug (see patch for aarch64.h)
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
# for unknown reasons $(TC_GCC) does not work here, evaluate $(TCVERSION) >= 7 instead
ifeq ($(call version_ge, $(TCVERSION), 7.0),1)
ADDITIONAL_CFLAGS += -O2
endif
else
ADDITIONAL_CFLAGS += -O2
endif

include ../../mk/spksrc.cross-cc.mk
