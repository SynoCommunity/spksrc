###############################################################################
# spksrc.spk-videodriver.mk
#
# Shared Video Driver reuse logic for SPK packages.
#
# Purpose:
#   Allows a package to either:
#     1) Build required video driver stack locally (legacy mode), or
#     2) Reuse an existing synocli-videodriver SPK build (reuse mode).
#
# ─────────────────────────────────────────────────────────────────────────────
# Modes of Operation
#
# 1) Legacy Mode (default fallback)
#    - Triggered when no matching:
#          spk/<videodriver>/work-<arch>-<tcversion>
#      directory exists.
#    - Injects required cross/* dependencies directly.
#    - Primarily relevant for x64 architectures.
#    - Builds libva, Intel media stack, OpenCL, Vulkan, etc., as needed.
#
# 2) Reuse Mode
#    - Triggered when a matching videodriver work directory exists.
#    - Reuses staged headers and shared libraries.
#    - Injects include/lib paths into ADDITIONAL_*FLAGS.
#    - Links pkg-config files into STAGING_INSTALL_PREFIX.
#    - Links dependency .*-*_done cookies into WORK_DIR.
#    - Avoids rebuilding the full GPU/media stack.
#
# ─────────────────────────────────────────────────────────────────────────────
#
# Architecture Constraints:
#   - Reuse is bound to:
#         work-<arch>-<tcversion>
#   - Ensures ABI compatibility with the active toolchain.
#   - Extended Intel stack enabled only when toolchain GCC >= 5.
#
# Key Variables:
#   VIDEODRV_PACKAGE                Default: synocli-videodriver
#   VIDEODRV_PACKAGE_WORK_DIR       Architecture-specific work dir
#   VIDEODRV_STAGING_INSTALL_PREFIX Staged reuse prefix
#   VIDEODRV_LIBS                   Reused pkg-config libraries
#   VIDEODRV_STATUS_COOKIES         Reused build completion markers
#
# Failure Handling:
#   - If reuse mode is detected but required staging paths are missing,
#     the build aborts explicitly via $(error).
#
# Integration:
#   - Extends DEPENDS dynamically.
#   - Hooks into PRE_DEPEND_TARGET via videodrv_pre_depend.
#   - Designed to be transparent to package Makefiles.
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

ifeq ($(wildcard $(VIDEODRV_PACKAGE_WORK_DIR)),)
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))

# if VIDEODRV_PACKAGE_WORK_DIR does not exist, proceed with the inclusion
# of synocli-videodriver dependencies directly built-into the package

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

# end ifeq version_gt $(TC_GCC)
endif
# end ifeq $(x64_ARCHS)
endif

# VIDEODRV_PACKAGE_WORK_DIR exists
else

# Set videodriver installation prefix directory variables
ifeq ($(strip $(VIDEODRV_STAGING_INSTALL_PREFIX)),)
export VIDEODRV_INSTALL_PREFIX = /var/packages/$(VIDEODRV_PACKAGE)/target
export VIDEODRV_STAGING_INSTALL_PREFIX = $(realpath $(VIDEODRV_PACKAGE_WORK_DIR)/install/$(VIDEODRV_INSTALL_PREFIX))
endif

# set build flags including ld to rewrite for the library path
# used to access videodrv package provide libraries at destination
ifneq ($(wildcard $(VIDEODRV_STAGING_INSTALL_PREFIX)),)
export ADDITIONAL_CFLAGS   += -I$(VIDEODRV_STAGING_INSTALL_PREFIX)/include
export ADDITIONAL_CPPFLAGS += -I$(VIDEODRV_STAGING_INSTALL_PREFIX)/include
export ADDITIONAL_CXXFLAGS += -I$(VIDEODRV_STAGING_INSTALL_PREFIX)/include
export ADDITIONAL_LDFLAGS  += -L$(VIDEODRV_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_LDFLAGS  += -Wl,--rpath-link,$(VIDEODRV_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_LDFLAGS  += -Wl,--rpath,$(VIDEODRV_INSTALL_PREFIX)/lib
export ADDITIONAL_RUSTFLAGS += -Clink-arg=-L$(VIDEODRV_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_RUSTFLAGS += -Clink-arg=-Wl,--rpath-link,$(VIDEODRV_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_RUSTFLAGS += -Clink-arg=-Wl,--rpath,$(VIDEODRV_INSTALL_PREFIX)/lib

VIDEODRV_LIBS_EXCLUDE = %bzip2.pc %lzma.pc %zlib.pc
VIDEODRV_DEPENDS_EXCLUDE = bzip2 xz zlib
VIDEODRV_FILTERED_DEPENDS = $(addprefix cross/,$(VIDEODRV_DEPENDS_EXCLUDE))

# Re-use all default videodriver library dependencies (with exception of excludes)
VIDEODRV_LIBS := $(filter-out $(VIDEODRV_LIBS_EXCLUDE),$(wildcard $(VIDEODRV_STAGING_INSTALL_PREFIX)/lib/pkgconfig/*.pc))

# Re-use all videodriver dependencies and mark as already done (with exceltion of bzip2, xz, zlib)
VIDEODRV_STATUS_COOKIES := $(foreach cross,$(filter-out $(VIDEODRV_DEPENDS_EXCLUDE),$(foreach pkg_name,$(shell $(MAKE) dependency-list -C $(realpath $(VIDEODRV_PACKAGE_WORK_DIR)/../) 2>/dev/null | grep ^$(VIDEODRV_PACKAGE) | cut -f2 -d:),$(shell sed -n 's/^PKG_NAME = \(.*\)/\1/p' $(realpath $(CURDIR)/../../$(pkg_name)/Makefile)))),$(wildcard $(VIDEODRV_PACKAGE_WORK_DIR)/.$(cross)-*_done))

# call-up pre-depend to prepare the shared videodrv build environment
PRE_DEPEND_TARGET += videodrv_pre_depend

else
$(error VIDEODRIVER reuse detected but staging prefix not found: $(VIDEODRV_STAGING_INSTALL_PREFIX))

# end ifeq VIDEODRV_STAGING_INSTALL_PREFIX
endif

# end ifeq VIDEODRV_PACKAGE_WORK_DIR
endif

# re-inject either:
#    - videodrv dependencies for inclusion in-app spk package; or
#    - filtered libraries to be processed first
DEPENDS := $(VIDEODRV_DEPENDS) $(VIDEODRV_FILTERED_DEPENDS) $(DEPENDS)

include ../../mk/spksrc.spk.mk

.PHONY: videodrv_pre_depend
videodrv_pre_depend:
	@$(MSG) "*****************************************************"
	@$(MSG) "*** Use existing shared objects from [$(VIDEODRV_PACKAGE)]"
	@$(MSG) "*** PATH: $(VIDEODRV_PACKAGE_WORK_DIR)"
	@$(MSG) "*****************************************************"
	@mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
	@$(foreach lib,$(VIDEODRV_LIBS),ln -sf $(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)
	@$(foreach _done,$(VIDEODRV_STATUS_COOKIES),ln -sf $(_done) $(WORK_DIR) ;)
