SPK_NAME = dnsmasqproxy
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/icon.png
BETA = 1

DEPENDS  = cross/syslinux

MAINTAINER = SynoCommunity
DESCRIPTION = Dnsmasqproxy uses Dnsmasq that creates a proxy environment for use synology tftp/pxe boot server. This is useful when you already have a router/dhcp server already running on your network.
RELOAD_UI = no
DISPLAY_NAME = DnsMasq Proxy
CHANGELOG = "Initial release"

HOMEPAGE   = http://www.thekelleys.org.uk
LICENSE    = 

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)
COPY_TARGET = nop

POST_STRIP_TARGET = dnsmasqproxy_extra_install

# Pure PHP package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: dnsmasqproxy_extra_install
dnsmasqproxy_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/lease
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 755 -d $(STAGING_DIR)/sbin
	install -m 755 -d $(STAGING_DIR)/share/pxelinux.cfg
	install -m 755 -d $(STAGING_DIR)/share/ISO
	install -m 755 -d $(STAGING_DIR)/share/NONISO
	install -m 755 -d $(STAGING_DIR)/share/memtest

	install -m 644 src/dnsmasq.conf $(STAGING_DIR)/etc/dnsmasq.conf
	install -m 644 src/default $(STAGING_DIR)/share/pxelinux.cfg/default
	install -m 644 src/bg.legacy.png $(STAGING_DIR)/share/bg.legacy.png

	install -m 644 $(WORK_DIR)/install$(INSTALL_PREFIX)/share/syslinux/com32/menu/vesamenu.c32 $(STAGING_DIR)/share
	install -m 644 $(WORK_DIR)/install$(INSTALL_PREFIX)/share/syslinux/core/pxelinux.0 $(STAGING_DIR)/share
	install -m 644 $(WORK_DIR)/install$(INSTALL_PREFIX)/share/syslinux/memdisk/memdisk $(STAGING_DIR)/share

