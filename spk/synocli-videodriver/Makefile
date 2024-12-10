SPK_NAME = synocli-videodriver
SPK_VERS = 1.2
SPK_REV = 2
SPK_ICON = src/SynoPackagegreen-videodriver.png

MAINTAINER = th0ma7
DESCRIPTION = "Provides video driver support for Intel GPU acceleration including OpenCL \(DSM7 only\)."
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

ifeq ($(call version_lt, ${TCVERSION}, 7),1)
CHANGELOG = "1. Intel Media Driver 2022Q4 Release"
else
CHANGELOG = "1. Intel Media Driver 2024Q2 Release"
endif

# Enable OpenCL only on DSM >= 7.1
ifeq ($(call version_ge, ${TCVERSION}, 7.1),1)
CHANGELOG += "<br/>2. Intel Level-Zero 1.17.42"
DEPENDS += cross/intel-level-zero

CHANGELOG += "<br/>3. Intel Graphics Compiler \(IGC\) 1.0.17537.20"
DEPENDS += cross/intel-graphics-compiler

CHANGELOG += "<br/>4. Intel Compute Runtime 24.31.30508.7"
DEPENDS += cross/intel-compute-runtime
DEPENDS += cross/ocl-icd
DEPENDS += cross/clinfo
endif

# Enable Intel libVPL only on DSM >= 7.1
# -->> can not use libmfx and libvpl together in ffmpeg
#      Jellyfin requires QSV provided by libmfx
ifeq ($(call version_ge, ${TCVERSION}, 7),1)
CHANGELOG += "<br/>5. Intel Video Processing Library \(Intel VPL\) 2.13.0"
DEPENDS += cross/intel-libvpl cross/intel-libvpl-tools
endif

# Enable intel_gpu_top on DSM >= 7.1
ifeq ($(call version_ge, ${TCVERSION}, 7.1),1)
CHANGELOG = "<br/>6. Intel GPU Tools \(IGT\) 1.29"
DEPENDS += cross/intel-gpu-tools
endif

include ../../mk/spksrc.spk.mk
