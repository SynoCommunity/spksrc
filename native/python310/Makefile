PKG_NAME = python310
PKG_VERS = 3.10.15
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
# Uses system default libffi-dev
CONFIGURE_ARGS += --with-system-ffi
# Uses system default libssl-dev
CONFIGURE_ARGS += --with-ssl-default-suites=openssl

COMPILE_MAKE_OPTIONS += all

POST_INSTALL_TARGET = python310_native_post_install

include ../../mk/spksrc.native-cc.mk

PYTHON = $(WORK_DIR)/install/usr/local/bin/python3
PIP = $(WORK_DIR)/install/usr/local/bin/pip
PIP_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/bin/pip

.PHONY: python310_native_post_install
python310_native_post_install: $(WORK_DIR)/python-native.mk
	@$(MSG) Installing pip
	@$(RUN) wget https://bootstrap.pypa.io/get-pip.py
	@$(RUN) $(PYTHON) get-pip.py "pip==24.2" --no-setuptools --no-wheel --disable-pip-version-check
	@$(MSG) Installing setuptools, wheel, cffi and cross env
	@$(PIP) --disable-pip-version-check install "setuptools==75.1.0" "setuptools-rust==1.10.2" "maturin==1.7.4" "wheel==0.44.0" "cffi==1.17.1" "crossenv==1.5.0"

$(WORK_DIR)/python-native.mk:
	@echo PIP=$(PIP_NATIVE) >> $@
