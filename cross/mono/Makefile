PKG_NAME = mono
PKG_VERS_MAJOR = 5.18.0
PKG_VERS_MINOR = 225
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
UNSUPPORTED_ARCHS = $(PPC_ARCHES)
GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = mono_pre_configure

# Avoid building C# code (built natively)
CONFIGURE_ARGS = --disable-mcs-build

# force building with BTLS
# needed for platforms compiling with gcc < 4.8
# patches/001-add-boringssl-alignas-support.patch adds the necessary compatibility
CONFIGURE_ARGS += --enable-btls

include ../../mk/spksrc.cross-cc.mk

AG_ARGS = --disable-mcs-build
ifeq ($(findstring $(ARCH), $(ARM_ARCHES)),$(ARCH))
	AG_ARGS += --host=arm-linux
endif

.PHONY: mono_pre_configure
mono_pre_configure:
	$(RUN) ; ./autogen.sh ${AG_ARGS}
