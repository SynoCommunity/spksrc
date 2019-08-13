PKG_NAME = libtorrent
PKG_VERS = 1.0.11
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-rasterbar-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/arvidn/$(PKG_NAME)/releases/download/$(PKG_NAME)-$(subst .,_,$(PKG_VERS))
PKG_DIR = $(PKG_NAME)-rasterbar-$(PKG_VERS)

DEPENDS = cross/boost cross/geoip cross/libiconv cross/openssl

HOMEPAGE = http://www.rasterbar.com/products/libtorrent
COMMENT  = libtorrent is a feature complete C++ bittorrent implementation focusing on efficiency and scalability. It runs on embedded devices as well as desktops.
LICENSE  = BSD

# Build the libtorrent library first, then create a wheel with the python bindings
CONFIGURE_TARGET = configure_target
COMPILE_TARGET = compile_target build_python_wheel
INSTALL_TARGET = install_destdir_target install_python_wheel

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --enable-python-binding --with-libgeoip --with-libiconv
CONFIGURE_ARGS += --with-boost-system=boost_system --with-boost-python=boost_python
CONFIGURE_ARGS += PYTHON=$(WORK_DIR)/../../../native/python/work-native/install/usr/local/bin/python
CONFIGURE_ARGS += PYTHON_CPPFLAGS=-I$(STAGING_INSTALL_PREFIX)/include/python2.7
ADDITIONAL_CFLAGS = -I$(STAGING_INSTALL_PREFIX)/include/python2.7
ADDITIONAL_LDFLAGS = "-Wl,-Bsymbolic"

BOOST_LIBRARIES += system python
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"

include ../../mk/spksrc.python-wheel.mk
