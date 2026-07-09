###############################################################################
# spksrc.spk-meta/videodriver.mk
#
# Video-driver meta integration: selects the videodriver meta on supported
# archs when VIDEODRV_PACKAGE is set.
###############################################################################

IS_VIDEODRV_SUPPORTED := $(findstring $(ARCH),$(x64_ARCHS) $(ARMv8_ARCHS))

ifneq ($(IS_VIDEODRV_SUPPORTED),)

# Set default videodriver package name
ifeq ($(strip $(VIDEODRV_PACKAGE)),)
  VIDEODRV_PACKAGE = synocli-videodriver
endif

# set default spk/synocli-videodriver path to use
VIDEODRV_PACKAGE_DIR = $(abspath $(CURDIR)/../../spk/$(VIDEODRV_PACKAGE))
VIDEODRV_PACKAGE_WORK_DIR = $(VIDEODRV_PACKAGE_DIR)/work-$(ARCH)-$(TCVERSION)

# Videodriver library dependency list (single source of truth, also
# consumed by spk/synocli-videodriver/Makefile). Libraries only: the
# diagnostic tools live in spk/synocli-videodriver-tools.
include ../../mk/spksrc.spk-meta/videodriver-depends.mk

# META_DEPENDS: the arch-resolved list actually provided by the meta
# (used as EXCLUDE_DEPENDS in the consumer build). OPTIONAL_DEPENDS: the
# all-toolchains superset, for arch-less dependency discovery.
META_DEPENDS += $(VIDEODRV_DEPENDS)
OPTIONAL_DEPENDS += $(VIDEODRV_OPTIONAL_DEPENDS)

# Ship the GPU diagnostic tools with every DIRECT videodriver consumer
# (x64, DSM 7.1+ — the only targets the tools package exists for). Indirect
# consumers (videodriver via the ffmpeg rpath) rely on the ffmpeg chain,
# and the tools package itself must not depend on itself.
VIDEODRV_TOOLS_PACKAGE = synocli-videodriver-tools
ifeq ($(strip $(VIDEODRV_INDIRECT_DEPENDS)),)
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
ifeq ($(call version_ge, $(TCVERSION), 7.1),1)
ifneq ($(SPK_NAME),$(VIDEODRV_TOOLS_PACKAGE))
SPK_DEPENDS := $(if $(strip $(SPK_DEPENDS)),$(SPK_DEPENDS):$(VIDEODRV_TOOLS_PACKAGE),$(VIDEODRV_TOOLS_PACKAGE))
endif
endif
endif
endif

# Build the meta source spk/$(VIDEODRV_PACKAGE) in spk-stage1 so its work dir
# exists for the stage2 SPK_BASE_TEMPLATE parse.
BUILD_DEPENDS := $(call uniq,spk/$(VIDEODRV_PACKAGE) $(BUILD_DEPENDS))

# $(1)_meta hook required by base.mk; no extra action for this meta.
.PHONY: VIDEODRV_meta
VIDEODRV_meta: ;

# Export the meta package name (read by consumers / sub-makes).
export VIDEODRV_PACKAGE

# Share the meta's libraries at spk-stage2 (its work dir is built by stage1).
ifneq ($(and $(wildcard $(VIDEODRV_PACKAGE_WORK_DIR)),$(filter spk-stage2,$(MAKECMDGOALS))),)
  export VIDEODRV_PACKAGE_WORK_DIR
  $(eval $(call SPK_BASE_TEMPLATE,VIDEODRV))
endif

endif
