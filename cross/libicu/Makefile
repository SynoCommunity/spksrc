PKG_NAME = libicu
PKG_VERS_MAJOR = 67
PKG_VERS_MINOR = 1
PKG_VERS = $(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)
PKG_EXT = tgz

PKG_DIST_NAME = icu4c-$(PKG_VERS_MAJOR)_$(PKG_VERS_MINOR)-src.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/unicode-org/icu/releases/download/release-$(PKG_VERS_MAJOR)-$(PKG_VERS_MINOR)
PKG_DIR = icu/source

BUILD_DEPENDS = native/$(PKG_NAME)

HOMEPAGE = http://site.icu-project.org/home
COMMENT  = International Components for Unicode
LICENSE  = https://www.unicode.org/copyright.html#License

GNU_CONFIGURE = 1
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
CONFIGURE_ARGS = --host=arm-unknown-linux-gnueabi
endif
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
CONFIGURE_ARGS = --host=arm-unknown-linux-gnueabi
endif
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CONFIGURE_ARGS = --host=aarch64-unknown-linux-gnu
endif
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
CONFIGURE_ARGS = --host=powerpc-unknown-linux-gnu
endif
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
CONFIGURE_ARGS = --host=i686-pc-linux-gnu
endif
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CONFIGURE_ARGS = --host=x86_64-pc-linux-gnu
endif
NATIVE_BUILD_DIR = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR)
CONFIGURE_ARGS += --with-cross-build=$(NATIVE_BUILD_DIR) --prefix=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
