PKG_NAME = dejavu
PKG_VERS = 2.37
PKG_FULLNAME = $(PKG_NAME)-fonts-ttf-$(PKG_VERS)
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_FULLNAME).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/dejavu-fonts/dejavu-fonts/releases/download/version_$(subst .,_,$(PKG_VERS))

DEPENDS =

# arch independent
override ARCH=

HOMEPAGE = https://dejavu-fonts.github.io/
COMMENT  = The DejaVu fonts are a font family based on the Vera Fonts. Its purpose is to provide a wider range of characters while maintaining the original look and feel through the process of collaborative development, under a Free license.
LICENSE  = https://dejavu-fonts.github.io/License.html

INSTALL_TARGET = dejavu_install

include ../../mk/spksrc.install-resources.mk

.PHONY: dejavu_install
dejavu_install:
	@$(RUN) install -m 755 -d $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)/fonts -d $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)/fontconfig
	@$(RUN) cp $(PKG_FULLNAME)/ttf/* $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)/fonts
	@$(RUN) cp $(PKG_FULLNAME)/fontconfig/* $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)/fontconfig
