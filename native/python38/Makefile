PKG_NAME = python38
PKG_VERS = 3.8.11
PKG_EXT = tar.xz
PKG_DIST_NAME = Python-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.python.org/ftp/python/$(PKG_VERS)
PKG_DIR = Python-$(PKG_VERS)

HOMEPAGE = https://www.python.org/
COMMENT  = Python Programming Language
LICENSE  = PSF

DEPENDS = native/expat native/readline native/xz native/gdbm native/sqlite

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --enable-ipv6
CONFIGURE_ARGS += --without-ensurepip
CONFIGURE_ARGS += --enable-loadable-sqlite-extensions
CONFIGURE_ARGS += --with-computed-gotos=yes
CONFIGURE_ARGS += --with-dbmliborder=gdbm:ndbm:bdb
CONFIGURE_ARGS += --with-system-expat
CONFIGURE_ARGS += --with-system-ffi
CONFIGURE_ARGS += --with-ssl-default-suites=openssl
CONFIGURE_ARGS += --enable-optimizations

NATIVE_CFLAGS   = -I$(realpath $(WORK_DIR)/../../../native/expat/work-native/install/usr/local/include )
NATIVE_CFLAGS  += -I$(realpath $(WORK_DIR)/../../../native/readline/work-native/install/usr/local/include )
NATIVE_CFLAGS  += -I$(realpath $(WORK_DIR)/../../../native/xz/work-native/install/usr/local/include )
NATIVE_CFLAGS  += -I$(realpath $(WORK_DIR)/../../../native/gdbm/work-native/install/usr/local/include )
NATIVE_CFLAGS  += -I$(realpath $(WORK_DIR)/../../../native/sqlite/work-native/install/usr/local/include )

NATIVE_LDFLAGS  = -L$(realpath $(WORK_DIR)/../../../native/expat/work-native/install/usr/local/lib )
NATIVE_LDFLAGS += -L$(realpath $(WORK_DIR)/../../../native/readline/work-native/install/usr/local/lib )
NATIVE_LDFLAGS += -L$(realpath $(WORK_DIR)/../../../native/xz/work-native/install/usr/local/lib )
NATIVE_LDFLAGS += -L$(realpath $(WORK_DIR)/../../../native/gdbm/work-native/install/usr/local/lib )
NATIVE_LDFLAGS += -L$(realpath $(WORK_DIR)/../../../native/sqlite/work-native/install/usr/local/lib )

COMPILE_TARGET = python38_native_compile
POST_INSTALL_TARGET = python38_native_post_install

include ../../mk/spksrc.native-cc.mk

.PHONY: python38_native_compile
python38_native_compile:
	@$(RUN) $(MAKE) Parser/pgen all

PYTHON = $(WORK_DIR)/install/usr/local/bin/python3
PIP = $(WORK_DIR)/install/usr/local/bin/pip
PIP_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/bin/pip

.PHONY: python38_native_post_install
python38_native_post_install: $(WORK_DIR)/python-native.mk
	@$(MSG) Installing pip, setuptools, cffi and cross env
	@$(RUN) wget https://bootstrap.pypa.io/get-pip.py
	@$(RUN) $(PYTHON) get-pip.py "pip==21.1.3"
	@$(PIP) install "setuptools==49.6.0" "cffi==1.14.6" "crossenv==1.1.4"

$(WORK_DIR)/python-native.mk:
	@echo PIP=$(PIP_NATIVE) >> $@
