PKG_NAME = tor
PKG_VERS = 0.3.2.9
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = https://www.torproject.org/dist

DEPENDS = cross/libevent

HOMEPAGE = https://www.torproject.org/
COMMENT  = Tor is free software for enabling anonymous communication. The name is an acronym derived from the original software project name The Onion Router.
LICENSE  =

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = generate_auto_conf
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk


CONFIGURE_ARGS = --disable-asciidoc --disable-tool-name-check

generate_auto_conf:
	$(RUN) aclocal -I m4 && \
		   autoheader && \
		   autoconf && \
		   automake --add-missing --copy

myInstall:
	$(RUN) make install prefix=$(STAGING_INSTALL_PREFIX) exec_prefix=$(STAGING_INSTALL_PREFIX)
