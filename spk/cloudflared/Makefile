SPK_NAME = cloudflared
SPK_VERS = 2022.8.0
SPK_REV = 2
SPK_ICON = src/cloudflared.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)
UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = karasevm
DISPLAY_NAME = cloudflared
DESCRIPTION = Cloudflare Tunnel client (formerly Argo Tunnel).
HOMEPAGE = https://github.com/cloudflare/cloudflared
LICENSE = Apache-2.0
CHANGELOG = "Update to 2022.8.0"

WIZARDS_DIR = src/wizard/

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

include ../../mk/spksrc.spk.mk
