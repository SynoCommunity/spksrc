SPK_NAME = uidevelop
SPK_VERS = 0.1
SPK_REV = 1
SPK_ICON = src/uidevelop.png
DSM_UI_DIR = app
DSM_APP_NAME = SYNOCOMMUNITY.UIDevelop.Instance
BETA = 1

SPK_DEPENDS = "python>=2.7.2-1"

MAINTAINER = SynoCommunity
DESCRIPTION = SPK to help developers creating DSM interfaces
DESCRIPTION_FRE = SPK pour aider les développeurs à créer des interfaces DSM
RELOAD_UI = yes
DISPLAY_NAME = UI Develop

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = uidevelop_extra_install

override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: uidevelop_extra_install
uidevelop_extra_install: $(STAGING_DIR)/share/requirements.pybundle
	install -m 755 -d $(STAGING_DIR)/data
	install -m 644 src/data/config $(STAGING_DIR)/data/config
	install -m 644 src/data/uidevelop.js $(STAGING_DIR)/data/uidevelop.js
	install -m 644 src/data/style.css $(STAGING_DIR)/data/style.css
	install -m 755 src/data/uidevelop.cgi.py $(STAGING_DIR)/data/uidevelop.cgi
	install -m 755 -d $(STAGING_DIR)/data/texts
	for language in enu fre; do \
		install -m 755 -d $(STAGING_DIR)/data/texts/$${language}; \
		install -m 644 src/data/texts/$${language}/strings $(STAGING_DIR)/data/texts/$${language}/strings; \
	done
	install -m 755 -d $(STAGING_DIR)/data/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/data/images/$(SPK_NAME)-$${size}.png ; \
	done
	install -m 644 src/data/images/icon_config.png $(STAGING_DIR)/data/images/icon_config.png
	install -m 644 src/data/images/list_item_active.png $(STAGING_DIR)/data/images/list_item_active.png
	install -m 644 src/data/images/list_item_hover.png $(STAGING_DIR)/data/images/list_item_hover.png

$(STAGING_DIR)/share/requirements.pybundle:
	@$(MSG) "Bundling requirements"
	install -m 755 -d $(STAGING_DIR)/share
	@cd $(WORK_DIR) && pip bundle --use-mirrors $@ pyextdirect==0.2

