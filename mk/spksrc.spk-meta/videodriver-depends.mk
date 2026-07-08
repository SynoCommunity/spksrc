###############################################################################
# spksrc.spk-meta/videodriver-depends.mk
#
# Single source of truth for the videodriver library dependencies, shared by
# spk/synocli-videodriver/Makefile (DEPENDS) and by the consumer-side meta
# integration (mk/spksrc.spk-meta/videodriver.mk, META_DEPENDS).
# Libraries only: the diagnostic tools live in spk/synocli-videodriver-tools.
###############################################################################

ifndef SPKSRC_VIDEODRV_DEPENDS_MK
SPKSRC_VIDEODRV_DEPENDS_MK := 1

# List of videodriver aarch64 default dependencies
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
VIDEODRV_DEPENDS = cross/libdrm
endif

# List of videodriver x64 default dependencies
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))

# Common videodrv dependencies
VIDEODRV_DEPENDS  = cross/libva
VIDEODRV_DEPENDS += cross/intel-vaapi-driver
VIDEODRV_DEPENDS += cross/intel-media-driver cross/intel-mediasdk

ifeq ($(call version_gt, $(TC_GCC), 5),1)

# Newer Intel implementation
VIDEODRV_DEPENDS += cross/intel-level-zero

# OpenCL
VIDEODRV_DEPENDS += cross/intel-graphics-compiler
VIDEODRV_DEPENDS += cross/intel-compute-runtime
VIDEODRV_DEPENDS += cross/ocl-icd

# Vulkan
VIDEODRV_DEPENDS += cross/mesa
VIDEODRV_DEPENDS += cross/Khronos-Vulkan-Loader
VIDEODRV_DEPENDS += cross/shaderc

# Enable Intel libVPL only on DSM 7
# -->> can not use libmfx and libvpl together in ffmpeg
#      Jellyfin requires QSV provided by libmfx
VIDEODRV_DEPENDS += cross/intel-libvpl

# endif TC_GCC > 5
endif

# endif x64
endif

# Flat superset of the conditional entries above, for OPTIONAL_DEPENDS
VIDEODRV_OPTIONAL_DEPENDS  = cross/intel-level-zero
VIDEODRV_OPTIONAL_DEPENDS += cross/intel-graphics-compiler
VIDEODRV_OPTIONAL_DEPENDS += cross/intel-compute-runtime
VIDEODRV_OPTIONAL_DEPENDS += cross/ocl-icd
VIDEODRV_OPTIONAL_DEPENDS += cross/mesa
VIDEODRV_OPTIONAL_DEPENDS += cross/Khronos-Vulkan-Loader
VIDEODRV_OPTIONAL_DEPENDS += cross/shaderc
VIDEODRV_OPTIONAL_DEPENDS += cross/intel-libvpl

endif # ifndef SPKSRC_VIDEODRV_DEPENDS_MK
