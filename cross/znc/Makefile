PKG_NAME = znc
PKG_VERS = 1.9.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://znc.in/releases/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# Ensure C++17 compatibility
REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k

HOMEPAGE = https://wiki.znc.in/
COMMENT  = Advanced IRC bouncer
LICENSE  = Apache 2.0

ifeq ($(strip $(PYTHON_PACKAGE)),)
BUILD_DEPENDS = cross/python312
endif
CMAKE_ARGS = -DWANT_PYTHON=true
DEPENDS = cross/zlib

DEPENDS += cross/openssl3
CMAKE_ARGS += -DWANT_OPENSSL=true

DEPENDS += cross/libicu
CMAKE_ARGS += -DWANT_ICU=true

DEPENDS += cross/argon2
CMAKE_ARGS += -DWANT_ARGON=true

DEPENDS += cross/cyrus-sasl
CMAKE_ARGS += -DWANT_CYRUS=true

# Boost mandatory for i18n and
# can only be built from spk
ifneq ($(strip $(BOOST_BUILD_PATH)),)
CMAKE_ARGS += -DWANT_I18N=true
endif

CMAKE_ARGS += -DWANT_SYSTEMD=false
CMAKE_ARGS += -DWANT_TCL=false
CMAKE_ARGS += -DWANT_PERL=false
ifneq ($(wildcard $(OPENSSL_STAGING_PREFIX)),)
CMAKE_ARGS += -DOPENSSL_INCLUDE_DIR=$(OPENSSL_STAGING_PREFIX)/include
CMAKE_ARGS += -DOPENSSL_SSL_LIBRARY=$(OPENSSL_STAGING_PREFIX)/lib/libssl.so
CMAKE_ARGS += -DOPENSSL_CRYPTO_LIBRARY=$(OPENSSL_STAGING_PREFIX)/lib/libcrypto.so
endif

# For ZNC to build using github-action, enforce adding Python & OpenSSL include directories
ADDITIONAL_CPPFLAGS += -I$(PYTHON_STAGING_PREFIX)/include/python3.$(subst python3,,$(PYTHON_PACKAGE))
ADDITIONAL_CPPFLAGS += -I$(OPENSSL_STAGING_PREFIX)/include/openssl

ifneq ($(wildcard modules/*),)
POST_INSTALL_TARGET = znc_post_install
endif

include ../../mk/spksrc.cross-cmake.mk

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
	@$(MSG) CMAKE_BUILD_DIR: $(CMAKE_BUILD_DIR)/znc-buildmod
	@chmod +x $(CMAKE_BUILD_DIR)/znc-buildmod
	@rm -fr $(WORK_DIR)/modules
	@cp -R modules $(WORK_DIR)/
	$(RUN) sed -i 's|$(INSTALL_PREFIX)|$(STAGING_INSTALL_PREFIX)|g' $(STAGING_INSTALL_PREFIX)/share/znc/cmake/znc_internal.cmake
	@cd $(WORK_DIR)/modules && CMAKE_PREFIX_PATH=$(STAGING_INSTALL_PREFIX) $(CMAKE_BUILD_DIR)/znc-buildmod $(EXTRA_MODULES)
	$(RUN) sed -i 's|$(STAGING_INSTALL_PREFIX)|$(INSTALL_PREFIX)|g' $(STAGING_INSTALL_PREFIX)/share/znc/cmake/znc_internal.cmake
	@install -m 644 $(WORK_DIR)/modules/*.so $(STAGING_INSTALL_PREFIX)/lib/znc/
