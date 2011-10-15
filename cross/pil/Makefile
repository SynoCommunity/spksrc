

PKG_NAME = Imaging
PKG_VERS = 1.1.7
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://effbot.org/downloads
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/libjpeg

MAINTAINER = superzebulon@superzebulon.org
HOMEPAGE   = http://www.pythonware.com/products/pil/
COMMENT    = Image processing capabilities for Python 
LICENSE    = http://www.pythonware.com/products/pil/license.htm

ADDITIONAL_CFLAGS =
CONFIGURE_ARGS = 

CONFIGURE_TARGET = nop
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

# Fetch python definition (provides HOSTPYTHON)
include $(WORK_DIR)/python-cc.mk

ENV += STAGING_INSTALL_PREFIX=$(STAGING_INSTALL_PREFIX)

nop: ;

myCompile:
	@$(RUN) $(HOSTPYTHON) setup.py build
	
myInstall:
	@$(RUN) $(HOSTPYTHON) setup.py install --root $(INSTALL_DIR)
