PKG_NAME = sslh
PKG_VERS = 2.1.4
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/yrutschle/sslh/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_DIST_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libconfig
DEPENDS += cross/pcre2
DEPENDS += cross/tcp_wrappers
DEPENDS += cross/libcap
DEPENDS += cross/libev

# compiler must support -std=c11
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

HOMEPAGE = https://www.rutschle.net/tech/sslh/README.html
COMMENT  = Applicative Protocol Multiplexer (e.g. share SSH and HTTPS on the same port).
LICENSE  = GPLv2

GNU_CONFIGURE = 1

INSTALL_TARGET = sslh_install
COMPILE_MAKE_OPTIONS = USELIBWRAP=1 USELIBCAP=1

ADDITIONAL_CFLAGS = -std=c11
# force definition of __USE_MISC to define NI_MAXHOST, NI_MAXSERV, ... in netdb.h of toolchain
# __USE_MISC is defined in features.h when _DEFAULT_SOURCE is defined (otherwise __USE_MISC is undefined)
ADDITIONAL_CFLAGS += -D_DEFAULT_SOURCE

include ../../mk/spksrc.cross-cc.mk

.PHONY: sslh_install
sslh_install:
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(WORK_DIR)/$(PKG_DIR)/sslh-fork $(STAGING_INSTALL_PREFIX)/bin/
	@install -m 755 $(WORK_DIR)/$(PKG_DIR)/sslh-select $(STAGING_INSTALL_PREFIX)/bin/
	@install -m 755 $(WORK_DIR)/$(PKG_DIR)/sslh-ev $(STAGING_INSTALL_PREFIX)/bin/
