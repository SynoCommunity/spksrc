PKG_NAME = patch
PKG_VERS = 2.7.6
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/patch
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/attr

HOMEPAGE = https://savannah.gnu.org/projects/patch/
COMMENT  = Patch takes a patch file containing a difference listing produced by the diff program and applies those differences to one or more original files, producing patched versions.
LICENSE  = GPLv3+

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
