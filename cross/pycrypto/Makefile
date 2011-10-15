

PKG_NAME = pycrypto
PKG_VERS = 2.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.dlitz.net/pub/dlitz/crypto/pycrypto
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

MAINTAINER = superzebulon@superzebulon.org
HOMEPAGE   = https://www.dlitz.net/software/pycrypto/
COMMENT    = Python interface to the OpenSSL library
LICENSE    = Public domain

ADDITIONAL_CFLAGS =
CONFIGURE_ARGS = 

CONFIGURE_TARGET = nop
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

# Fetch python definition (provides HOSTPYTHON)
include $(WORK_DIR)/python-cc.mk

nop: ;

myCompile:
	@$(RUN) $(HOSTPYTHON) setup.py build

myInstall:
	@$(RUN) $(HOSTPYTHON) setup.py install --root $(INSTALL_DIR)
