PKG_NAME = python38
PKG_VERS = 3.8.8
PKG_EXT = tar.xz
PKG_DIST_NAME = Python-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.python.org/ftp/python/$(PKG_VERS)
PKG_DIR = Python-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.python.org/
COMMENT  = Python Programming Language
LICENSE  = PSF

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-ipv6 --without-ensurepip

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
	@$(RUN) $(PYTHON) get-pip.py "pip==21.1.1"
	@$(PIP) install "setuptools==44.1.0" "cffi==1.14.5" "crossenv==1.0"

$(WORK_DIR)/python-native.mk:
	@echo PIP=$(PIP_NATIVE) >> $@
