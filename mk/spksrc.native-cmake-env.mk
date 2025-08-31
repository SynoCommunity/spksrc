# Configuration for CMake build of native packages
#
CMAKE_ARGS += -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)
CMAKE_ARGS += -DCMAKE_BUILD_TYPE=Release

# Use native cmake (latest stable)
ifeq ($(strip $(USE_NATIVE_CMAKE)),1)
  BUILD_DEPENDS += native/cmake
  CMAKE_PATH = $(abspath $(CURDIR)/../../native/cmake/work-native/install/usr/local/bin)
  ENV += PATH=$(CMAKE_PATH):$$PATH
  export PATH := $(CMAKE_PATH):$(PATH)
endif

# Use native cmake (Debian 10 "Buster")
ifeq ($(strip $(USE_NATIVE_CMAKE_LEGACY)),1)
  BUILD_DEPENDS += native/cmake-legacy
  CMAKE_PATH = $(abspath $(CURDIR)/../../native/cmake-legacy/work-native/install/usr/local/bin)
  ENV += PATH=$(CMAKE_PATH):$$PATH
  export PATH := $(CMAKE_PATH):$(PATH)
endif

# Use ninja to build
ifeq ($(strip $(CMAKE_USE_NINJA)),)
  CMAKE_USE_NINJA = 1
endif
ifeq ($(strip $(CMAKE_USE_NINJA)),1)
  CMAKE_ARGS += -G Ninja
endif

# set default use destdir
ifeq ($(strip $(CMAKE_USE_DESTDIR)),)
  CMAKE_USE_DESTDIR = 1
endif

# set default destdir directory
ifeq ($(strip $(CMAKE_DESTDIR)),)
  CMAKE_DESTDIR = $(INSTALL_DIR)
endif

# set default build directory
ifeq ($(strip $(CMAKE_BUILD_DIR)),)
  CMAKE_BUILD_DIR = $(WORK_DIR)/$(PKG_DIR)/build
endif
