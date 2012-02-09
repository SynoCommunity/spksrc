

PKG_NAME = python27
PKG_VERS = 2.7.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = Python-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.python.org/ftp/python/$(PKG_VERS)
PKG_DIR = Python-$(PKG_VERS)

DEPENDS  = cross/zlib cross/openssl cross/sqlite cross/readline cross/ncurses cross/bzip2
DEPENDS += cross/pyextdirect
DEPENDS += native/$(PKG_NAME)

MAINTAINER = superzebulon@superzebulon.org
HOMEPAGE   = http://www.python.org/
COMMENT    = Python Programming Language
LICENSE    =

# Patch
POST_PATCH_TARGET = pyPostPatch

# Configure
GNU_CONFIGURE = 1
ADDITIONAL_CFLAGS =  -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
CONFIGURE_ARGS = --enable-ipv6 ac_cv_buggy_getaddrinfo=no

# Compile
COMPILE_TARGET = myCompile

# Install
INSTALL_TARGET = myInstall
POST_INSTALL_TARGET = $(WORK_DIR)/python-cc.mk

include ../../mk/spksrc.cross-cc.mk

HOSTPYTHON_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR)/python
HOSTPYTHON_LIB_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR)/build/lib.linux-i686-2.7
PYTHON_LIB_CROSS = $(WORK_DIR)/$(PKG_DIR)/build/lib.linux-i686-2.7
HOSTPGEN_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR)/Parser/pgen
PYTHON_LIB_DIR = lib/python2.7

HOSTPYTHON = $(WORK_DIR)/$(PKG_DIR)/hostpython
HOSTPGEN = $(WORK_DIR)/$(PKG_DIR)/hostpgen

pyPostPatch:
	$(RUN) sed -e 's#@INSTALL_PREFIX@#$(INSTALL_PREFIX)#' -i Lib/mimetypes.py

myCompile:
	cp $(HOSTPYTHON_NATIVE) $(HOSTPYTHON)
	cp $(HOSTPGEN_NATIVE) $(HOSTPGEN)
	$(RUN) $(MAKE) HOSTPYTHON=$(HOSTPYTHON) HOSTPGEN=$(HOSTPGEN) CROSS_COMPILE_TARGET=yes
	
myInstall:
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/etc
	@install -m 644 src/mime.types $(STAGING_INSTALL_PREFIX)/etc/
	$(RUN) $(MAKE) HOSTPYTHON=$(HOSTPYTHON) HOSTPGEN=$(HOSTPGEN) CROSS_COMPILE_TARGET=yes install prefix=$(STAGING_INSTALL_PREFIX)

$(WORK_DIR)/python-cc.mk: Makefile
	@echo HOSTPYTHON=$(HOSTPYTHON) > $@
	@echo HOSTPYTHON_LIB_NATIVE=$(HOSTPYTHON_LIB_NATIVE) >> $@
	@echo PYTHON_LIB_CROSS=$(PYTHON_LIB_CROSS) >> $@
	@echo PYTHON_LIB_DIR=$(PYTHON_LIB_DIR) >> $@
