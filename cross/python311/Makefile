PKG_NAME = python311
PKG_VERS = 3.11.11
PKG_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_EXT = tar.xz
PKG_DIST_NAME = Python-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.python.org/ftp/python/$(PKG_VERS)
PKG_DIR = Python-$(PKG_VERS)

# Platform "powerpc-none-linux-gnuspe" with compiler "gcc" is not supported by the
# CPython core team, see https://peps.python.org/pep-0011/ for more information.
# And compiler must support std=c++11 (OlD_PPC_ARCHS fail, but ARMv5_ARCHS have no issue).
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

BUILD_DEPENDS = native/python311

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
CONFIGURE_ARGS += --with-system-ffi

ADDITIONAL_CFLAGS = -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -L $(STAGING_INSTALL_PREFIX)/lib -I $(STAGING_INSTALL_PREFIX)/include

POST_PATCH_TARGET    = python311_post_patch
PRE_CONFIGURE_TARGET = python311_pre_configure
COMPILE_TARGET       = python311_compile
INSTALL_TARGET       = python311_install

include ../../mk/spksrc.cross-cc.mk

PYTHON_NATIVE = $(abspath $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/bin/python$(PKG_VERS_MAJOR_MINOR))
HOSTPYTHON = $(WORK_DIR)/$(PKG_DIR)/hostpython

.PHONY: python311_post_patch
python311_post_patch:
	$(RUN) sed -e 's#@INSTALL_PREFIX@#$(INSTALL_PREFIX)#' -i Lib/mimetypes.py

.PHONY: python311_pre_configure
python311_pre_configure:
	cp $(PYTHON_NATIVE) $(HOSTPYTHON)
	$(RUN) autoreconf
	# create phantom header and library to succeed add_dir_to_list in setup.py
	# so that future-promised libsqlite3.so and sqlite3.h will be used.  Yep,
	# it's a bit hokey, but avoids editing upstream pristine source
	mkdir -p $(STAGING_INSTALL_PREFIX)/lib $(STAGING_INSTALL_PREFIX)/include
	mkdir -p $(WORK_DIR)/Python-$(PKG_VERS)/Include $(WORK_DIR)/Python-$(PKG_VERS)/lib
	test -h $(WORK_DIR)/Python-$(PKG_VERS)/Include/sqlite3.h || ln -fs $(STAGING_INSTALL_PREFIX)/include/sqlite3.h $(WORK_DIR)/Python-$(PKG_VERS)/Include/sqlite3.h
	test -h $(WORK_DIR)/Python-$(PKG_VERS)/lib/libsqlite3.so || ln -fs $(STAGING_INSTALL_PREFIX)/lib/libsqlite3.so $(WORK_DIR)/Python-$(PKG_VERS)/lib/

.PHONY: python311_compile
python311_compile:
	$(RUN) _PYTHON_HOST_PLATFORM=$(TC_TARGET) $(MAKE) -j $(NCPUS)

.PHONY: python311_install
python311_install:
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/etc
	@install -m 644 src/mime.types $(STAGING_INSTALL_PREFIX)/etc/
	$(RUN) _PYTHON_HOST_PLATFORM=$(TC_TARGET) $(MAKE) install prefix=$(STAGING_INSTALL_PREFIX)
