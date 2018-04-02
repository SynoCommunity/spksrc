SPK_NAME = dnscrypt-proxy
SPK_VERS = 2.0.8
SPK_REV = 0
SPK_ICON = src/dnscrypt-proxy.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = publicarray
DESCRIPTION = A flexible DNS proxy, with support for modern encrypted DNS protocols such as DNSCrypt v2 and DNS-over-HTTP/2. <https://github.com/jedisct1/dnscrypt-proxy>

RELOAD_UI = no
DISPLAY_NAME = DNSCrypt-proxy
STARTABLE = no
CHANGELOG = "New version 2 of dnscrypt-proxy"
BETA = 1

HOMEPAGE   = https://github.com/jedisct1/dnscrypt-proxy
LICENSE    = ISC License

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk
