PKG_NAME = imapfilter
PKG_VERS = 2.8.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/lefcha/imapfilter/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)/src

DEPENDS = cross/openssl3 cross/lua cross/pcre2

HOMEPAGE = http://github.com/lefcha/imapfilter
COMMENT  = An IMAP mail filtering utility using the Lua programming language as a configuration and extension language.
LICENSE  = MIT

CONFIGURE_TARGET = nop
INSTALL_MAKE_OPTIONS = install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)
POST_INSTALL_TARGET = imapfilter_post_install

ENV += SHAREDIR="$(INSTALL_PREFIX)/share/imapfilter"
ENV += SSLCAPATH="/etc/ssl/certs"
ENV += SSLCAFILE="/etc/ssl/certs/ca-certificates.crt"

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
ADDITIONAL_CFLAGS = -DLUA_USE_C89
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: imapfilter_post_install
imapfilter_post_install:
	@$(MSG) "Install sample configuration files"
	@install -d -m 777 $(INSTALL_DIR)/$(INSTALL_PREFIX)/var
	@install -m 755 $(WORK_DIR)/$(PKG_DIR)/../samples/*.lua $(INSTALL_DIR)/$(INSTALL_PREFIX)/var/
