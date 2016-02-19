PKG_NAME = faad2
PKG_VERS = 2.7
PKG_EXT = tar.bz2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/faac

DEPENDS = 

HOMEPAGE = http://www.audiocoding.com/faad2.html
COMMENT  = Open source MPEG-4 and MPEG-2 AAC decoder
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --prefix=$(INSTALL_PREFIX) --disable-static
CONFIGURE_TARGET = myConfigure

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure:
	$(RUN) sed -i "s:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:g" configure.in
	$(RUN) sed -i "s:man_MANS:man1_MANS:g" frontend/Makefile.am
	$(RUN) autoreconf -fi
	$(RUN) ./configure $(TC_CONFIGURE_ARGS) $(CONFIGURE_ARGS)

