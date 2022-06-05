PKG_NAME = znc
PKG_VERS = 1.8.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://znc.in/releases/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = cross/python310
DEPENDS = cross/openssl cross/libicu

# configure: No compiler with C++11 support was found
# error: Upgrade your compiler. GCC 4.8+ and Clang 3.2+ are known to work.
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

HOMEPAGE = https://wiki.znc.in/
COMMENT  = Advanced IRC bouncer
LICENSE  = Apache 2.0

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-python

ifneq ($(wildcard modules/*),)
POST_INSTALL_TARGET = znc_post_install
endif

include ../../mk/spksrc.cross-cc.mk

EXTRA_MODULES  = colloquy.cpp
EXTRA_MODULES += identd.cpp
EXTRA_MODULES += palaver.cpp
EXTRA_MODULES += playback.cpp
EXTRA_MODULES += privmsg.cpp
ifneq ($(findstring $(ARCH), $(ARMv7L_ARCHS)),$(ARCH))
EXTRA_MODULES += push.cpp
else
PLIST_TRANSFORM = sed -e '/:lib\/znc\/push.so/d'
endif
EXTRA_MODULES += clientbuffer.cpp


# The following extra modules are stored in cross/znc/modules and are built via the znc-buildmod command.
# Adapt as needed (-O is used to overwrite existing files, and to rename to *.cpp where needed).
# call "make znc_update_modules" in cross/znc folder to get the latest versions.
.PHONY: znc_update_modules
znc_update_modules:
	wget -O modules/colloquy.cpp      https://raw.githubusercontent.com/colloquy/colloquypush/master/znc/colloquy.cpp
	wget -O modules/identd.cpp        https://raw.githubusercontent.com/cynix/znc-identd/master/identd.cc
	wget -O modules/palaver.cpp       https://raw.githubusercontent.com/cocodelabs/znc-palaver/master/palaver.cpp
	wget -O modules/playback.cpp      https://raw.githubusercontent.com/jpnurmi/znc-playback/master/playback.cpp
	wget -O modules/privmsg.cpp       https://raw.githubusercontent.com/kylef/znc-contrib/master/privmsg.cpp
	wget -O modules/push.cpp          https://raw.githubusercontent.com/jreese/znc-push/master/push.cpp
	wget -O modules/clientbuffer.cpp  https://raw.githubusercontent.com/CyberShadow/znc-clientbuffer/master/clientbuffer.cpp

.PHONY: znc_post_install
znc_post_install:
	@$(MSG) "Building extra modules"
	@chmod +x $(WORK_DIR)/$(PKG_DIR)/znc-buildmod
	@rm -fr $(WORK_DIR)/modules
	@cp -R modules $(WORK_DIR)/
	@cd $(WORK_DIR)/modules && PATH=$(WORK_DIR)/$(PKG_DIR) INCLUDES=-I$(STAGING_INSTALL_PREFIX)/include/znc prefix=$(STAGING_INSTALL_PREFIX) znc-buildmod $(EXTRA_MODULES)
	@install -m 644 $(WORK_DIR)/modules/*.so $(STAGING_INSTALL_PREFIX)/lib/znc/
