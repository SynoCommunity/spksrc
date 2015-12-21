PKG_NAME = owfs
PKG_VERS = 3.1p0
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/$(PKG_NAME)/$(PKG_NAME)/$(PKG_VERS)

#SPK_DEPENDS = "python>=2.7.11-15"

#BUILD_DEPENDS = cross/python

DEPENDS = cross/libusb

HOMEPAGE = http://owfs.org/
COMMENT  = Easy way to use the 1-wire sensors like temperature, voltage and more. 
LICENSE  = GPLv2

GNU_CONFIGURE = 1

#CONFIGURE_ARGS = --without-perl5 --with-python=$(INSTALL_DIR)/usr/local/bin/python --with-pythonconfig=$(INSTALL_DIR)/usr/local/bin/python-config 
CONFIGURE_ARGS = --without-perl5 --without-python

include ../../mk/spksrc.cross-cc.mk
