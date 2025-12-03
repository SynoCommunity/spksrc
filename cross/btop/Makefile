PKG_NAME = btop
PKG_VERS = 1.4.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/aristocratos/btop/archive/refs/tags/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/aristocratos/btop
COMMENT  = Resource monitor that shows usage and stats for processor, memory, disks, network and processes.
LICENSE  = Apache 2.0

# compiler with support for c++20 is required
REQUIRED_MIN_DSM = 7.2

include ../../mk/spksrc.archs.mk
ifneq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CMAKE_ARGS += -DBTOP_GPU=OFF
endif

include ../../mk/spksrc.cross-cmake.mk
