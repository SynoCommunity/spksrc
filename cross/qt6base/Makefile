PKG_NAME = qt6base
PKG_VERS = 6.12.0
PKG_EXT = tar.xz
PKG_DIST_NAME = qtbase-everywhere-src-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.qt.io/archive/qt/6.12/6.12.0/submodules
PKG_DIR = qtbase-everywhere-src-$(PKG_VERS)

HOMEPAGE = https://www.qt.io/
COMMENT  = Qt 6 Base (Core only)
LICENSE  = LGPL-3.0

MIN_GCC_VERSION = 10

BUILD_DEPENDS = native/cmake native/qt6base

NATIVE_CMAKE_DIR = $(abspath $(CURDIR)/../../native/cmake/work-native/install/usr/local/bin)
ENV += PATH=$(NATIVE_CMAKE_DIR):$$PATH

NATIVE_QT6_DIR = $(realpath $(WORK_DIR)/../../../native/qt6base/work-native/install/usr/local)

BUILD_DIR = $(WORK_DIR)/build

CONFIGURE_ARGS = -qt-host-path $(NATIVE_QT6_DIR)
CONFIGURE_ARGS += -prefix $(INSTALL_PREFIX)
CONFIGURE_ARGS += -release -no-gui -no-widgets -no-opengl -no-dbus -no-glib -no-icu -no-ssl
CONFIGURE_ARGS += -no-feature-zstd -no-feature-network -no-feature-sql -no-feature-testlib
CONFIGURE_ARGS += -no-feature-xml -no-feature-concurrent
CONFIGURE_ARGS += -nomake examples -nomake tests -platform linux-g++
CONFIGURE_ARGS += -- -DCMAKE_SYSROOT=$(TC_WORK_DIR)/$(TC_TARGET)/$(TC_SYSROOT)
CONFIGURE_ARGS += -DCMAKE_FIND_ROOT_PATH=$(TC_WORK_DIR)/$(TC_TARGET)/$(TC_SYSROOT)
CONFIGURE_ARGS += -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY
CONFIGURE_ARGS += -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY
CONFIGURE_ARGS += -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ONLY

COMPILE_TARGET = qt6base_compile
INSTALL_TARGET = qt6base_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: qt6base_compile
qt6base_compile:
	$(BUILD_RUN) cmake --build . -j $(NCPUS)

.PHONY: qt6base_install
qt6base_install:
	$(BUILD_RUN) DESTDIR=$(INSTALL_DIR) cmake --install .
