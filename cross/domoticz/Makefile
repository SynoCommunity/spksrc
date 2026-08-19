PKG_NAME = domoticz
PKG_VERS = 2026.3
PKG_EXT = tar.gz
# The domoticz_src_* release asset bundles all git submodules (jsoncpp, minizip, jwtcpp, sqlite).
# Plain tag archives do not contain the submodules and will not build. There is no .git in the
# archive; the build revision is resolved from History.txt (see patches/002-fix-history-revision-path.patch).
PKG_DIST_NAME = domoticz_src_2026.18157.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/domoticz/domoticz/releases/download/$(PKG_VERS)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = domoticz

# libusb-compat provides the legacy libusb-0.1 API (usb.h/libusb.so) that
# domoticz uses for TE923/Voltcraft USB weather stations (as in upstream CI)
DEPENDS = cross/boost cross/curl cross/lua-5.3 cross/mosquitto cross/openssl3 cross/sqlite cross/zlib cross/libusb-compat
DEPENDS += cross/python314

# Requires C++ compiler, supporting at least C++17.
MIN_GCC_VERSION = 7

HOMEPAGE = https://www.domoticz.com/
COMMENT  = Domoticz is a Home Automation System.
LICENSE  = GPLv3

# jsoncpp, minizip and jwt-cpp are built from the bundled submodules
# (the source archive contains them, no network access required)
CONFIGURE_ARGS += -DUSE_BUILTIN_JSONCPP=YES
CONFIGURE_ARGS += -DUSE_BUILTIN_MINIZIP=YES
CONFIGURE_ARGS += -DUSE_BUILTIN_JWTCPP=YES
# use the cross-compiled sqlite instead of the bundled one
CONFIGURE_ARGS += -DUSE_BUILTIN_SQLITE=NO
# GIT_SUBMODULE must stay OFF so cmake does not try to refresh the submodules over the network
CONFIGURE_ARGS += -DGIT_SUBMODULE=OFF
# Python plugins, using the cross-compiled python
CONFIGURE_ARGS += -DUSE_PYTHON=YES
# cross/python314 provides the headers and shared library
ADDITIONAL_CPPFLAGS += -I$(STAGING_INSTALL_PREFIX)/include/python3.14
# FindPython3 needs explicit hints since the cross-compiled python cannot run on the build host
CONFIGURE_ARGS += -DPython3_ROOT_DIR=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += -DPython3_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/python3.14
CONFIGURE_ARGS += -DPython3_LIBRARY=$(STAGING_INSTALL_PREFIX)/lib/libpython3.14.so
# open-zwave is deprecated upstream (domoticz recommends zwavejs2mqtt + MQTT auto
# discovery), so Z-Wave hardware support is intentionally disabled.

# match the stable (master) release channel: version string without build number and "-beta" suffix
CONFIGURE_ARGS += -DBUILD_MASTER=ON
# use shared boost libraries (as provided by cross/boost) instead of static ones
CONFIGURE_ARGS += -DUSE_STATIC_BOOST=NO
# std::filesystem needs -lstdc++fs on gcc 7/8 (DSM 7.x toolchains)
CONFIGURE_ARGS += -DCMAKE_CXX_STANDARD_LIBRARIES=-lstdc++fs

ENV += CMAKE_INCLUDE_PATH="$(STAGING_INSTALL_PREFIX)/include"
ENV += CMAKE_LIBRARY_PATH="$(STAGING_INSTALL_PREFIX)/lib"

USE_NATIVE_CMAKE = 1

include ../../mk/spksrc.cross-cmake.mk
