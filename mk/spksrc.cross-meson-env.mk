# meson cross-compilation definitions
MESON_CFG=$(WORK_DIR)/../../../mk/meson

# Set default build directory
ifeq ($(strip $(MESON_BUILD_DIR)),)
MESON_BUILD_DIR = builddir
endif

# Set other build options
CONFIGURE_ARGS += -Dbuildtype=release

# Define per arch specific common options
ifeq ($(findstring $(ARCH),$(ARM5_ARCHES)),$(ARCH))
  CONFIGURE_ARGS += --cross-file $(MESON_CFG)/armv5.cfg
endif
ifeq ($(findstring $(ARCH),$(ARM7_ARCHES)),$(ARCH))
  CONFIGURE_ARGS += --cross-file $(MESON_CFG)/armv7.cfg
endif
ifeq ($(findstring $(ARCH),hi3535),$(ARCH))
  CONFIGURE_ARGS += --cross-file $(MESON_CFG)/armv7l.cfg
endif
ifeq ($(findstring $(ARCH),$(ARM8_ARCHES)),$(ARCH))
  CONFIGURE_ARGS += --cross-file $(MESON_CFG)/armv8.cfg
endif
ifeq ($(findstring $(ARCH), $(PPC_ARCHES)),$(ARCH))
  CONFIGURE_ARGS += --cross-file $(MESON_CFG)/ppc.cfg
endif
ifeq ($(findstring $(ARCH),$(x86_ARCHES)),$(ARCH))
  CONFIGURE_ARGS += --cross-file $(MESON_CFG)/x86.cfg
endif
ifeq ($(findstring $(ARCH),$(x64_ARCHES)),$(ARCH))
  CONFIGURE_ARGS += --cross-file $(MESON_CFG)/x86_64.cfg
endif
