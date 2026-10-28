PKG_NAME = qt6base
PKG_VERS = 6.12.0
PKG_EXT = tar.xz
PKG_DIST_NAME = qtbase-everywhere-src-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.qt.io/archive/qt/6.12/6.12.0/submodules
PKG_DIR = qtbase-everywhere-src-$(PKG_VERS)

HOMEPAGE = https://www.qt.io/
COMMENT  = Qt 6 Base (host tools)
LICENSE  = LGPL-3.0

BUILD_DEPENDS = native/cmake

NATIVE_CMAKE_DIR = $(abspath $(CURDIR)/../../native/cmake/work-native/install/usr/local/bin)
ENV += PATH=$(NATIVE_CMAKE_DIR):$$PATH

BUILD_DIR = $(WORK_DIR)/build

CONFIGURE_ARGS = -prefix $(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += -release -no-gui -no-widgets -no-opengl -no-dbus -no-glib -no-icu -no-ssl
CONFIGURE_ARGS += -no-feature-zstd -no-feature-network -no-feature-sql -no-feature-testlib
CONFIGURE_ARGS += -no-feature-xml -no-feature-concurrent
CONFIGURE_ARGS += -nomake examples -nomake tests

COMPILE_TARGET = qt6base_compile
INSTALL_TARGET = qt6base_install

include ../../mk/spksrc.native-cc.mk

.PHONY: qt6base_compile
qt6base_compile:
	$(BUILD_RUN) cmake --build . -j $(NCPUS)

.PHONY: qt6base_install
qt6base_install:
	$(BUILD_RUN) cmake --install .
