SPK_NAME = znc
SPK_VERS = 0.204
SPK_REV = 1
SPK_ICON = src/znc.png
DSM_UI_DIR = app

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Advanced IRC bouncer. ZNC remain connected to your IRC servers and delivers messages you got while you were away.
DESCRIPTION_FRE = Bouncer IRC avancé. ZNC reste connecté à vos serveurs IRC et vous retransmet les messages arrivés pendant votre absence.
ADMIN_PORT = 8250
RELOAD_UI = yes
DISPLAY_NAME = ZNC

HOMEPAGE = http://wiki.znc.in/
LICENSE  =

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = znc_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: znc_extra_install
znc_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/modules
	install -m 755 -d $(STAGING_DIR)/var/configs
	install -m 644 src/znc.conf $(STAGING_DIR)/var/configs/znc.conf
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/znc.cgi.pl $(STAGING_DIR)/app/znc.cgi
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

