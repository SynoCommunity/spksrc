PKG_NAME = libtorrent
PKG_VERS = 1.2.10
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-rasterbar-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/arvidn/libtorrent/releases/download/$(PKG_NAME)-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-rasterbar-$(PKG_VERS)

# for boost python binding (BOOST_LIBRARIES = python), the dependency on cross/python310 must appear before cross/boost
BUILD_DEPENDS = cross/python310
DEPENDS = cross/boost cross/geoip cross/libiconv cross/openssl

# cross/boost: archs lacking C++11 compiler (88f6281, hi3535 and ppc archs except QorIQ)
UNSUPPORTED_ARCHS = $(ARM5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)

HOMEPAGE = https://www.rasterbar.com/products/libtorrent
COMMENT  = libtorrent is a feature complete C++ bittorrent implementation focusing on efficiency and scalability. It runs on embedded devices as well as desktops.
LICENSE  = BSD

GNU_CONFIGURE = 1

# Build the libtorrent library first, then create a wheel with the python bindings
CONFIGURE_TARGET = configure_target
COMPILE_TARGET = compile_target build_python_wheel_target
INSTALL_TARGET = install_destdir_target install_python_wheel_target

BOOST_LIBRARIES += system python chrono random
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"

include ../../mk/spksrc.python-wheel.mk

# The following definitions must be below the include of spksrc.python-wheel.mk 
# to get evaluated WORK_DIR for builds in cross/libtorrent.
-include $(WORK_DIR)/python-cc.mk
CONFIGURE_ARGS  = --with-boost --enable-python-binding --with-libiconv
CONFIGURE_ARGS += --with-boost-libdir=$(STAGING_INSTALL_PREFIX)/lib
CONFIGURE_ARGS += PYTHON=$(WORK_DIR)/../../../native/python310/work-native/install/usr/local/bin/python3
CONFIGURE_ARGS += LIB=-L/$(STAGING_INSTALL_PREFIX)/$(PYTHON_LIB_DIR)

ADDITIONAL_CFLAGS = -I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR)
ADDITIONAL_CXXFLAGS = -I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR)
ADDITIONAL_LDFLAGS = "-Wl,-Bsymbolic"

# Only required for DSM <= 6.* using gcc-4.9 along with comcerto2k-7.0
# Enabled for all as without negative impact.
ADDITIONAL_CXXFLAGS += -std=c++11
