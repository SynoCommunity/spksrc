SPK_NAME = dnscrypt
SPK_VERS = 1.9.5
SPK_REV = 1
SPK_ICON = src/dnscrypt.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = cytec
DESCRIPTION = DNSCrypt is a protocol that authenticates communications between a DNS client and a DNS resolver. It prevents DNS spoofing.
RELOAD_UI = no
DISPLAY_NAME = DNSCrypt
STARTABLE = no
CHANGELOG = "Initial release"
BETA = 1

HOMEPAGE   = https://dnscrypt.org/
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = dnscrypt_extra_install

include ../../mk/spksrc.spk.mk


.PHONY: dnscrypt_extra_install
dnscrypt_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 $(STAGING_DIR)/etc/dnscrypt-proxy.conf $(STAGING_DIR)/var/
