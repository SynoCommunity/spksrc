PKG_NAME = python
PKG_VERS = 2.7.8
PKG_EXT = tar.xz
PKG_DIST_NAME = Python-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.python.org/ftp/python/$(PKG_VERS)
PKG_DIR = Python-$(PKG_VERS)

DEPENDS =

HOMEPAGE   = http://www.python.org/
COMMENT    = Python Programming Language
LICENSE    =

GNU_CONFIGURE = 1
ADDITIONAL_CFLAGS = -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
CONFIGURE_ARGS = --enable-unicode=ucs4 --enable-ipv6

POST_INSTALL_TARGET = myPostInstall

include ../../mk/spksrc.native-cc.mk

PYTHON = $(WORK_DIR)/install/usr/local/bin/python
EASY_INSTALL = $(WORK_DIR)/install/usr/local/bin/easy_install
PIP = $(WORK_DIR)/install/usr/local/bin/pip

.PHONY: myPostInstall
myPostInstall:
	@$(MSG) Installing setuptools, pip and cffi
	@$(RUN) wget https://bootstrap.pypa.io/ez_setup.py -O - | $(PYTHON)
	@$(EASY_INSTALL) "pip==1.5.6"
	@$(PIP) install "cffi==0.8.6"
