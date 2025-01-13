SPK_NAME = cloudflared
SPK_VERS = 2025.1.0
SPK_REV = 16
SPK_ICON = src/cloudflared.png

DEPENDS = cross/cloudflared
UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = karasevm
DISPLAY_NAME = Cloudflare Tunnel
DESCRIPTION = "Cloudflare Tunnel provides you with a secure way to connect your resources to Cloudflare without a publicly routable IP address. With Tunnel, you do not send traffic to an external IP - instead, a lightweight daemon in your infrastructure \('cloudflared'\) creates outbound-only connections to Cloudflare\'s global network. Cloudflare Tunnel can connect HTTP web servers, SSH servers, remote desktops, and other protocols safely to Cloudflare. This way, your origins can serve traffic through Cloudflare without being vulnerable to attacks that bypass Cloudflare."
HOMEPAGE = https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/
LICENSE = Apache-2.0
CHANGELOG = "Update to v2025.1.0"

WIZARDS_DIR = src/wizard/

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

POST_STRIP_TARGET = cloudflared_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: cloudflared_extra_install
cloudflared_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/config.yml $(STAGING_DIR)/var/config.yml
