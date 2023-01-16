PKG_NAME = sslh
PKG_VERS = 1.22c
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/yrutschle/sslh/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_DIST_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libconfig cross/pcre2 cross/tcp_wrappers
DEPENDS += cross/libcap

# compiller must support -std=c11
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

HOMEPAGE = https://www.rutschle.net/tech/sslh/README.html
COMMENT  = Applicative Protocol Multiplexer (e.g. share SSH and HTTPS on the same port).
LICENSE  = GPLv2

CONFIGURE_TARGET = sslh_configure
INSTALL_TARGET = sslh_install
COMPILE_MAKE_OPTIONS = USELIBWRAP=1

ADDITIONAL_CFLAGS = -std=c11
# use misc of netdb.h in toolchain to define NI_MAXHOST, NI_MAXSERV, ...
ADDITIONAL_CFLAGS += -D__USE_MISC
ADDITIONAL_CFLAGS += -DNI_MAXHOST=1025
ADDITIONAL_CFLAGS += -DNI_MAXSERV=32

include ../../mk/spksrc.cross-cc.mk

.PHONY: sslh_configure
sslh_configure:
	@$(RUN) sed -i -e '/^USELIBCAP=/s/=.*/=1/' $(WORK_DIR)/$(PKG_DIR)/Makefile 

.PHONY: sslh_install
sslh_install:
	@$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/bin
	@$(RUN) cp $(WORK_DIR)/$(PKG_DIR)/sslh-fork $(STAGING_INSTALL_PREFIX)/bin/sslh
