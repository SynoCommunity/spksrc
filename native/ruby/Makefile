PKG_NAME = ruby
PKG_VERS = 3.0.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://cache.ruby-lang.org/pub/ruby/3.0
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE   = http://www.ruby-lang.org/
COMMENT    = Ruby Programming Language
LICENSE    =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-install-doc --prefix=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.native-cc.mk
