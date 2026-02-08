PKG_NAME = coreutils
PKG_VERS = 9.5
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/coreutils
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.gnu.org/s/coreutils/
COMMENT  = Basic file, shell and text manipulation utilities of the GNU operating system. We use 'nice' only.
LICENSE  = GPLv3

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

# 32-bit archs require glibc >= 2.34 (i.e. DSM 7.2) to support 64 bit timestamps
ifneq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
ifeq ($(call version_lt, $(TC_GLIBC), 2.34),1)
CONFIGURE_ARGS += --disable-year2038
endif
endif
