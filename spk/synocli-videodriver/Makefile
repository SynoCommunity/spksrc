SPK_NAME = synocli-videodriver
SPK_VERS = 1.4
SPK_REV = 5
SPK_ICON = src/SynoPackagegreen-videodriver.png

MAINTAINER = th0ma7
DESCRIPTION = "Provides video driver support for Intel GPU acceleration \(DSM6-7\), including Vulkan and OpenCL \(DSM7.1+ only\)."
DISPLAY_NAME = SynoCli Video Drivers
STARTABLE = no

HOMEPAGE = https://github.com/intel/compute-runtime
LICENSE  = MIT license

REQUIRED_MIN_DSM = 6.2.4
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

SERVICE_USER = auto
VIDEODRIVER = on

SPK_COMMANDS  = bin/vainfo

DEPENDS  = cross/libva cross/libva-utils
DEPENDS += cross/intel-vaapi-driver
DEPENDS += cross/intel-media-driver cross/intel-mediasdk

include ../../mk/spksrc.common.mk

CHANGELOG  = "1. Intel Media Driver Release 2024Q4 (Release 2022Q4 for DSM 6).<br/> "
CHANGELOG += "2. Intel Level-Zero 1.17.42 (DSM 7.1+).<br/> "
CHANGELOG += "3. Intel Graphics Compiler (IGC) 1.0.17791.18 (DSM 7.1+).<br/> "
CHANGELOG += "4. Intel Compute Runtime 24.35.30872.41 (DSM 7.1+).<br/> "
CHANGELOG += "5. Intel Video Processing Library (Intel VPL) 2.15.0 (DSM 7.1+).<br/> "
CHANGELOG += "6. MESA Intel Vulkan driver (anv) 23.3.6 (DSM 7.1+)."
CHANGELOG += "7. Intel GPU Tools (igt) 2.3 (DSM 7.1+)."

ifeq ($(call version_ge, ${TCVERSION}, 7.1),1)

# Enable OpenCL only on DSM >= 7.1
DEPENDS += cross/intel-compute-runtime
DEPENDS += cross/clinfo
SPK_COMMANDS += bin/clinfo

# Enable Vulkan only on DSM >= 7.1
DEPENDS += cross/mesa
DEPENDS += cross/Khronos-Vulkan-Loader
DEPENDS += cross/Khronos-Vulkan-Tools
SPK_COMMANDS += bin/vulkaninfo

# Enable intel_gpu_top on DSM >= 7.1
DEPENDS += cross/intel-gpu-tools
SPK_COMMANDS += bin/lsgpu

endif


ifeq ($(call version_ge, ${TCVERSION}, 7),1)

# Enable Intel libVPL only on DSM 7
# -->> can not use libmfx and libvpl together in ffmpeg
#      Jellyfin requires QSV provided by libmfx
DEPENDS += cross/intel-libvpl cross/intel-libvpl-tools

endif

include ../../mk/spksrc.spk.mk
