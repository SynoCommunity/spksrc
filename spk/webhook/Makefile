SPK_NAME = webhook
SPK_VERS = 2.8.3
SPK_REV = 1
SPK_ICON = src/webhook.png

DEPENDS = cross/webhook

UNSUPPORTED_ARCHS = $(PPC_ARCHS)


MAINTAINER = talkahe
DESCRIPTION =  webhook is a lightweight incoming webhook server to run shell commands. Port: 9010. Configuration file: /var/packages/webhook/var/hooks.json.
DISPLAY_NAME = webhook
HOMEPAGE = https://github.com/adnanh/webhook
LICENSE  = MIT
CHANGELOG = "Initial package release."


STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 9010
SERVICE_PORT_TITLE = Webhook HTTP Port
NO_SERVICE_SHORTCUT = true

SPK_COMMANDS = bin/webhook

POST_STRIP_TARGET = webhook_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: webhook_extra_install
webhook_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/hooks.json $(STAGING_DIR)/var/hooks.json
