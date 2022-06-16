PKG_NAME = python38
PKG_VERS = 3.8.12
PKG_EXT = tar.xz
PKG_DIST_NAME = Python-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.python.org/ftp/python/$(PKG_VERS)
PKG_DIR = Python-$(PKG_VERS)

HOMEPAGE = https://www.python.org/
COMMENT  = Python Programming Language
LICENSE  = PSF

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --enable-ipv6
CONFIGURE_ARGS += --without-ensurepip
# old gcc does not know -Wno-unused-result
# without this setting, cross compile wheels for ppc853x-5.2 will fail
CONFIGURE_ARGS += ac_cv_disable_unused_result_warning=no

COMPILE_MAKE_OPTIONS += Parser/pgen
COMPILE_MAKE_OPTIONS += all

POST_INSTALL_TARGET = python38_native_post_install

include ../../mk/spksrc.native-cc.mk

PYTHON = $(WORK_DIR)/install/usr/local/bin/python3
PIP = $(WORK_DIR)/install/usr/local/bin/pip
PIP_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/bin/pip

.PHONY: python38_native_post_install
python38_native_post_install: $(WORK_DIR)/python-native.mk
	@$(MSG) Installing pip, setuptools, cffi and cross env
	@$(RUN) wget https://bootstrap.pypa.io/get-pip.py
	@$(RUN) $(PYTHON) get-pip.py --no-setuptools --no-wheel
	@$(PIP) install "setuptools==58.3.0" "wheel==0.37.1" "cffi==1.14.6" "crossenv==1.0"

$(WORK_DIR)/python-native.mk:
	@echo PIP=$(PIP_NATIVE) >> $@
