SPK_NAME = umurmur
SPK_VERS = 0.2.20
SPK_REV = 8
SPK_ICON = src/umurmur.png

DEPENDS = cross/umurmur

MAINTAINER = Diaoul
DESCRIPTION = uMurmur is a minimalistic VoIP server based on the open source software Mumble. It allows simultaneous communications between multiple users. Its low latency makes it especially suitable for communications during online gaming. The Mumble client is available at https://dl.mumble.info/stable/ \(Windows, Mac, Linux and iOS\).
DESCRIPTION_FRE = uMurmur est un serveur minimaliste de voix sur IP basé sur le logiciel libre Mumble. Il rend possible la communication entre plusieurs interlocuteurs de manière simultanée. Sa faible latence le rend particulièrement adapté aux communications pendant les parties de jeux en réseau. Le client Mumble est téléchargeable à l\'adresse https://dl.mumble.info/stable/ \(Windows, Mac, Linux et iOS\).
DESCRIPTION_SPN = uMurmur es un servidor VoIP minimalista basado en el software de codigo abierto Mumble. Permite comunicaciones simultáneas entre múltiples usuarios. Su baja latencia lo hace especialmente adecuado para comunicarse durante un juego en linea. El cliente Mumble está disponible en https://dl.mumble.info/stable/ \(Windows, Mac, Linux and iOS\).
DISPLAY_NAME = uMurmur
CHANGELOG = "1. Update uMurmur to v0.2.20<br/>2. Use mbedtls instead of openssl.<br/>3. Update for DSM 7 compatibility."

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

HOMEPAGE = https://umurmur.net/
LICENSE = 3-clause BSD

POST_STRIP_TARGET = umurmur_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: umurmur_extra_install
umurmur_extra_install:
	install -m 755 -d $(STAGING_DIR)/var $(STAGING_DIR)/app
	install -m 644 src/umurmur.conf $(STAGING_DIR)/var/umurmur.conf
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/umurmur.cgi.sh $(STAGING_DIR)/app/umurmur.cgi
