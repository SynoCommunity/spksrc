SPK_NAME = sslh
SPK_VERS = 1.19c
SPK_REV = 3
SPK_ICON = src/sslh.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = sslh accepts HTTPS, SSH, OpenVPN, tinc and XMPP connections on the same port. This makes it possible to connect to any of these servers on port 443 \(e.g. from inside a corporate firewall, which almost never block port 443\) while still serving HTTPS on that port.
DESCRIPTION_FRE = sslh accepte des connexions HTTPS, SSH, OpenVPN, tinc et XMPP sur le même port TCP. Il est ainsi possible de se connecter à l\'un de ces services sur le port 443 \(par exemple depuis derrière un firewall d\'entrepise qui ne bloque en général pas le port 443\) tout en préservant les accès HTTPS sur ce même port.
RELOAD_UI = no
DISPLAY_NAME = sslh

HOMEPAGE   = http://www.rutschle.net/tech/sslh/README.html
LICENSE    = GPLv2
STARTABLE  = yes

SERVICE_SETUP = src/service-setup.sh

POST_STRIP_TARGET = sslh_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: sslh_extra_install
sslh_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/sslh.cfg $(STAGING_DIR)/var/sslh.cfg
