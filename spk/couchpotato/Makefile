SPK_NAME = couchpotato
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/couchpotato.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>=2.7.2-1"

MAINTAINER = SynoCommunity
COMMENT    = Automatic NZB and torrent downloader for movies
ADMIN_PORT = 8200
RELOAD_UI = yes
DISPLAY_NAME = CouchPotato

HOMEPAGE   = http://couchpota.to/
LICENSE    = GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = couchpotato_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: couchpotato_extra_install
couchpotato_extra_install: $(STAGING_DIR)/share/requirements.pybundle $(STAGING_DIR)/share/CouchPotato
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/couchpotato.cgi.pl $(STAGING_DIR)/app/couchpotato.cgi
	install -m 755 src/app/couchpotato-cfg.cgi.py $(STAGING_DIR)/app/couchpotato-cfg.cgi
	install -m 644 src/app/couchpotato-cfg.js $(STAGING_DIR)/app/couchpotato-cfg.js
	install -m 755 -d $(STAGING_DIR)/app/texts
	for language in enu fre; do \
		install -m 755 -d $(STAGING_DIR)/app/texts/$${language}; \
		install -m 644 src/app/texts/$${language}/strings $(STAGING_DIR)/app/texts/$${language}/strings; \
	done
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
		convert src/couchpotato-cfg.png -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/couchpotato-cfg-$${size}.png ; \
	done

$(STAGING_DIR)/share/CouchPotato:
	cd $(STAGING_DIR)/share && git clone https://github.com/RuudBurger/CouchPotato.git CouchPotato
	rm -fr $(STAGING_DIR)/share/CouchPotato/.git $(STAGING_DIR)/share/CouchPotato/.gitignore

$(STAGING_DIR)/share/requirements.pybundle:
	@$(MSG) "Bundling requirements"
	install -m 755 -d $(STAGING_DIR)/share
	@cd $(WORK_DIR) && pip bundle --use-mirrors $@ pyextdirect==0.2 configobj

