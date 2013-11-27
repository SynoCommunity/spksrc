PKG_NAME = dnsmasq
PKG_VERS = 2.67
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.thekelleys.org.uk/dnsmasq
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)


DEPENDS = 

HOMEPAGE = http://www.thekelleys.org.uk
COMMENT  = Dnsmasq is a lightweight, easy to configure DNS forwarder and DHCP server.
LICENSE  =

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)