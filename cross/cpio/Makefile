PKG_NAME = cpio
PKG_VERS = 2.12
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.gnu.org/s/cpio/
COMMENT  = GNU cpio copies files into or out of a cpio or tar archive. The archive can be another file on the disk, a magnetic tape, or a pipe.
LICENSE  = GPLv3

PATCHES_LEVEL = 2
GNU_CONFIGURE = 1
ENV += FORCE_UNSAFE_CONFIGURE=1
CONFIGURE_ARGS = --disable-nls

include ../../mk/spksrc.cross-cc.mk
