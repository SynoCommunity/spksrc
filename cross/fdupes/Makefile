PKG_NAME = fdupes
PKG_VERS = 1.51
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/adrianlopezroche/fdupes/archive/
PKG_DIR = $(PKG_NAME)-$(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/adrianlopezroche/fdupes
COMMENT  = FDUPES is a program for identifying or deleting duplicate files residing within specified directories.
LICENSE  = MIT

include ../../mk/spksrc.cross-cc.mk

CONFIGURE_TARGET = none

INSTALL_TARGET = myInstall

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install PREFIX=$(STAGING_INSTALL_PREFIX)
