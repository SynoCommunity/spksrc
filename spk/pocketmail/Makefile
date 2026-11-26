SPK_NAME = pocketmail
SPK_VERS = 0.1.7
SPK_REV = 4
SPK_ICON = src/pocketmail.png

DEPENDS = cross/pocketmail
UNSUPPORTED_ARCHS = $(filter-out rtd1296,$(ALL_ARCHS))
REQUIRED_MIN_DSM = 7.2
OS_MIN_VER = 7.2.2-72806

MAINTAINER = yuwashme
DISPLAY_NAME = Pocketmail
DESCRIPTION = Read, write and reply to email using IMAP or the built-in webmail. Follow the setup guide to configure TLS and enable network access.
HOMEPAGE = https://pocketmail.app/
HELPURL = https://pocketmail.app/setup
LICENSE = MIT
CHANGELOG = "Initial community preview with rich-text compose and formatted paste."

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE = yes

POST_STRIP_TARGET = pocketmail_install_launcher

include ../../mk/spksrc.spk.mk

.PHONY: pocketmail_install_launcher
pocketmail_install_launcher:
	install -m 755 src/serve $(STAGING_DIR)/bin/serve
