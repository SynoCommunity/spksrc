SPK_NAME = vaultwarden
SPK_VERS = 1.25.2
SPK_REV = 1
SPK_ICON = src/vaultwarden.png

DEPENDS = cross/vaultwarden cross/vaultwarden_web

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS)

MAINTAINER = Hylen
DESCRIPTION = Alternative implementation of the Bitwarden server API written in Rust and compatible with upstream Bitwarden clients*, perfect for self-hosted deployment where running the official resource-heavy service might not be ideal.
STARTABLE = yes
DISPLAY_NAME = vaultwarden

HOMEPAGE = https://github.com/dani-garcia/vaultwarden
LICENSE  = GPLv3

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8180
SERVICE_PORT_TITLE = vaultwarden web
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

POST_STRIP_TARGET = vaultwarden_custom_install

include ../../mk/spksrc.spk.mk

.PHONY: vaultwarden_custom_install
# Set library path to find shared libraries and install template files
vaultwarden_custom_install:
	@$(MSG) "Set library runpath in vaultwarden executable."
	@sudo apt-get update 
	@sudo apt-get install -y patchelf
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/vaultwarden
	@$(MSG) "Install template files for config.json and .env."
	@install -d -m 775 $(STAGING_DIR)/var
	@install -m 600 src/template.config.json $(STAGING_DIR)/var/
	@install -m 600 src/env.default $(STAGING_DIR)/var/
