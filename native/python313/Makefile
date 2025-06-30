PKG_NAME = python313
PKG_VERS = 3.13.5
PKG_EXT = tar.xz
PKG_DIST_NAME = Python-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.python.org/ftp/python/$(PKG_VERS)
PKG_DIR = Python-$(PKG_VERS)

HOMEPAGE = https://www.python.org/
COMMENT  = Python Programming Language
LICENSE  = PSF

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --enable-ipv6
CONFIGURE_ARGS += --without-static-libpython
# installed pip is not on PATH
CONFIGURE_ARGS += --with-ensurepip=no
# test modules are required for optimization only
CONFIGURE_ARGS += --disable-test-modules
# Uses system default libssl-dev
CONFIGURE_ARGS += --with-ssl-default-suites=openssl

COMPILE_MAKE_OPTIONS += all

POST_INSTALL_TARGET = python313_native_post_install

include ../../mk/spksrc.native-cc.mk

PYTHON = $(WORK_DIR)/install/usr/local/bin/python3
PIP = $(WORK_DIR)/install/usr/local/bin/pip
PIP_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/bin/pip

REQUIREMENTS = src/requirements.txt

.PHONY: python313_native_post_install
python313_native_post_install: $(WORK_DIR)/python-native.mk
	@$(MSG) Installing latest pip
	@$(RUN) wget https://bootstrap.pypa.io/get-pip.py
	@$(RUN) $(PYTHON) get-pip.py --no-setuptools --no-wheel --disable-pip-version-check
	@$(MSG) Installing wheels from requirements file
	@$(PIP) --disable-pip-version-check install -r $(REQUIREMENTS)

$(WORK_DIR)/python-native.mk:
	@echo PIP=$(PIP_NATIVE) >> $@
