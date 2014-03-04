SPK_NAME = lighttpd
SPK_VERS = 1.4.33
SPK_REV = 1
SPK_ICON = src/lighttpd.png

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Lighttpd is a webserver focused on security, speed and compliance. It is designed and optimized for high performance environments.
DESCRIPTION_FRE = Lighttpd est un serveur web sécurisé, rapide et compatible. Il a été conçu et optimisé pour des environnements à haute performance.
DISPLAY_NAME = Lighttpd
CHANGELOG =

HOMEPAGE = http://www.lighttpd.net/
LICENSE  =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = lighttpd_extra_install

BUSYBOX_CONFIG = daemon
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: lighttpd_extra_install
lighttpd_extra_install:
	install -m 755 -d $(STAGING_DIR)/{etc/lighttpd,var}
	install -m 644 src/lighttpd.conf $(STAGING_DIR)/etc/lighttpd/lighttpd.conf
