SPK_NAME = synocli-videodriver
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/SynoPackagegreen-videodriver.png
CHANGELOG = "Initial version providing Intel Media Driver 2024Q2 Release, intel-graphics-compiler (IGC) 1.0.17384.12, intel-level-zero 1.17.28"

MAINTAINER = th0ma7
DESCRIPTION = Provides video driver support for Intel GPU acceleration including OpenCL.
DESCRIPTION_FRE = Fournit un soutien pour les pilotes vidéo pour l'accélération GPU Intel incluant OpenCL.
DISPLAY_NAME = SynoCli Video Drivers
STARTABLE = no

HOMEPAGE = https://github.com/intel/compute-runtime
LICENSE  = MIT license

REQUIRED_MIN_DSM = 6.2.4
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

SERVICE_USER = auto
VIDEODRIVER = on

SPK_COMMANDS = bin/vainfo

DEPENDS  = cross/libva cross/libva-utils
DEPENDS += cross/intel-vaapi-driver
DEPENDS += cross/intel-media-driver cross/intel-mediasdk
DEPENDS += cross/intel-libvpl cross/intel-libvpl-tools

include ../../mk/spksrc.archs.mk

# Enable OpenCL only on DSM >= 7.1
ifeq ($(call version_ge, ${TCVERSION}, 7.1),1)
CHANGELOG += " and intel-compute-runtime 24.31.30508.7"
DEPENDS += cross/intel-compute-runtime
DEPENDS += cross/ocl-icd
endif

include ../../mk/spksrc.spk.mk
