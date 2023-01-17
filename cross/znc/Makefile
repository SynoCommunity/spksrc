PKG_NAME = znc
PKG_VERS = 1.7.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://znc.in/releases/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl

HOMEPAGE = http://wiki.znc.in/
COMMENT  = Advanced IRC bouncer
LICENSE  = Apache License 2.0

GNU_CONFIGURE = 1
ifneq ($(wildcard modules/*),)
POST_INSTALL_TARGET = myPostInstall
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPostInstall
myPostInstall:
	# The following extra modules are stored in cross/znc/modules and are built via the znc-buildmod command. Adapt as needed.
	# wget https://raw.githubusercontent.com/colloquy/colloquypush/master/znc/colloquy.cpp
	# wget -O identd.cpp https://raw.githubusercontent.com/cynix/znc-identd/master/identd.cc
	# wget https://raw.githubusercontent.com/cocodelabs/znc-palaver/master/palaver.cpp
	# wget https://raw.githubusercontent.com/jpnurmi/znc-playback/master/playback.cpp
	# wget https://raw.githubusercontent.com/kylef/znc-contrib/master/privmsg.cpp
	# wget https://raw.githubusercontent.com/jreese/znc-push/master/push.cpp
	@$(MSG) "Building extra modules"
	@chmod +x $(WORK_DIR)/$(PKG_DIR)/znc-buildmod
	@rm -fr $(WORK_DIR)/modules
	@cp -R modules $(WORK_DIR)/
	@cd $(WORK_DIR)/modules && PATH=$(WORK_DIR)/$(PKG_DIR) INCLUDES=-I$(STAGING_INSTALL_PREFIX)/include/znc prefix=$(STAGING_INSTALL_PREFIX) znc-buildmod $(WORK_DIR)/modules/*.cpp
	@install -m 644 $(WORK_DIR)/modules/*.so $(STAGING_INSTALL_PREFIX)/lib/znc/
