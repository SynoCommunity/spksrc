
PKG_NAME = espeak
PKG_SHORT_VERS = 1.46
PKG_VERS = $(PKG_SHORT_VERS).01
PKG_EXT = zip
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)-source/src
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-source.$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/$(PKG_NAME)/$(PKG_NAME)/$(PKG_NAME)-$(PKG_SHORT_VERS)
PORTAUDIO_VERS = 19

DEPENDS = cross/portaudio

MAINTAINER=	http://packages.nas-forum.com/
HOMEPAGE=	http://sourceforge.net/projects/$(PKG_NAME)/
COMMENT=	Compact open source software speech synthesizer
LICENSE=	GPL

GNU_CONFIGURE = 1

CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure:
	$(RUN) cp portaudio$(PORTAUDIO_VERS).h portaudio.h

.PHONY: myCompile
myCompile:
	$(RUN) $(MAKE) DATADIR=$(INSTALL_PREFIX)/share/espeak-data

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX) DATADIR=$(INSTALL_PREFIX)/share/espeak-data
