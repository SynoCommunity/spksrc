SPK_NAME = ente
SPK_VERS = 1.7.14
SPK_REV = 1
SPK_ICON = src/ente.png

DEPENDS = cross/ente cross/ente-web

SPK_DEPENDS = "minio"

UNSUPPORTED_ARCHS = $(32bit_ARCHS) $(ARMv5_ARCHS)

MAINTAINER = SynoCommunity
DESCRIPTION = "End-to-end encrypted platform for photos and authenticators. Self-hosted alternative to Google Photos with privacy-first design."
DISPLAY_NAME = Ente
CHANGELOG = "Initial release of Ente server v1.7.14"
HOMEPAGE = https://ente.io
HELPURL = https://help.ente.io/self-hosting
SUPPORTURL = https://github.com/ente-io/ente/discussions

LICENSE = AGPLv3
LICENSE_FILE = $(WORK_DIR)/$(SPK_NAME)-photosd-v$(SPK_VERS)/LICENSE

WIZARDS_DIR = src/wizard/

# 'auto' reserved value grabs SPK_NAME
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE = yes

# Service configuration
SERVICE_PORT = 8097
SERVICE_PORT_TITLE = Ente (HTTP)

# Admin link
ADMIN_PORT = $(SERVICE_PORT)

POST_STRIP_TARGET = ente_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: ente_extra_install
ente_extra_install:
	@$(MSG) "Install configuration template"
	@install -m 755 -d $(STAGING_DIR)/var
	@install -m 644 src/museum.yaml $(STAGING_DIR)/var/museum.yaml
	@$(MSG) "Install server configurations from cross/ente"
	@if [ -d $(WORK_DIR)/install/$(INSTALL_PREFIX)/share ]; then \
		cp -r $(WORK_DIR)/install/$(INSTALL_PREFIX)/share $(STAGING_DIR)/; \
	fi
