PKG_NAME = js
PKG_VERS = 1.6.20070208
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://download.openpkg.org/components/cache/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# former url (not working anymore):
# ftp://ftp.ossp.org/pkg/lib/js/js-1.6.20070208.tar.gz
# working mirrors:
# http://download.openpkg.org/components/cache/js/js-1.6.20070208.tar.gz
# http://www.mirrorservice.org/sites/ftp.ossp.org/pkg/lib/js/js-1.6.20070208.tar.gz

DEPENDS =

HOMEPAGE = http://www.ossp.org/pkg/lib/js/
COMMENT  = Mozilla JavaScript Engine
LICENSE  = MPL/GPL/LGPL tri-license

GNU_CONFIGURE = 1
CONFIGURE_ARGS = ac_cv_va_copy=C99 --disable-dependency-tracking --disable-static

PRE_COMPILE_TARGET = js_pre_compile

include ../../mk/spksrc.archs.mk

PRE_COMPILE_HOST_CPU =
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
PRE_COMPILE_HOST_CPU = -D__x86_64__
endif
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
PRE_COMPILE_HOST_CPU = -D__i386__
endif
ifeq ($(findstring $(ARCH),$(ARM_ARCHS)),$(ARCH))
PRE_COMPILE_HOST_CPU = -D__arm__
endif
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
PRE_COMPILE_HOST_CPU = -D__powerpc__
endif

ifeq (,$(PRE_COMPILE_HOST_CPU))
$(error "HOST CPU for ARCH $(ARCH) is not defined)
endif

PRE_COMPILE_ARGS = -DCROSS_COMPILE=1 -DNDEBUG $(PRE_COMPILE_HOST_CPU)

include ../../mk/spksrc.cross-cc.mk

.PHONY: js_pre_compile
# Compile jscpucfg executable for local cpu. 
# Regular build will use this to generate jsautocfg.h for host cpu.
js_pre_compile:
	cp src/prtypes.h $(WORK_DIR)/$(PKG_DIR)
	cd $(WORK_DIR)/$(PKG_DIR) && gcc -I. $(PRE_COMPILE_ARGS) -o jscpucfg.o -c src/jscpucfg.c
	cd $(WORK_DIR)/$(PKG_DIR) && gcc -o jscpucfg jscpucfg.o
