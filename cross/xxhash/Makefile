PKG_NAME = xxHash
PKG_VERS = 0.8.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Cyan4973/xxHash/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://xxhash.com/
COMMENT  = xxHash is an extremely fast non-cryptographic hash algorithm, working at RAM speed limit. It is proposed in four flavors (XXH32, XXH64, XXH3_64bits and XXH3_128bits). The latest variant, XXH3, offers improved performance across the board, especially on small data.
LICENSE  = 2-Clause BSD

CONFIGURE_TARGET = nop

include ../../mk/spksrc.cross-cc.mk
