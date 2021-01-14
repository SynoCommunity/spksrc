# meson cross-compilation definitions

# Set default build directory
ifeq ($(strip $(MESON_BUILD_DIR)),)
MESON_BUILD_DIR = builddir
endif

# Set other build options
CONFIGURE_ARGS += -Dbuildtype=release

# Use arch specific configuration file
MESON_CFG_DIR = $(realpath $(WORK_DIR)/../../../mk/meson)
MESON_CFG_FILE =

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
  MESON_CFG_FILE = armv5.cfg
endif
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
  MESON_CFG_FILE = armv7.cfg
endif
ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
  MESON_CFG_FILE = armv7l.cfg
endif
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
  MESON_CFG_FILE = aarch64.cfg
endif
ifeq ($(findstring $(ARCH), $(PPC_ARCHS)),$(ARCH))
  MESON_CFG_FILE = ppc.cfg
endif
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
  MESON_CFG_FILE = i686.cfg
endif
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
  MESON_CFG_FILE = x86_64.cfg
endif

# disable error handling for target dependency-list
ifneq ($(strip $(DEPENDENCY_WALK)),1)
  ifeq ($(strip $(MESON_CFG_FILE)),)
    $(warning No meson config file defined for $(ARCH))
  else
    ifeq ($(wildcard $(MESON_CFG_DIR)/$(MESON_CFG_FILE)),)
      $(warning meson config file not found: $(MESON_CFG_DIR)/$(MESON_CFG_FILE))
    endif
  endif
endif

CONFIGURE_ARGS += --cross-file $(MESON_CFG_DIR)/$(MESON_CFG_FILE)
