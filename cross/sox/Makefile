PKG_NAME = sox
PKG_VERS = 14.4.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/$(PKG_NAME)/files/sox/$(PKG_VERS)/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/flac
DEPENDS += cross/lame
DEPENDS += cross/opencore-amr

HOMEPAGE = https://sourceforge.net/projects/sox/
COMMENT  = SoX is the Swiss Army Knife of sound processing utilities. It can convert audio files to other popular audio file types and also apply sound effects and filters during the conversion.
LICENSE  = GPL & LGPL v2

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
