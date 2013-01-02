SPK_NAME = umurmur
SPK_VERS = 0.2.10
SPK_REV = 4
SPK_ICON = src/umurmur.png
DSM_UI_DIR = app

DEPENDS = cross/openssl cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = uMurmur is a minimalistic VoIP server based on the open source software Mumble. It allows simultaneous communications between multiple users. Its low latency makes it especially suitable for communications during online gaming. The Mumble client is available at http://mumble.sourceforge.net/ \(Windows, Mac, Linux and iOS\).
DESCRIPTION_FRE = uMurmur est un serveur minimaliste de voix sur IP basé sur le logiciel libre Mumble. Il rend possible la communication entre plusieurs interlocuteurs de manière simultanée. Sa faible latence le rend particulièrement adapté aux communications pendant les parties de jeux en réseau. Le client Mumble est téléchargeable à l\\\'adresse http://mumble.sourceforge.net/ \\\(Windows, Mac, Linux et iOS\\\).
DESCRIPTION_SPN = uMurmur es un servidor VoIP minimalista basado en el software de codigo abierto Mumble. Permite comunicaciones simultáneas entre múltiples usuarios. Su baja latencia lo hace especialmente adecuado para comunicarse durante un juego en linea. El cliente Mumble está disponible en http://mumble.sourceforge.net/ \\\(Windows, Mac, Linux and iOS\\\).
RELOAD_UI = yes
DISPLAY_NAME = uMurmur
CHANGELOG = "1. Use 64-bit toolchains for bromolow, cedarview and x86"

HOMEPAGE   = http://code.google.com/p/umurmur/
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

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
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} \
	            $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
