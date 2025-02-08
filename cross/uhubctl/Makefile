PKG_NAME = uhubctl
PKG_VERS = 2.5.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mvp/uhubctl/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

OPTIONAL_DEPENDS = cross/libusb cross/libusb_1.0.23

HOMEPAGE = https://github.com/mvp/uhubctl
COMMENT  = USB hub per-port power control.
LICENSE  = GPLv2

include ../../mk/spksrc.common.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(PPC_ARCHS)),$(ARCH))
DEPENDS += cross/libusb_1.0.23
else ifeq ($(call version_lt, ${TCVERSION}, 6.0)$(call version_ge, ${TCVERSION}, 3.0),11)
DEPENDS += cross/libusb_1.0.23
else
DEPENDS += cross/libusb
endif

CONFIGURE_TARGET = nop
POST_INSTALL_TARGET = uhubctl_post_install

# Remarks:
# The following error comes from "git describe --match "v[0-9]*" --abbrev=8 --dirty --tags"
# and can be ignored, because we are not in uhubctl repo and GIT_VERSION is taken from VERSION file instead:
# fatal: No names found, cannot describe anything.

include ../../mk/spksrc.cross-cc.mk

.PHONY: uhubctl_post_install
uhubctl_post_install:
	@$(MSG) Create link in bin folder for DSM 7 resources to work
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/bin
	@cd $(STAGING_INSTALL_PREFIX)/bin && ln -sf ../sbin/uhubctl .
