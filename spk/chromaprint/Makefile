SPK_NAME = chromaprint
SPK_VERS = 1.2
SPK_REV = 1
SPK_ICON = src/chromaprint.png

DEPENDS  = cross/$(SPK_NAME)

RELOAD_UI = yes
STARTABLE = no

BETA = 1

MAINTAINER = SynoCommunity
DESCRIPTION = "Chromaprint is the core component of the AcoustID project. It's a client-side library that implements a custom algorithm for extracting fingerprints from any audio source. "
DISPLAY_NAME = Chromaprint

HOMEPAGE   = http://acoustid.org/chromaprint
LICENSE    = LGPL2.1+

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = chromaprint_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: chromaprint_extra_install
chromaprint_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
	#delete unneeded stuff
	rm -f $(STAGING_DIR)/bin/ffmpeg
	rm -f $(STAGING_DIR)/bin/ffprobe
	rm -f $(STAGING_DIR)/bin/ffserver
	rm -rf $(STAGING_DIR)/share/
	rm -f $(STAGING_DIR)/bin/lame
	rm -f $(STAGING_DIR)/bin/x264
	rm -rf $(STAGING_DIR)/include

