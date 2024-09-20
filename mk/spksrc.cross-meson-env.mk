# meson cross-compilation definitions

# Set default base meson directory
# Exceptionnally it is under a sub-directory (ex: zstd)
ifeq ($(strip $(MESON_BASE_DIR)),)
MESON_BASE_DIR = $(WORK_DIR)/$(PKG_DIR)
endif

# Set default build directory
ifeq ($(strip $(MESON_BUILD_DIR)),)
MESON_BUILD_DIR = $(MESON_BASE_DIR)/builddir
endif

# Set other build options
# We normally build regular Release
ifeq ($(strip $(MESON_BUILD_TYPE)),)
  ifeq ($(strip $(GCC_DEBUG_INFO)),1)
    CONFIGURE_ARGS += -Dbuildtype=debug
  else
    CONFIGURE_ARGS += -Dbuildtype=release
  endif
else
  CONFIGURE_ARGS += -Dbuildtype=$(MESON_BUILD_TYPE)
endif

# Configuration for meson build
MESON_TOOLCHAIN_WRK = $(WORK_DIR)/tc_vars.meson
CONFIGURE_ARGS += --cross-file $(MESON_TOOLCHAIN_WRK)

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
  MESON_HOST_CPU_FAMILY = arm
  MESON_HOST_CPU = armv5
  MESON_HOST_ENDIAN = little
endif
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
  MESON_BUILTIN_CPP_ARGS = -fPIC
  MESON_HOST_CPU_FAMILY = arm
  MESON_HOST_CPU = armv7
  MESON_HOST_ENDIAN = little
endif
ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
  MESON_BUILTIN_CPP_ARGS = -fPIC
  MESON_HOST_CPU_FAMILY = arm
  MESON_HOST_CPU = armv7l
  MESON_HOST_ENDIAN = little
endif
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
  MESON_BUILTIN_CPP_ARGS = -fPIC
  MESON_HOST_CPU_FAMILY = aarch64
  MESON_HOST_CPU = aarch64
  MESON_HOST_ENDIAN = little
endif
ifeq ($(findstring $(ARCH), $(PPC_ARCHS)),$(ARCH))
  MESON_HOST_CPU_FAMILY = ppc
  MESON_HOST_CPU = ppc
  MESON_HOST_ENDIAN = big
endif
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
  MESON_BUILTIN_C_ARGS = -m32
  MESON_BUILTIN_C_LINK_ARGS = -m32
  MESON_BUILTIN_CPP_ARGS = -m32
  MESON_BUILTIN_CPP_LINK_ARGS = -m32
  MESON_HOST_CPU_FAMILY = x86
  MESON_HOST_CPU = i686
  MESON_HOST_ENDIAN = little
endif
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
  MESON_HOST_CPU_FAMILY = x86_64
  MESON_HOST_CPU = x86_64
  MESON_HOST_ENDIAN = little
endif
