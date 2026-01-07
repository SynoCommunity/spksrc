PKG_NAME = fdupes
PKG_VERS = 2.4.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/adrianlopezroche/fdupes/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw cross/pcre2 cross/sqlite

HOMEPAGE = https://github.com/adrianlopezroche/fdupes
COMMENT  = FDUPES is a program for identifying or deleting duplicate files residing within specified directories.
LICENSE  = MIT

GNU_CONFIGURE = 1

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
ADDITIONAL_LDFLAGS += -lrt
endif

include ../../mk/spksrc.cross-cc.mk
