SPK_NAME = deluge
SPK_VERS = 1.3.5
SPK_REV = 1
SPK_ICON = src/deluge.png
DSM_UI_DIR = app
BETA = 1

DEPENDS  = cross/$(SPK_NAME)

SPK_DEPENDS = "python>2.7.3-2"

MAINTAINER = SynoCommunity
DESCRIPTION = Deluge is a full-featured  BitTorrent client for Linux, OS X, Unix and Windows. It uses libtorrent in its backend and features multiple user-interfaces including: GTK+, web and console. It has been designed using the client server model with a daemon process that handles all the bittorrent activity. The Deluge daemon is able to run on headless machines with the user-interfaces being able to connect remotely from any platform.
ADMIN_PORT = 8112
RELOAD_UI = yes
DISPLAY_NAME = Deluge

HOMEPAGE   = http://deluge-torrent.org/
LICENSE    = GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = deluge_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: deluge_extra_install
deluge_extra_install: $(STAGING_DIR)/share/requirements.pybundle
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/deluge.cgi.py $(STAGING_DIR)/app/deluge.cgi
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/requirements.pybundle:
	@$(MSG) "Bundling requirements"
	install -m 755 -d $(STAGING_DIR)/share
	@cd $(WORK_DIR) && $(PIP) bundle --no-dependencies $@ Mako chardet pyxdg
