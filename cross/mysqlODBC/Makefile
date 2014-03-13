PKG_NAME = mysql-connector-odbc
PKG_VERS = 3.51.30
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-src.$(PKG_EXT)
PKG_DIST_SITE = https://dev.mysql.com/get/Downloads/Connector-ODBC/3.51
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)-src


DEPENDS = cross/mysql cross/unixODBC

HOMEPAGE = https://dev.mysql.com
COMMENT  = 
LICENSE  =


GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-mysql-path=$(STAGING_INSTALL_PREFIX) --with-unixODBC=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk