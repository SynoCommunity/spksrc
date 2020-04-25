PKG_NAME = mono
PKG_VERS_MAJOR = 5.18.0
PKG_VERS_MINOR = 240
PKG_VERS = $(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.mono-project.com/sources/mono
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = native/$(PKG_NAME)

HOMEPAGE = http://www.mono-project.com
COMMENT  = Cross platform, open source .NET development framework
LICENSE  = http://www.mono-project.com/docs/faq/licensing

REQUIRED_DSM = 5.0
# Although qoriq can be compiled successfully it won't run as classic floating point unit not available
# For details see: https://github.com/SynoCommunity/spksrc/issues/3470#issuecomment-469391052
UNSUPPORTED_ARCHS = $(PPC_ARCHES)

PRE_CONFIGURE_TARGET = mono_pre_configure
GNU_CONFIGURE = 1
# Avoid building C# code (built natively)
CONFIGURE_ARGS = --disable-mcs-build
# force building with BTLS
# needed for platforms compiling with gcc < 4.8
# patches/001-add-boringssl-alignas-support.patch adds the necessary compatibility
CONFIGURE_ARGS += --enable-btls
# Optimize compilation for size
ADDITIONAL_CFLAGS = -Os

include ../../mk/spksrc.cross-cc.mk

PLIST_TRANSFORM = cat
ifeq ($(findstring $(ARCH), $(ARM5_ARCHES)),$(ARCH))
	AG_ARGS = --host=arm-linux
	PLIST_TRANSFORM = sed -e '/:lib\/libmono-btls-shared.so/d'
endif
ifeq ($(findstring $(ARCH), $(ARM7_ARCHES)),$(ARCH))
	AG_ARGS = --host=arm-linux
	ifeq ($(findstring $(TCVERSION), "5.0 5.1 5.2"),$(TCVERSION))
		PLIST_TRANSFORM = sed -e '/:lib\/libmono-btls-shared.so/d'
	endif
endif
ifeq ($(findstring $(ARCH), $(ARM8_ARCHES)),$(ARCH))
	AG_ARGS = --host=aarch64-linux
	PLIST_TRANSFORM = sed -e '/:bin\/mono-boehm/d' -e '/:lib\/libmonoboehm/d'
endif
ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
	ifeq ($(findstring $(TCVERSION), "5.0 5.1 5.2"),$(TCVERSION))
		PLIST_TRANSFORM = sed -e '/:lib\/libmono-btls-shared.so/d'
	endif
endif
AG_ARGS += --disable-mcs-build

.PHONY: mono_pre_configure
mono_pre_configure:
	$(RUN) ; ./autogen.sh $(AG_ARGS)
