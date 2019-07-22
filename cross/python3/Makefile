PKG_NAME = python3
PKG_VERS_MAJOR = 3
PKG_VERS_MINOR = 6
PKG_VERS_PATCH = 8
PKG_VERS = $(PKG_VERS_MAJOR).$(PKG_VERS_MINOR).$(PKG_VERS_PATCH)
PKG_EXT = tar.xz
PKG_DIST_NAME = Python-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.python.org/ftp/python/$(PKG_VERS)
PKG_DIR = Python-$(PKG_VERS)

DEPENDS  = cross/zlib cross/openssl cross/sqlite cross/readline cross/ncurses cross/bzip2 cross/xz
DEPENDS += native/$(PKG_NAME)

HOMEPAGE = http://www.python.org/
COMMENT  = Python Programming Language
LICENSE  = PSF

GNU_CONFIGURE = 1
ADDITIONAL_CFLAGS = -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -L $(STAGING_INSTALL_PREFIX)/lib -I $(STAGING_INSTALL_PREFIX)/include
CONFIGURE_ARGS  = --enable-shared --enable-ipv6 --without-ensurepip --enable-loadable-sqlite-extensions PYTHON_FOR_BUILD=$(HOSTPYTHON) PGEN_FOR_BUILD=$(HOSTPGEN)
CONFIGURE_ARGS += ac_cv_buggy_getaddrinfo=no ac_cv_file__dev_ptmx=no ac_cv_file__dev_ptc=no ac_cv_have_long_long_format=yes

POST_PATCH_TARGET = python3_post_patch
PRE_CONFIGURE_TARGET = python3_pre_configure
COMPILE_TARGET = python3_custom_compile
INSTALL_TARGET = python3_custom_install
POST_INSTALL_TARGET = python3_post_install

PLIST_TRANSFORM = sed -e 's%@PKG_SHORT_VERS@%$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)%'

include ../../mk/spksrc.cross-cc.mk

HOST_ARCH = $(shell uname -m)
BUILD_ARCH = $(shell expr "$(TC_TARGET)" : '\([^-]*\)' )
PYTHON_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/bin/python$(PKG_VERS_MAJOR)
PIP_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/bin/pip
PGEN_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR)/Parser/pgen
HOSTPYTHON = $(WORK_DIR)/$(PKG_DIR)/hostpython
HOSTPGEN = $(WORK_DIR)/$(PKG_DIR)/hostpgen
HOSTPYTHON_LIB_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR)/build/lib.linux-$(HOST_ARCH)-$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)
PYTHON_LIB_NATIVE = $(WORK_DIR)/$(PKG_DIR)/build/lib.linux-$(HOST_ARCH)-$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)
PYTHON_SITE_PACKAGES_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/lib/python$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)/site-packages
PYTHON_LIB_CROSS = $(WORK_DIR)/$(PKG_DIR)/build/lib.linux-$(BUILD_ARCH)-$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)
PYTHON_LIB_DIR = lib/python$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)
PYTHON_INC_DIR = include/python$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)m

.PHONY: python3_post_patch
python3_post_patch:
	$(RUN) sed -e 's#@INSTALL_PREFIX@#$(INSTALL_PREFIX)#' -i Lib/mimetypes.py

.PHONY: python3_pre_configure
python3_pre_configure:
	cp $(PYTHON_NATIVE) $(HOSTPYTHON)
	cp $(PGEN_NATIVE) $(HOSTPGEN)
	$(RUN) autoreconf
	# create phantom header and library to succeed add_dir_to_list in setup.py
	# so that future-promised libsqlite3.so and sqlite3.h will be used.  Yep,
	# it's a bit hokey, but avoids editing upstream pristine source
	mkdir -p $(STAGING_INSTALL_PREFIX)/lib $(STAGING_INSTALL_PREFIX)/include
	mkdir -p $(WORK_DIR)/Python-$(PKG_VERS)/Include $(WORK_DIR)/Python-$(PKG_VERS)/lib
	test -h $(WORK_DIR)/Python-$(PKG_VERS)/Include/sqlite3.h || ln -fs $(STAGING_INSTALL_PREFIX)/include/sqlite3.h $(WORK_DIR)/Python-$(PKG_VERS)/Include/sqlite3.h
	test -h $(WORK_DIR)/Python-$(PKG_VERS)/lib/libsqlite3.so || ln -fs $(STAGING_INSTALL_PREFIX)/lib/libsqlite3.so $(WORK_DIR)/Python-$(PKG_VERS)/lib/

.PHONY: python3_custom_compile
python3_custom_compile:
	$(RUN) _PYTHON_HOST_PLATFORM=$(TC_TARGET) $(MAKE)

.PHONY: python3_custom_install
python3_custom_install:
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/etc
	@install -m 644 src/mime.types $(STAGING_INSTALL_PREFIX)/etc/
	$(RUN) _PYTHON_HOST_PLATFORM=$(TC_TARGET) $(MAKE) install prefix=$(STAGING_INSTALL_PREFIX)

.PHONY: python3_post_install
python3_post_install: $(WORK_DIR)/python-cc.mk
	mkdir -p $(PYTHON_LIB_CROSS)
	cp -R $(HOSTPYTHON_LIB_NATIVE) $(PYTHON_LIB_CROSS)/../
ifneq ($(PYTHON_LIB_NATIVE),$(PYTHON_LIB_CROSS))
	cp $(PYTHON_LIB_CROSS)/_sysconfigdata_*.py $(PYTHON_LIB_NATIVE)/_sysconfigdata.py
endif

$(WORK_DIR)/python-cc.mk:
	@echo HOSTPYTHON=$(HOSTPYTHON) > $@
	@echo HOSTPYTHON_LIB_NATIVE=$(HOSTPYTHON_LIB_NATIVE) >> $@
	@echo PYTHON_LIB_NATIVE=$(PYTHON_LIB_NATIVE) >> $@
	@echo PYTHON_SITE_PACKAGES_NATIVE=$(PYTHON_SITE_PACKAGES_NATIVE) >> $@
	@echo PYTHON_INTERPRETER=$(INSTALL_PREFIX)/bin/python$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR) >> $@
	@echo PYTHON_VERSION=$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR) >> $@
	@echo PYTHON_LIB_CROSS=$(PYTHON_LIB_CROSS) >> $@
	@echo PYTHON_LIB_DIR=$(PYTHON_LIB_DIR) >> $@
	@echo PYTHON_INC_DIR=$(PYTHON_INC_DIR) >> $@
	@echo PIP=$(PIP_NATIVE) >> $@
	@echo CROSS_COMPILE_WHEELS=1 >> $@
