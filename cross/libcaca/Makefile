PKG_NAME = libcaca
PKG_VERS = 0.99.beta20
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/cacalabs/libcaca/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/imlib2

HOMEPAGE = http://caca.zoy.org/
COMMENT  = The industry-standard colour ASCII-art library.
LICENSE  = WTFPL

GNU_CONFIGURE = 1

PRE_CONFIGURE_TARGET = libcaca_pre_configure

CONFIGURE_ARGS  = --disable-x11
CONFIGURE_ARGS += --disable-imlib2
CONFIGURE_ARGS += --disable-gl
CONFIGURE_ARGS += --disable-csharp
CONFIGURE_ARGS += --disable-java
CONFIGURE_ARGS += --disable-python
CONFIGURE_ARGS += --disable-ruby
CONFIGURE_ARGS += --disable-doc
CONFIGURE_ARGS += --disable-plugins
CONFIGURE_ARGS += --disable-examples
CONFIGURE_ARGS += --disable-doc
CONFIGURE_ARGS += --disable-static

include ../../mk/spksrc.cross-cc.mk

.PHONY: libcaca_pre_configure
libcaca_pre_configure:
	@$(RUN) ./bootstrap
