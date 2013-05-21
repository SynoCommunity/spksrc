PKG_NAME = dnsmasq
PKG_VERS = 2.63
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.thekelleys.org.uk/dnsmasq
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PATCHES_LEVEL = 1

DEPENDS = 

PRE_CONFIGURE_TARGET = myPreConfigure

HOMEPAGE = http://www.thekelleys.org.uk/dnsmasq/doc.html
COMMENT  = Dnsmasq is a lightweight, easy to configure DNS forwarder and DHCP server.
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = 

ENV += ac_cv_func_malloc_0_nonnull=yes

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) autoreconf -i

