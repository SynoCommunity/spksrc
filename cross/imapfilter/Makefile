PKG_NAME = imapfilter
PKG_VERS = 2.7.5
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/lefcha/$(PKG_NAME)/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl cross/lua cross/pcre2

HOMEPAGE = http://github.com/lefcha/imapfilter
COMMENT  = An IMAP mail filtering utility using the Lua programming language as a configuration and extension language.
LICENSE  = MIT

CONFIGURE_TARGET = nop
INSTALL_TARGET = imapfilter_install

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
# PPC_ARCHES except QorIQ
ADDITIONAL_CPPFLAGS = -DLUA_32BITS
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: imapfilter_install
imapfilter_install:
	@$(RUN) ; cd src && $(MAKE) install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)
	mkdir -p $(INSTALL_DIR)/$(INSTALL_PREFIX)/var
	@$(RUN) ; cp samples/*.lua $(INSTALL_DIR)/$(INSTALL_PREFIX)/var/
