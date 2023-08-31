SPK_NAME = cloudflared
SPK_VERS = 2023.8.2
SPK_REV = 11
SPK_ICON = src/cloudflared.png

DEPENDS = cross/cloudflared
UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = karasevm
DISPLAY_NAME = cloudflared
DESCRIPTION = "Cloudflare Tunnel client \(formerly Argo Tunnel\)."
HOMEPAGE = https://github.com/cloudflare/cloudflared
LICENSE = Apache-2.0
CHANGELOG = "Update to 2023.8.2"

WIZARDS_DIR = src/wizard/

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

include ../../mk/spksrc.spk.mk
