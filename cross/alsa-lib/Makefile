PKG_NAME = alsa-lib
PKG_VERS = 1.1.0
PKG_EXT = tar.bz2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.alsa-project.org/pub/lib

DEPENDS =

HOMEPAGE = http://www.alsa-project.org/
COMMENT  = Advanced Linux Sound Architecture provides audio and MIDI functionality to the Linux operating system
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-python
ifeq ($(findstring $(ARCH),88f5281 ppc853x ppc854x),$(ARCH))
ADDITIONAL_CFLAGS = -DNO_TLS_PFX
endif

INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk


.PHONY: myInstall
myInstall:
	$(RUN) make install DESTDIR=$(INSTALL_DIR)

