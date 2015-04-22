PKG_NAME = tor
PKG_VERS = 0.2.5.12
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = https://www.torproject.org/dist

DEPENDS = cross/libevent

HOMEPAGE = https://www.torproject.org/
COMMENT  = Tor is free software for enabling anonymous communication. The name is an acronym derived from the original software project name The Onion Router.
LICENSE  =

GNU_CONFIGURE = 1
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk


CONFIGURE_ARGS = --disable-asciidoc

myInstall:
	$(RUN) make install prefix=$(STAGING_INSTALL_PREFIX) exec_prefix=$(STAGING_INSTALL_PREFIX)
