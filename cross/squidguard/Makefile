PKG_NAME = squidguard
PKG_VERS = 1.6.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).orig.$(PKG_EXT)
PKG_DIST_SITE = http://deb.debian.org/debian/pool/main/s/squidguard
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
# http://dsi.ut-capitole.fr/blacklists/index_en.php
DB_FILE= ftp://ftp.ut-capitole.fr/pub/reseau/cache/squidguard_contrib/blacklists.tar.gz
DEPENDS = 

HOMEPAGE = http://www.squidguard.org/
COMMENT  = SquidGuard is a URL redirector used to use blacklists with the proxysoftware Squid.
LICENSE  = GPL

DESTDIR = $(INSTALL_DIR)
GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = squidguard_pre_configure
INSTALL_TARGET = squidguard_install
POST_INSTALL_TARGET = squidguard_post_install

include ../../mk/spksrc.cross-cc.mk

CONFIGURE_ARGS = --with-db=$(INSTALL_DIR)/$(INSTALL_PREFIX)
#CONFIGURE_ARGS += --exec-prefix=$(INSTALL_DIR)/$(INSTALL_PREFIX)
CONFIGURE_ARGS += --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += -with-sg-dbhome=$(INSTALL_DIR)/$(INSTALL_PREFIX)/var/db
CONFIGURE_ARGS += --with-sg-config=$(INSTALL_DIR)/$(INSTALL_PREFIX)/etc/squidguard.conf
CONFIGURE_ARGS += --with-sg-logdir=$(INSTALL_DIR)/$(INSTALL_PREFIX)/var/logs
CONFIGURE_ARGS += --with-squiduser=$(USER)
CONFIGURE_ARGS += -with-mysql=no
CONFIGURE_ARGS += --with-ldap-inc=no

.PHONY: squidguard_pre_configure
squidguard_pre_configure:
	$(RUN) NOCONFIGURE=1 ./autogen.sh

.PHONY: squidguard_install
squidguard_install:
	$(RUN) DESTDIR=$(INSTALL_DIR) $(MAKE) install

.PHONY: squidguard_post_install
squidguard_post_install:
	@$(RUN) install -m 755 -d $(INSTALL_DIR)/$(INSTALL_PREFIX)/var/db
	@$(RUN) wget $(DB_FILE) -O $(INSTALL_DIR)/$(INSTALL_PREFIX)/var/db/blacklists.tar.gz
	@$(RUN) tar xvzf $(INSTALL_DIR)/$(INSTALL_PREFIX)/var/db/blacklists.tar.gz -C $(INSTALL_DIR)/$(INSTALL_PREFIX)/var/db
	@$(RUN) cp -R $(INSTALL_DIR)/$(INSTALL_PREFIX)/var/db/blacklists/* $(INSTALL_DIR)/$(INSTALL_PREFIX)/var/db/
	@$(RUN) rm -Rf $(INSTALL_DIR)/$(INSTALL_PREFIX)/var/db/blacklists*
	@$(RUN) install -m 755 -d $(INSTALL_DIR)/$(INSTALL_PREFIX)/share/www/squidguardmgr/
