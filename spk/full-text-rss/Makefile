SPK_NAME = full-text-rss
SPK_VERS = 3.3.$(shell date +%Y%m%d)
SPK_REV = 4
SPK_ICON = src/full-text-rss.png
DSM_UI_DIR = app

DEPENDS  =

MAINTAINER = moneytoo
DESCRIPTION = Create full-text feed from feed or webpage URL.
ADMIN_URL = /full-text-rss/
RELOAD_UI = yes
STARTABLE = no
DISPLAY_NAME = Full-Text RSS
CHANGELOG = "1. Add site config files"

HOMEPAGE   = http://code.fivefilters.org/full-text-rss/
LICENSE    = AGPLv3

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_DEP_SERVICES = apache-web

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = full-text-rss_extra_install

# Pure PHP package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: full-text-rss_extra_install
full-text-rss_extra_install: $(STAGING_DIR)/share/full-text-rss
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config

$(STAGING_DIR)/share/full-text-rss:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone http://bitbucket.org/fivefilters/full-text-rss.git full-text-rss && cd full-text-rss && git checkout cfe4c012ef494f93237bb8248f0b7f8a5a887f5a
	rm -fr $(STAGING_DIR)/share/full-text-rss/.git $(STAGING_DIR)/share/full-text-rss/.gitignore
	rm -fr $(STAGING_DIR)/share/full-text-rss/site_config/standard/ && cd $(STAGING_DIR)/share/full-text-rss/site_config/ && git clone http://github.com/fivefilters/ftr-site-config standard
	rm -fr $(STAGING_DIR)/share/full-text-rss/site_config/standard/.git $(STAGING_DIR)/share/full-text-rss/site_config/standard/.gitignore
