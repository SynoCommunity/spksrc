
PKG_NAME = pycurl
PKG_VERS = 7.19.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://pycurl.sourceforge.net/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/curl

MAINTAINER = superzebulon@superzebulon.org
HOMEPAGE   = http://pycurl.sourceforge.net/
COMMENT    = PycURL is a Python interface to libcurl
LICENSE    = Dual licensed under the LGPL and an MIT/X derivative license based on the cURL license

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
	@$(RUN) $(HOSTPYTHON) setup.py build --curl-config=$(STAGING_INSTALL_PREFIX)/bin/curl-config

myInstall:
	@$(RUN) $(HOSTPYTHON) setup.py install --root $(INSTALL_DIR) --curl-config=$(STAGING_INSTALL_PREFIX)/bin/curl-config
