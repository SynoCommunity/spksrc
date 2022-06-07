# Configuration for CMake build
#
CMAKE_ARGS += -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)
CMAKE_ARGS += -DCMAKE_BUILD_TYPE=Release

# Use native cmake
ifeq ($(strip $(USE_NATIVE_CMAKE)),1)
  BUILD_DEPENDS += native/cmake
  CMAKE_PATH = $(realpath $(WORK_DIR)/../../../native/cmake/work-native/install/usr/local/bin)
  ENV += PATH=$(CMAKE_PATH):$$PATH
endif

# Use ninja to build
ifeq ($(strip $(CMAKE_USE_NINJA)),)
  CMAKE_USE_NINJA = 0
endif
ifeq ($(strip $(CMAKE_USE_NINJA)),1)
  CMAKE_ARGS += -G Ninja
endif

# set default ASM build environment
ifeq ($(strip $(CMAKE_USE_NASM)),1)
  DEPENDS += native/nasm
  NASM_PATH = $(WORK_DIR)/../../../native/nasm/work-native/install/usr/local/bin
  ENV += PATH=$(NASM_PATH):$$PATH
  ENV += AS=$(NASM_PATH)/nasm
  CMAKE_ARGS += -DENABLE_ASSEMBLY=ON
  CMAKE_ARGS += -DCMAKE_ASM_COMPILER=$(NASM_PATH)/nasm
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

# set default build directory
ifeq ($(strip $(CMAKE_BUILD_DIR)),)
  CMAKE_BUILD_DIR = $(WORK_DIR)/$(PKG_DIR)/build
endif
