SPK_NAME = rustdesk-server
SPK_VERS = 1.1.15
SPK_REV = 1
SPK_ICON = src/rustdesk-server.png

DEPENDS = cross/rustdesk-server

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv7L_ARCHS) $(ARMv5_ARCHS)

MAINTAINER = SynoCommunity
DESCRIPTION = RustDesk Server provides self-hosted relay and rendezvous services for RustDesk remote desktop clients. An open-source alternative to TeamViewer or AnyDesk server infrastructure.
DISPLAY_NAME = RustDesk Server
CHANGELOG = Initial release of RustDesk Server 1.1.15

HOMEPAGE = https://rustdesk.com/
LICENSE  = AGPL-3.0

# Service configuration
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE = yes
WIZARDS_DIR = src/wizard

# RustDesk default ports:
# 21115 (TCP) - NAT type test
# 21116 (TCP+UDP) - ID/Rendezvous server
# 21117 (TCP) - Relay server
# 21118 (TCP) - WebSocket for web clients
FWPORTS = src/rustdesk-server.sc

# Minimum DSM version
SPK_MIN_DSM = 6.0

include ../../mk/spksrc.spk.mk
