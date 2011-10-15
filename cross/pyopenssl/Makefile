

PKG_NAME = pyOpenSSL
PKG_VERS = 0.11
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://launchpad.net/pyopenssl/main/$(PKG_VERS)/+download/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl

MAINTAINER = superzebulon@superzebulon.org
HOMEPAGE   = https://launchpad.net/pyopenssl
COMMENT    = Python interface to the OpenSSL library
LICENSE    = Apache License

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
