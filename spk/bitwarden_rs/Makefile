SPK_NAME = bitwarden_rs
SPK_VERS = 1.13.1
SPK_REV = 0
# There's no icon!
# SPK_ICON = src/bitwarden_rs.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = Hylen
DESCRIPTION =  A Bitwarden server API implementation written in Rust compatible with upstream Bitwarden clients*, perfect for self-hosted deployment where running the official resource-heavy service might not be ideal.
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = BitwardenRS

HOMEPAGE = https://github.com/dani-garcia/bitwarden_rs
LICENSE  = GPLv3

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
# TODO: What to put here?
SERVICE_PORT = 38529
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

include ../../mk/spksrc.spk.mk
