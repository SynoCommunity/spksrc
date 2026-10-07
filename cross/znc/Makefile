PKG_NAME = znc
PKG_VERS = 1.10.3
PKG_EXT = tar.gz
# From git, at the commit tag znc-$(PKG_VERS) points to: znc.in has been flaky (its TLS
# certificate expired on 2026-07-14) and the mirrors that carried its tarball came and
# went. GitHub's own archive leaves the submodules empty, so they are added from the
# commits the tag pins: Csocket is needed to build, cctz for timezones. The release
# tarball's pregenerated modpython sources are not in git; the host's SWIG (>= 4.0.1)
# generates them instead.
PKG_GIT_HASH = 6bd91573cebd1e4ee954ebd4eb6db5b654e0e412
PKG_GIT_SUBMODULES = third_party/Csocket third_party/cctz
PKG_DOWNLOAD_METHOD = git
PKG_DIST_SITE = https://github.com/znc/znc.git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

# Ensure C++17 compatibility
MIN_GCC_VERSION = 7

HOMEPAGE = https://wiki.znc.in/
COMMENT  = Advanced IRC bouncer
LICENSE  = Apache 2.0

ifeq ($(strip $(PYTHON_PACKAGE)),)
BUILD_DEPENDS = python314
endif

CONFIGURE_ARGS += -DWANT_PYTHON=true
DEPENDS = cross/zlib

DEPENDS += cross/openssl3
CONFIGURE_ARGS += -DWANT_OPENSSL=true

DEPENDS += cross/libicu
CONFIGURE_ARGS += -DWANT_ICU=true

DEPENDS += cross/argon2
CONFIGURE_ARGS += -DWANT_ARGON=true

DEPENDS += cross/cyrus-sasl
CONFIGURE_ARGS += -DWANT_CYRUS=true

# Boost mandatory for i18n and
# can only be built from spk
ifneq ($(strip $(BOOST_BUILD_PATH)),)
CONFIGURE_ARGS += -DWANT_I18N=true
endif

CONFIGURE_ARGS += -DWANT_SYSTEMD=false
CONFIGURE_ARGS += -DWANT_TCL=false
CONFIGURE_ARGS += -DWANT_PERL=false

# For ZNC to build using github-action, enforce adding Python & OpenSSL include directories
ADDITIONAL_CPPFLAGS += -I$(PYTHON_STAGING_INSTALL_PREFIX)/include/python3.$(subst python3,,$(PYTHON_PACKAGE))
ADDITIONAL_CPPFLAGS += -I$(OPENSSL_STAGING_INSTALL_PREFIX)/include/openssl

ifneq ($(wildcard modules/*),)
POST_INSTALL_TARGET = znc_post_install
endif

# Although ZNC uses CMake, its modules are built via znc-buildmod,
# which requires CC/CXX (tc_vars.autotools.mk) and *FLAGS (tc_vars.flags.mk)
# to be present in the environment.
DEFAULT_ENV  = cmake
DEFAULT_ENV += autotools
DEFAULT_ENV += flags

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
	@$(MSG) BUILD_DIR: $(BUILD_DIR)/znc-buildmod
	@chmod +x $(BUILD_DIR)/znc-buildmod
	@rm -fr $(WORK_DIR)/modules
	@cp -R modules $(WORK_DIR)/
	@$(RUN) sed -i 's|$(INSTALL_PREFIX)|$(STAGING_INSTALL_PREFIX)|g' $(STAGING_INSTALL_PREFIX)/share/znc/cmake/znc_internal.cmake
	cd $(WORK_DIR)/modules && env $(ENV) sh -c 'CMAKE_PREFIX_PATH=$(STAGING_INSTALL_PREFIX) $(BUILD_DIR)/znc-buildmod $(EXTRA_MODULES)'
	@$(RUN) sed -i 's|$(STAGING_INSTALL_PREFIX)|$(INSTALL_PREFIX)|g' $(STAGING_INSTALL_PREFIX)/share/znc/cmake/znc_internal.cmake
	@install -m 644 $(WORK_DIR)/modules/*.so $(STAGING_INSTALL_PREFIX)/lib/znc/
