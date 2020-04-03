PKG_NAME = libsamplerate
PKG_VERS = 0.1.9
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.mega-nerd.com/SRC/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = http://www.mega-nerd.com
COMMENT  = Secret Rabbit Code (aka libsamplerate) is a Sample Rate Converter for audio. \
	   One example of where such a thing would be useful is converting audio \
	   from the CD sample rate of 44.1kHz to the 48kHz sample rate used by DAT players.
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-shared=yes --with-pic

include ../../mk/spksrc.cross-cc.mk
