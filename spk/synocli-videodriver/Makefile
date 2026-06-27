SPK_NAME = synocli-videodriver
SPK_VERS = 1.5
SPK_REV = 6
SPK_ICON = src/SynoPackagegreen-videodriver.png

MAINTAINER = th0ma7
DESCRIPTION = "Provides headless video driver support \(DSM6-7\), including Vulkan and OpenCL \(DSM7.1+ Intel only\)."
DISPLAY_NAME = SynoCli Video Drivers
STARTABLE = no

HOMEPAGE = https://github.com/intel/compute-runtime
LICENSE  = MIT license

REQUIRED_MIN_DSM = 6.2.4
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7_ARCHS) $(ARMv7L_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

SERVICE_USER = auto
VIDEODRIVER = on

CHANGELOG  = "1. New armv8 package with basic libdrm support.<br/> "
CHANGELOG += "2. Intel Media Driver Release 2024Q4 (Release 2022Q4 for DSM 6).<br/> "
CHANGELOG += "3. Intel Level-Zero 1.17.42 (DSM 7.1+).<br/> "
CHANGELOG += "4. Intel Graphics Compiler (IGC) 1.0.17791.18 (DSM 7.1+).<br/> "
CHANGELOG += "5. Intel Compute Runtime 24.35.30872.41 (DSM 7.1+).<br/> "
CHANGELOG += "6. Intel Video Processing Library (Intel VPL) 2.15.0 (DSM 7.1+).<br/> "
CHANGELOG += "7. MESA Intel Vulkan driver (anv) 23.3.6 (DSM 7.1+)."
CHANGELOG += "8. libshaderc for accessing glslc functionality (DSM 7.1+)."
CHANGELOG += "9. Intel GPU Tools (igt) 2.3 (DSM 7.1+)."

OPTIONAL_DEPENDS  = cross/intel-level-zero
OPTIONAL_DEPENDS += cross/intel-graphics-compiler
OPTIONAL_DEPENDS += cross/intel-compute-runtime
OPTIONAL_DEPENDS += cross/ocl-icd
OPTIONAL_DEPENDS += cross/clinfo
OPTIONAL_DEPENDS += cross/mesa
OPTIONAL_DEPENDS += cross/Khronos-Vulkan-Loader
OPTIONAL_DEPENDS += cross/Khronos-Vulkan-Tools
OPTIONAL_DEPENDS += cross/shaderc
OPTIONAL_DEPENDS += cross/libplacebo
OPTIONAL_DEPENDS += cross/intel-gpu-tools
OPTIONAL_DEPENDS += cross/intel-libvpl
OPTIONAL_DEPENDS += cross/intel-libvpl-tools

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(64bit_ARCHS)),$(ARCH))
DEPENDS  = cross/libdrm
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
SPK_COMMANDS  = bin/clinfo
SPK_COMMANDS += bin/vainfo
SPK_COMMANDS += bin/vulkaninfo
SPK_COMMANDS += bin/lsgpu

# Common videodrv dependencies
DEPENDS  = cross/libva cross/libva-utils
DEPENDS += cross/intel-vaapi-driver
DEPENDS += cross/intel-media-driver cross/intel-mediasdk

ifeq ($(call version_gt, $(TC_GCC), 5),1)

# Newer Intel implementation
DEPENDS += cross/intel-level-zero

# OpenCL
DEPENDS += cross/intel-graphics-compiler
DEPENDS += cross/intel-compute-runtime
DEPENDS += cross/ocl-icd
DEPENDS += cross/clinfo

# Vulkan
DEPENDS += cross/mesa
DEPENDS += cross/Khronos-Vulkan-Loader
DEPENDS += cross/Khronos-Vulkan-Tools
DEPENDS += cross/shaderc

# Requires GCC >= 12 (C++20 <version> header support)
ifeq ($(call version_ge, $(TC_GCC), 12),1)
DEPENDS += cross/libplacebo
endif

# Enable intel_gpu_top on DSM >= 7.1
DEPENDS += cross/intel-gpu-tools

# Enable Intel libVPL only on DSM 7
# -->> can not use libmfx and libvpl together in ffmpeg
#      Jellyfin requires QSV provided by libmfx
DEPENDS += cross/intel-libvpl cross/intel-libvpl-tools

# endif TCVERSION >= 7
endif

# endif x64
endif

include ../../mk/spksrc.spk.mk
