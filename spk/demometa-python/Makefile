SPK_NAME = demometa-python
SPK_VERS = 1.0.0
SPK_REV = 1
SPK_ICON = src/demometa-python.png

# Include common.mk first to get ARCH definitions
include ../../mk/spksrc.common.mk

# Declare the python meta package: SPK_BASE_TEMPLATE accumulates and exports
# its pkgconfig dir so the cross/ test probes below resolve python-meta libs.
PYTHON_PACKAGE = python314

# cmake, meson and autotools probes that pkg-config-resolve libzstd/sqlite3 from the meta
DEPENDS = cross/demometa-python-cmake cross/demometa-python-meson cross/demometa-python-autotools

MAINTAINER = SynoCommunity
DESCRIPTION = Meta cross-dependency test package: validates that python meta libraries are shared to cross/ dependencies (cmake and meson channels) via the ordered PKG_CONFIG_LIBDIR.
DISPLAY_NAME = Demo Meta Python
LICENSE = MIT
STARTABLE = no

include ../../mk/spksrc.spk-meta.mk
