SPK_NAME = autobrr
SPK_VERS = 1.65.0
SPK_REV = 1
SPK_ICON = src/autobrr.png

DEPENDS = cross/autobrr

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

MAINTAINER = SynoCommunity
DESCRIPTION = Modern, easy to use download automation for torrents and usenet.
DISPLAY_NAME = autobrr
CHANGELOG = "Initial package release."
HOMEPAGE = https://autobrr.com/
LICENSE = GPLv2

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE = yes

SERVICE_PORT = 7474
SERVICE_PORT_TITLE = autobrr (web ui)

POST_STRIP_TARGET = autobrr_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: autobrr_extra_install
autobrr_extra_install:
	@$(MSG) "Install config file."
	@install -m 755 -d $(STAGING_DIR)/var
	@install -m 644 src/config.toml $(STAGING_DIR)/var/
