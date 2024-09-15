SPK_NAME = synocli-videodriver
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/SynoPackagegreen-videodriver.png
CHANGELOG = "Initial version providing Intel Media Driver 2024Q2 Release"

MAINTAINER = th0ma7
DESCRIPTION = "Provides video driver support for Intel GPU acceleration including OpenCL."
DISPLAY_NAME = SynoCli Video Drivers
STARTABLE = no

HOMEPAGE = https://github.com/intel/compute-runtime
LICENSE  = MIT license

REQUIRED_MIN_DSM = 6.2.4
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

SERVICE_USER = auto
VIDEODRIVER = on

SPK_COMMANDS = bin/vainfo
SPK_COMMANDS = bin/clinfo

DEPENDS  = cross/libva cross/libva-utils
DEPENDS += cross/intel-vaapi-driver
DEPENDS += cross/intel-media-driver cross/intel-mediasdk

include ../../mk/spksrc.common.mk

# Enable OpenCL only on DSM >= 7.1
ifeq ($(call version_ge, ${TCVERSION}, 7.1),1)
CHANGELOG += "Intel Level-Zero 1.17.28, Intel Graphics Compiler \(IGC\) 1.0.17384.12, Intel Compute Runtime 24.31.30508.7"
DEPENDS += cross/intel-level-zero
DEPENDS += cross/intel-graphics-compiler
DEPENDS += cross/intel-compute-runtime
DEPENDS += cross/ocl-icd
DEPENDS += cross/clinfo
endif

# Enable Intel libVPL only on DSM >= 7.1
# -->> can not use libmfx and libvpl together in ffmpeg
#      Jellyfin requires QSV provided by libmfx
ifeq ($(call version_ge, ${TCVERSION}, 7),1)
CHANGELOG += " and Intel Video Processing Library \(Intel VPL\) 2.13.0"
DEPENDS += cross/intel-libvpl cross/intel-libvpl-tools
endif

include ../../mk/spksrc.spk.mk
