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
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	@$(RUN) sed -e 's/ac_run() {/ac_run() { return 0/g' -i configure.lib

.PHONY: myCompile
myCompile:
	$(RUN) $(MAKE) shared

.PHONY: myInstall
myInstall:
	@$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/bin/
	@$(RUN) cp dnsget_s $(STAGING_INSTALL_PREFIX)/bin/dnsget
	@$(RUN) cp ex-rdns_s $(STAGING_INSTALL_PREFIX)/bin/ex-rdns
	@$(RUN) cp rblcheck_s $(STAGING_INSTALL_PREFIX)/bin/rblcheck
	@$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/lib/
	@$(RUN) cp libudns.so.0 $(STAGING_INSTALL_PREFIX)/lib/
	ln -sf libudns.so.0 $(STAGING_INSTALL_PREFIX)/lib/libudns.so
	@$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/include/
	@$(RUN) cp udns.h $(STAGING_INSTALL_PREFIX)/include/
