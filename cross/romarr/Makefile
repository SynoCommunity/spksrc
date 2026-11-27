PKG_NAME = romarr
PKG_VERS = 1.14.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/BlizzHacker/romarr/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://romarr.app
COMMENT  = The *arr for games: search, grab, verify and file ROMs into a game library.
LICENSE  = MIT

INSTALL_TARGET = romarr_install

include ../../mk/spksrc.cross-install.mk

# Only the Python package, its licence and the version it reports are shipped.
# A release tarball carries no _version.py (CI writes it into the image), so the
# version is written here, the same way the Proxmox installer does it.
.PHONY: romarr_install
romarr_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/share/romarr
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) romarr LICENSE NOTICE | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/romarr
	printf '__version__ = "%s"\n' "$(PKG_VERS)" > $(STAGING_INSTALL_PREFIX)/share/romarr/romarr/_version.py
