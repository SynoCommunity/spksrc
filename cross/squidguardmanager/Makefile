PKG_NAME = squidguardmgr
PKG_VERS = 1.11
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = http://squidguardmgr.darold.net/
COMMENT  = SquidGuard Manager is a Perl CGI script used to manage SquidGuard blocklists and ACLs. It also have a GUI for SquidClamav.
LICENSE  = GNU GPL v3

CONFIGURE_TARGET = nop
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myCompile
myCompile: $(SRC_DIR)squid_wrapper/squid_wrapper

$(SRC_DIR)squid_wrapper/squid_wrapper:
	@$(RUN) $(CC) $(CFLAGS) -D'VERSION=$(VERSION)' -o $(SRC_DIR)squid_wrapper/squid_wrapper $(SRC_DIR)squid_wrapper/squid_wrapper.c

.PHONY: myInstall
myInstall:
	@$(RUN) mkdir -p $(WORK_DIR)/install/$(INSTALL_PREFIX)/share/www/squidguardmgr
	@$(RUN) cp $(SRC_DIR)squid_wrapper/squid_wrapper $(WORK_DIR)/install/$(INSTALL_PREFIX)/share/www/squidguardmgr/
	@$(RUN) cp -R $(WORK_DIR)/$(PKG_DIR)/cgi-bin/* $(WORK_DIR)/install/$(INSTALL_PREFIX)/share/www/squidguardmgr/
	@$(RUN) cp -R $(WORK_DIR)/$(PKG_DIR)/htdocs/* $(WORK_DIR)/install/$(INSTALL_PREFIX)/share/www/squidguardmgr/
	@$(RUN) chmod 775 $(WORK_DIR)/install/$(INSTALL_PREFIX)/share/www/squidguardmgr/*cgi
