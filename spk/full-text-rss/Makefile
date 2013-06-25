SPK_NAME = full-text-rss
SPK_VERS = 2.9.5
SPK_REV = 1
SPK_ICON = src/full-text-rss.png
DSM_UI_DIR = app

DEPENDS  =

MAINTAINER = SynoCommunity
DESCRIPTION = Create full-text feed from feed or webpage URL.
ADMIN_URL = /full-text-rss/
RELOAD_UI = yes
STARTABLE = no
DISPLAY_NAME = Full-Text RSS

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
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/full-text-rss:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone http://bitbucket.org/fivefilters/full-text-rss.git full-text-rss && cd full-text-rss && git checkout bb2ea808169ada9cfdc7bed787336e5faadb067a
	rm -fr $(STAGING_DIR)/share/full-text-rss/.git $(STAGING_DIR)/share/full-text-rss/.gitignore
