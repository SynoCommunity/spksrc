PKG_NAME = libusb-compat
PKG_VERS = 0.1.8
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libusb/libusb-compat-0.1/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# Provides the legacy libusb 0.1 API (usb.h, libusb.so) on top of libusb-1.0,
# as used by domoticz for the TE923/Voltcraft USB weather stations
DEPENDS = cross/libusb

HOMEPAGE = https://libusb.info/
COMMENT  = Compatibility library for the legacy libusb-0.1 API on top of libusb-1.0.
LICENSE  = LGPL-2.1

GNU_CONFIGURE = 1
CONFIGURE_ARGS += --disable-log

# libusb-1.0 prefix, derived from the ordered PKG_CONFIG_LIBDIR (dep staging dirs);
# the pkg-config include path is not usable when the .pc prefix does not resolve
LIBUSB_STAGING_INSTALL_PREFIX = $(firstword $(foreach d,$(subst :,$(space),$(PKG_CONFIG_LIBDIR)),$(if $(wildcard $(patsubst %/lib/pkgconfig,%,$(d))/lib/libusb-1.0.so),$(patsubst %/lib/pkgconfig,%,$(d)),)) $(STAGING_INSTALL_PREFIX))
ADDITIONAL_CPPFLAGS += -I$(LIBUSB_STAGING_INSTALL_PREFIX)/include/libusb-1.0

include ../../mk/spksrc.cross-cc.mk
