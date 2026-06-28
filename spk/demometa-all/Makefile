SPK_NAME = demometa-all
SPK_VERS = 1.0.0
SPK_REV = 1
SPK_ICON = src/demometa-all.png

# Include common.mk first to get ARCH definitions
include ../../mk/spksrc.common.mk

# Declare MULTIPLE meta packages at once: SPK_BASE_TEMPLATE accumulates each
# one's pkgconfig dir into the ordered list, so the cross/ probe resolves libs
# from both python (libzstd) and videodriver (dbus-1) in a single build.
PYTHON_PACKAGE = python314
VIDEODRV_PACKAGE = synocli-videodriver

# Probes both python (libzstd) and videodriver (dbus-1) at once. dbus-1 is only
# in the videodriver meta on x64 + DSM 7.x (Intel tool stack), so the combined
# harness can only run there; restrict to x64 / DSM 7.1+.
REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7_ARCHS) $(ARMv7L_ARCHS) $(ARMv8_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

DEPENDS = cross/demometa-all-cmake

MAINTAINER = SynoCommunity
DESCRIPTION = Meta cross-dependency test package: validates that several meta packages (python + videodriver) are accumulated into one ordered PKG_CONFIG_LIBDIR and shared to a cross/ dependency simultaneously.
DISPLAY_NAME = Demo Meta All
LICENSE = MIT
STARTABLE = no

include ../../mk/spksrc.spk-meta.mk
