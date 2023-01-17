SPK_NAME = darkstat
SPK_VERS = 3.0.719
SPK_REV = 4
SPK_ICON = src/darkstat.png
DSM_UI_DIR = app

DEPENDS = cross/zlib cross/libpcap cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = DarkStat is an ntop-workalike network statistics gatherer. It runs as a background process on a cable or DSL router, uses libpcap to capture network traffic, and has a Web interface that serves up reports of statistics such as data transferred by host, port, and protocol. It also has a neat bandwidth usage graph.
DESCRIPTION_FRE = DarkStat est un outil de monitoring réseau simple et léger. Il présente ses résultats via une interface web par des graphiques simplifiés avec leurs statistiques sommaires \(min/moy/max\) et un récapitulatif du trafic pour les différentes adresses IP ayant eu une connexion avec la machine surveillée.
ADMIN_PORT = 667
RELOAD_UI = yes
DISPLAY_NAME = DarkStat
CHANGELOG = "1. Update to 3.0.719<br>2. Use default interface instead of hardcoded eth0"

HOMEPAGE   = http://unix4lyfe.org/darkstat
LICENSE    = GPL v2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = darkstat_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: darkstat_extra_install
darkstat_extra_install:
	install -m 777 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
