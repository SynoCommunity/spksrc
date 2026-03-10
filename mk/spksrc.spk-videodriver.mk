###############################################################################
# spksrc.spk-videodriver.mk
#
# Shared Video Driver reuse logic for SPK packages.
#
# Purpose:
#   Supports two modes for SPK packages needing the videodriver stack:
#     1) Legacy Mode
#        - Builds the full video driver stack locally, injecting required
#          cross/* dependencies.
#        - Triggered when work directories (work-<arch>-<tcversion>) do not exist.
#     2) Reuse Mode
#        - Reuses pre-built headers, libraries, and pkg-config files from
#          an existing synocli-videodriver SPK work directory.
#        - Avoids rebuilding common GPU/media dependencies.
#
# Dependency Management:
#   - VIDEODRV_DEPENDS: default videodriver cross-* dependencies.
#   - VIDEODRV_DEPENDS_EXCLUDE: libraries excluded from automatic injection
#       (e.g., bzip2, xz, zlib) because they can cause build issues with
#       other dependencies that also require them.
#   - VIDEODRV_FILTERED_DEPENDS: subset of excluded libraries that actually
#       appear in the current package, ensuring they are integrated if required.
#   - DEPENDENCY_LIST: computed list of current package dependencies excluding
#       VIDEODRV_DEPENDS and other specified libraries (supports EXCLUDE_DEPENDS).
#
# Integration:
#   - DEPENDS is extended dynamically with filtered videodriver dependencies.
#   - SPK_DEPENDS is updated to reflect inclusion of the videodriver SPK.
#   - Hooks into PRE_DEPEND_TARGET via videodrv_pre_depend.
#
# Notes:
#   - Excluded dependencies are only reinjected if needed by the package.
#   - Dependency filtering avoids infinite loops during nested make calls.
#   - Only certain targets (e.g., dependency-%) will trigger DEPENDENCY_LIST
#     evaluation to minimize redundant shell calls.
#   - Build flags (CFLAGS, LDFLAGS, etc.) are updated when staging install
#     paths exist and stage2 build is in progress.
#
###############################################################################

# Set default videodriver package name
ifeq ($(strip $(VIDEODRV_PACKAGE)),)
export VIDEODRV_PACKAGE = synocli-videodriver
endif

# set default spk/synocli-videodriver path to use
VIDEODRV_PACKAGE_DIR = $(realpath $(CURDIR)/../../spk/$(VIDEODRV_PACKAGE))
VIDEODRV_PACKAGE_WORK_DIR = $(VIDEODRV_PACKAGE_DIR)/work-$(ARCH)-$(TCVERSION)

include ../../mk/spksrc.common.mk

# Always export these variables - they use deferred expansion so
# they will resolve correctly at recipe execution time even when
# VIDEODRV_PACKAGE is set conditionally after include.
export VIDEODRV_PACKAGE
export VIDEODRV_PACKAGE_DIR
export VIDEODRV_PACKAGE_WORK_DIR

# List of videodriver default dependencies
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))

# Common videodrv dependencies
VIDEODRV_DEPENDS  = cross/libva cross/libva-utils
VIDEODRV_DEPENDS += cross/intel-vaapi-driver
VIDEODRV_DEPENDS += cross/intel-media-driver cross/intel-mediasdk

# Newer Intel implementations (oneAPI, level-zero) requires gcc >= 5
ifeq ($(call version_gt, $(TC_GCC), 5),1)
VIDEODRV_DEPENDS += cross/intel-level-zero

# OpenCL
VIDEODRV_DEPENDS += cross/intel-graphics-compiler
VIDEODRV_DEPENDS += cross/intel-compute-runtime
VIDEODRV_DEPENDS += cross/ocl-icd
VIDEODRV_DEPENDS += cross/clinfo

# Vulkan
VIDEODRV_DEPENDS += cross/mesa
VIDEODRV_DEPENDS += cross/Khronos-Vulkan-Loader
VIDEODRV_DEPENDS += cross/Khronos-Vulkan-Tools
endif
endif

# VIDEODRV_PACKAGE_WORK_DIR exists
ifneq ($(wildcard $(VIDEODRV_PACKAGE_WORK_DIR)),)

# Set videodriver installation prefix directory variables
ifeq ($(strip $(VIDEODRV_STAGING_INSTALL_PREFIX)),)
export VIDEODRV_INSTALL_PREFIX = /var/packages/$(VIDEODRV_PACKAGE)/target
export VIDEODRV_STAGING_INSTALL_PREFIX = $(realpath $(VIDEODRV_PACKAGE_WORK_DIR)/install/$(VIDEODRV_INSTALL_PREFIX))
endif

# set build flags including ld to rewrite for the library path
# used to access videodrv package provide libraries at destination
ifneq ($(wildcard $(VIDEODRV_STAGING_INSTALL_PREFIX)),)

# Only apply flags if we are in build stage2 as
# usage of += will duplicate values per make calls
ifneq ($(filter %stage2,$(MAKECMDGOALS)),)
export ADDITIONAL_CFLAGS   += -I$(VIDEODRV_STAGING_INSTALL_PREFIX)/include
export ADDITIONAL_CPPFLAGS += -I$(VIDEODRV_STAGING_INSTALL_PREFIX)/include
export ADDITIONAL_CXXFLAGS += -I$(VIDEODRV_STAGING_INSTALL_PREFIX)/include
export ADDITIONAL_LDFLAGS  += -L$(VIDEODRV_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_LDFLAGS  += -Wl,--rpath-link,$(VIDEODRV_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_LDFLAGS  += -Wl,--rpath,$(VIDEODRV_INSTALL_PREFIX)/lib
export ADDITIONAL_RUSTFLAGS += -Clink-arg=-L$(VIDEODRV_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_RUSTFLAGS += -Clink-arg=-Wl,--rpath-link,$(VIDEODRV_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_RUSTFLAGS += -Clink-arg=-Wl,--rpath,$(VIDEODRV_INSTALL_PREFIX)/lib

# Generate package dependencies excluding specific videodriver libs
ifeq ($(filter dependency-%,$(MAKECMDGOALS)),)
DEPENDENCY_LIST = $(shell $(MAKE) -s dependency-list EXCLUDE_DEPENDS="$(VIDEODRV_DEPENDS) cross/ffmpeg7 $(FFMPEG_DEPENDS)" | cut -f2 -d:)
endif

VIDEODRV_LIBS_EXCLUDE = %bzip2.pc %lzma.pc %zlib.pc
VIDEODRV_DEPENDS_EXCLUDE = bzip2 xz zlib

# Only include excluded dependencies that actually appear in the current package
VIDEODRV_FILTERED_DEPENDS := $(filter $(addprefix cross/,$(VIDEODRV_DEPENDS_EXCLUDE)),$(DEPENDENCY_LIST))

# Re-use all default videodriver library dependencies (with exception of excludes)
VIDEODRV_LIBS := $(filter-out $(VIDEODRV_LIBS_EXCLUDE),$(wildcard $(VIDEODRV_STAGING_INSTALL_PREFIX)/lib/pkgconfig/*.pc))

# Re-use all videodriver dependencies and mark as already done (with exceltion of bzip2, xz, zlib)
VIDEODRV_STATUS_COOKIES := $(foreach cross,$(filter-out $(VIDEODRV_DEPENDS_EXCLUDE),$(foreach pkg_name,$(shell $(MAKE) dependency-list -C $(realpath $(VIDEODRV_PACKAGE_WORK_DIR)/../) 2>/dev/null | grep ^$(VIDEODRV_PACKAGE) | cut -f2 -d:),$(shell sed -n 's/^PKG_NAME = \(.*\)/\1/p' $(realpath $(CURDIR)/../../$(pkg_name)/Makefile)))),$(wildcard $(VIDEODRV_PACKAGE_WORK_DIR)/.$(cross)-*_done))

# call-up pre-depend to prepare the shared videodrv build environment
PRE_DEPEND_TARGET += videodrv_pre_depend

# Define resulting dependencies
DEPENDS := $(VIDEODRV_FILTERED_DEPENDS) $(DEPENDS)

# Assign SPK package depdendencies
SPK_DEPENDS := $(if $(strip $(SPK_DEPENDS)),$(VIDEODRV_PACKAGE):$(SPK_DEPENDS),$(VIDEODRV_PACKAGE))

# end ifeq stage2
endif

else
$(error VIDEODRIVER reuse detected but staging prefix not found: $(VIDEODRV_STAGING_INSTALL_PREFIX))

# end ifeq VIDEODRV_STAGING_INSTALL_PREFIX
endif

# No pre-built videodriver available, inject dependencies
else
DEPENDS := $(VIDEODRV_DEPENDS) $(DEPENDS)

# end ifeq VIDEODRV_PACKAGE_WORK_DIR
endif


include ../../mk/spksrc.spk.mk

.PHONY: videodrv_pre_depend
videodrv_pre_depend:
	@$(MSG) "*****************************************************"
	@$(MSG) "*** Use existing shared objects from [$(VIDEODRV_PACKAGE)]"
	@$(MSG) "*** PATH: $(VIDEODRV_PACKAGE_WORK_DIR)"
	@$(MSG) "*** DEPENDS: $(DEPENDS)"
	@$(MSG) "*** VIDEODRV_DEPENDS: $(VIDEODRV_DEPENDS)"
	@$(MSG) "*** DEPENDENCY_LIST: $(DEPENDENCY_LIST)"
	@$(MSG) "*****************************************************"
	@mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
	@$(foreach lib,$(VIDEODRV_LIBS),ln -sf $(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)
	@$(foreach _done,$(VIDEODRV_STATUS_COOKIES),ln -sf $(_done) $(WORK_DIR) ;)
