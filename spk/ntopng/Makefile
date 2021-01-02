SPK_NAME = ntopng
SPK_VERS = 4.2
SPK_REV = 3
SPK_ICON = src/$(SPK_NAME).png

DEPENDS = cross/$(SPK_NAME)

SPK_DEPENDS = "redis"

# toolchains of DSM <=5.2 have outdated compiler (PPC archs except qoriq)
UNSUPPORTED_ARCHS = $(OLD_PCC_ARCHS)

MAINTAINER = hgy59
DESCRIPTION = ntopng is the next generation version of the original ntop, a network traffic probe that monitors network usage. ntopng is based on libpcap and it has been written in a portable way in order to virtually run on every Unix platform, MacOSX and on Windows as well.
CHANGELOG = "1. Update to version 4.2<br/>2. Update nDPI to version 3.4"
RELOAD_UI = yes
DISPLAY_NAME = ntopng

HELPURL = https://www.ntop.org/guides/ntopng/index.html
LICENSE = GNU GPLv3

# 'auto' (reserved value) grabs SPK_NAME
SERVICE_USER   = auto
SSS_SCRIPT     = src/start-stop-status.sh
STARTABLE      = yes
SERVICE_PORT   = 3000

# generate app/config and app/images/*.png
DSM_UI_DIR = app

# In case script start-stop-status has to run as root on DSM 6, package can
# provide its own conf/privilege file as far as CONF_DIR variable is set.
CONF_DIR = src/conf

POST_STRIP_TARGET = ntopng_extra_install


include ../../mk/spksrc.spk.mk

.PHONY: ntopng_extra_install
ntopng_extra_install:
	install -m 755 -d $(STAGING_DIR)/var/data
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 644 src/ntopng.conf $(STAGING_DIR)/etc/ntopng.conf
	unzip -o src/GeoLite2.mmdb.zip -d $(STAGING_DIR)/share/ntopng/httpdocs/geoip/
