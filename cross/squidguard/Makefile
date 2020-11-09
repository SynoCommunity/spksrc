PKG_NAME = squidGuard
PKG_VERS = 1.5-beta
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://fossies.org/linux/www/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
DB_FILE= ftp://ftp.univ-tlse1.fr/pub/reseau/cache/squidguard_contrib/blacklists.tar.gz
DEPENDS = 

# original url: http://www.squidguard.org/Downloads/Devel/squidGuard-1.5-beta.tar.gz
# squidguard.org is not reachable anymore! alternate mirrors (as of 2019.03.):
# https://fossies.org/linux/www/squidGuard-1.5-beta.tar.gz

HOMEPAGE = http://www.squidguard.org/
COMMENT  = SquidGuard is a URL redirector used to use blacklists with the proxysoftware Squid.
LICENSE  = GPL

DESTDIR = $(INSTALL_DIR)
GNU_CONFIGURE = 1
POST_INSTALL_TARGET = squidguard_post_install

include ../../mk/spksrc.cross-cc.mk

CONFIGURE_ARGS = --with-db=$(INSTALL_DIR)/$(INSTALL_PREFIX)
CONFIGURE_ARGS += --exec-prefix=$(INSTALL_DIR)/$(INSTALL_PREFIX)
CONFIGURE_ARGS += -with-sg-dbhome=$(INSTALL_DIR)/$(INSTALL_PREFIX)/var/db
CONFIGURE_ARGS += --with-sg-config=$(INSTALL_DIR)/$(INSTALL_PREFIX)/etc/squidguard.conf
CONFIGURE_ARGS += --with-sg-logdir=$(INSTALL_DIR)/$(INSTALL_PREFIX)/var/logs
CONFIGURE_ARGS += --with-squiduser=$(USER)
CONFIGURE_ARGS += -with-mysql=no
CONFIGURE_ARGS += --with-ldap-inc=no

.PHONY: squidguard_post_install
squidguard_post_install:
	@$(RUN) install -m 755 -d $(INSTALL_DIR)/$(INSTALL_PREFIX)/var/db
	@$(RUN) wget $(DB_FILE) -O $(INSTALL_DIR)/$(INSTALL_PREFIX)/var/db/blacklists.tar.gz
	@$(RUN) tar xvzf $(INSTALL_DIR)/$(INSTALL_PREFIX)/var/db/blacklists.tar.gz -C $(INSTALL_DIR)/$(INSTALL_PREFIX)/var/db
	@$(RUN) cp -R $(INSTALL_DIR)/$(INSTALL_PREFIX)/var/db/blacklists/* $(INSTALL_DIR)/$(INSTALL_PREFIX)/var/db/
	@$(RUN) rm -Rf $(INSTALL_DIR)/$(INSTALL_PREFIX)/var/db/blacklists*
	@$(RUN) install -m 755 -d $(INSTALL_DIR)/$(INSTALL_PREFIX)/share/www/squidguardmgr/
