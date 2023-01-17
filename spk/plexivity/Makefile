SPK_NAME = plexivity
SPK_VERS = 0.9.9
SPK_REV = 3
SPK_ICON = src/plexivity.png
DSM_UI_DIR = app
BETA = 1

DEPENDS  =
SPK_DEPENDS = "python>=2.7.6-8"

WHEELS = src/requirements.txt

MAINTAINER = cytec
DESCRIPTION = plexivity is a simple alternative for plexWatch. It connects with your Plex Media Server and is able to notify you on activity.
ADMIN_PORT = 6060
RELOAD_UI = yes
DISPLAY_NAME = plexivity

HOMEPAGE   = http://raphaelmutschler.de/work/plexivity/
LICENSE    = GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc
CONF_DIR         = src/conf/

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = plexivity_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: plexivity_extra_install
plexivity_extra_install: $(STAGING_DIR)/share/plexivity
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
	install -m 644 src/app/config $(STAGING_DIR)/app/config

$(STAGING_DIR)/share/plexivity:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/mutschler/plexivity.git plexivity 
	cd $(STAGING_DIR)/share/plexivity && git checkout $(SPK_VERS) && rm -rf .git && rm .gitignore
