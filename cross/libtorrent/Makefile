PKG_NAME = libtorrent
PKG_VERS = 1.1.14
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-rasterbar-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/arvidn/$(PKG_NAME)/releases/download/$(PKG_NAME)-$(subst .,_,$(PKG_VERS))
PKG_DIR = $(PKG_NAME)-rasterbar-$(PKG_VERS)

# for boost python binding (BOOST_LIBRARIES = python), the dependency on cross/python2 must appear before cross/boost
BUILD_DEPENDS = cross/python2 
DEPENDS = cross/boost cross/geoip cross/libiconv cross/openssl

# cross/boost: archs lacking C++11 compiler (88f6281 and ppc archs except QorIQ)
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PCC_ARCHS)
# libtorrent:
UNSUPPORTED_ARCHS += $(ARMv7L_ARCHS)

HOMEPAGE = https://www.rasterbar.com/products/libtorrent
COMMENT  = libtorrent is a feature complete C++ bittorrent implementation focusing on efficiency and scalability. It runs on embedded devices as well as desktops.
LICENSE  = BSD

# Build the libtorrent library first, then create a wheel with the python bindings
CONFIGURE_TARGET = configure_target
COMPILE_TARGET = compile_target build_python_wheel
INSTALL_TARGET = install_destdir_target install_python_wheel

GNU_CONFIGURE = 1
-include $(WORK_DIR)/python-cc.mk
CONFIGURE_ARGS  = --enable-python-binding --with-libiconv
CONFIGURE_ARGS += --with-boost-system=boost_system --with-boost-python=boost_python
CONFIGURE_ARGS += --with-boost-chrono=boost_chrono --with-boost-random=boost_random
CONFIGURE_ARGS += PYTHON=$(WORK_DIR)/../../../native/python2/work-native/install/usr/local/bin/python
CONFIGURE_ARGS += LIB=-L/$(STAGING_INSTALL_PREFIX)/$(PYTHON_LIB_DIR)
CONFIGURE_ARGS += PYTHON_CPPFLAGS=-I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR)
ADDITIONAL_CFLAGS = -I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR)
ADDITIONAL_CXXFLAGS = -I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR)
ADDITIONAL_LDFLAGS = "-Wl,-Bsymbolic"

BOOST_LIBRARIES += system python chrono random
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"

include ../../mk/spksrc.python-wheel.mk
