SPK_NAME = synocli-videodriver-tools
SPK_VERS = 1.0
SPK_REV = 2
SPK_ICON = src/SynoPackagegreen-videodriver.png

MAINTAINER = th0ma7
DESCRIPTION = "Diagnostic and monitoring tools for GPU video drivers \(vainfo, clinfo, vulkaninfo, lsgpu, intel_gpu_top, ...\). Requires SynoCli Video Drivers."
DISPLAY_NAME = SynoCli Video Driver Tools
STARTABLE = no

HOMEPAGE = https://gitlab.freedesktop.org/drm/igt-gpu-tools
LICENSE  = MIT license

# VA-API tools (vainfo) work wherever synocli-videodriver provides VA-API,
# i.e. down to DSM 6.2.4; the OpenCL/Vulkan/igt tools need the newer Intel
# stack (DSM 7.1+) and are gated below.
REQUIRED_MIN_DSM = 6.2.4
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7_ARCHS) $(ARMv7L_ARCHS) $(ARMv8_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

SERVICE_USER = auto
VIDEODRIVER = on

# Link against the synocli-videodriver core libraries
VIDEODRV_PACKAGE = synocli-videodriver

CHANGELOG  = "1. Initial release: diagnostic and monitoring tools split out of synocli-videodriver.<br/>"
CHANGELOG += "2. Provide vainfo down to DSM 6.2.4 (VA-API); OpenCL/Vulkan/igt tools remain DSM 7.1+."

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))

# VA-API (available on all supported DSM, including 6.2.4)
DEPENDS  = cross/libva-utils
SPK_COMMANDS  = bin/vainfo

# OpenCL / Vulkan / GPU tools require the newer Intel stack (DSM 7.1+, GCC > 5)
ifeq ($(call version_gt, $(TC_GCC), 5),1)

# OpenCL
DEPENDS += cross/clinfo
SPK_COMMANDS += bin/clinfo

# Vulkan
DEPENDS += cross/Khronos-Vulkan-Tools
SPK_COMMANDS += bin/vulkaninfo

# Intel GPU Tools (igt)
DEPENDS += cross/intel-gpu-tools
SPK_COMMANDS += bin/lsgpu
SPK_COMMANDS += bin/intel_gpu_top

# Intel Video Processing Library (Intel VPL) tools
DEPENDS += cross/intel-libvpl-tools
SPK_COMMANDS += bin/vpl-inspect

endif

endif

include ../../mk/spksrc.spk-meta.mk
