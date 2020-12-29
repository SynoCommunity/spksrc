# meson cross-compilation definitions
MESON_CFG_DIR=$(WORK_DIR)/../../../mk/meson

# Set default build directory
ifeq ($(strip $(MESON_BUILD_DIR)),)
MESON_BUILD_DIR = builddir
endif

# Set other build options
CONFIGURE_ARGS += -Dbuildtype=release

# Define per arch specific common options
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
  CONFIGURE_ARGS += --cross-file $(MESON_CFG_DIR)/armv5.cfg
endif
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHES)),$(ARCH))
  CONFIGURE_ARGS += --cross-file $(MESON_CFG_DIR)/armv7.cfg
endif
ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
  CONFIGURE_ARGS += --cross-file $(MESON_CFG_DIR)/armv7l.cfg
endif
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHES)),$(ARCH))
  CONFIGURE_ARGS += --cross-file $(MESON_CFG_DIR)/aarch64.cfg
endif
ifeq ($(findstring $(ARCH), $(PPC_ARCHES)),$(ARCH))
  CONFIGURE_ARGS += --cross-file $(MESON_CFG_DIR)/ppc.cfg
endif
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
  CONFIGURE_ARGS += --cross-file $(MESON_CFG_DIR)/i686.cfg
endif
ifeq ($(findstring $(ARCH),$(x64_ARCHES)),$(ARCH))
  CONFIGURE_ARGS += --cross-file $(MESON_CFG_DIR)/x86_64.cfg
endif
