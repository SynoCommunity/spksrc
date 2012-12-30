PKG_NAME = libtorrent
PKG_VERS = 0.16.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-rasterbar-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://libtorrent.googlecode.com/files
PKG_DIR = $(PKG_NAME)-rasterbar-$(PKG_VERS)

DEPENDS = cross/openssl cross/geoip cross/boost cross/python

HOMEPAGE = http://www.rasterbar.com/products/libtorrent/
COMMENT  = libtorrent is a feature complete C++ bittorrent implementation focusing on efficiency and scalability. It runs on embedded devices as well as desktops.
LICENSE  = BSD

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --enable-python-binding --with-boost-system=boost_system --with-boost-python=boost_python
CONFIGURE_ARGS += PYTHON=$(WORK_DIR)/../../../native/python/work-native/install/usr/local/bin/python PYTHON_CPPFLAGS=-I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR)
ADDITIONAL_CFLAGS = -I$(STAGING_INSTALL_PREFIX)/include/python2.7

BOOST_LIBRARIES += system python
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"

include ../../mk/spksrc.cross-cc.mk
include $(WORK_DIR)/python-cc.mk
