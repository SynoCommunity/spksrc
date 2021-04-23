PKG_NAME = adminer
PKG_VERS = 4.8.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/vrana/adminer/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.adminer.org/
COMMENT  = Adminer is a full-featured database management tool written in PHP. Adminer is available for MySQL, PostgreSQL, SQLite, MS SQL, Oracle, Firebird, SimpleDB, Elasticsearch and MongoDB.
LICENSE  = Apache License 2.0 or GPL 2

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = adminer_install

# previous used design "nette" does not contain changes since Adminer 4.6.x
PKG_DESIGN = rmsoft_blue

# Option to install all design files
# To use a different design manually overwrite adminer.css 
# on the target system by one found in the designs sub folders
INSTALL_DESIGNS = 0


include ../../mk/spksrc.cross-cc.mk

.PHONY: adminer_install
adminer_install:
	(cd $(WORK_DIR)/$(PKG_DIR) && php compile.php && mv $(PKG_NAME)-$(PKG_VERS).php index.php)
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/web
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/index.php $(STAGING_INSTALL_PREFIX)/web
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/designs/$(PKG_DESIGN)/adminer.css $(STAGING_INSTALL_PREFIX)/web
	@if [ "$(INSTALL_DESIGNS)" = "1" ]; \
	then \
		$(MSG) "Install design files" ; \
		tar -cf - -C $(WORK_DIR)/$(PKG_DIR) ./designs | tar -xf - -C $(STAGING_INSTALL_PREFIX)/web ; \
	fi
