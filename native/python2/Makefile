PKG_NAME = python2
PKG_VERS = 2.7.18
PKG_EXT = tar.xz
PKG_DIST_NAME = Python-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.python.org/ftp/python/$(PKG_VERS)
PKG_DIR = Python-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.python.org
COMMENT  = Python Programming Language
LICENSE  = PSF

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-unicode=ucs4 --enable-ipv6

POST_INSTALL_TARGET = python_native_post_install

include ../../mk/spksrc.native-cc.mk

PYTHON = $(WORK_DIR)/install/usr/local/bin/python
PIP = $(WORK_DIR)/install/usr/local/bin/pip

.PHONY: python_native_post_install
# install latest pip that supports python2
python_native_post_install: $(WORK_DIR)/python-native.mk
	@$(MSG) Installing setuptools, pip and cffi
	@$(RUN) wget https://bootstrap.pypa.io/2.7/get-pip.py -O - | $(PYTHON)
	@$(PIP) install "setuptools==44.1.0"
	@$(PIP) install "cffi==1.14.1"

$(WORK_DIR)/python-native.mk:
	@echo PIP=$(PIP_NATIVE) >> $@
