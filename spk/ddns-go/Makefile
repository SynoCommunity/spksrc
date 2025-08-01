SPK_NAME = ddns-go
SPK_VERS = 6.12.1
SPK_REV = 1
SPK_ICON = src/ddns-go.png

DEPENDS = cross/ddns-go

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS)
# not supported by go:
UNSUPPORTED_ARCHS += $(PPC_ARCHS)

MAINTAINER = GrandDuke1106
DESCRIPTION = Automatically obtain your public IPv4 or IPv6 address and resolve it to the corresponding domain name service.
DISPLAY_NAME = ddns-go
CHANGELOG = "Initial package release."

HOMEPAGE = https://github.com/jeessy2/ddns-go
LICENSE = MIT

SERVICE_SETUP = src/service-setup.sh

STARTABLE = yes
SERVICE_USER = auto
SERVICE_PORT = 9876
ADMIN_PORT = $(SERVICE_PORT)

include ../../mk/spksrc.spk.mk
