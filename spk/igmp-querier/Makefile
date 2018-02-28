SPK_NAME = igmp-querier
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/default.jpg
DSM_UI_DIR = app

DEPENDS = cross/${SPK_NAME}

MAINTAINER = "Daniel Lorch"
DESCRIPTION = "Fixes a problem with Apple AirPlay / Bonjour devices not showing up on the local network (or showing up and then disappearing after a while) due to faulty IGMP snooping implementations on home routers. This is a frequently reported problem with AV receivers (e.g. from Denon, Yamaha, Pioneer) in conjuction with AirPlay."
DISPLAY_NAME = "IGMP Querier"

HOMEPAGE = https://github.com/dlorch/igmp-querier
LICENSE  = BSD

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)
POST_STRIP_TARGET = igmp_querier_extra_install 

include ../../mk/spksrc.spk.mk

.PHONY: igmp_querier_extra_install
igmp_querier_extra_install:
	rm -rf $(STAGING_DIR)/bin
	rm -rf $(STAGING_DIR)/lib
	rm -rf $(STAGING_DIR)/include
