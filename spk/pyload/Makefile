SPK_NAME = pyload
SPK_VERS = 0.4.9
SPK_REV = 1
SPK_ICON = src/pyload.png
DSM_UI_DIR = app

DEPENDS = cross/tesseract-ocr cross/$(SPK_NAME)
SPK_DEPENDS = "python>2.7.3-3"

MAINTAINER = SynoCommunity
DESCRIPTION = pyLoad is a fast, lightweight and full featured download manager for many One-Click-Hoster, container formats like DLC, video sites or just plain http/ftp links.
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = pyLoad

HOMEPAGE   = http://pyload.org
LICENSE    = GPLv3

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = pyload_extra_install

TESSDATA_DIST_SITE = http://tesseract-ocr.googlecode.com/files
TESSDATA_DIST_NAME = tesseract-ocr-3.02.eng.tar.gz

include ../../mk/spksrc.spk.mk

.PHONY: pyload_extra_install
pyload_extra_install: $(WORK_DIR)/.tessdata_install_done
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/pyload.cgi.sh $(STAGING_DIR)/app/pyload.cgi
	install -m 644 src/default_syn.conf $(STAGING_DIR)/share/pyload/module/config/default_syn.conf
	install -m 644 src/pyload_init.sql $(STAGING_DIR)/share/pyload/module/config/pyload_init.sql
	install -m 644 src/htaccess.example $(STAGING_DIR)/share/pyload/module/config/htaccess.example
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 64 72 256; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(WORK_DIR)/.tessdata_install_done:
	install -m 755 -d $(STAGING_DIR)/share/tessdata
	@if [ ! -f "$(DISTRIB_DIR)/$(TESSDATA_DIST_NAME)" ]; then \
		echo "wget $(TESSDATA_DIST_SITE)/$(TESSDATA_DIST_NAME)"; \
		wget -nv -O $(DISTRIB_DIR)/$(TESSDATA_DIST_NAME).part $(TESSDATA_DIST_SITE)/$(TESSDATA_DIST_NAME) ; \
		mv $(DISTRIB_DIR)/$(TESSDATA_DIST_NAME).part $(DISTRIB_DIR)/$(TESSDATA_DIST_NAME) ; \
	else \
		$(MSG) "File $(TESSDATA_DIST_NAME) already downloaded" ; \
	fi
	@$(MSG) "  Extracting $(TESSDATA_DIST_NAME)"
	tar -xzpf "$(DISTRIB_DIR)/$(TESSDATA_DIST_NAME)" -C "$(STAGING_DIR)/share/tessdata" --strip-components 2
	@touch -f $@
