# By default use cmake toolchain
# for cross-compiling
ifeq ($(strip $(CMAKE_USE_TOOLCHAIN_FILE)),)
CMAKE_USE_TOOLCHAIN_FILE = ON
endif

# We normally build regular Release
ifeq ($(strip $(CMAKE_BUILD_TYPE)),)
CMAKE_ARGS += -DCMAKE_BUILD_TYPE=Release
else
CMAKE_ARGS += -DCMAKE_BUILD_TYPE=$(CMAKE_BUILD_TYPE)
endif

# Set the default install prefix
CMAKE_ARGS += -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)

# DSM7 appdir
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
CMAKE_ARGS += -DCMAKE_INSTALL_LOCALSTATEDIR=$(INSTALL_PREFIX_VAR)
endif

# Necessary variables for the toolchain file
# used at generation from spksrc.tc.mk that
# will define the cross-compiled environment
# for the target build
CMAKE_SYSTEM_NAME = Linux
_CMAKE_TOOLCHAIN_LOCATION = $(WORK_DIR)/$(TC_TARGET)/bin/
_CMAKE_TOOLCHAIN_PREFIX = $(TC_PREFIX)
CMAKE_FIND_ROOT_PATH = $(INSTALL_DIR)$(INSTALL_PREFIX)
CMAKE_FIND_ROOT_PATH_MODE_PROGRAM = NEVER
CMAKE_FIND_ROOT_PATH_MODE_LIBRARY = ONLY
CMAKE_FIND_ROOT_PATH_MODE_INCLUDE = ONLY
CMAKE_INSTALL_RPATH = $(INSTALL_PREFIX)/lib
CMAKE_INSTALL_RPATH_USE_LINK_PATH = TRUE
CMAKE_BUILD_WITH_INSTALL_RPATH = TRUE
BUILD_SHARED_LIBS = ON

# Configuration for CMake build
CMAKE_TOOLCHAIN_FILE = $(WORK_DIR)/$(ARCH)-toolchain.cmake

# Ensure to unset cross-compiler target toolchain
# so host toolset can be available to CMAKE
ifeq ($(strip $(CMAKE_USE_TOOLCHAIN_FILE)),ON)
ENV := -u AR -u AS -u CC -u CPP -u CXX -u LD -u NM -u OBJDUMP -u RANLIB -u READELF -u STRIP $(ENV)
endif

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

# Set default ASM build environment
# At toolchain step variables are not yet evaluated
# resulting in inability to set in toolchain file
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

# Define per arch specific common options
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
  CMAKE_SYSTEM_PROCESSOR = armv5
  CROSS_COMPILE_ARM = ON
endif
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
  CMAKE_SYSTEM_PROCESSOR = armv7
  CROSS_COMPILE_ARM = ON
  CMAKE_CXX_FLAGS += -fPIC
endif
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
  CMAKE_SYSTEM_PROCESSOR = aarch64
  CROSS_COMPILE_ARM = ON
  CMAKE_CXX_FLAGS += -fPIC
endif
ifeq ($(findstring $(ARCH), $(PPC_ARCHS)),$(ARCH))
  CMAKE_SYSTEM_PROCESSOR = ppc
  CMAKE_C_FLAGS += -mcpu=8548 -mhard-float -mfloat-gprs=double
endif
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
  CMAKE_SYSTEM_PROCESSOR = x86
  CMAKE_ARCH = 32
endif
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
  CMAKE_SYSTEM_PROCESSOR = x86_64
  CMAKE_ARCH = 64
endif
