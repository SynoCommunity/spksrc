PKG_NAME = fish
PKG_VERS = 3.1.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/fish-shell/fish-shell/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncurses cross/pcre2

HOMEPAGE = https://fishshell.com
COMMENT = fish is a smart and user-friendly command line shell for Linux, macOS, and the rest of the family.
LICENSE = Custom

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(PPC_ARCHS)

include ../../mk/spksrc.cross-cmake.mk
