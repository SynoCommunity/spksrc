SPK_NAME = headphones
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/headphones.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>=2.7.2-1"

MAINTAINER = SynoCommunity
COMMENT    = Automatic music downloader for SABnzbd
ADMIN_PORT = 8181
RELOAD_UI = yes
DISPLAY_NAME = Headphones

HOMEPAGE   = https://github.com/rembo10/headphones
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = headphones_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: headphones_extra_install
headphones_extra_install: $(STAGING_DIR)/share/requirements.pybundle $(STAGING_DIR)/share/Headphones
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/headphones.cgi.pl $(STAGING_DIR)/app/headphones.cgi
	install -m 755 src/app/headphones-cfg.cgi.py $(STAGING_DIR)/app/headphones-cfg.cgi
	install -m 644 src/app/headphones-cfg.js $(STAGING_DIR)/app/headphones-cfg.js
	install -m 755 -d $(STAGING_DIR)/app/texts
	for language in enu fre; do \
		install -m 755 -d $(STAGING_DIR)/app/texts/$${language}; \
		install -m 644 src/app/texts/$${language}/strings $(STAGING_DIR)/app/texts/$${language}/strings; \
	done
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
		convert src/headphones-cfg.png -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/headphones-cfg-$${size}.png ; \
	done

$(STAGING_DIR)/share/Headphones:
	cd $(STAGING_DIR)/share && git clone https://github.com/rembo10/headphones.git Headphones
	rm -fr $(STAGING_DIR)/share/Headphones/.git $(STAGING_DIR)/share/Headphones/.gitignore

$(STAGING_DIR)/share/requirements.pybundle:
	@$(MSG) "Bundling requirements"
	install -m 755 -d $(STAGING_DIR)/share
	@cd $(WORK_DIR) && pip bundle --use-mirrors $@ pyextdirect==0.2 configobj

