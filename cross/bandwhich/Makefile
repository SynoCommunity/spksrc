PKG_NAME = bandwhich
PKG_VERS = 0.20.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/imsnif/bandwhich/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# unknown relocation type 95 ...
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://github.com/imsnif/bandwhich#readme
COMMENT  = CLI utility for displaying current network utilization by process, connection and remote IP/hostname.
LICENSE  = MIT

include ../../mk/spksrc.cross-rust.mk
