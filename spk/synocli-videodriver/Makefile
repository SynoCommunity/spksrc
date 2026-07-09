SPK_NAME = synocli-videodriver
SPK_VERS = 1.5
SPK_REV = 8
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
CHANGELOG += "7. MESA Intel Vulkan driver (anv) 23.3.6 (DSM 7.1+).<br/>"
CHANGELOG += "8. libshaderc for accessing glslc functionality (DSM 7.1+).<br/>"
CHANGELOG += "9. Re-publish for DSM 7.2+.<br/>"
CHANGELOG += "10. Diagnostic tools (vainfo, clinfo, vulkaninfo, lsgpu, intel_gpu_top) moved to synocli-videodriver-tools: this package now ships libraries only.<br/>"

include ../../mk/spksrc.common.mk

# Library dependency list shared with the consumer-side meta integration
# (single source of truth: mk/spksrc.spk-meta/videodriver-depends.mk)
include ../../mk/spksrc.spk-meta/videodriver-depends.mk

DEPENDS = $(VIDEODRV_DEPENDS)
OPTIONAL_DEPENDS = $(VIDEODRV_OPTIONAL_DEPENDS)

include ../../mk/spksrc.spk.mk
