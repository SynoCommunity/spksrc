SPK_NAME = sslh
SPK_VERS = 2.1.4
SPK_REV = 8
SPK_ICON = src/sslh.png

DEPENDS = cross/sslh

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

MAINTAINER = SynoCommunity
DESCRIPTION = sslh is a ssl/ssh multiplexer. sslh accepts connections on specified ports, and forwards them further based on tests performed on the first data packet sent by the remote client. Probes for HTTP, TLS/SSL \(including SNI and ALPN\), SSH, OpenVPN, tinc, XMPP, SOCKS5, are implemented, and any other protocol that can be tested using a regular expression, can be recognised. A typical use case is to allow serving several services on port 443 \(e.g. to connect to SSH from inside a corporate firewall, which almost never block port 443\) while still serving HTTPS on that port.

DISPLAY_NAME = sslh
CHANGELOG = "1. Update sslh to v2.1.4. <br/>2. Add sslh-select and sslh-ev. <br/>3. Add option to choose sslh-fork, sslh-select or sslh-ev at installation and upgrade."

HOMEPAGE  = https://www.rutschle.net/tech/sslh/README.html
LICENSE   = GPLv2
STARTABLE = yes

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

POST_STRIP_TARGET = sslh_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: sslh_extra_install
sslh_extra_install:
	@install -m 755 -d $(STAGING_DIR)/var
	@install -m 644 src/sslh.cfg $(STAGING_DIR)/var/sslh.cfg
	@install -m 644 src/example.cfg $(STAGING_DIR)/var/example.cfg
