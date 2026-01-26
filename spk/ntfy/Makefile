SPK_NAME = ntfy
SPK_VERS = 2.16.0
SPK_REV = 1
SPK_ICON = src/ntfy.png

DEPENDS = cross/ntfy

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS)

MAINTAINER = hgy59
DISPLAY_NAME = ntfy
DESCRIPTION = Send push notifications to your phone or desktop using PUT/POST.
HOMEPAGE = https://ntfy.sh/
LICENSE  = Apache-2.0 and GPLv2
CHANGELOG = "Initial package release."

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8094
# There is no web app on service port:
NO_SERVICE_SHORTCUT = true

SPK_COMMANDS = bin/ntfy

POST_STRIP_TARGET = ntfy_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: ntfy_extra_install
ntfy_extra_install:
	@$(MSG) Install config file
	@install -d $(STAGING_DIR)/var
	@install -m 644 src/server.yml $(STAGING_DIR)/var/server.yml
