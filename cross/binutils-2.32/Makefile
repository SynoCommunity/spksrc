PKG_NAME = binutils
PKG_VERS = 2.32
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/binutils
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/mpfr

HOMEPAGE = https://www.gnu.org/software/binutils/
COMMENT  = GNU Binutils
LICENSE  = GPLv2/LGPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS += --enable-host-shared
CONFIGURE_ARGS += --with-system-zlib
CONFIGURE_ARGS += --enable-gold=yes

include ../../mk/spksrc.archs.mk

# embedspu is a tool to "Embed an SPU ELF executable into a PowerPC object file"
# and hence built only for PPC_ARCHS.
ifneq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
PLIST_TRANSFORM = sed -e '/bin\/embedspu/d'
endif

include ../../mk/spksrc.cross-cc.mk
