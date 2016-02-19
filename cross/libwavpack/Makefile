PKG_NAME = wavpack
PKG_VERS = 4.75.2
PKG_EXT = tar.bz2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://www.wavpack.com

DEPENDS = 

HOMEPAGE = http://http://www.wavpack.com/
COMMENT  = Completely open audio compression format providing lossless, high-quality lossy, and a unique hybrid compression mode. Although the technology is loosely based on previous versions of WavPack, the new version 4 format has been designed from the ground up to offer unparalleled performance and functionality
LICENSE  = 

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static
ifeq ($(findstring $(ARCH),88f5281 88f6281 alpine armada370 armada375 armadaxp),$(ARCH))
CONFIGURE_ARGS += --disable-asm
endif

include ../../mk/spksrc.cross-cc.mk

