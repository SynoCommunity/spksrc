SPK_NAME = dante-sockd
SPK_VERS = 1.4.4
SPK_REV = 2
SPK_ICON = src/dante.png

DEPENDS = cross/dante-sockd

MAINTAINER = Anonym-tsk
# From Inferno Nettverk A/S
DESCRIPTION = Dante implements the socks standard and can function as a firewall between networks. Package contains sockd - socks proxyserver.
DESCRIPTION_FRE = Dante fournit le service socks et peut servir de firewall entre réseaux. Le package contient sockd - un serveur proxy socks.
DISPLAY_NAME = Dante SOCKS server
CHANGELOG = "1. Update to version 1.4.4 and DSM 7.<br/>2. Include socksify script.<br/>3. Add DSM firewall rule for configured port."

HOMEPAGE = https://www.inet.no/dante/
LICENSE  = BSD/CMU

WIZARDS_DIR = src/wizard/

STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh
# service port is set in service_preinst from wizard-variable
SERVICE_PORT = @socks_port@
SERVICE_PORT_TITLE = "TCP \(proxy server\)"
NO_SERVICE_SHORTCUT = true
SERVICE_USER = auto

POST_STRIP_TARGET = sockd_extra_install

SPK_COMMANDS = bin/socksify

include ../../mk/spksrc.spk.mk

.PHONY: sockd_extra_install
sockd_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/sockd.conf $(STAGING_DIR)/var/sockd.conf
