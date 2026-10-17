PKG_NAME = nnn
PKG_VERS = 4.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/jarun/nnn/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw cross/readline

# REMARKS:
# nnn version 4.0 is the latest version for 32-bit archs with glibc < 2.23 (DSM 6 and comcerto2k)

# glibc 2.8 <sys/inotify.h> has neither inotify_init1 nor IN_NONBLOCK (added in 2.9).
MIN_GLIBC_VERSION = 2.9

HOMEPAGE = https://github.com/jarun/nnn
COMMENT  = n³ The unorthodox terminal file manager.
LICENSE  = 2-clause BSD

CONFIGURE_TARGET = nop
INSTALL_ARGS = install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
