PKG_NAME = binutils
PKG_VERS = 2.41
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/binutils
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/mpfr

HOMEPAGE = https://www.gnu.org/software/binutils/
COMMENT  = GNU Binutils
LICENSE  = GPLv2/LGPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --enable-host-shared
CONFIGURE_ARGS += --with-system-zlib
CONFIGURE_ARGS += --enable-gold=yes

include ../../mk/spksrc.archs.mk

# embedspu is a tool to "Embed an SPU ELF executable into a PowerPC object file"
# and hence built only for PPC_ARCHS.
# gprofng fails to build on i686 and does not build on other 32-bit archs.
ifeq ($(findstring $(ARCH),$(64bit_ARCHS)),$(ARCH))
PLIST_TRANSFORM = sed -e '/bin\/embedspu/d'
else
CONFIGURE_ARGS += --disable-gprofng
PLIST_TRANSFORM = sed -e '/bin\/gprofng/d' -e '/bin\/gp\-/d' -e '/lib\/gprofng/d'
ifneq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
PLIST_TRANSFORM += -e '/bin\/embedspu/d'
endif
endif

# Avoid conflicts with gdb
CONFIGURE_ARGS += --includedir=$(INSTALL_PREFIX)/include/binutils

include ../../mk/spksrc.cross-cc.mk
