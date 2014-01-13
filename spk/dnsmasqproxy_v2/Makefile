SPK_NAME = dnsmasqproxy
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/icon.png
BETA = 1

DEPENDS = 

MAINTAINER = DnsMasq, Packaged by SynoCommunity, RustyPixel
DESCRIPTION = Dnsmasq is a lightweight, easy to configure DNS forwarder and DHCP server.
RELOAD_UI = no
DISPLAY_NAME = DnsMasq Proxy
CHANGELOG = ""

HOMEPAGE   = http://www.thekelleys.org.uk
LICENSE    = 

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS = 

INSTALL_PREFIX = /usr/local/$(SPK_NAME)
COPY_TARGET = nop

# ARCH is not defined
override ARCH=

POST_STRIP_TARGET = dnsmasqproxy_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: dnsmasqproxy_extra_install
dnsmasqproxy_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/lease
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 755 -d $(STAGING_DIR)/sbin
	
	install -m 644 src/dnsmasq.conf $(STAGING_DIR)/etc/dnsmasq.conf

	install -m 644 src/app/config $(STAGING_DIR)/app/
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} -transparent white \
	            $(STAGING_DIR)/www/images/icon$${size}.png ; \
	done	
	
