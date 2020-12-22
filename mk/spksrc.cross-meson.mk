# Build CMake programs
#
# prerequisites:
# - cross/module depends on meson + ninja
#

# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

# meson cross-compilation definitions
MESON_CFG=$(WORK_DIR)/../../../mk/meson

# Set default build directory
ifeq ($(strip $(MESON_BUILD_DIR)),)
MESON_BUILD_DIR = builddir
endif

#ifeq ($(strip $(MESON_DESTDIR)),)
#MESON_DESTDIR = $(INSTALL_DIR)
#endif

# Set other build options
CONFIGURE_ARGS += -Dbuildtype=release

# Define per arch specific common options
ifeq ($(findstring $(ARCH),$(ARM5_ARCHES)),$(ARCH))
  CONFIGURE_ARGS += --cross-file $(MESON_CFG)/armv5.cfg
endif
ifeq ($(findstring $(ARCH),$(ARM7_ARCHES)),$(ARCH))
  CONFIGURE_ARGS += --cross-file $(MESON_CFG)/armv7.cfg
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

# configure using cmake
ifeq ($(strip $(CONFIGURE_TARGET)),)
CONFIGURE_TARGET = meson_configure_target
endif

.PHONY: meson_configure_target

# default meson configure:
meson_configure_target:
	@$(MSG) - Meson configure
	@$(MSG)    - Dependencies = $(DEPENDS)
	@$(MSG)    - Build path = $(WORK_DIR)/$(PKG_DIR)/$(MESON_BUILD_DIR)
	@$(MSG)    - Configure ARGS = $(CONFIGURE_ARGS)
	@$(MSG)    - Install prefix = $(INSTALL_PREFIX)
	cd $(WORK_DIR)/$(PKG_DIR) && env $(ENV) meson $(MESON_BUILD_DIR) -Dprefix=$(INSTALL_PREFIX) $(CONFIGURE_ARGS)

# call-up ninja build process
include ../../mk/spksrc.cross-ninja.mk
