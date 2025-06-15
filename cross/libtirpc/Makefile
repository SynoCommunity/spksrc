PKG_NAME = libtirpc
PKG_VERS = 1.3.6
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/libtirpc/files/libtirpc/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# homepage not reachable as of 2025.06.15
HOMEPAGE = http://libtirpc.sourceforge.net/
COMMENT  = Libtirpc is a port of Suns Transport-Independent RPC library to Linux. It's being developed by the Bull GNU/Linux NFSv4 project.
LICENSE  = BSD

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --disable-gssapi

include ../../mk/spksrc.cross-cc.mk
