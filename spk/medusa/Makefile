SPK_NAME = medusa
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 2
SPK_ICON = src/medusa.png

SPK_DEPENDS = "python3>=3.5.6-8:git"

MAINTAINER = SynoCommunity
DESCRIPTION = Automatic Video Library Manager for TV Shows. It watches for new episodes of your favorite shows, and when they are posted it does its magic.
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = Medusa
CHANGELOG = "Separate service for Medusa"

HOMEPAGE   = http://pymedusa.com
LICENSE    = GPL

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8081
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

COPY_TARGET = nop
POST_STRIP_TARGET = medusa-custom_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: medusa-custom_extra_install
medusa-custom_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
