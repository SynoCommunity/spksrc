PKG_NAME = znc
PKG_VERS = 1.10.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://znc.in/releases
# znc.in is upstream, but flaky: its TLS certificate expired on 2026-07-14 and
# downloads fail on it until it is renewed. Gentoo serves the same tarball under
# its upstream name, so fall back there meanwhile. The subdirectory is the first
# two hex digits of the blake2b hash of the file name, so it must be recomputed
# on a version bump; a stale one just 404s and we fall through.
# Debian cannot be used: it renames the file to znc_$(PKG_VERS).orig.tar.gz, and
# a mirror base is only ever appended with PKG_DIST_NAME.
# GitHub is not an option either: znc publishes no release assets, and its git
# archive ships an empty third_party/Csocket submodule, so it cannot build.
PKG_DIST_MIRRORS = https://distfiles.gentoo.org/distfiles/c9
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# Ensure C++17 compatibility
REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k
REQUIRED_MIN_SRM = 1.3

HOMEPAGE = https://wiki.znc.in/
COMMENT  = Advanced IRC bouncer
LICENSE  = Apache 2.0

ifeq ($(strip $(PYTHON_PACKAGE)),)
BUILD_DEPENDS = cross/python312
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
