PKG_NAME = minetest
PKG_NAME_GAME = minetest_game
PKG_NAME_IRRLICHT = irrlicht

# Make sure this versions are different, otherwise the scrip will not work
PKG_VERS = 5.0.1
PKG_VERS_GAME = 5.0.1
PKG_VERS_IRRLICHT = 1.7.3

PKG_EXT = zip
PKG_EXT_GAME = tar.gz
PKG_EXT_IRRLICHT = zip

# The package name is not included into file to download
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_NAME_GAME = $(PKG_VERS_GAME).$(PKG_EXT_GAME)
PKG_DIST_NAME_IRRLICHT = $(PKG_NAME_IRRLICHT)-$(PKG_VERS_IRRLICHT).$(PKG_EXT_IRRLICHT)

PKG_DIST_SITE = https://github.com/minetest/minetest/archive/
PKG_DIST_SITE_GAME = https://github.com/minetest/minetest_game/archive/
PKG_DIST_SITE_IRRLICHT = http://downloads.sourceforge.net/irrlicht

PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIR_GAME = $(PKG_NAME_GAME)-$(PKG_VERS_GAME)
PKG_DIR_IRRLICHT = $(PKG_NAME_IRRLICHT)-$(PKG_VERS_IRRLICHT)

BUILD_DEPENDS = cross/sqlite cross/curl

HOMEPAGE = https://www.minetest.net/
COMMENT  = An open source voxel game engine. Play one of our many games, mod a game to your liking, make your own game, or play on a multiplayer server. 
LICENSE  = GPLv2/GPLv3

POST_EXTRACT_TARGET = minetest-post-extract
CONFIGURE_TARGET = minetest-configure
INSTALL_TARGET = minetest-install

include ../../mk/spksrc.cross-cc.mk

URLS = $(PKG_DIST_SITE)/$(PKG_DIST_NAME) $(PKG_DIST_SITE_GAME)/$(PKG_DIST_NAME_GAME) $(PKG_DIST_SITE_IRRLICHT)/$(PKG_DIST_NAME_IRRLICHT)

.PHONY: minetest-post-extract

minetest-post-extract:
	@$(MSG) "Minetest post-extract for $(NAME)"
	tar -xvf $(DISTRIB_DIR)/$(PKG_DIST_NAME_GAME) -C $(EXTRACT_PATH)/$(PKG_DIR)/games
	mv $(EXTRACT_PATH)/$(PKG_DIR)/games/$(PKG_DIR_GAME) $(EXTRACT_PATH)/$(PKG_DIR)/games/$(PKG_NAME_GAME)
	unzip $(DISTRIB_DIR)/$(PKG_DIST_NAME_IRRLICHT) -d $(EXTRACT_PATH)/$(PKG_DIR)/lib
	mv $(EXTRACT_PATH)/$(PKG_DIR)/lib/$(PKG_DIR_IRRLICHT) $(EXTRACT_PATH)/$(PKG_DIR)/lib/$(PKG_NAME_IRRLICHT)

.PHONY: minetest-configure

minetest-configure:
	@$(MSG) "Minetest configure for $(NAME)"
	$(RUN) cmake -DRUN_IN_PLACE=FALSE -DBUILD_SERVER=TRUE -DBUILD_CLIENT=FALSE -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX) \
	-DCURL_INCLUDE_DIR=$(INSTALL_DIR)/$(INSTALL_PREFIX)/include -DCURL_LIBRARY=$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/libcurl.a \
	-DSQLITE3_INCLUDE_DIR=$(INSTALL_DIR)/$(INSTALL_PREFIX)/include -DSQLITE3_LIBRARY=$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/libsqlite3.a \
	-DZLIB_INCLUDE_DIR=$(INSTALL_DIR)/$(INSTALL_PREFIX)/include -DZLIB_LIBRARY=$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/libz.a \
	-DIRRLICHT_SOURCE_DIR=lib/$(PKG_NAME_IRRLICHT)

#	-DOPENSSL_SSL_LIBRARY=../install/var/packages/target/lib/libssl.so -DOPENSSL_CRYPTO_LIBRARY=../install/var/packages/target/lib/libcrypto.so

.PHONY: minetest-install

minetest-install:
	@$(MSG) "Minetest install for $(NAME)"
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX)
