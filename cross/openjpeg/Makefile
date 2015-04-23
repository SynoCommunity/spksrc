PKG_NAME = openjpeg
PKG_VERS = 2.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/openjpeg.mirror/files/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.openjpeg.org/
COMMENT  = The OpenJPEG library is an open-source JPEG 2000 codec written in C language.
LICENSE  = BSD

# GNU_CONFIGURE = 1

CONFIGURE_TARGET = nop
COMPILE_TARGET = myCompile

include ../../mk/spksrc.cross-cc.mk

ENV += DESTDIR=$(WORK_DIR)/install/

myCompile:
	$(RUN) cmake . && $(RUN) make


