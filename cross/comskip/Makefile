PKG_NAME = Comskip
PKG_VERS = 0.83
PKG_EXT = tar.gz
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_NAME = V$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/erikkaashoek/Comskip/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/argtable
OPTIONAL_DEPENDS = cross/ffmpeg8

# ffmpeg8 needs C11 -- gcc 4.9 or newer
MIN_GCC_VERSION = 4.9

# ffmpeg8 is built through the gcc 8.5 overlay wherever the vendor compiler falls short,
# so follow it: same condition, same compiler, one ABI across the chain. Linking an
# overlay-built ffmpeg8 with the vendor gcc fails on std::__cxx11 and CXXABI symbols its
# libstdc++ never had. Recursive (=): TC_GCC does not exist until the include below, and
# overlay.mk's `?=` must still see this assignment.
OVERLAY_GCC = $(if $(call version_lt,$(TC_GCC),$(MIN_GCC_VERSION)),1)

HOMEPAGE = https://www.kaashoek.com/comskip
COMMENT  = Commercial detector
LICENSE  = GNU/LGPL

PRE_CONFIGURE_TARGET = comskip_pre_configure
GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: comskip_pre_configure
comskip_pre_configure:
	@$(RUN) ; ./autogen.sh
