PKG_NAME = python38
PKG_VERS = 3.8.16
PKG_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_EXT = tar.xz
PKG_DIST_NAME = Python-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.python.org/ftp/python/$(PKG_VERS)
PKG_DIR = Python-$(PKG_VERS)

BUILD_DEPENDS = native/python38

DEPENDS  = cross/zlib cross/sqlite cross/readline cross/ncursesw cross/bzip2 cross/xz
# required for uuid module
DEPENDS += cross/libuuid

HOMEPAGE = https://www.python.org/
COMMENT  = Python Programming Language
LICENSE  = PSF

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --enable-shared
CONFIGURE_ARGS += --enable-ipv6
# installed pip is not on PATH
CONFIGURE_ARGS += --without-ensurepip
CONFIGURE_ARGS += --enable-loadable-sqlite-extensions
CONFIGURE_ARGS += --with-computed-gotos=yes

include ../../mk/spksrc.archs.mk

# optionally generate optimized code
ifeq ($(strip $(PYTHON_OPTIMIZE)),1)
CONFIGURE_ARGS += --enable-optimizations
# old compilers fail with unrecognized command line options: -flto -fuse-linker-plugin -ffat-lto-objects -flto-partition=none
ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
# Enable Link-Time Optimization
CONFIGURE_ARGS += --with-lto
endif
endif

ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
# older gcc does not know -Wno-unused-result
CONFIGURE_ARGS += ac_cv_disable_unused_result_warning=no
endif

CONFIGURE_ARGS += ac_cv_buggy_getaddrinfo=no
CONFIGURE_ARGS += ac_cv_file__dev_ptmx=no
CONFIGURE_ARGS += ac_cv_file__dev_ptc=no
CONFIGURE_ARGS += ac_cv_have_long_long_format=yes

DEPENDS += cross/openssl
CONFIGURE_ARGS += --with-ssl-default-suites=openssl

DEPENDS += cross/gdbm
CONFIGURE_ARGS += --with-dbmliborder=gdbm:ndbm:bdb

DEPENDS += cross/libexpat
CONFIGURE_ARGS += --with-system-expat

# libffi is no longer bundled with python
DEPENDS += cross/libffi
CONFIGURE_ARGS += --with-system-ffi

# Mandatory PYO3_* variables for rust cross-compiling
ENV += PYO3_CROSS_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib/
ENV += PYO3_CROSS_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/
# Mandatory of using OPENSSL_*_DIR starting with
# cryptography version >= 40
# https://docs.rs/openssl/latest/openssl/#automatic
ENV += OPENSSL_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib/
ENV += OPENSSL_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/


ADDITIONAL_CFLAGS = -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -L $(STAGING_INSTALL_PREFIX)/lib -I $(STAGING_INSTALL_PREFIX)/include

POST_PATCH_TARGET    = python38_post_patch
PRE_CONFIGURE_TARGET = python38_pre_configure
COMPILE_TARGET       = python38_compile
INSTALL_TARGET       = python38_install
POST_INSTALL_TARGET  = python38_post_install

include ../../mk/spksrc.cross-cc.mk

HOST_ARCH = $(shell uname -m)
BUILD_ARCH = $(shell expr "$(TC_TARGET)" : '\([^-]*\)' )
PYTHON_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/bin/python3
PIP_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/bin/pip
HOSTPYTHON = $(WORK_DIR)/$(PKG_DIR)/hostpython
HOSTPGEN = $(WORK_DIR)/$(PKG_DIR)/hostpgen
HOSTPYTHON_LIB_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR)/build/lib.linux-$(HOST_ARCH)-$(PKG_VERS_MAJOR_MINOR)
PYTHON_LIB_NATIVE = $(WORK_DIR)/$(PKG_DIR)/build/lib.linux-$(HOST_ARCH)-$(PKG_VERS_MAJOR_MINOR)
PYTHON_SITE_PACKAGES_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/lib/python$(PKG_VERS_MAJOR_MINOR)/site-packages
PYTHON_LIB_CROSS = $(WORK_DIR)/$(PKG_DIR)/build/lib.linux-$(BUILD_ARCH)-$(PKG_VERS_MAJOR_MINOR)
PYTHON_LIB_DIR = lib/python$(PKG_VERS_MAJOR_MINOR)
PYTHON_INC_DIR = include/python$(PKG_VERS_MAJOR_MINOR)

# Required so that the python3 binaries and libraries generated by native compilation
# take precedence over current environment python3 when generating
# target architecture resources
PATH := $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/bin:$(PATH)
LD_LIBRARY_PATH := $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/lib:$(LD_LIBRARY_PATH)
export PATH LD_LIBRARY_PATH

.PHONY: python38_post_patch
python38_post_patch:
	$(RUN) sed -e 's#@INSTALL_PREFIX@#$(INSTALL_PREFIX)#' -i Lib/mimetypes.py

.PHONY: python38_pre_configure
python38_pre_configure:
	cp $(PYTHON_NATIVE) $(HOSTPYTHON)
	$(RUN) autoreconf
	# create phantom header and library to succeed add_dir_to_list in setup.py
	# so that future-promised libsqlite3.so and sqlite3.h will be used.  Yep,
	# it's a bit hokey, but avoids editing upstream pristine source
	mkdir -p $(STAGING_INSTALL_PREFIX)/lib $(STAGING_INSTALL_PREFIX)/include
	mkdir -p $(WORK_DIR)/Python-$(PKG_VERS)/Include $(WORK_DIR)/Python-$(PKG_VERS)/lib
	test -h $(WORK_DIR)/Python-$(PKG_VERS)/Include/sqlite3.h || ln -fs $(STAGING_INSTALL_PREFIX)/include/sqlite3.h $(WORK_DIR)/Python-$(PKG_VERS)/Include/sqlite3.h
	test -h $(WORK_DIR)/Python-$(PKG_VERS)/lib/libsqlite3.so || ln -fs $(STAGING_INSTALL_PREFIX)/lib/libsqlite3.so $(WORK_DIR)/Python-$(PKG_VERS)/lib/

.PHONY: python38_compile
python38_compile:
	$(RUN) _PYTHON_HOST_PLATFORM=$(TC_TARGET) $(MAKE) -j $(NCPUS)

.PHONY: python38_install
python38_install:
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/etc
	@install -m 644 src/mime.types $(STAGING_INSTALL_PREFIX)/etc/
	$(RUN) _PYTHON_HOST_PLATFORM=$(TC_TARGET) $(MAKE) install prefix=$(STAGING_INSTALL_PREFIX)


# wheels to install in crossenv
CROSSENV_WHEELS  = setuptools-rust==1.6.0
CROSSENV_WHEELS += setuptools-scm==7.1.0
CROSSENV_WHEELS += wheel==0.40.0
CROSSENV_WHEELS += poetry==1.4.2
CROSSENV_WHEELS += Cython==0.29.34
CROSSENV_WHEELS += flit==3.8.0
CROSSENV_WHEELS += cryptography==40.0.2
ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
CROSSENV_WHEELS += maturin==0.15.1
endif

# Create the crossenv in preparation for
# cross-compiling all the necessary wheels
.PHONY: python38_post_install
python38_post_install: $(WORK_DIR)/python-cc.mk
	mkdir -p $(PYTHON_LIB_CROSS)
	cp -R $(HOSTPYTHON_LIB_NATIVE) $(PYTHON_LIB_CROSS)/../
	@$(RUN) $(PYTHON_NATIVE) -m crossenv $(STAGING_INSTALL_PREFIX)/bin/python$(PKG_VERS_MAJOR_MINOR) --cc $${CC} --cxx $${CXX} --ar $${AR} --sysroot $${SYSROOT} --env LIBRARY_PATH= --manylinux manylinux2014 $(WORK_DIR)/crossenv/
	. $(WORK_DIR)/crossenv/bin/activate && $(RUN) wget https://bootstrap.pypa.io/get-pip.py
	. $(WORK_DIR)/crossenv/bin/activate && $(RUN) build-python get-pip.py "pip==23.1.2" --no-setuptools --no-wheel --disable-pip-version-check
	. $(WORK_DIR)/crossenv/bin/activate && $(RUN) python get-pip.py "pip==23.1.2" --no-setuptools --no-wheel --disable-pip-version-check
	. $(WORK_DIR)/crossenv/bin/activate && $(RUN) build-pip --disable-pip-version-check install "setuptools==63.4.3" "wheel==0.40.0"
	. $(WORK_DIR)/crossenv/bin/activate && $(RUN) pip --disable-pip-version-check install "setuptools==63.4.3" "wheel==0.40.0"
	. $(WORK_DIR)/crossenv/bin/activate && $(RUN) build-pip --disable-pip-version-check install $(CROSSENV_WHEELS)
	. $(WORK_DIR)/crossenv/bin/activate && $(RUN) pip --disable-pip-version-check install $(CROSSENV_WHEELS)
ifneq ($(PYTHON_LIB_NATIVE),$(PYTHON_LIB_CROSS))
	cp $(PYTHON_LIB_CROSS)/_sysconfigdata_*.py $(PYTHON_LIB_NATIVE)/_sysconfigdata.py
endif

$(WORK_DIR)/python-cc.mk:
	@echo HOSTPYTHON=$(HOSTPYTHON) > $@
	@echo CROSSENV=$(WORK_DIR)/crossenv/bin/activate >> $@
	@echo HOSTPYTHON_LIB_NATIVE=$(HOSTPYTHON_LIB_NATIVE) >> $@
	@echo PYTHON_LIB_NATIVE=$(PYTHON_LIB_NATIVE) >> $@
	@echo PYTHON_SITE_PACKAGES_NATIVE=$(PYTHON_SITE_PACKAGES_NATIVE) >> $@
	@echo PYTHON_INTERPRETER=$(INSTALL_PREFIX)/bin/python$(PKG_VERS_MAJOR_MINOR) >> $@
	@echo PYTHON_VERSION=$(PKG_VERS_MAJOR_MINOR) >> $@
	@echo PYTHON_LIB_CROSS=$(PYTHON_LIB_CROSS) >> $@
	@echo PYTHON_LIB_DIR=$(PYTHON_LIB_DIR) >> $@
	@echo PYTHON_INC_DIR=$(PYTHON_INC_DIR) >> $@
	@echo PIP=$(PIP_NATIVE) >> $@
	@echo CROSS_COMPILE_WHEELS=1 >> $@
	@echo ADDITIONAL_WHEEL_BUILD_ARGS=--no-build-isolation >> $@
