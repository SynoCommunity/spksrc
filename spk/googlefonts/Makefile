SPK_NAME = googlefonts
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/googlefonts.png

DEPENDS  =
SPK_DEPENDS = 

MAINTAINER = SynoCommunity
DESCRIPTION = Collection of all available Google Fonts.
RELOAD_UI = yes
DISPLAY_NAME = GoogleFonts
STARTABLE = no

HOMEPAGE   = http://fonts.google.com/
LICENSE    = 

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = fonts_extra_install

# Pure package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: fonts_extra_install
fonts_extra_install: 
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/google/fonts.git fonts
	rm -fr $(STAGING_DIR)/share/fonts/.git $(STAGING_DIR)/share/fonts/.gitignore
	#create xml file for use with imagemagick
	find $(STAGING_DIR) -name '*.ttf' ! -path "*AppleDouble*" -type f | $(WORK_DIR)/../src/imagick_type_gen -f - | sed -e 's|$(STAGING_DIR)|$(INSTALL_PREFIX)|g' > $(STAGING_DIR)/share/googlefonts.xml
