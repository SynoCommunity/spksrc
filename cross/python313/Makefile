PKG_NAME = python313
PKG_VERS = 3.13.1
PKG_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_EXT = tar.xz
PKG_DIST_NAME = Python-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.python.org/ftp/python/$(PKG_VERS)
PKG_DIR = Python-$(PKG_VERS)

# Compiler must support std=c++11
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

BUILD_DEPENDS = native/python313

DEPENDS  = cross/zlib cross/sqlite cross/readline cross/ncursesw cross/bzip2 cross/xz
# required for Sleepycat^WOracle Berkeley DB interface
DEPENDS += cross/berkeleydb
# required for uuid module
DEPENDS += cross/libuuid

HOMEPAGE = https://www.python.org/
COMMENT  = Python Programming Language
LICENSE  = PSF

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --enable-shared
CONFIGURE_ARGS += --without-static-libpython
CONFIGURE_ARGS += --enable-ipv6
# installed pip is not on PATH
CONFIGURE_ARGS += --without-ensurepip
CONFIGURE_ARGS += --enable-loadable-sqlite-extensions
CONFIGURE_ARGS += --with-computed-gotos=yes
CONFIGURE_ARGS += --with-build-python=$(PYTHON_NATIVE)
CONFIGURE_ARGS += --with-readline=readline
CONFIGURE_ARGS += --disable-test-modules

include ../../mk/spksrc.archs.mk

# optionally generate optimized code
ifeq ($(strip $(PYTHON_OPTIMIZE)),1)
#
# Enable Link-Time Optimization
CONFIGURE_ARGS += --with-lto
#
# pgo optimization can only be run native platform and now
# exit on errors which had no impact (and effects) previously.
#    https://github.com/python/cpython/pull/111950
#CONFIGURE_ARGS += --enable-optimizations
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
# for qoriq
ADDITIONAL_LDFLAGS = -latomic
endif

CONFIGURE_ARGS += ac_cv_buggy_getaddrinfo=no
CONFIGURE_ARGS += ac_cv_file__dev_ptmx=no
CONFIGURE_ARGS += ac_cv_file__dev_ptc=no
CONFIGURE_ARGS += ac_cv_have_long_long_format=yes

DEPENDS += cross/openssl3
CONFIGURE_ARGS += --with-ssl-default-suites=openssl

DEPENDS += cross/gdbm
CONFIGURE_ARGS += --with-dbmliborder=gdbm:ndbm:bdb

DEPENDS += cross/libexpat
CONFIGURE_ARGS += --with-system-expat

# libffi is no longer bundled with python
DEPENDS += cross/libffi

ADDITIONAL_CFLAGS = -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -L $(STAGING_INSTALL_PREFIX)/lib -I $(STAGING_INSTALL_PREFIX)/include

POST_PATCH_TARGET    = python313_post_patch
PRE_CONFIGURE_TARGET = python313_pre_configure
COMPILE_TARGET       = python313_compile
INSTALL_TARGET       = python313_install

include ../../mk/spksrc.cross-cc.mk

PYTHON_NATIVE = $(abspath $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/bin/python$(PKG_VERS_MAJOR_MINOR))
HOSTPYTHON = $(WORK_DIR)/$(PKG_DIR)/hostpython

.PHONY: python313_post_patch
python313_post_patch:
	$(RUN) sed -e 's#@INSTALL_PREFIX@#$(INSTALL_PREFIX)#' -i Lib/mimetypes.py

.PHONY: python313_pre_configure
python313_pre_configure:
	cp $(PYTHON_NATIVE) $(HOSTPYTHON)
	$(RUN) autoreconf -ivf -Werror
	# create phantom header and library to succeed add_dir_to_list in setup.py
	# so that future-promised libsqlite3.so and sqlite3.h will be used.  Yep,
	# it's a bit hokey, but avoids editing upstream pristine source
	mkdir -p $(STAGING_INSTALL_PREFIX)/lib $(STAGING_INSTALL_PREFIX)/include
	mkdir -p $(WORK_DIR)/Python-$(PKG_VERS)/Include $(WORK_DIR)/Python-$(PKG_VERS)/lib
	test -h $(WORK_DIR)/Python-$(PKG_VERS)/Include/sqlite3.h || ln -fs $(STAGING_INSTALL_PREFIX)/include/sqlite3.h $(WORK_DIR)/Python-$(PKG_VERS)/Include/sqlite3.h
	test -h $(WORK_DIR)/Python-$(PKG_VERS)/lib/libsqlite3.so || ln -fs $(STAGING_INSTALL_PREFIX)/lib/libsqlite3.so $(WORK_DIR)/Python-$(PKG_VERS)/lib/

.PHONY: python313_compile
python313_compile:
	$(RUN) _PYTHON_HOST_PLATFORM=$(TC_TARGET) $(MAKE) -j $(NCPUS)

.PHONY: python313_install
python313_install:
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/etc
	@install -m 644 src/mime.types $(STAGING_INSTALL_PREFIX)/etc/
	$(RUN) _PYTHON_HOST_PLATFORM=$(TC_TARGET) $(MAKE) install prefix=$(STAGING_INSTALL_PREFIX)
