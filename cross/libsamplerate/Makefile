PKG_NAME = libsamplerate
PKG_VERS = 0.1.8
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://www.mega-nerd.com/SRC

DEPENDS = cross/libsndfile

HOMEPAGE = http://www.mega-nerd.com/SRC/
COMMENT  = Secret Rabbit Code (aka libsamplerate) is a Sample Rate Converter for audio
LICENSE  = GPL

GNU_CONFIGURE = 1
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) make install DESTDIR=$(INSTALL_DIR)

