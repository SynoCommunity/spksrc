SPK_NAME = jappix
SPK_VERS = 1.0.1
SPK_REV = 2
SPK_ICON = src/jappix.png
DSM_UI_DIR = app

DEPENDS  = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Jappix, a full-featured XMPP web-client \(Jappix Desktop, Jappix Mobile \& Jappix Mini\). Jappix is a fresh new open social platform which enables you to create your own cloud, wherever you want to. People must be able to get in touch with all their friends on a free decentralized network!
ADMIN_URL = /jappix/
RELOAD_UI = yes
STARTABLE = no
DISPLAY_NAME = Jappix
CHANGELOG = "1. DSM 5.0 compatibility"
BETA = 1

HOMEPAGE   = http://jappix.org/
LICENSE    = AGPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_DEP_SERVICES = apache-web
START_DEP_SERVICES = apache-web

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = jappix_extra_install

# Pure PHP package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: jappix_extra_install
jappix_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
