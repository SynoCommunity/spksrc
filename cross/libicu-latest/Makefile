PKG_NAME = libicu
PKG_VERS = 78.3
PKG_EXT = tgz
PKG_DIST_NAME = icu4c-$(PKG_VERS)-sources.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/unicode-org/icu/releases/download/release-$(PKG_VERS)
PKG_DIR = icu/source

# Remarks:
# libicu 74 is the latest version that builds for DSM 6
# libicu >= 75 requires compiler with c++17
MIN_GCC_VERSION = 7

BUILD_DEPENDS = native/libicu

HOMEPAGE = http://site.icu-project.org/home
COMMENT  = International Components for Unicode.
LICENSE  = https://www.unicode.org/copyright.html#License

GNU_CONFIGURE = 1

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
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

NATIVE_BUILD_DIR = $(realpath $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR))

# archive is the only mode built. In library mode the ICU data lives in libicudata.so,
# which DSM ARMv7 systems fail to load at runtime (#7347) and every other arch loads
# slightly slower. postgresql, znc and kiwix each asked for archive themselves; the
# packages that did not were simply broken on ARMv7, so this is not a choice a consumer
# should have to make -- and with the knob gone nothing can make it wrongly. The data file
# archive installs, share/icu/*/icudt*.dat, is a plain PLIST line.
CONFIGURE_ARGS += --with-data-packaging=archive

PRE_COMPILE_TARGET = libicu_prepare_dir
POST_INSTALL_TARGET = libicu_post_install

CONFIGURE_ARGS += --with-cross-build=$(NATIVE_BUILD_DIR) 
CONFIGURE_ARGS += --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --disable-samples
CONFIGURE_ARGS += --disable-tools
CONFIGURE_ARGS += --disable-tests

ADDITIONAL_CFLAGS = -O3

include ../../mk/spksrc.cross-cc.mk

.PHONY: libicu_prepare_dir
libicu_prepare_dir:
	@mkdir -p $(WORK_DIR)/$(PKG_DIR)/data/out/tmp

.PHONY: libicu_post_install
libicu_post_install:
	$(RUN) sed -i 's|$(INSTALL_PREFIX)|$(STAGING_INSTALL_PREFIX)|g' $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/icu-*.pc
