SPK_NAME = tinyproxy
SPK_VERS = 1.8.3
SPK_REV = 1
SPK_ICON = src/tinyproxy.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = tinyproxy - a light-weight HTTP/HTTPS proxy daemon for POSIX operating systems
DESCRIPTION_FRE = tinyproxy - un proxy HTTP/HTTPS légé pour les systèmes d\\\'exploitation POSIX
RELOAD_UI = no
DISPLAY_NAME = tinyproxy

HOMEPAGE   = https://tinyproxy.github.io/
LICENSE    = GPLv2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)
POST_STRIP_TARGET = tinyproxy_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: tinyproxy_extra_install
tinyproxy_extra_install:
	install -m 755 -o nobody -d $(STAGING_DIR)/var
	install -m 644 src/tinyproxy.conf $(STAGING_DIR)/var/tinyproxy.conf
	install -m 644 src/filter.conf $(STAGING_DIR)/var/filter.conf
