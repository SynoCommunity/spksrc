SPK_NAME = tvheadend
SPK_VERS = 4.2.3
SPK_REV = 10
SPK_ICON = src/tvheadend.png
DSM_UI_DIR = app
BETA = 1

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = m4tt075
DESCRIPTION = Tvheadend is a TV streaming server and recorder for Linux, FreeBSD and Android supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT IP and HDHomeRun as input sources. Tvheadend offers HTTP, HTSP and SAT IP streaming.
ADMIN_PORT = 9981
RELOAD_UI = yes
DISPLAY_NAME = Tvheadend
CHANGELOG = "Update to Tvheadend 4.2.3 (Release)"

HOMEPAGE = https://www.lonelycoder.com/tvheadend/
LICENSE  = GPL v3

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc
CONF_DIR         = src/conf/
WIZARDS_DIR      = src/wizard/

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = tvheadend_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: tvheadend_extra_install
tvheadend_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/accesscontrol
	install -m 755 -d $(STAGING_DIR)/var/passwd
	# The following filenames stem from an arbitrary (valid) combination created by TVH
	install -m 644 src/accesscontrol.json $(STAGING_DIR)/var/accesscontrol/d80ccc09630261ffdcae1497a690acc8
	install -m 644 src/passwd.json $(STAGING_DIR)/var/passwd/a927e30a755504f9784f23a4efac5109
