

PKG_NAME = sqlite-autoconf
PKG_VERS = 3070800
PKG_EXT = tar.gz
PKG_REV = 1
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.sqlite.org/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl

MAINTAINER = superzebulon@superzebulon.org
HOMEPAGE   = http://www.sqlite.org/
COMMENT    = Self-contained, serverless, zero-configuration, transactional SQL database engine.
LICENSE    = http://www.sqlite.org/copyright.html

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
