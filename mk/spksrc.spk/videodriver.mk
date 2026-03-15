
# Set default videodriver package name
ifeq ($(strip $(VIDEODRV_PACKAGE)),)
  VIDEODRV_PACKAGE = synocli-videodriver
endif

# set default spk/synocli-videodriver path to use
VIDEODRV_PACKAGE_DIR = $(abspath $(CURDIR)/../../spk/$(VIDEODRV_PACKAGE))
VIDEODRV_PACKAGE_WORK_DIR = $(VIDEODRV_PACKAGE_DIR)/work-$(ARCH)-$(TCVERSION)

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

META_DEPENDS += $(VIDEODRV_DEPENDS)
OPTIONAL_DEPENDS += $(VIDEODRV_DEPENDS)

# Always export these variables - they use deferred expansion so
# they will resolve correctly at recipe execution time even when
# VIDEODRV_PACKAGE is set conditionally after include.

.PHONY: VIDEODRV_meta
VIDEODRV_meta: ;

ifneq ($(and $(wildcard $(VIDEODRV_PACKAGE_WORK_DIR)),$(filter spk-stage2,$(MAKECMDGOALS))),)
  export VIDEODRV_PACKAGE
  export VIDEODRV_PACKAGE_DIR
  export VIDEODRV_PACKAGE_WORK_DIR
  export VIDEODRV_DEPENDS
  export META_DEPENDS
  $(eval $(call SPK_BASE_TEMPLATE,VIDEODRV))
else
  DEPENDS += $(VIDEODRV_DEPENDS)
endif
