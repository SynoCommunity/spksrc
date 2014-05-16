PKG_NAME = mysql-connector-odbc
PKG_VERS = 5.2.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-src.$(PKG_EXT)
PKG_DIST_SITE = http://cdn.mysql.com/Downloads/Connector-ODBC/5.2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)-src


DEPENDS = cross/mysql5 cross/unixODBC

HOMEPAGE = https://dev.mysql.com/
COMMENT  = 
LICENSE  =


CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall
ENV += CMAKE_INCLUDE_PATH="$(STAGING_INSTALL_PREFIX)/include" CMAKE_LIBRARY_PATH="$(STAGING_INSTALL_PREFIX)/lib"
ADDITIONAL_LDFLAGS = "-ldl"


include ../../mk/spksrc.cross-cc.mk


.PHONY: myConfigure
myConfigure:
	$(RUN) cmake CMakeLists.txt -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX) -DWITH_UNIXODBC=1 -DDL_LIBS=$(TOOLS) -DODBC_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib -DODBC_INCLUDES=$(STAGING_INSTALL_PREFIX)/include -DMYSQL_CONFIG_EXECUTABLE=$(STAGING_INSTALL_PREFIX)/bin/mysql_config -DMYSQL_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/mysql -DMYSQL_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib -DMYSQLCLIENT_LIB_NAME=libmysqlclient.so


.PHONY: myCompile
myCompile:
	$(RUN) $(MAKE)

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)