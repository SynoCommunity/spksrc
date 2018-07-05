SPK_NAME = bitlbee
SPK_VERS = 3.4.2
SPK_REV = 12
SPK_ICON = src/bitlbee.png

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = Diaoul
DESCRIPTION = BitlBee brings IM \(instant messaging\) to IRC clients. It\'s a great solution for people who have an IRC client running all the time and don\'t want to run an additional MSN/AIM/whatever client.
DESCRIPTION_FRE = BitlBee permet d\'accèder à sa messagerie instantanée depuis un client IRC. C\'est la solution idéale pour les personnes ayant un client IRC connecté en permanence et qui ne veulent pas de programmes supplémentaires comme MSN, AIM ou autre.
DISPLAY_NAME = BitlBee
CHANGELOG = Update to 3.4.2

HOMEPAGE = http://www.bitlbee.org/
LICENSE  = GPLv2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc
CONF_DIR         = src/conf/


INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = bitlbee_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: bitlbee_extra_install
bitlbee_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/bitlbee.conf $(STAGING_DIR)/var/bitlbee.conf
