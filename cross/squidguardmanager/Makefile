PKG_NAME = squidguardmgr
PKG_VERS = 1.14
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/project/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = http://squidguardmgr.darold.net/
COMMENT  = SquidGuard Manager is a Perl CGI script used to manage SquidGuard blocklists and ACLs. It also have a GUI for SquidClamav.
LICENSE  = GNU GPL v3

CONFIGURE_TARGET = nop
COMPILE_TARGET = squidguardmgr_compile
INSTALL_TARGET = squidguardmgr_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: squidguardmgr_compile
squidguardmgr_compile: $(SRC_DIR)squid_wrapper/squid_wrapper

$(SRC_DIR)squid_wrapper/squid_wrapper:
	@$(RUN) $(CC) $(CFLAGS) -D'VERSION=$(VERSION)' -o $(SRC_DIR)squid_wrapper/squid_wrapper $(SRC_DIR)squid_wrapper/squid_wrapper.c

.PHONY: squidguardmgr_install
squidguardmgr_install:
	@$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/var/www/squidguardmgr
	@$(RUN) cp $(SRC_DIR)squid_wrapper/squid_wrapper $(STAGING_INSTALL_PREFIX)/var/www/squidguardmgr/
	@$(RUN) cp -R $(WORK_DIR)/$(PKG_DIR)/cgi-bin/* $(STAGING_INSTALL_PREFIX)/var/www/squidguardmgr/
	@$(RUN) cp -R $(WORK_DIR)/$(PKG_DIR)/htdocs/* $(STAGING_INSTALL_PREFIX)/var/www/squidguardmgr/
	@$(RUN) chmod 775 $(STAGING_INSTALL_PREFIX)/var/www/squidguardmgr/*cgi
	@$(RUN) chmod 755 $(STAGING_INSTALL_PREFIX)/var/www/squidguardmgr/squid_wrapper
	@$(RUN) sed -i 's?/usr/local/bin/squidGuard?$(INSTALL_PREFIX)/bin/squidGuard?' $(STAGING_INSTALL_PREFIX)/var/www/squidguardmgr/squidguardmgr.cgi
	@$(RUN) sed -i 's?/usr/local/squidGuard/squidguard.conf?$(INSTALL_PREFIX)/etc/squidguard.conf?' $(STAGING_INSTALL_PREFIX)/var/www/squidguardmgr/squidguardmgr.cgi
	@$(RUN) sed -i 's?/usr/bin/squidclamav?$(INSTALL_PREFIX)/libexec/squidclamav?' $(STAGING_INSTALL_PREFIX)/var/www/squidguardmgr/squidguardmgr.cgi
	@$(RUN) sed -i 's?/etc/squidclamav.conf?$(INSTALL_PREFIX)/etc/squidclamav.conf?' $(STAGING_INSTALL_PREFIX)/var/www/squidguardmgr/squidguardmgr.cgi
	@$(RUN) sed -i 's?/var/www/squidguardmgr/squid_wrapper?$(INSTALL_PREFIX)/var/www/squidguardmgr/squid_wrapper?' $(STAGING_INSTALL_PREFIX)/var/www/squidguardmgr/squidguardmgr.cgi
	@$(RUN) sed -i 's?/var/run/c-icap/c-icap.ctl?$(INSTALL_PREFIX)/var/run/c-icap/c-icap.ctl?' $(STAGING_INSTALL_PREFIX)/var/www/squidguardmgr/squidguardmgr.cgi
