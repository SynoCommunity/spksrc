SPK_NAME = plexconnect
SPK_VERS = 0.2
SPK_REV = 9
SPK_ICON = src/plexconnect.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>2.7.3-3"

MAINTAINER = SynoCommunity
DESCRIPTION = PlexConnect: Plex @ aTV - think different. See http://forums.plexapp.com/index.php/topic/72356-plexconnect-on-synology/ for detailed installation instructions.
RELOAD_UI = yes
DISPLAY_NAME = PlexConnect

HOMEPAGE   = https://github.com/iBaa/PlexConnect
LICENSE    = GPL

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = plexconnect_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: plexconnect_extra_install
plexconnect_extra_install: $(STAGING_DIR)/share/PlexConnect
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/etc/certificates
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/plexconnect-vhosts.conf $(STAGING_DIR)/app/plexconnect-vhosts.conf
	install -m 755 src/app/plexconnect-ssl-vhosts.conf $(STAGING_DIR)/app/plexconnect-ssl-vhosts.conf
	#install -m 777 -d $(STAGING_DIR)/etc/certificates
	install -m 755 src/app/certificates/trailers.cer $(STAGING_DIR)/etc/certificates/trailers.cer
	install -m 755 src/app/certificates/trailers.key $(STAGING_DIR)/etc/certificates/trailers.key
	install -m 755 src/app/certificates/trailers.pem $(STAGING_DIR)/etc/certificates/trailers.pem
	install -m 755 src/share/PlexConnect/Settings.cfg $(STAGING_DIR)/share/PlexConnect/Settings.cfg
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
	         $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/PlexConnect:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone -b master https://github.com/iBaa/PlexConnect.git
	#cd $(STAGING_DIR)/share/PlexConnect && git am < $(STAGING_DIR)/../../src/share/PlexConnect/patch.diff
	rm -fr $(STAGING_DIR)/share/PlexConnect/.git $(STAGING_DIR)/share/PlexConnect/.gitignore
