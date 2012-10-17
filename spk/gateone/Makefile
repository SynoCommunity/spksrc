SPK_NAME = gateone
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/gateone.png
DSM_UI_DIR = app

DEPENDS  = cross/busybox cross/dtach
SPK_DEPENDS = "python>=2.7.3-1"

MAINTAINER = SynoCommunity
DESCRIPTION = Gate One is an HTML5-powered terminal emulator and SSH client
DESCRIPTION_FRE = Gate One est un émulateur de terminal et un client SSH fonctionnant en HTML 5.
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
	install -m 755 -d $(STAGING_DIR)/var/conf
	install -m 770 -d $(STAGING_DIR)/var/sessions
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/help
	install -m 755 $(INSTALL_DIR)/$(INSTALL_PREFIX)/bin/dtach $(STAGING_DIR)/bin/
	install -m 644 src/app/config $(STAGING_DIR)/app/
	install -m 755 src/app/gateone.cgi $(STAGING_DIR)/app/
	install -m 644 src/gateone.tpl $(STAGING_DIR)/var/conf/
	install -m 755 src/setConf.pl $(STAGING_DIR)/var/conf/
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
	install -m 755 -d $(STAGING_DIR)/help/texts
	install -m 755 -d $(STAGING_DIR)/help/help
	install -m 644 src/help/index.conf $(STAGING_DIR)/help/
	install -m 644 src/help/helptoc.conf $(STAGING_DIR)/help/
	for language in fre enu; do \
		install -m 755 -d $(STAGING_DIR)/help/help/$${language}; \
		install -m 755 -d $(STAGING_DIR)/help/texts/$${language}; \
		install -m 644 src/help/help/$${language}/*.html $(STAGING_DIR)/help/help/$${language}/; \
		install -m 644 src/help/texts/$${language}/strings $(STAGING_DIR)/help/texts/$${language}/strings; \
	done

$(STAGING_DIR)/share/requirements.pybundle:
	@$(MSG) "Bundling requirements"
	install -m 755 -d $(STAGING_DIR)/share
	@cd $(WORK_DIR) && pip bundle $@ auto2to3 tornado

$(STAGING_DIR)/share/GateOne:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/liftoff/GateOne.git GateOne
	rm -fr $(STAGING_DIR)/share/GateOne/.git $(STAGING_DIR)/share/GateOne/.gitignore

