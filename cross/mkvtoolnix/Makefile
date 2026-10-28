PKG_NAME = mkvtoolnix
PKG_VERS = 103.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://mkvtoolnix.download/sources
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# MKVToolNix 103 requires C++20 and GCC >= 10, hence DSM 7.2+
MIN_GCC_VERSION = 10

BUILD_DEPENDS = native/ruby native/qt6base
DEPENDS = cross/qt6base
DEPENDS += cross/boost-1.92 cross/gmp
DEPENDS += cross/libogg cross/libvorbis cross/zlib
DEPENDS += cross/flac

HOMEPAGE = https://mkvtoolnix.org/
COMMENT  = MKVToolNix - Ultimate Tool for Editing and Merging MKV Files.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
COMPILE_TARGET = mkvtoolnix_compile
INSTALL_TARGET = mkvtoolnix_install

CONFIGURE_ARGS = --prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-boost-libdir=$(STAGING_INSTALL_PREFIX)/lib
CONFIGURE_ARGS += --enable-gui=no
CONFIGURE_ARGS += --with-qmake6=$(CURDIR)/files/qmake6

BOOST_LIBRARIES = filesystem system
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"

NATIVE_RUBY_DIR = $(realpath $(WORK_DIR)/../../../native/ruby/work-native/install/usr/local/bin)
ENV += PATH=$(NATIVE_RUBY_DIR):$$PATH

NATIVE_QT6_DIR = $(realpath $(WORK_DIR)/../../../native/qt6base/work-native/install/usr/local)
ENV += QMAKE6_HOST_PREFIX=$(NATIVE_QT6_DIR)
ENV += QMAKE6_TARGET_PREFIX=$(STAGING_INSTALL_PREFIX)

ADDITIONAL_CXXFLAGS += -Os

include ../../mk/spksrc.cross-cc.mk

.PHONY: mkvtoolnix_compile
mkvtoolnix_compile:
	$(RUN) rake

.PHONY: mkvtoolnix_install
mkvtoolnix_install:
	$(RUN) rake install
