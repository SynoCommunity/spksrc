SPK_NAME = sickbeard
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/sickbeard.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>=2.7.2-1"

MAINTAINER = SynoCommunity
COMMENT    = The ultimate PVR application that downloads and manages your TV shows
ADMIN_PORT = 8081
RELOAD_UI = yes
DISPLAY_NAME = SickBeard

HOMEPAGE   = http://sickbeard.com/
LICENSE    = GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = sickbeard_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: sickbeard_extra_install
sickbeard_extra_install: $(STAGING_DIR)/share/requirements.pybundle $(STAGING_DIR)/share/SickBeard
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/sickbeard.cgi.pl $(STAGING_DIR)/app/sickbeard.cgi
	install -m 755 src/app/sickbeard-cfg.cgi.py $(STAGING_DIR)/app/sickbeard-cfg.cgi
	install -m 644 src/app/sickbeard-cfg.js $(STAGING_DIR)/app/sickbeard-cfg.js
	install -m 755 -d $(STAGING_DIR)/app/texts
	for language in enu fre; do \
		install -m 755 -d $(STAGING_DIR)/app/texts/$${language}; \
		install -m 644 src/app/texts/$${language}/strings $(STAGING_DIR)/app/texts/$${language}/strings; \
	done
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
		convert src/sickbeard-cfg.png -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/sickbeard-cfg-$${size}.png ; \
	done

$(STAGING_DIR)/share/SickBeard:
	cd $(STAGING_DIR)/share && git clone https://github.com/midgetspy/Sick-Beard.git SickBeard
	rm -fr $(STAGING_DIR)/share/SickBeard/.git $(STAGING_DIR)/share/SickBeard/.gitignore
	chmod 777 $(STAGING_DIR)/share/SickBeard/autoProcessTV
	install -m 600 $(STAGING_DIR)/share/SickBeard/autoProcessTV/autoProcessTV.cfg.sample $(STAGING_DIR)/share/SickBeard/autoProcessTV/autoProcessTV.cfg

$(STAGING_DIR)/share/requirements.pybundle:
	@$(MSG) "Bundling requirements"
	install -m 755 -d $(STAGING_DIR)/share
	@cd $(WORK_DIR) && pip bundle $@ pyextdirect configobj

