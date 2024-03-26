PKG_NAME = mono
PKG_VERS = 6.12.0.182
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.mono-project.com/sources/mono
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# native/mono must be of the same version
BUILD_DEPENDS = native/mono

HOMEPAGE = https://www.mono-project.com
COMMENT  = Cross platform, open source .NET development framework.
LICENSE  = https://www.mono-project.com/docs/faq/licensing

# Although qoriq can be compiled successfully it won't run as a classic floating point unit is not available
# For details see: https://github.com/SynoCommunity/spksrc/issues/3470#issuecomment-469391052
UNSUPPORTED_ARCHS = $(PPC_ARCHS)

PRE_CONFIGURE_TARGET = mono_pre_configure
GNU_CONFIGURE = 1
# Avoid building C# code (built natively)
CONFIGURE_ARGS = --disable-mcs-build
# force building with BTLS
# needed for platforms compiling with gcc < 4.8
# patches/001-add-boringssl-alignas-support.patch adds the necessary compatibility
CONFIGURE_ARGS += --enable-btls
CONFIGURE_ARGS += --disable-dependency-tracking
CONFIGURE_ARGS += --without-mcs-docs
CONFIGURE_ARGS += --disable-boehm
CONFIGURE_ARGS += --without-ikvm-native
# disable some features
CONFIGURE_ARGS += --enable-minimal=profiler

# Optimize compilation for minimal size
ADDITIONAL_CFLAGS  = -Os

include ../../mk/spksrc.common.mk

PLIST_TRANSFORM = cat
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
	AG_ARGS = --host=arm-linux
	# enforce build of BTLS library
	CONFIGURE_ARGS += ac_cv_header_stdalign_h=yes
endif
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
	AG_ARGS = --host=arm-linux
endif
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
	AG_ARGS = --host=aarch64-linux
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
	# fix for https://github.com/SynoCommunity/spksrc/issues/3666
	ADDITIONAL_CFLAGS += -fno-split-wide-types
endif
endif
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
endif
AG_ARGS += --disable-mcs-build
AG_ARGS += --disable-boehm
AG_ARGS += --without-ikvm-native

include ../../mk/spksrc.cross-cc.mk

.PHONY: mono_pre_configure
mono_pre_configure:
	$(RUN) ; ./autogen.sh $(AG_ARGS)
