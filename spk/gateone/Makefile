SPK_NAME = gateone
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/gateone.png
DSM_UI_DIR = app
BETA = 1

DEPENDS  =
SPK_DEPENDS = "python>=2.7.3-1:haproxy>=1.5-dev11"

MAINTAINER = SynoCommunity
DESCRIPTION = Gate One is an HTML5-powered terminal emulator and SSH client
DESCRIPTION_FRE = Gate One est un émulateur de terminal et un client SSH fonctionnant en HTML 5.
ADMIN_PORT = 8200
RELOAD_UI = yes
DISPLAY_NAME = GateOne

HOMEPAGE   = http://liftoffsoftware.com/Products/GateOne
LICENSE    = AGPLv3

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = gateone_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: gateone_extra_install
gateone_extra_install: $(STAGING_DIR)/share/requirements.pybundle $(STAGING_DIR)/share/GateOne
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/conf
	install -m 770 -d $(STAGING_DIR)/var/sessions
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config.tpl
	install -m 644 src/gateone.tpl $(STAGING_DIR)/var/conf/gateone.tpl
	install -m 755 src/setConf.pl $(STAGING_DIR)/var/conf/setConf.pl
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/requirements.pybundle:
	@$(MSG) "Bundling requirements"
	install -m 755 -d $(STAGING_DIR)/share
	@cd $(WORK_DIR) && pip bundle --use-mirrors $@ auto2to3 tornado

$(STAGING_DIR)/share/GateOne:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/liftoff/GateOne.git GateOne
	rm -fr $(STAGING_DIR)/share/GateOne/.git $(STAGING_DIR)/share/GateOne/.gitignore

