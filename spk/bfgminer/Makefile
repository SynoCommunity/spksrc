SPK_NAME = bfgminer
SPK_VERS = 3.3.0
SPK_REV = 1
SPK_ICON = src/app/static/img/bfgminer.png
DSM_UI_DIR = app

DEPENDS = cross/bfgminer

SPK_DEPENDS = "Python>2.7"

MAINTAINER = SynoCommunity
DESCRIPTION = BFGMiner is a crypto coin miner, meant for use with external mining hardware, like that from butterfly labs or AsicMiner. 
ADMIN_PORT = 1072
RELOAD_UI = yes
DISPLAY_NAME = BFGMiner
CHANGELOG = 1. Initial package go to polandj, all credit go to him !\\\2. Cpumining is disabled in this package.\\\3. bfgminer upgraded to version 3.3.0\\\4. bitcoin upgraded to version 0.8.3
HOMEPAGE = https://github.com/luke-jr/bfgminer
LICENSE  = 

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = bfgminer_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: bfgminer_extra_install
bfgminer_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/settings.json $(STAGING_DIR)/var/settings.json
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/redirect.cgi.sh $(STAGING_DIR)/app/redirect.cgi
	install -m 644 src/app/bottle.py $(STAGING_DIR)/app/bottle.py
	install -m 755 src/app/bfgui.py $(STAGING_DIR)/app/bfgui.py
	cp -r src/app/static $(STAGING_DIR)/app
	cp -r src/app/views $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} \
	            $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
