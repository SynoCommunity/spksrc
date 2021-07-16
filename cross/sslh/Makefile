PKG_NAME = sslh
PKG_VERS = 1.21c
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/yrutschle/sslh/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_DIST_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libconfig cross/pcre cross/tcp_wrappers

HOMEPAGE = https://www.rutschle.net/tech/sslh/README.html
COMMENT  = sslh accepts HTTPS, SSH and OpenVPN connections on the same port
LICENSE  = GPLv2

# Error on ppc853x - libcap.so: undefined reference to `pipe2'
# - glibc is too old
ifeq ($(findstring $(ARCH), ppc853x),$(ARCH))
CONFIGURE_TARGET = nop
else
DEPENDS += cross/libcap
CONFIGURE_TARGET = sslh_configure
endif

INSTALL_TARGET = sslh_install
COMPILE_MAKE_OPTIONS = USELIBWRAP=1

include ../../mk/spksrc.cross-cc.mk

.PHONY: sslh_configure
sslh_configure:
	@$(RUN) sed -i -e '/^USELIBCAP=/s/=.*/=1/' $(WORK_DIR)/$(PKG_DIR)/Makefile 

.PHONY: sslh_install
sslh_install:
	@$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/bin
	@$(RUN) cp $(WORK_DIR)/$(PKG_DIR)/sslh-fork $(STAGING_INSTALL_PREFIX)/bin/sslh

