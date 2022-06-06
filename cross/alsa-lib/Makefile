PKG_NAME = alsa-lib
PKG_VERS = 1.2.7
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.alsa-project.org/files/pub/lib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.alsa-project.org/
COMMENT  = Advanced Linux Sound Architecture provides audio and MIDI functionality to the Linux operating system.
LICENSE  = LGPLv2.1

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-python

ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH), ppc853x ppc854x),$(ARCH))
ADDITIONAL_CFLAGS += -DNO_TLS_PFX
endif

include ../../mk/spksrc.cross-cc.mk
