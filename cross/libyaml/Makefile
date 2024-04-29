PKG_NAME = yaml
PKG_VERS = 0.2.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://pyyaml.org/download/libyaml
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://pyyaml.org/wiki/LibYAML
COMMENT  = LibYAML is a YAML parser and emitter library.
LICENSE  = MIT

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static

include ../../mk/spksrc.cross-cc.mk
