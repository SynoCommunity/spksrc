SPK_NAME = gotify
SPK_VERS = 2.8.0
SPK_REV = 2
SPK_ICON = src/gotify.png

DEPENDS = cross/gotify-server cross/gotify-cli

REQUIRED_MIN_DSM = 7.2

MAINTAINER = SynoCommunity
DISPLAY_NAME = Gotify
DESCRIPTION = A simple server for sending and receiving messages. Includes gotify-cli for pushing messages to gotify/server.
HOMEPAGE = https://gotify.net/
HELPURL = https://github.com/gotify/server/issues
LICENSE = MIT
CHANGELOG = "Update Gotify server to 2.8.0 and CLI to 2.3.2. Requires DSM 7.2+ (GLIBC 2.34+ dependency)."

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 7152
ADMIN_PORT = $(SERVICE_PORT)
SERVICE_PORT_TITLE = Gotify (HTTP)

POST_STRIP_TARGET = gotify_extra_install

SPK_COMMANDS = bin/gotify-cli

include ../../mk/spksrc.spk.mk

.PHONY: gotify_extra_install
gotify_extra_install:
	@install -d -m 755 $(STAGING_DIR)/var
	@install -m 644 src/environment-variables $(STAGING_DIR)/var/
