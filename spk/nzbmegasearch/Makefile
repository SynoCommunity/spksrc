SPK_NAME = nzbmegasearch
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 2
SPK_ICON = src/nzbmegasearch.png
DSM_UI_DIR = app

DEPENDS  = 
SPK_DEPENDS = "python>2.7.3-3:git"

MAINTAINER = SynoCommunity
DESCRIPTION = Aggregate automatically NZB search results. Easy. Quick. Clean. NZBmegasearcH collects all your \(not only\) newznab-based accounts to one place. It is your meta-search engine and your SB, CP unique NZB provider.
ADMIN_PORT = 8086
RELOAD_UI = yes
DISPLAY_NAME = NZBmegasearcH
BETA = 1
CHANGELOG = "1. Update to 0.47, fixes tvrage<br>2. Allow built-in updater to work"

HOMEPAGE   = http://pillone.github.io/usntssearch/
LICENSE    = GPLv2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc
CONF_DIR         = src/conf/

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = nzbmegasearch_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: nzbmegasearch_extra_install
nzbmegasearch_extra_install: $(STAGING_DIR)/share/NZBmegasearch
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config

$(STAGING_DIR)/share/NZBmegasearch:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone --depth=1 https://github.com/pillone/usntssearch.git .
	sed -i "s|^port = .*$$|port = 8086|g" $(STAGING_DIR)/share/NZBmegasearch/builtin_params.ini
