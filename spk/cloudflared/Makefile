SPK_NAME = cloudflared
SPK_VERS = 2024.1.5
SPK_REV = 11
SPK_ICON = src/cloudflared.png

DEPENDS = cross/cloudflared
UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = karasevm
DISPLAY_NAME = cloudflared
DESCRIPTION = "Cloudflare Tunnel client \(formerly Argo Tunnel\)."
HOMEPAGE = https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/
LICENSE = Apache-2.0
CHANGELOG = "Update to 2024.1.5"

WIZARDS_DIR = src/wizard/

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

include ../../mk/spksrc.spk.mk
