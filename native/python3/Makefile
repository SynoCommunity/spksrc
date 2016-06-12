PKG_NAME = python
PKG_VERS = 3.4.1
PKG_EXT = tar.xz
PKG_DIST_NAME = Python-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.python.org/ftp/python/$(PKG_VERS)
PKG_DIR = Python-$(PKG_VERS)

DEPENDS =

HOMEPAGE   = http://www.python.org/
COMMENT    = Python Programming Language
LICENSE    =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-ipv6 --without-ensurepip

COMPILE_TARGET = myCompile
POST_INSTALL_TARGET = myPostInstall

include ../../mk/spksrc.native-cc.mk

.PHONY: myCompile
myCompile:
	@$(RUN) $(MAKE) Parser/pgen all

PYTHON = $(WORK_DIR)/install/usr/local/bin/python3
PIP = $(WORK_DIR)/install/usr/local/bin/pip

.PHONY: myPostInstall
myPostInstall:
	@$(MSG) Installing setuptools, pip and cffi
	@$(RUN) wget https://bootstrap.pypa.io/ez_setup.py -O - | $(PYTHON)
	@$(RUN) wget https://bootstrap.pypa.io/get-pip.py -O - | $(PYTHON)
	@$(PIP) install "cffi==1.5.2"
