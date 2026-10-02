###############################################################################
# spksrc.spk-meta/videodriver-depends.mk
#
# Single source of truth for the videodriver library dependencies, shared by
# spk/synocli-videodriver/Makefile (DEPENDS) and by the consumer-side meta
# integration (mk/spksrc.spk-meta/videodriver.mk, META_DEPENDS).
# Libraries only: the diagnostic tools live in spk/synocli-videodriver-tools.
###############################################################################

# Include guard: both the videodriver spk Makefile and videodriver.mk may end
# up including this file within the same parse; define the lists only once.
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

# Each set where the packages behind it build, by their own MIN_GCC_VERSION.
# media-driver-latest and level-zero need C++14 (gcc 5).
ifeq ($(call version_ge, $(TC_GCC), 5),1)

# Newer Intel implementation
VIDEODRV_DEPENDS += cross/intel-level-zero

# Intel libVPL
# -->> can not use libmfx and libvpl together in ffmpeg
#      Jellyfin requires QSV provided by libmfx
VIDEODRV_DEPENDS += cross/intel-libvpl

endif

# OpenCL and Vulkan: the OpenCL headers, IGC, compute-runtime, shaderc and mesa need
# C++17 (gcc 7.5). The Vulkan loader has no floor of its own but is of no use without them.
ifeq ($(call version_ge, $(TC_GCC), 7.5),1)

# OpenCL
VIDEODRV_DEPENDS += cross/ocl-icd
VIDEODRV_DEPENDS += cross/intel-graphics-compiler
VIDEODRV_DEPENDS += cross/intel-compute-runtime

# Vulkan
VIDEODRV_DEPENDS += cross/Khronos-Vulkan-Loader
VIDEODRV_DEPENDS += cross/shaderc
VIDEODRV_DEPENDS += cross/mesa

endif

# endif x64
endif

# Flat superset of every possible VIDEODRV_DEPENDS variant, for
# OPTIONAL_DEPENDS: with ARCH/TCVERSION unset all conditionals above
# resolve empty, and the dependency discovery (dependency-tree.mk)
# relies on OPTIONAL_DEPENDS covering all toolchains.
VIDEODRV_OPTIONAL_DEPENDS  = cross/libdrm
VIDEODRV_OPTIONAL_DEPENDS += cross/libva
VIDEODRV_OPTIONAL_DEPENDS += cross/intel-vaapi-driver
VIDEODRV_OPTIONAL_DEPENDS += cross/intel-media-driver cross/intel-mediasdk
VIDEODRV_OPTIONAL_DEPENDS += cross/intel-level-zero
VIDEODRV_OPTIONAL_DEPENDS += cross/intel-graphics-compiler
VIDEODRV_OPTIONAL_DEPENDS += cross/intel-compute-runtime
VIDEODRV_OPTIONAL_DEPENDS += cross/ocl-icd
VIDEODRV_OPTIONAL_DEPENDS += cross/mesa
VIDEODRV_OPTIONAL_DEPENDS += cross/Khronos-Vulkan-Loader
VIDEODRV_OPTIONAL_DEPENDS += cross/shaderc
VIDEODRV_OPTIONAL_DEPENDS += cross/intel-libvpl

endif # ifndef SPKSRC_VIDEODRV_DEPENDS_MK
