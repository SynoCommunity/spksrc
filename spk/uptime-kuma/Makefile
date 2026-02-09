SPK_NAME = uptime-kuma
SPK_VERS = 2.1.0
SPK_REV = 1
SPK_ICON = src/uptime-kuma.png

DEPENDS = cross/uptime-kuma
BUILD_DEPENDS = native/nodejs_22
SPK_DEPENDS = "Node.js_v22"

MAINTAINER = efren-builder
MAINTAINER_URL = https://efren.me

DISPLAY_NAME = Uptime Kuma
DESCRIPTION = A self-hosted monitoring tool. Monitor HTTP\(s\), TCP, Ping, DNS, Docker containers, game servers, and more with 87+ notification providers.
HOMEPAGE = https://uptime.kuma.pet
LICENSE = MIT
CHANGELOG = "Initial package release. Uptime Kuma v2.1.0."

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

SERVICE_PORT = 3001
SERVICE_PORT_TITLE = Uptime Kuma (HTTP)

ADMIN_PORT = $(SERVICE_PORT)
ADMIN_PROTOCOL = http
ADMIN_URL = /

WIZARDS_DIR = src/wizard/
CONF_DIR = src/conf

OS_MIN_VER = 7.0-40000

POST_STRIP_TARGET = uptime_kuma_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: uptime_kuma_extra_install
uptime_kuma_extra_install:
	@$(MSG) "Installing Uptime Kuma service configuration"
	@install -d $(STAGING_DIR)/app
	@install -m 644 src/app/uptime-kuma.sc $(STAGING_DIR)/app/uptime-kuma.sc
