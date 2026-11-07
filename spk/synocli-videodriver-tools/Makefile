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

# VA-API tools (vainfo) work wherever synocli-videodriver provides VA-API (its kernel
# floor); the OpenCL/Vulkan/igt tools need the newer stack and are gated below.
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

# clinfo and vulkaninfo where the videodriver meta ships the OpenCL and Vulkan runtime
# they query: gcc 8 (videodriver-depends.mk)
ifeq ($(call version_ge, $(TC_GCC), 8),1)

# OpenCL
DEPENDS += cross/clinfo
SPK_COMMANDS += bin/clinfo

# Vulkan
DEPENDS += cross/Khronos-Vulkan-Tools
SPK_COMMANDS += bin/vulkaninfo

endif

# Intel Video Processing Library (Intel VPL) tools
ifeq ($(call version_ge, $(TC_GCC), 7.5),1)
DEPENDS += cross/intel-libvpl-tools
SPK_COMMANDS += bin/vpl-inspect
endif

# Intel GPU Tools (igt): libudev 219 must match the udev the system runs, DSM 7's --
# a platform fact (DSM 6 runs udev 204) -- and gcc 8, igt's own floor.
ifeq ($(call version_ge, $(TCVERSION), 7)$(call version_ge, $(TC_GCC), 8),11)
DEPENDS += cross/intel-gpu-tools
SPK_COMMANDS += bin/lsgpu
SPK_COMMANDS += bin/intel_gpu_top
endif

endif

include ../../mk/spksrc.spk-meta.mk
