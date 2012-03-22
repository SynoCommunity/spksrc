SPK_NAME = nzbconfig
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/nzbconfig.png
DSM_UI_DIR = app
DSM_APP_NAME = SYNOCOMMUNITY.NZBConfig.AppInstance
BETA = 1

SPK_DEPENDS = "python>=2.7.2-1"

MAINTAINER = SynoCommunity
DESCRIPTION = Configuration interface for your packages SABnzbd, NZBGet, SickBeard, CouchPotato and Headphones
DESCRIPTION_FRE = Interface de configuration pour vos paquets SABnzbd, NZBGet, SickBeard, CouchPotato et Headphones
RELOAD_UI = yes
DISPLAY_NAME = NZB Config

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = nzbconfig_extra_install

override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: nzbconfig_extra_install
nzbconfig_extra_install: $(STAGING_DIR)/share/requirements.pybundle
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 644 src/app/nzbconfig.js $(STAGING_DIR)/app/nzbconfig.js
	install -m 644 src/app/style.css $(STAGING_DIR)/app/style.css
	install -m 755 src/app/nzbconfig.cgi.py $(STAGING_DIR)/app/nzbconfig.cgi
	install -m 755 -d $(STAGING_DIR)/app/texts
	for language in enu fre; do \
		install -m 755 -d $(STAGING_DIR)/app/texts/$${language}; \
		install -m 644 src/app/texts/$${language}/strings $(STAGING_DIR)/app/texts/$${language}/strings; \
	done
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
	install -m 644 src/app/images/* $(STAGING_DIR)/app/images/

$(STAGING_DIR)/share/requirements.pybundle:
	@$(MSG) "Bundling requirements"
	install -m 755 -d $(STAGING_DIR)/share
	@cd $(WORK_DIR) && pip bundle --use-mirrors $@ pyextdirect==0.2 configobj

