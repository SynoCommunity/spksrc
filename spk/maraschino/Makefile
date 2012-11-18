SPK_NAME = maraschino
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 2
SPK_ICON = src/maraschino.png
DSM_UI_DIR = app
BETA = 1

DEPENDS  =
SPK_DEPENDS = "python>=2.7.3-3"

MAINTAINER = SynoCommunity
DESCRIPTION = Maraschino is a simple web interface that acts as a nice overview/front page for your XBMC HTPC. It has many modules: Media library browser, SABnzbd+, SickBeard, XBMC controller, Diskspace, Weather, Transmission and so on.
DESCRIPTION_FRE = Maraschino est une interface web qui sert de vue d\\\'ensemble/page d\\\'accueil à votre HTPC XBMC. Il dispose de multiple modules: Bibliothèque multimédia, SABnzbd+, SickBeard, Controlleur XBMC, Espace disque, Météo, Transmission et bien d\\\'autres.
ADMIN_PORT = 8260
RELOAD_UI = yes
DISPLAY_NAME = Maraschino

HOMEPAGE   = http://www.maraschinoproject.com/
LICENSE    = GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = maraschino_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: maraschino_extra_install
maraschino_extra_install: $(STAGING_DIR)/share/maraschino
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/maraschino.cgi.py $(STAGING_DIR)/app/maraschino.cgi
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/maraschino:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/mrkipling/maraschino.git
	rm -fr $(STAGING_DIR)/share/maraschino/.git $(STAGING_DIR)/share/maraschino/.gitignore
