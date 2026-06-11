PKG_NAME = sox
PKG_VERS = 14.4.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/chirlu/sox/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/flac
DEPENDS += cross/lame
DEPENDS += cross/opencore-amr

HOMEPAGE = https://sox.sourceforge.net
COMMENT  = SoX is the Swiss Army Knife of sound processing utilities. It can convert audio files to other popular audio file types and also apply sound effects and filters during the conversion.
LICENSE  = GPL & LGPL v2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static
PRE_CONFIGURE_TARGET = sox_pre_configure

ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk

.PHONY: sox_pre_configure
sox_pre_configure:
	$(RUN) autoreconf -ivf
