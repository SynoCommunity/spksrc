PKG_NAME = argon2
PKG_VERS = 20190702
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = 62358ba
PKG_DIST_SITE = https://github.com/P-H-C/phc-winner-$(PKG_NAME).git
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)
PKG_DIST_FILE = $(PKG_DIR).$(PKG_EXT)

HOMEPAGE = https://www.password-hashing.net/
COMMENT  = The password hash Argon2, winner of PHC
LICENSE  = Apache-2.0

include ../../mk/spksrc.archs.mk
ifneq ($(filter $(ARCH),$(i686_ARCHS)),)
OPTTARGET = i686
else ifneq ($(filter $(ARCH),$(x64_ARCHS)),)
OPTTARGET = x86-64
else
OPTTARGET = none
endif

CONFIGURE_TARGET = nope

COMPILE_MAKE_OPTIONS = ARGON2_VERSION=$(PKG_VERS) OPTTARGET=$(OPTTARGET) LIBRARY_REL=lib
INSTALL_MAKE_OPTIONS = install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX) LIBRARY_REL=lib

include ../../mk/spksrc.cross-cc.mk
