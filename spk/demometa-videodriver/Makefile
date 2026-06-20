SPK_NAME = demometa-videodriver
SPK_VERS = 1.0.0
SPK_REV = 1
SPK_ICON = src/demometa-videodriver.png

# Include common.mk first to get ARCH definitions
include ../../mk/spksrc.common.mk

# Declare the videodriver meta package: SPK_BASE_TEMPLATE accumulates and
# exports its pkgconfig dir so the cross/ test probe resolves videodriver libs.
VIDEODRV_PACKAGE = synocli-videodriver

# cmake probe that pkg-config-resolves dbus-1 from the videodriver meta
DEPENDS = cross/demometa-videodriver-cmake

MAINTAINER = SynoCommunity
DESCRIPTION = Meta cross-dependency test package: validates that videodriver meta libraries (dbus-1) are shared to cross/ dependencies via the ordered PKG_CONFIG_LIBDIR.
DISPLAY_NAME = Demo Meta Videodriver
LICENSE = MIT
STARTABLE = no

include ../../mk/spksrc.spk-meta.mk
