SPK_NAME = dnscrypt-proxy
SPK_VERS = 2.0.9b1
SPK_REV = 0
SPK_ICON = src/dnscrypt-proxy.png

UNSUPPORTED_ARCHS = $(PPC_ARCHES)

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = publicarray
DESCRIPTION = A flexible DNS proxy, with support for modern encrypted DNS protocols such as DNSCrypt v2 and DNS-over-HTTP/2. <https://github.com/jedisct1/dnscrypt-proxy>
DISPLAY_NAME = DNSCrypt-proxy
HOMEPAGE = https://github.com/jedisct1/dnscrypt-proxy
LICENSE = ISC
CHANGELOG = "New version 2 of dnscrypt-proxy"

RELOAD_UI = no
STARTABLE = yes
BETA = 1

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
# SERVICE_PORT = 10053
# SERVICE_PORT_TITLE = DNS
# NO_SERVICE_SHORTCUT = yes

include ../../mk/spksrc.spk.mk
