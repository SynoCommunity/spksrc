SPK_NAME = umurmur
SPK_VERS = 0.2.17
SPK_REV = 7
SPK_ICON = src/umurmur.png
DSM_UI_DIR = app

DEPENDS = cross/openssl cross/$(SPK_NAME)

MAINTAINER = Diaoul
DESCRIPTION = uMurmur is a minimalistic VoIP server based on the open source software Mumble. It allows simultaneous communications between multiple users. Its low latency makes it especially suitable for communications during online gaming. The Mumble client is available at http://mumble.sourceforge.net/ \(Windows, Mac, Linux and iOS\).
DESCRIPTION_FRE = uMurmur est un serveur minimaliste de voix sur IP basé sur le logiciel libre Mumble. Il rend possible la communication entre plusieurs interlocuteurs de manière simultanée. Sa faible latence le rend particulièrement adapté aux communications pendant les parties de jeux en réseau. Le client Mumble est téléchargeable à l\'adresse http://mumble.sourceforge.net/ \(Windows, Mac, Linux et iOS\).
DESCRIPTION_SPN = uMurmur es un servidor VoIP minimalista basado en el software de codigo abierto Mumble. Permite comunicaciones simultáneas entre múltiples usuarios. Su baja latencia lo hace especialmente adecuado para comunicarse durante un juego en linea. El cliente Mumble está disponible en http://mumble.sourceforge.net/ \(Windows, Mac, Linux and iOS\).
RELOAD_UI = yes
DISPLAY_NAME = uMurmur
CHANGELOG = "1. Update to 0.2.17 2. Use DSM5+6 generic service"
STARTABLE = yes

SERVICE_USER = auto
# SERVICE_COMMAND is provided there
SERVICE_SETUP = src/service-setup.sh

HOMEPAGE = https://github.com/umurmur/umurmur
LICENSE = BSD 3-clause License

POST_STRIP_TARGET = umurmur_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: umurmur_extra_install
umurmur_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/umurmur.conf $(STAGING_DIR)/var/umurmur.conf
	install -m 755 -d $(STAGING_DIR)/sbin
	install -m 755 src/gencert.sh $(STAGING_DIR)/sbin/gencert.sh
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/umurmur.cgi.pl $(STAGING_DIR)/app/umurmur.cgi
