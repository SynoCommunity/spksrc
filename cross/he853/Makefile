PKG_NAME = he853-cli
PKG_VERS = 1.0.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/hphde/he853-cli/archive
PKG_DIR = $(PKG_NAME)-$(PKG_NAME)-v$(PKG_VERS)

DEPENDS = cross/libusb_1.0.23

HOMEPAGE = https://github.com/hphde/he853-cli
COMMENT  = HomeEasy HE853 USB device executable.
LICENSE  = GPLv2

CONFIGURE_TARGET = nop

# need static libusb (when built without libudev)
export LIBUSB_ENABLE_STATIC=1

INSTALL_TARGET = he853_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: he853_install
he853_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/lib/udev/rules.d
	$(RUN) $(MAKE) install PREFIX=$(INSTALL_DIR)$(INSTALL_PREFIX) MY_UDEV_RULES=$(STAGING_INSTALL_PREFIX)/lib/udev/rules.d
