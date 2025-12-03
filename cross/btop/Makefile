PKG_NAME = btop
PKG_VERS = 1.4.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/aristocratos/btop/archive/refs/tags/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/lowdown cross/coreutils

HOMEPAGE = https://github.com/aristocratos/btop
COMMENT  = Resource monitor that shows usage and stats for processor, memory, disks, network and processes.
LICENSE  = Apache 2.0

include ../../mk/spksrc.archs.mk
UNSUPPORTED_ARCHS = $(32bit_ARCHS) $(ARMv8_ARCHS)

include ../../mk/spksrc.cross-cmake.mk
