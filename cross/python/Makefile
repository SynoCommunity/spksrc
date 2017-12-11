PKG_NAME = python
PKG_VERS_MAJOR = 2
PKG_VERS_MINOR = 7
PKG_VERS_PATCH = 13
PKG_VERS = $(PKG_VERS_MAJOR).$(PKG_VERS_MINOR).$(PKG_VERS_PATCH)
PKG_EXT = tar.xz
PKG_DIST_NAME = Python-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.python.org/ftp/python/$(PKG_VERS)
PKG_DIR = Python-$(PKG_VERS)

DEPENDS  = cross/zlib cross/openssl cross/sqlite cross/readline cross/ncurses cross/bzip2
DEPENDS += cross/berkeleydb native/$(PKG_NAME)

HOMEPAGE = http://www.python.org
COMMENT  = Python Programming Language
LICENSE  = PSF

GNU_CONFIGURE = 1
ADDITIONAL_CFLAGS = -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
CONFIGURE_ARGS  = --enable-shared --enable-unicode=ucs4 --enable-ipv6 PYTHON_FOR_BUILD=$(HOSTPYTHON) PGEN_FOR_BUILD=$(HOSTPGEN)
CONFIGURE_ARGS += ac_cv_file__dev_ptmx=yes ac_cv_file__dev_ptc=no ac_cv_have_long_long_format=yes ac_cv_buggy_getaddrinfo=no

POST_PATCH_TARGET = myPostPatch
PRE_CONFIGURE_TARGET = myPreConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall
POST_INSTALL_TARGET = myPostInstall

include ../../mk/spksrc.cross-cc.mk

HOST_ARCH = $(shell uname -m)
BUILD_ARCH = $(shell expr "$(TC_TARGET)" : '\([^-]*\)' )
PYTHON_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/bin/python
PGEN_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR)/Parser/pgen
PIP_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/bin/pip
HOSTPYTHON = $(WORK_DIR)/$(PKG_DIR)/hostpython
HOSTPGEN = $(WORK_DIR)/$(PKG_DIR)/hostpgen
HOSTPYTHON_LIB_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR)/build/lib.linux-$(HOST_ARCH)-$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)
PYTHON_LIB_NATIVE = $(WORK_DIR)/$(PKG_DIR)/build/lib.linux-$(HOST_ARCH)-$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)
PYTHON_SITE_PACKAGES_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/lib/python$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)/site-packages
PYTHON_LIB_CROSS = $(WORK_DIR)/$(PKG_DIR)/build/lib.linux2-$(BUILD_ARCH)-$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)
PYTHON_LIB_DIR = lib/python$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)
PYTHON_INC_DIR = include/python$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)

.PHONY: myPostPatch
myPostPatch:
	$(RUN) sed -e 's#@INSTALL_PREFIX@#$(INSTALL_PREFIX)#' -i Lib/mimetypes.py

.PHONY: myPreConfigure
myPreConfigure:
	cp $(PYTHON_NATIVE) $(HOSTPYTHON)
	cp $(PGEN_NATIVE) $(HOSTPGEN)
	$(RUN) autoreconf

.PHONY: myCompile
myCompile:
	$(RUN) _PYTHON_HOST_PLATFORM=$(TC_TARGET) $(MAKE)

.PHONY: myInstall
myInstall:
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/etc
	@install -m 644 src/mime.types $(STAGING_INSTALL_PREFIX)/etc/
	$(RUN) _PYTHON_HOST_PLATFORM=$(TC_TARGET) $(MAKE) install prefix=$(STAGING_INSTALL_PREFIX)

.PHONY: myPostInstall
myPostInstall: $(WORK_DIR)/python-cc.mk
	cp -R $(HOSTPYTHON_LIB_NATIVE) $(PYTHON_LIB_CROSS)/../
	cp $(PYTHON_LIB_CROSS)/_sysconfigdata.py* $(PYTHON_LIB_NATIVE)/

$(WORK_DIR)/python-cc.mk:
	@echo HOSTPYTHON=$(HOSTPYTHON) > $@
	@echo HOSTPYTHON_LIB_NATIVE=$(HOSTPYTHON_LIB_NATIVE) >> $@
	@echo PYTHON_LIB_NATIVE=$(PYTHON_LIB_NATIVE) >> $@
	@echo PYTHON_SITE_PACKAGES_NATIVE=$(PYTHON_SITE_PACKAGES_NATIVE) >> $@
	@echo PYTHON_INTERPRETER=$(INSTALL_PREFIX)/bin/python >> $@
	@echo PYTHON_VERSION=$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR) >> $@
	@echo PYTHON_LIB_CROSS=$(PYTHON_LIB_CROSS) >> $@
	@echo PYTHON_LIB_DIR=$(PYTHON_LIB_DIR) >> $@
	@echo PYTHON_INC_DIR=$(PYTHON_INC_DIR) >> $@
	@echo PIP=$(PIP_NATIVE) >> $@
	@echo CROSS_COMPILE_WHEELS=1 >> $@
