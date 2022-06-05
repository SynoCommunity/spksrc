PKG_NAME = libicu
PKG_VERS = 71.1
PKG_EXT = tgz
PKG_DIST_NAME = icu4c-$(subst .,_,$(PKG_VERS))-src.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/unicode-org/icu/releases/download/release-$(subst .,-,$(PKG_VERS))
PKG_DIR = icu/source

BUILD_DEPENDS = native/$(PKG_NAME)

HOMEPAGE = http://site.icu-project.org/home
COMMENT  = International Components for Unicode.
LICENSE  = https://www.unicode.org/copyright.html#License

include ../../mk/spksrc.archs.mk

# Compiler too old, stdc++11 is required.
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

GNU_CONFIGURE = 1

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

# the packaging can be customized in a dependent package by definition
# of LIBICU_DATA_PACKAGING_MODE like:
# export LIBICU_DATA_PACKAGING_MODE=files
# 
# valid data packaging values are
# - library (the default)
# - archive
# - files
DATA_PACKAGING = $(LIBICU_DATA_PACKAGING_MODE)
ifeq ($(strip $(DATA_PACKAGING)),)
# default data packaging
DATA_PACKAGING = library
endif
CONFIGURE_ARGS += --with-data-packaging=$(DATA_PACKAGING)

ifeq ($(strip $(DATA_PACKAGING)),"files")
# needs a custom install target to successfully build.
INSTALL_TARGET = libicu_install_with_data_files
endif

CONFIGURE_ARGS += --with-cross-build=$(NATIVE_BUILD_DIR) 
CONFIGURE_ARGS += --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --disable-samples
CONFIGURE_ARGS += --disable-tools
CONFIGURE_ARGS += --disable-tests

ADDITIONAL_CFLAGS = -O3
ADDITIONAL_CPPFLAGS = -D_GLIBCXX_USE_C99_MATH -D_GLIBCXX_HAVE_OBSOLETE_ISNAN -D_GLIBCXX_HAVE_OBSOLETE_ISINF
ADDITIONAL_CXXFLAGS = $(ADDITIONAL_CPPFLAGS)

include ../../mk/spksrc.cross-cc.mk

.PHONY: libicu_install_with_data_files
libicu_install_with_data_files:
	$(RUN) $(MAKE) DESTDIR=$(INSTALL_DIR) ICUPKGDATA_DIR=$(INSTALL_PREFIX)/share install PREFIX=$(INSTALL_PREFIX)
