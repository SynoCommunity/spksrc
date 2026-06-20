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

DEPENDS = cross/demometa-all-cmake

MAINTAINER = SynoCommunity
DESCRIPTION = Meta cross-dependency test package: validates that several meta packages (python + videodriver) are accumulated into one ordered PKG_CONFIG_LIBDIR and shared to a cross/ dependency simultaneously.
DISPLAY_NAME = Demo Meta All
LICENSE = MIT
STARTABLE = no

include ../../mk/spksrc.spk-meta.mk
