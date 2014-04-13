PKG_NAME = mysql
PKG_VERS = 5.6.16
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://cdn.mysql.com/Downloads/MySQL-5.6
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)


DEPENDS = 

HOMEPAGE = https://dev.mysql.com/
COMMENT  = 
LICENSE  =


CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall
ENV += CMAKE_INCLUDE_PATH="$(STAGING_INSTALL_PREFIX)/include" CMAKE_LIBRARY_PATH="$(STAGING_INSTALL_PREFIX)/lib"

include ../../mk/spksrc.native-cc.mk

.PHONY: myConfigure
myConfigure:
	$(RUN) cmake .


.PHONY: myCompile
myCompile:
	$(RUN) $(MAKE) comp_err comp_sql gen_lex_hash gen_pfs_lex_token

.PHONY: myInstall
myInstall:
	