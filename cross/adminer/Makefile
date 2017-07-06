PKG_NAME = adminer
PKG_VERS = 4.2.5
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/vrana/adminer/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.adminer.org/
COMMENT  = Adminer is a full-featured database management tool written in PHP. Adminer is available for MySQL, PostgreSQL, SQLite, MS SQL, Oracle, Firebird, SimpleDB, Elasticsearch and MongoDB.
LICENSE  = Apache License 2.0 or GPL 2

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	(cd $(WORK_DIR)/$(PKG_DIR) && php compile.php && mv $(PKG_NAME)-$(PKG_VERS).php index.php)
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
	(cd $(WORK_DIR)/$(PKG_DIR) && wget -O $(PKG_NAME).css https://raw.githubusercontent.com/vrana/adminer/master/designs/nette/adminer.css)
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) ./index.php | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) ./$(PKG_NAME).css | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
	echo 'Order Deny,Allow\nDeny from all\nAllow from 192.168.0.0/16 172.16.0.0/12 10.0.0.0/8' > $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)/.htaccess
