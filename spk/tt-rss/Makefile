SPK_NAME = tt-rss
SPK_VERS = 20261118
SPK_REV = 22
SPK_ICON = src/tt-rss.png

DEPENDS = cross/tt-rss
override ARCH=noarch

REQUIRED_MIN_DSM = 7.2
SPK_DEPENDS = "WebStation:PHP8.4:postgresql:Apache2.4"
# SRM is not supported due lacking webstation package
REQUIRED_MIN_SRM = 3.0

MAINTAINER = moneytoo
DESCRIPTION = Tiny Tiny RSS is an open source web-based news feed \(RSS/Atom\) reader and aggregator, designed to allow you to read news from any location, while feeling as close to a real desktop application as possible.
DESCRIPTION_FRE = Tiny Tiny RSS est un agrégateur et lecteur web de flux RSS et Atom open source conçu pour vous permettre de lire des nouvelles de n\'importe quel endroit, tout en se sentant aussi proche d\'une application de bureau que possible.
DISPLAY_NAME = Tiny Tiny RSS
CHANGELOG = "Update to 2026-11-18 git snapshot (926394fa)."

HOMEPAGE = https://tt-rss.org/
LICENSE = GPL

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

ADMIN_URL = /tt-rss/

WIZARDS_TEMPLATES_DIR = src/wizard_templates
SYSTEM_GROUP = http

DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config

CONF_DIR = src/conf/

include ../../mk/spksrc.spk.mk
