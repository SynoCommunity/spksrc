###############################################################################
# spksrc.spk-ffmpeg.mk
#
# Shared FFmpeg reuse logic for SPK packages.
#
# Purpose:
#   Allows a package to either:
#     1) Rebuild FFmpeg as a normal cross dependency (legacy mode), or
#     2) Reuse an existing FFmpeg SPK build (reuse mode).
#
# ─────────────────────────────────────────────────────────────────────────────
# Modes of Operation
#
# 1) Legacy Mode (default fallback)
#    - Triggered when no matching:
#          spk/<ffmpeg>/work-<arch>-<tcversion>
#      directory exists.
#    - Adds cross/<ffmpeg> to FFMPEG_DEPENDS.
#    - FFmpeg is rebuilt as part of the current package build.
#
# 2) Reuse Mode
#    - Triggered when a matching FFmpeg work directory exists.
#    - Reuses staged headers and shared libraries.
#    - Injects include/lib paths into ADDITIONAL_*FLAGS.
#    - Links pkg-config files and .ffmpeg-*_done cookies.
#    - Avoids rebuilding FFmpeg and heavy dependencies.
#
# ─────────────────────────────────────────────────────────────────────────────
#
# Architecture Constraints:
#   - Reuse is strictly bound to:
#         work-<arch>-<tcversion>
#   - Guarantees ABI consistency with the active toolchain.
#
# Key Variables:
#   FFMPEG_PACKAGE                Default: ffmpeg7
#   FFMPEG_PACKAGE_WORK_DIR       Architecture-specific FFmpeg work dir
#   FFMPEG_STAGING_INSTALL_PREFIX Staged reuse prefix
#   FFMPEG_LIBS                   Default pkg-config libraries
#
# Failure Handling:
#   - If reuse mode is detected but required staging paths are missing,
#     the build aborts explicitly via $(error).
#
# Integration:
#   - Extends DEPENDS when needed.
#   - Hooks into PRE_DEPEND_TARGET via ffmpeg_pre_depend.
#   - Compatible with spksrc.spk.mk and spksrc.spk-videodriver.mk.
#
# TODO TODO TODO TODO
# Manage SPK_DEPEND
#
###############################################################################

# Set default ffmpeg package name
ifeq ($(strip $(FFMPEG_PACKAGE)),)
export FFMPEG_PACKAGE = ffmpeg7
endif

# set default spk/ffmpeg* path to use
FFMPEG_PACKAGE_DIR = $(realpath $(CURDIR)/../../spk/$(FFMPEG_PACKAGE))
FFMPEG_PACKAGE_WORK_DIR = $(FFMPEG_PACKAGE_DIR)/work-$(ARCH)-$(TCVERSION)

include ../../mk/spksrc.common.mk

# Always export these variables - they use deferred expansion so
# they will resolve correctly at recipe execution time even when
# FFMPEG_PACKAGE is set conditionally after include.
export FFMPEG_PACKAGE
export FFMPEG_PACKAGE_DIR
export FFMPEG_PACKAGE_WORK_DIR

ifeq ($(wildcard $(FFMPEG_PACKAGE_WORK_DIR)),)

FFMPEG_DEPENDS += cross/$(FFMPEG_PACKAGE)

# FFMPEG_PACKAGE_WORK_DIR exists
else

# Set ffmpeg installtion prefix directory variables
ifeq ($(strip $(FFMPEG_STAGING_INSTALL_PREFIX)),)
export FFMPEG_INSTALL_PREFIX = /var/packages/$(FFMPEG_PACKAGE)/target
export FFMPEG_STAGING_INSTALL_PREFIX = $(realpath $(FFMPEG_PACKAGE_ROOT)/install/$(FFMPEG_INSTALL_PREFIX))
endif

# set build flags including ld to rewrite for the library path
# used to access ffmpeg package provide libraries at destination
ifneq ($(wildcard $(FFMPEG_STAGING_INSTALL_PREFIX)),)

# Only apply flags if we are in build stage2 as
# usage of += will duplicate values per make calls
ifneq ($(filter spk-stage2,$(MAKECMDGOALS)),)
export ADDITIONAL_CFLAGS   += -I$(FFMPEG_STAGING_INSTALL_PREFIX)/include
export ADDITIONAL_CPPFLAGS += -I$(FFMPEG_STAGING_INSTALL_PREFIX)/include
export ADDITIONAL_CXXFLAGS += -I$(FFMPEG_STAGING_INSTALL_PREFIX)/include
export ADDITIONAL_LDFLAGS  += -L$(FFMPEG_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_LDFLAGS  += -Wl,--rpath-link,$(FFMPEG_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_LDFLAGS  += -Wl,--rpath,$(FFMPEG_INSTALL_PREFIX)/lib
export ADDITIONAL_RUSTFLAGS += -Clink-arg=-L$(FFMPEG_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_RUSTFLAGS += -Clink-arg=-Wl,--rpath-link,$(FFMPEG_STAGING_INSTALL_PREFIX)/lib
export ADDITIONAL_RUSTFLAGS += -Clink-arg=-Wl,--rpath,$(FFMPEG_INSTALL_PREFIX)/lib

# Re-use all default ffmpeg mandatory libraries
FFMPEG_LIBS  = libavcodec.pc
FFMPEG_LIBS += libavfilter.pc
FFMPEG_LIBS += libavformat.pc
FFMPEG_LIBS += libpostproc.pc
FFMPEG_LIBS += libavutil.pc
FFMPEG_LIBS += libswresample.pc
FFMPEG_LIBS += libswscale.pc
endif

# Link .ffmpeg-*_done status cookies
FFMPEG_STATUS_COOKIES := $(wildcard $(FFMPEG_PACKAGE_WORK_DIR)/.ffmpeg-*_done)

# call-up pre-depend to prepare the shared ffmpeg build environment
PRE_DEPEND_TARGET += ffmpeg_pre_depend

else
$(error FFMPEG reuse detected but staging prefix not found: $(FFMPEG_STAGING_INSTALL_PREFIX))

# end ifeq FFMPEG_STAGING_INSTALL_PREFIX
endif

# end ifeq FFMPEG_PACKAGE_WORK_DIR
endif

# re-inject either:
#    - ffmpeg dependencies for inclusion in-app spk package; or
ifneq ($(filter spk-stage2,$(MAKECMDGOALS)),)
DEPENDS := $(FFMPEG_DEPENDS) $(DEPENDS)
endif

ifneq ($(VIDEODRV_PACKAGE),)
include ../../mk/spksrc.spk-videodriver.mk
else
include ../../mk/spksrc.spk.mk
endif


# Create symbolic links against:
#    - ffmpeg pkg_config files
#    - .ffmpeg-*_done status cookies
#    - any other pkg_config files defined using $(MEDIA_LIBS) - see cross/tvheadend
.PHONY: ffmpeg_pre_depend
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
# Also call-up videodriver pre-depend for remaining dependencies
ffmpeg_pre_depend: videodrv_pre_depend
else
ffmpeg_pre_depend:
endif
	@$(MSG) "*****************************************************"
	@$(MSG) "*** Use existing shared objects from [$(FFMPEG_PACKAGE)]"
	@$(MSG) "*** PATH: $(FFMPEG_PACKAGE_WORK_DIR)"
	@$(MSG) "*****************************************************"
	@mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
	@$(foreach lib,$(FFMPEG_LIBS),ln -sf $(FFMPEG_STAGING_INSTALL_PREFIX)/lib/pkgconfig/$(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)
	@$(foreach _done,$(FFMPEG_STATUS_COOKIES),ln -sf $(_done) $(WORK_DIR) ;)
	@# EXCEPTION: Some package links against other manually speficied media libraries provided by ffmpeg (i.e. tvheadend)
	@$(foreach lib,$(MEDIA_LIBS),ln -sf $(FFMPEG_STAGING_INSTALL_PREFIX)/lib/pkgconfig/$(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)
