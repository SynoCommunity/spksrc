SPK_NAME = vaultwarden
SPK_VERS = 1.35.2
SPK_REV = 1
SPK_ICON = src/vaultwarden.png

DEPENDS = cross/vaultwarden cross/vaultwarden_web

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)

MAINTAINER = Hylen
DESCRIPTION = Alternative implementation of the Bitwarden server API written in Rust and compatible with upstream Bitwarden clients*, perfect for self-hosted deployment where running the official resource-heavy service might not be ideal.
DISPLAY_NAME = Vaultwarden
CHANGELOG = "Initial package release with vaultwarden 1.35.2 and vaultwarden_web 2025.12.1."

HOMEPAGE = https://github.com/dani-garcia/vaultwarden
LICENSE  = GPLv3

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8180
SERVICE_PORT_TITLE = Vaultwarden
NO_SERVICE_SHORTCUT = true

WIZARDS_DIR = src/wizard/

POST_STRIP_TARGET = vaultwarden_custom_install

include ../../mk/spksrc.spk.mk

.PHONY: vaultwarden_custom_install
vaultwarden_custom_install:
	@$(MSG) "Set library runpath in vaultwarden executable."
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/vaultwarden
	@$(MSG) "Install template files for config.json and .env."
	@install -d -m 775 $(STAGING_DIR)/var
	@install -m 600 src/template.config.json $(STAGING_DIR)/var/
	@install -m 600 src/env.default $(STAGING_DIR)/var/
