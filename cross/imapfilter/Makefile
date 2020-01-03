PKG_NAME = imapfilter
PKG_VERS = 2.6.16
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/lefcha/$(PKG_NAME)/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

CONFIGURE_TARGET = nop

DEPENDS = cross/openssl cross/lua cross/pcre

HOMEPAGE = http://github.com/lefcha/imapfilter
COMMENT  = An IMAP mail filtering utility using the Lua programming language as a configuration and extension language.
LICENSE  = MIT

ifeq ($(findstring $(ARCH),powerpc ppc824x ppc853x ppc854x),$(ARCH))
# PPC_ARCHES except QorIQ
ADDITIONAL_CFLAGS = -DLUA_32BITS
endif

include ../../mk/spksrc.cross-cc.mk
