PKG_NAME = python
PKG_VERS = 2.7.15
PKG_EXT = tar.xz
PKG_DIST_NAME = Python-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.python.org/ftp/python/$(PKG_VERS)
PKG_DIR = Python-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.python.org
COMMENT  = Python Programming Language
LICENSE  = PSF

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-unicode=ucs4 --enable-ipv6

POST_INSTALL_TARGET = python_post_install

include ../../mk/spksrc.native-cc.mk

PYTHON = $(WORK_DIR)/install/usr/local/bin/python
PIP = $(WORK_DIR)/install/usr/local/bin/pip

.PHONY: python_post_install
python_post_install: $(WORK_DIR)/python-native.mk
	@$(MSG) Installing setuptools, pip and cffi
	@$(RUN) wget https://bootstrap.pypa.io/get-pip.py -O - | $(PYTHON)
	@$(PIP) install "setuptools==40.6.2"
	@$(PIP) install "cffi==1.11.5"

$(WORK_DIR)/python-native.mk:
	@echo PIP=$(PIP_NATIVE) >> $@
