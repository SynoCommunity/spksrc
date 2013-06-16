PKG_NAME = udns
PKG_VERS = 0.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.corpit.ru/mjt/udns/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = http://www.corpit.ru/mjt/udns.html
COMMENT  = UDNS is a stub DNS resolver library with ability to perform both syncronous and asyncronous DNS queries. 
LICENSE  = LGPL

PRE_CONFIGURE_TARGET = myPreConfigure
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	@$(RUN) sed -e 's/ac_run() {/ac_run() { return 0/g' -i configure.lib

.PHONY: myInstall
myInstall:
	@$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/bin/
	@$(RUN) cp dnsget $(STAGING_INSTALL_PREFIX)/bin/
	@$(RUN) cp ex-rdns $(STAGING_INSTALL_PREFIX)/bin/
	@$(RUN) cp rblcheck $(STAGING_INSTALL_PREFIX)/bin/
	@$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/lib/
	@$(RUN) cp libudns.a $(STAGING_INSTALL_PREFIX)/lib/
	@$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/include/
	@$(RUN) cp udns.h $(STAGING_INSTALL_PREFIX)/include/
