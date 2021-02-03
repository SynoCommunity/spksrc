PKG_NAME = libtorrent
PKG_VERS = 1.2.12
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-rasterbar-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/arvidn/$(PKG_NAME)/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-rasterbar-$(PKG_VERS)

# for boost python binding (BOOST_LIBRARIES = python), the dependency on cross/python2 must appear before cross/boost
DEPENDS = cross/python3 cross/boost cross/geoip cross/libiconv cross/openssl

# cross/boost: archs lacking C++11 compiler, 88f6281(arm5) and ppc archs except QorIQ
# libtorrent: qoriq(ppc) evansport(x86) lack some recent linux includes network definitions (if_link.h IFLA_CARRIER IFLA_PROMISCUITY)
UNSUPPORTED_ARCHS = hi3535 $(ARM5_ARCHES) $(PPC_ARCHES) $(x86_ARCHES)

HOMEPAGE = https://www.rasterbar.com/products/libtorrent
COMMENT  = libtorrent is a feature complete C++ bittorrent implementation focusing on efficiency and scalability. It runs on embedded devices as well as desktops.
LICENSE  = BSD

# Build the libtorrent library first, then create a wheel with the python bindings
CONFIGURE_TARGET = configure_target
COMPILE_TARGET = compile_target build_python_wheel
INSTALL_TARGET = install_destdir_target install_python_wheel

GNU_CONFIGURE = 1
-include $(WORK_DIR)/python-cc.mk
CONFIGURE_ARGS += --with-boost-system=boost_system --with-boost-python=boost_python37
CONFIGURE_ARGS += --with-boost-chrono=boost_chrono --with-boost-random=boost_random
CONFIGURE_ARGS += PYTHON=$(WORK_DIR)/../../../native/python3/work-native/install/usr/local/bin/python3
CONFIGURE_ARGS += LIB=-L/$(STAGING_INSTALL_PREFIX)/$(PYTHON_LIB_DIR)
CONFIGURE_ARGS += PYTHON_CPPFLAGS=-I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR)
CONFIGURE_ARGS += PYTHON_CPPFLAGS=-I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR)
ADDITIONAL_CFLAGS = -I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR)
ADDITIONAL_CXXFLAGS = -I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR)
ADDITIONAL_LDFLAGS = "-Wl,-Bsymbolic"

BOOST_LIBRARIES += system python chrono random
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"

include ../../mk/spksrc.python-wheel.mk
