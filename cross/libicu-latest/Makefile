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

# archive is the default: in library mode the ICU data lives in libicudata.so, which DSM
# ARMv7 systems fail to load at runtime (#7347). Every package that cared said so for
# itself -- postgresql, znc -- and the ones that did not were simply broken there, so the
# working mode belongs here rather than in each consumer.
#
# A dependent package can still ask for the other one:
# export LIBICU_DATA_PACKAGING_MODE=library
#
# valid data packaging values are
# - archive (the default)
# - library

DATA_PACKAGING = $(LIBICU_DATA_PACKAGING_MODE)
ifeq ($(strip $(DATA_PACKAGING)),)
# default data packaging
DATA_PACKAGING = archive
endif
CONFIGURE_ARGS += --with-data-packaging=$(DATA_PACKAGING)

ifeq ($(strip $(DATA_PACKAGING)),archive)
# add the ICU data file.
PLIST_TRANSFORM = sed -e '$$a rsc:share/icu/*/icudt*.dat'
endif

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
