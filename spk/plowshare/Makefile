SPK_NAME = plowshare
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/plowshare.png
DSM_UI_DIR = app

DEPENDS = cross/bash cross/libcaca cross/screen

MAINTAINER = SynoCommunity
DESCRIPTION = Plowshare is a command-line \(CLI\) download/upload tool for popular file sharing websites.
RELOAD_UI = no
STARTABLE = no
DISPLAY_NAME = plowshare
BETA = 1

HOMEPAGE   = https://code.google.com/p/plowshare/
LICENSE    = GPLv3

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

PRE_COPY_TARGET = plowshare_install
PRE_STRIP_TARGET = plowshare_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: plowshare_install
plowshare_install: 
	cd $(WORK_DIR) && git clone https://code.google.com/p/plowshare/ plowshare
	cd $(WORK_DIR)/plowshare && make install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)

.PHONY: plowshare_extra_install
plowshare_extra_install: 
	mv $(INSTALL_DIR)/$(INSTALL_PREFIX)/bin/plow* $(STAGING_DIR)/bin
	sed -i "s|^#!/usr/bin/env bash|#!/usr/bin/env $(INSTALL_PREFIX)/bin/bash|g" $(STAGING_DIR)/share/plowshare4/*.sh
	sed -i "s|img2txt|$(INSTALL_PREFIX)/bin/img2txt|g" $(STAGING_DIR)/share/plowshare4/core.sh
