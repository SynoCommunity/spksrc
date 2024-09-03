SPK_NAME = ntopng
SPK_VERS = 6.2
SPK_REV = 5
SPK_ICON = src/ntopng.png

DEPENDS = cross/ntopng

SPK_DEPENDS = "redis"

# cross/ndpi and or cross/libcap not supported:
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

MAINTAINER = hgy59
DESCRIPTION = High-Speed Web-based Traffic Analysis and Flow Collection. ntopng is a network traffic probe that provides 360° Network visibility, with its ability to gather traffic information from traffic mirrors, NetFlow exporters, SNMP devices, Firewall logs, Intrusion Detection systems.  To run ntopng on DSM 7, the installed privileges file must be manually patched after installation or update.
CHANGELOG = "1. Update to version 6.2"
DISPLAY_NAME = ntopng

HELPURL = https://www.ntop.org/guides/ntopng/index.html
LICENSE = GPLv3

# 'auto' (reserved value) grabs SPK_NAME
SERVICE_USER = auto
SSS_SCRIPT = src/start-stop-status.sh
STARTABLE = yes

SERVICE_PORT = 3000
SERVICE_PORT_TITLE = ntopng (HTTP)

# generate app/config and app/images/*.png
DSM_UI_DIR = app

include ../../mk/spksrc.common.mk

ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
# On DSM 6: package runs as root
CONF_DIR = src/conf
else
# On DSM 7: package must be defined to run as package user to allow installation.
# Since ntopng must be run as root, the privilege file must be manually
# patched after installation and update.
CONF_DIR = src/conf.dsm7
WIZARDS_DIR = src/wizard.dsm7/
endif

POST_STRIP_TARGET = ntopng_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: ntopng_extra_install
ntopng_extra_install:
	install -m 755 -d $(STAGING_DIR)/var/data
	install -m 644 src/ntopng.conf $(STAGING_DIR)/var/ntopng.conf
	unzip -o src/GeoLite2.mmdb.zip -d $(STAGING_DIR)/share/ntopng/httpdocs/geoip/
