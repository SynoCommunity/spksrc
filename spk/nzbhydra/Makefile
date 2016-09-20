SPK_NAME = nzbhydra
SPK_VERS = 0.2.130
SPK_REV = 1
SPK_ICON = src/nzbhydra.png
DSM_UI_DIR = app

DEPENDS  = 
SPK_DEPENDS = "python>2.7.9:git"

MAINTAINER = adchevrier
DESCRIPTION = NZBHydra is a meta search for NZB indexers and the \"spiritual successor\" to NZBmegasearcH. It provides easy access to a number of raw and newznab based indexers.
ADMIN_PORT = 5075
RELOAD_UI = yes
DISPLAY_NAME = NZBHydra
BETA = 1
CHANGELOG = "First release"

HOMEPAGE   = https://github.com/theotherp/nzbhydra
LICENSE    = ApacheV2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = nzbhydra_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: nzbhydra_extra_install
nzbhydra_extra_install: $(STAGING_DIR)/share/NZBHydra
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/NZBHydra:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/theotherp/nzbhydra.git && cd nzbhydra && git checkout 4fe6d4dc7123de5e42a348ba043e36a38fd3a5d0
