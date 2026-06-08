PKG_NAME = inetutils
PKG_VERS = 2.7
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftpmirror.gnu.org/gnu/inetutils
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw

HOMEPAGE = https://www.gnu.org/software/inetutils/
COMMENT  = GNU network utilities.
LICENSE  = GPLv3

# original patches to fix CVE-2026-24061
PATCHES_LEVEL = 1

GNU_CONFIGURE = 1

# disable all
CONFIGURE_ARGS  = --disable-servers --disable-clients
# explicit build of telnet and whois
CONFIGURE_ARGS += --enable-telnet
CONFIGURE_ARGS += --enable-whois

include ../../mk/spksrc.cross-cc.mk
