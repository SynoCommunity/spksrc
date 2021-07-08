PKG_NAME = dnsmasq
PKG_VERS = 2.85
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://thekelleys.org.uk/dnsmasq
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://thekelleys.org.uk/dnsmasq/doc.html
COMMENT  = A lightweight, caching DNS proxy with integrated DHCP server. 
LICENSE  = GPLv2/GPLv3

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = dnsmasq_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: dnsmasq_install
dnsmasq_install:
	$(RUN) $(MAKE) DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX) install
