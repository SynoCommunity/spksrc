SPK_NAME = darkstat
SPK_VERS = 3.0.721
SPK_REV = 5
SPK_ICON = src/darkstat.png
DSM_UI_DIR = app

DEPENDS = cross/darkstat

# DSM 7 does not allow to run package as root
# error: pcap_open_live(): ovs_eth0: You don't have permission to capture on that device (socket: Operation not permitted)
REQUIRED_MAX_DSM = 6.999

MAINTAINER = SynoCommunity
DESCRIPTION = DarkStat is an ntop-workalike network statistics gatherer. It runs as a background process on a cable or DSL router, uses libpcap to capture network traffic, and has a Web interface that serves up reports of statistics such as data transferred by host, port, and protocol. It also has a neat bandwidth usage graph.
DESCRIPTION_FRE = DarkStat est un outil de monitoring réseau simple et léger. Il présente ses résultats via une interface web par des graphiques simplifiés avec leurs statistiques sommaires \(min/moy/max\) et un récapitulatif du trafic pour les différentes adresses IP ayant eu une connexion avec la machine surveillée.
ADMIN_PORT = 667
DISPLAY_NAME = DarkStat
CHANGELOG = "1. Update to v3.0.721<br>2. Use default interface instead of hardcoded eth0."

HOMEPAGE = https://unix4lyfe.org/darkstat
LICENSE  = GPLv2

STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 667

POST_STRIP_TARGET = darkstat_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: darkstat_extra_install
darkstat_extra_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/app
	install -m 644 src/app/config $(STAGING_INSTALL_PREFIX)/app/config
