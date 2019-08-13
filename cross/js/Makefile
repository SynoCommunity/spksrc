PKG_NAME = js
PKG_VERS = 1.6.20070208
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://download.openpkg.org/components/cache/$(PKG_NAME)

# former url (not working anymore):
# ftp://ftp.ossp.org/pkg/lib/js/js-1.6.20070208.tar.gz
# mirrors:
# http://download.openpkg.org/components/cache/js/js-1.6.20070208.tar.gz
# http://www.mirrorservice.org/sites/ftp.ossp.org/pkg/lib/js/js-1.6.20070208.tar.gz

DEPENDS =

HOMEPAGE = http://www.ossp.org/pkg/lib/js/
COMMENT  = Mozilla JavaScript Engine
LICENSE  = MPL/GPL/LGPL tri-license

GNU_CONFIGURE = 1
CONFIGURE_ARGS = ac_cv_va_copy=C99 --disable-dependency-tracking --disable-static

PRE_COMPILE_TARGET = myPreCompile

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreCompile
myPreCompile:
	cp src/prtypes.h $(WORK_DIR)/$(PKG_DIR)
	cd $(WORK_DIR)/$(PKG_DIR) && gcc -I. -DCROSS_COMPILE=1 -DNDEBUG -pipe -o jscpucfg.o -c src/jscpucfg.c
	cd $(WORK_DIR)/$(PKG_DIR) && gcc -o jscpucfg jscpucfg.o

