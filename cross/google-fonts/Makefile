PKG_NAME = google-fonts
PKG_VERS = 20221223
PKG_EXT = tar.gz
# git hash of December 23th 2022
PKG_GIT_HASH = 814345fe12e0a3ce4d2032c7f4b79e82e75119b4
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/google/fonts/archive
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = fonts-$(PKG_GIT_HASH)

DEPENDS =

HOMEPAGE = https://fonts.google.com/
COMMENT  = This project mainly contains the binary font files served by Google Fonts.
LICENSE  = Most of the fonts in the collection use the SIL Open Font License, v1.1. Some fonts use the Apache 2 license. The Ubuntu fonts use the Ubuntu Font License v1.0.

INSTALL_TARGET = google-fonts_install

include ../../mk/spksrc.install-resources.mk

.PHONY: google-fonts_install
# exclude folder with duplicate font NotoSansNKo-Regular.ttf
EXCLUDE_ARGS  = --exclude='notosansnko_todelist'
# exclude folder with large test font NotoColorEmojiCompatTest-Regular.ttf
# "Test of a font with many color tables for x-browser compatibility."
EXCLUDE_ARGS += --exclude='notocoloremojicompattest'

google-fonts_install:
	@$(MSG) Install fonts and generate type files for imagemagick
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/fonts/apache $(STAGING_INSTALL_PREFIX)/fonts/ofl $(STAGING_INSTALL_PREFIX)/fonts/ufl
	@tar -cf - -C $(WORK_DIR)/$(PKG_DIR)/ README.md TRIVIA.md | tar -xf - -C $(STAGING_INSTALL_PREFIX)/fonts/
	@tar -cf - -C $(WORK_DIR)/$(PKG_DIR)/apache . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/fonts/apache
	@tar -cf - -C $(WORK_DIR)/$(PKG_DIR)/ofl $(EXCLUDE_ARGS) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/fonts/ofl
	@tar -cf - -C $(WORK_DIR)/$(PKG_DIR)/ufl    . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/fonts/ufl
	@find $(STAGING_INSTALL_PREFIX)/fonts/apache -type f -name '*.ttf' | src/imagick_type_gen.pl -f - | sed -e 's|$(STAGING_INSTALL_PREFIX)|@@install_folder@@|g' > $(STAGING_INSTALL_PREFIX)/fonts/type-google-fonts-apache.xml
	@find $(STAGING_INSTALL_PREFIX)/fonts/ofl    -type f -name '*.ttf' | src/imagick_type_gen.pl -f - | sed -e 's|$(STAGING_INSTALL_PREFIX)|@@install_folder@@|g' > $(STAGING_INSTALL_PREFIX)/fonts/type-google-fonts-ofl.xml
	@find $(STAGING_INSTALL_PREFIX)/fonts/ufl    -type f -name '*.ttf' | src/imagick_type_gen.pl -f - | sed -e 's|$(STAGING_INSTALL_PREFIX)|@@install_folder@@|g' > $(STAGING_INSTALL_PREFIX)/fonts/type-google-fonts-ufl.xml
