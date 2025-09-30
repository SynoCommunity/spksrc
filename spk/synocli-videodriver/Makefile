SPK_NAME = synocli-videodriver
SPK_VERS = 1.2
SPK_REV = 3
SPK_ICON = src/SynoPackagegreen-videodriver.png

MAINTAINER = th0ma7
DESCRIPTION = "Provides video driver support for Intel GPU acceleration including OpenCL \(DSM7.1+ only\)."
DISPLAY_NAME = SynoCli Video Drivers
STARTABLE = no

HOMEPAGE = https://github.com/intel/compute-runtime
LICENSE  = MIT license

REQUIRED_MIN_DSM = 6.2.4
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

SERVICE_USER = auto
VIDEODRIVER = on

SPK_COMMANDS  = bin/clinfo
SPK_COMMANDS += bin/vainfo
SPK_COMMANDS += bin/lsgpu

DEPENDS  = cross/libva cross/libva-utils
DEPENDS += cross/intel-vaapi-driver
DEPENDS += cross/intel-media-driver cross/intel-mediasdk

include ../../mk/spksrc.common.mk

CHANGELOG  = "1. Intel Media Driver Release 2024Q2 (Release 2022Q4 for DSM 6).<br/> "
CHANGELOG += "2. Intel Level-Zero 1.17.42 (DSM 7.1+).<br/> "
CHANGELOG += "3. Intel Graphics Compiler (IGC) 1.0.17537.20 (DSM 7.1+).<br/> "
CHANGELOG += "4. Intel Compute Runtime 24.31.30508.7 (DSM 7.1+).<br/> "
CHANGELOG += "5. Intel Video Processing Library (Intel VPL) 2.13.0 (DSM 7).<br/> "
CHANGELOG += "6. Intel GPU Tools (IGT) 1.30 (DSM 7.1+)."

ifeq ($(call version_ge, ${TCVERSION}, 7.1),1)

# Enable OpenCL only on DSM >= 7.1
DEPENDS += cross/intel-compute-runtime
DEPENDS += cross/clinfo

# Enable intel_gpu_top on DSM >= 7.1
DEPENDS += cross/intel-gpu-tools

endif


ifeq ($(call version_ge, ${TCVERSION}, 7),1)

# Enable Intel libVPL only on DSM 7
# -->> can not use libmfx and libvpl together in ffmpeg
#      Jellyfin requires QSV provided by libmfx
DEPENDS += cross/intel-libvpl cross/intel-libvpl-tools

endif

include ../../mk/spksrc.spk.mk
