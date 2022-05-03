# Configuration for CMake build
#
CMAKE_ARGS += -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)
CMAKE_ARGS += -DCMAKE_CROSSCOMPILING=TRUE
CMAKE_ARGS += -DCMAKE_SYSTEM_NAME=Linux
CMAKE_ARGS += -DCMAKE_BUILD_TYPE=Release
CMAKE_ARGS += -D_CMAKE_TOOLCHAIN_LOCATION=$(TC_PATH)
CMAKE_ARGS += -D_CMAKE_TOOLCHAIN_PREFIX=$(TC_PREFIX)
CMAKE_ARGS += -DCMAKE_FIND_ROOT_PATH=$(INSTALL_DIR)$(INSTALL_PREFIX)
CMAKE_ARGS += -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER
CMAKE_ARGS += -DCMAKE_INSTALL_RPATH=$(INSTALL_PREFIX)/lib
CMAKE_ARGS += -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE
CMAKE_ARGS += -DCMAKE_BUILD_WITH_INSTALL_RPATH=TRUE
CMAKE_ARGS += -DBUILD_SHARED_LIBS=ON

# DSM7 appdir
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
CMAKE_ARGS += -DCMAKE_INSTALL_LOCALSTATEDIR=$(INSTALL_PREFIX_VAR)
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

# set default ASM build environment
ifeq ($(strip $(CMAKE_USE_NASM)),1)
  DEPENDS += native/nasm
  NASM_PATH = $(WORK_DIR)/../../../native/nasm/work-native/install/usr/local/bin
  ENV += PATH=$(NASM_PATH):$$PATH
  ENV += AS=$(NASM_PATH)/nasm
  CMAKE_ARGS += -DENABLE_ASSEMBLY=ON
  CMAKE_ARGS += -DCMAKE_ASM_COMPILER=$(AS)
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
  CMAKE_ARGS += -DCROSS_COMPILE_ARM=ON
  CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=armv5
endif
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
  CMAKE_ARGS += -DCMAKE_CXX_FLAGS="-fPIC $(ADDITIONAL_CXXFLAGS)" -DCROSS_COMPILE_ARM=ON
  CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=armv7
endif
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
  CMAKE_ARGS += -DCMAKE_CXX_FLAGS="-fPIC $(ADDITIONAL_CXXFLAGS)" -DCROSS_COMPILE_ARM=ON
  CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=aarch64
endif
ifeq ($(findstring $(ARCH), $(PPC_ARCHS)),$(ARCH))
  CMAKE_ARGS += -DCMAKE_C_FLAGS="-mcpu=8548 -mhard-float -mfloat-gprs=double $(ADDITIONAL_CFLAGS)"
  CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=ppc
endif
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
  CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=x86 -DARCH=32
endif
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
  CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=x86_64 -DARCH=64
endif
ifneq ($(strip $(ADDITIONAL_CFLAGS)),)
# define cflags if not applied above
ifneq ($(findstring $(ARCH), $(PPC_ARCHS)),$(ARCH))
  CMAKE_ARGS += -DCMAKE_C_FLAGS="$(ADDITIONAL_CFLAGS)"
endif
endif
ifneq ($(strip $(ADDITIONAL_CXXFLAGS)),)
# define cxxflags if not applied above
ifneq ($(findstring $(ARCH), $(ARMv7_ARCHS) $(ARMv8_ARCHS)),$(ARCH))
  CMAKE_ARGS += -DCMAKE_CXX_FLAGS="$(ADDITIONAL_CXXFLAGS)"
endif
endif

