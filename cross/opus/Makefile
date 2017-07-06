PKG_NAME = opus
PKG_VERS = 1.1.3
PKG_EXT = tar.gz
PKG_DIST_NAME = opus-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.xiph.org/releases/opus
PKG_DIR = opus-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.opus-codec.org
COMMENT  = Opus is a totally open, royalty-free, highly versatile audio codec. Opus is unmatched for interactive speech and music transmission over the Internet, but is also intended for storage and streaming applications.
LICENSE  = BSD

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --disable-doc --disable-extra-programs

include ../../mk/spksrc.cross-cc.mk

