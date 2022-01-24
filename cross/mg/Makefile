PKG_NAME = mg
PKG_VERS = 3.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/troglobit/mg/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw

HOMEPAGE = https://man.troglobit.com/man1/mg.1.html
COMMENT  = Micro (GNU) Emacs-like text editor.
LICENSE  = UNLICENSE

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --sysconfdir=$(INSTALL_PREFIX)/var

include ../../mk/spksrc.archs.mk
ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
# old gcc does not support option -flto
CONFIGURE_ARGS += --enable-size-optimizations
else
ADDITIONAL_CFLAGS = -Os
endif

include ../../mk/spksrc.cross-cc.mk
