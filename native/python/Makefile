PKG_NAME = python
PKG_VERS = 2.7.11
PKG_EXT = tar.xz
PKG_DIST_NAME = Python-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.python.org/ftp/python/$(PKG_VERS)
PKG_DIR = Python-$(PKG_VERS)

DEPENDS =

HOMEPAGE   = http://www.python.org
COMMENT    = Python Programming Language
LICENSE    = PSF

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-unicode=ucs4 --enable-ipv6

POST_INSTALL_TARGET = myPostInstall

include ../../mk/spksrc.native-cc.mk

PYTHON = $(WORK_DIR)/install/usr/local/bin/python
PIP = $(WORK_DIR)/install/usr/local/bin/pip

.PHONY: myPostInstall
myPostInstall:
	@$(MSG) Installing setuptools, pip and cffi
	@$(RUN) wget https://bootstrap.pypa.io/ez_setup.py -O - | $(PYTHON)
	@$(RUN) wget https://bootstrap.pypa.io/get-pip.py -O - | $(PYTHON)
	@$(PIP) install "cffi==1.5.2"
