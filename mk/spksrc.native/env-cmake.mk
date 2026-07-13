###############################################################################
# spksrc.native/env-cmake.mk
#
# Configuration for NATIVE CMake build
#
###############################################################################

# Declare the build system (mirrors the cross env-cmake.mk) so the gnu-make
# COMPILE_ARGS / INSTALL_ARGS defaults are not applied to native cmake builds.
DEFAULT_ENV ?= cmake

ifeq ($(strip $(filter -DCMAKE_BUILD_TYPE=%,$(CONFIGURE_ARGS))),)
CONFIGURE_ARGS += -DCMAKE_BUILD_TYPE=Release
endif

# Native build: install to staging prefix with
# RPATH pointing to ../lib for relocatable execution
CONFIGURE_ARGS += -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)
CONFIGURE_ARGS += -DCMAKE_INSTALL_RPATH='$$ORIGIN/../lib'
CONFIGURE_ARGS += -DCMAKE_BUILD_WITH_INSTALL_RPATH=OFF
CONFIGURE_ARGS += -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=OFF

# Use native cmake (latest stable)
ifeq ($(strip $(USE_NATIVE_CMAKE)),1)
  BUILD_DEPENDS += native/cmake
  CMAKE_PATH = $(abspath $(CURDIR)/../../native/cmake/work-native/install/usr/local/bin)
  ENV += PATH=$(CMAKE_PATH):$$PATH
  export PATH := $(CMAKE_PATH):$(PATH)
endif

# Use ninja to build
ifeq ($(strip $(CMAKE_USE_NINJA)),)
  CMAKE_USE_NINJA = 1
endif
ifeq ($(strip $(CMAKE_USE_NINJA)),1)
  CONFIGURE_ARGS += -G Ninja
endif

# set default ASM build environment
ifeq ($(strip $(CMAKE_USE_NASM)),1)
  DEPENDS += native/nasm
  NASM_PATH = $(realpath $(WORK_DIR)/../../../native/nasm/work-native/install/usr/local/bin)
  ENV += PATH=$(NASM_PATH):$$PATH
  ENV += AS=$(NASM_PATH)/nasm
  CONFIGURE_ARGS += -DENABLE_ASSEMBLY=ON
  CONFIGURE_ARGS += -DCMAKE_ASM_COMPILER=$(NASM_PATH)/nasm
else
  CMAKE_USE_NASM = 0
endif

# set default use destdir
ifeq ($(strip $(CMAKE_USE_DESTDIR)),)
  CMAKE_USE_DESTDIR = 1
endif

# set default destdir directory
ifeq ($(strip $(CMAKE_DESTDIR)),)
  CMAKE_DESTDIR = $(INSTALL_DIR)
endif

ifeq ($(strip $(CMAKE_BASE_DIR)),)
  CMAKE_BASE_DIR = $(WORK_DIR)/$(PKG_DIR)
endif

# set default build directory
ifeq ($(strip $(CMAKE_BUILD_DIR)),)
  CMAKE_BUILD_DIR = $(WORK_DIR)/$(PKG_DIR)/build
endif
