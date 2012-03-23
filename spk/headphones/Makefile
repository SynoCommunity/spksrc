SPK_NAME = headphones
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/headphones.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>=2.7.2-1"

MAINTAINER = SynoCommunity
DESCRIPTION = Headphones can download, tag, rename, move and index your music using SABnzbd. Manage your whole music library through its web interface.
DESCRIPTION_FRE = Headphones peut télécharger, tagger, renommer, déplacer et indexer votre musique via SABnzbd. Gérez toute votre librairie musicale grâce à son interface web.
ADMIN_PORT = 8181
RELOAD_UI = yes
DISPLAY_NAME = Headphones

HOMEPAGE   = https://github.com/rembo10/headphones
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = headphones_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: headphones_extra_install
headphones_extra_install: $(STAGING_DIR)/share/Headphones
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/headphones.cgi.pl $(STAGING_DIR)/app/headphones.cgi
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/Headphones:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/rembo10/headphones.git Headphones
	rm -fr $(STAGING_DIR)/share/Headphones/.git $(STAGING_DIR)/share/Headphones/.gitignore

