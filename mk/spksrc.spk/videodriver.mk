IS_VIDEODRV_SUPPORTED := $(findstring $(ARCH),$(x64_ARCHS) $(ARMv8_ARCHS))

ifneq ($(IS_VIDEODRV_SUPPORTED),)

# Set default videodriver package name
ifeq ($(strip $(VIDEODRV_PACKAGE)),)
  VIDEODRV_PACKAGE = synocli-videodriver
endif

# set default spk/synocli-videodriver path to use
VIDEODRV_PACKAGE_DIR = $(abspath $(CURDIR)/../../spk/$(VIDEODRV_PACKAGE))
VIDEODRV_PACKAGE_WORK_DIR = $(VIDEODRV_PACKAGE_DIR)/work-$(ARCH)-$(TCVERSION)

# List of videodriver aarch64 default dependencies
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
VIDEODRV_DEPENDS = cross/libdrm
endif

# List of videodriver x64 default dependencies
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))

# Common videodrv dependencies
VIDEODRV_DEPENDS  = cross/libva cross/libva-utils
VIDEODRV_DEPENDS += cross/intel-vaapi-driver
VIDEODRV_DEPENDS += cross/intel-media-driver cross/intel-mediasdk

ifeq ($(call version_gt, $(TC_GCC), 5),1)

# Newer Intel implementation
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
VIDEODRV_DEPENDS += cross/shaderc

# Requires GCC >= 12 (C++20 <version> header support)
ifeq ($(call version_ge, $(TC_GCC), 12),1)
VIDEODRV_DEPENDS += cross/libplacebo
endif

endif
endif

META_DEPENDS += $(VIDEODRV_DEPENDS)
OPTIONAL_DEPENDS += $(VIDEODRV_DEPENDS)

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
