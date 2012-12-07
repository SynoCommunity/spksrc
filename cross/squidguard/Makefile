PKG_NAME = squidGuard
PKG_VERS = 1.5-beta
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.squidguard.org/Downloads/Devel/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = http://www.squidguard.org/
COMMENT  = SquidGuard is a URL redirector used to use blacklists with the proxysoftware Squid.
LICENSE  = GNU PL

DESTDIR = $(INSTALL_DIR)
GNU_CONFIGURE = 1
POST_INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

CONFIGURE_ARGS  = --with-db=$(INSTALL_DIR)/$(INSTALL_PREFIX) --exec-prefix=$(INSTALL_DIR)/$(INSTALL_PREFIX) -with-sg-dbhome=$(INSTALL_DIR)/$(INSTALL_PREFIX)/var/db --with-sg-config=$(INSTALL_DIR)/$(INSTALL_PREFIX)/etc/squidguard.conf --with-sg-logdir=$(INSTALL_DIR)/$(INSTALL_PREFIX)/var/logs --with-squiduser=$(USER) -with-mysql=no --with-ldap-inc=no


.PHONY: myInstall
myInstall:
	@$(RUN) install -m 755 -d $(INSTALL_DIR)/$(INSTALL_PREFIX)/share/www/squidguardmgr/
	@$(RUN) install -m 755 samples/squidGuard.cgi $(INSTALL_DIR)/$(INSTALL_PREFIX)/share/www/squidguardmgr/



