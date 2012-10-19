SPK_NAME = gateone
SPK_VERS = 1.1.0~git20121015
SPK_REV = 1
SPK_ICON = src/gateone.png
DSM_UI_DIR = app
BETA = 1

DEPENDS  = cross/busybox cross/dtach
SPK_DEPENDS = "python>=2.7.3-1"

MAINTAINER = SynoCommunity
DESCRIPTION = Gate One is an HTML5-powered terminal emulator and SSH client
DESCRIPTION_FRE = Gate One est un émulateur de terminal et un client SSH fonctionnant en HTML5
ADMIN_PROTOCOL = https
ADMIN_PORT = 8071
RELOAD_UI = yes
DISPLAY_NAME = GateOne

HOMEPAGE   = http://liftoffsoftware.com/Products/GateOne
LICENSE    = AGPLv3

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = gateone_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: gateone_extra_install
gateone_extra_install: $(STAGING_DIR)/share/requirements.pybundle $(STAGING_DIR)/share/GateOne
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/ssl
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 644 src/server.conf $(STAGING_DIR)/var/server.conf
	install -m 755 src/app/gateone.cgi.py $(STAGING_DIR)/app/gateone.cgi
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/requirements.pybundle:
	@$(MSG) "Bundling requirements"
	install -m 755 -d $(STAGING_DIR)/share
	@cd $(WORK_DIR) && pip bundle $@ tornado

$(STAGING_DIR)/share/GateOne:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/liftoff/GateOne.git GateOne
	cd $(STAGING_DIR)/share/GateOne && git checkout 69b16c5147
	rm -fr $(STAGING_DIR)/share/GateOne/.git $(STAGING_DIR)/share/GateOne/.gitignore

