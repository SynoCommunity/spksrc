

PKG_NAME = python26
PKG_VERS = 2.6.6
PKG_EXT = tar.bz2
PKG_DIST_NAME = Python-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.python.org/ftp/python/$(PKG_VERS)
PKG_DIR = Python-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl cross/sqlite
DEPENDS += native/$(PKG_NAME)

MAINTAINER = superzebulon@superzebulon.org
HOMEPAGE   = http://www.python.org/
COMMENT    = Python Programming Language
LICENSE    =

GNU_CONFIGURE = 1
ADDITIONAL_CFLAGS =  -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
CONFIGURE_ARGS = --enable-ipv6 

COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall
POST_INSTALL_TARGET = $(WORK_DIR)/python-cc.mk

include ../../mk/spksrc.cross-cc.mk

HOSTPYTHON_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR)/python
HOSTPGEN_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR)/Parser/pgen

HOSTPYTHON = $(WORK_DIR)/$(PKG_DIR)/hostpython
HOSTPGEN = $(WORK_DIR)/$(PKG_DIR)/hostpgen

myCompile:
	cp $(HOSTPYTHON_NATIVE) $(HOSTPYTHON)
	cp $(HOSTPGEN_NATIVE) $(HOSTPGEN)
	$(RUN) $(MAKE) HOSTPYTHON=$(HOSTPYTHON) HOSTPGEN=$(HOSTPGEN) CROSS_COMPILE_TARGET=yes
	
myInstall:
	$(RUN) $(MAKE) HOSTPYTHON=$(HOSTPYTHON) HOSTPGEN=$(HOSTPGEN) CROSS_COMPILE_TARGET=yes install prefix=$(STAGING_INSTALL_PREFIX)

$(WORK_DIR)/python-cc.mk: Makefile
	@echo HOSTPYTHON=$(HOSTPYTHON) > $@
	
