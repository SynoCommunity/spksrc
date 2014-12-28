PKG_NAME = mysql
PKG_VERS = 5.6.16
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://cdn.mysql.com/Downloads/MySQL-5.6
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = native/mysql5 cross/ncurses

HOMEPAGE = 
COMMENT  = 
LICENSE  =

PRE_CONFIGURE_TARGET = myPreConfigure
CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall
ENV += CMAKE_INCLUDE_PATH="$(STAGING_INSTALL_PREFIX)/include" CMAKE_LIBRARY_PATH="$(STAGING_INSTALL_PREFIX)/lib"

include ../../mk/spksrc.cross-cc.mk


.PHONY: myPreConfigure
myPreConfigure:
	sed -i -e "s|COMMAND comp_err|COMMAND $(WORK_DIR)/../../../native/mysql5/work-native/$(PKG_DIR)/extra/comp_err|g" $(WORK_DIR)/$(PKG_DIR)/extra/CMakeLists.txt	
	sed -i -e "s|COMMAND comp_sql|COMMAND $(WORK_DIR)/../../../native/mysql5/work-native/$(PKG_DIR)/scripts/comp_sql|g" $(WORK_DIR)/$(PKG_DIR)/scripts/CMakeLists.txt

	ln -s $(WORK_DIR)/../../../native/mysql5/work-native/$(PKG_DIR)/sql/gen_lex_hash $(WORK_DIR)/$(PKG_DIR)/sql/gen_lex_hash
	ln -s $(WORK_DIR)/../../../native/mysql5/work-native/$(PKG_DIR)/storage/perfschema/gen_pfs_lex_token $(WORK_DIR)/$(PKG_DIR)/storage/perfschema/gen_pfs_lex_token

	sed -i '456i\ADD_SUBDIRECTORY(scripts)' $(WORK_DIR)/$(PKG_DIR)/CMakeLists.txt


.PHONY: myConfigure
myConfigure:
	$(RUN) cmake CMakeLists.txt -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX) -DWITHOUT_SERVER=ON -DWITH_UNIT_TESTS=OFF
	
.PHONY: myCompile
myCompile:
	$(RUN) $(MAKE)

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)