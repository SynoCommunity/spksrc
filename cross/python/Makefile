PKG_NAME = python
PKG_VERS_MAJOR = 2
PKG_VERS_MINOR = 7
PKG_VERS_PATCH = 15
PKG_VERS = $(PKG_VERS_MAJOR).$(PKG_VERS_MINOR).$(PKG_VERS_PATCH)
PKG_EXT = tar.xz
PKG_DIST_NAME = Python-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.python.org/ftp/python/$(PKG_VERS)
PKG_DIR = Python-$(PKG_VERS)

DEPENDS  = cross/zlib cross/openssl cross/sqlite cross/readline cross/ncurses cross/bzip2
DEPENDS += cross/berkeleydb-5.3 native/$(PKG_NAME)

HOMEPAGE = http://www.python.org
COMMENT  = Python Programming Language
LICENSE  = PSF

GNU_CONFIGURE = 1
ADDITIONAL_CFLAGS = -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
CONFIGURE_ARGS  = --enable-shared --enable-unicode=ucs4 --target=$(TC_TARGET) --enable-ipv6 PYTHON_FOR_BUILD=$(HOSTPYTHON) PYTHON_LIB_NATIVE=$(PYTHON_LIB_NATIVE)
CONFIGURE_ARGS += ac_cv_file__dev_ptmx=yes ac_cv_file__dev_ptc=no ac_cv_have_long_long_format=yes ac_cv_buggy_getaddrinfo=no

POST_PATCH_TARGET = python_post_patch
PRE_CONFIGURE_TARGET = python_pre_configure
PRE_INSTALL_TARGET = python_pre_install
POST_INSTALL_TARGET = python_post_install

PLIST_TRANSFORM = sed -e 's%@PKG_SHORT_VERS@%$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)%'

include ../../mk/spksrc.cross-cc.mk

HOST_ARCH = $(shell uname -m)
BUILD_ARCH = $(shell expr "$(TC_TARGET)" : '\([^-]*\)' )
PYTHON_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/bin/python
PIP_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/bin/pip
HOSTPYTHON = $(WORK_DIR)/$(PKG_DIR)/hostpython
HOSTPYTHON_LIB_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR)/build/lib.linux-$(HOST_ARCH)-$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)
PYTHON_LIB_NATIVE = $(WORK_DIR)/$(PKG_DIR)/build/lib.linux-$(HOST_ARCH)-$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)
PYTHON_SITE_PACKAGES_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/lib/python$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)/site-packages
PYTHON_LIB_CROSS = $(WORK_DIR)/$(PKG_DIR)/build/lib.linux2-$(BUILD_ARCH)-$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)
PYTHON_LIB_DIR = lib/python$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)
PYTHON_INC_DIR = include/python$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)

.PHONY: python_post_patch
python_post_patch:
	# Need to bring our own mime-type definitions
	$(RUN) sed -e 's#@INSTALL_PREFIX@#$(INSTALL_PREFIX)#' -i Lib/mimetypes.py

.PHONY: python_pre_configure
python_pre_configure:
	# Needed for cross-compilation of wheels
	cp $(PYTHON_NATIVE) $(HOSTPYTHON)
	# Needed to apply patch-changes to configure.ac
	$(RUN) autoreconf

.PHONY: python_pre_install
python_pre_install:
	# Needed to have native modules available when compiling wheels
	cp -R $(HOSTPYTHON_LIB_NATIVE) $(PYTHON_LIB_CROSS)/../
	# Supplies correct flags
	cp $(PYTHON_LIB_CROSS)/_sysconfigdata.py* $(PYTHON_LIB_NATIVE)/

.PHONY: python_post_install
python_post_install: $(WORK_DIR)/python-cc.mk
	# Add mimetypes
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/etc/
	@install -m 644 -D src/mime.types $(STAGING_INSTALL_PREFIX)/etc/

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
