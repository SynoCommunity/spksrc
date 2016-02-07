PKG_NAME = json-c
PKG_VERS = 0.12
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = https://s3.amazonaws.com/$(PKG_NAME)_releases/releases

DEPENDS =

HOMEPAGE = https://github.com/json-c/json-c/wiki
COMMENT  = JSON-C implements a reference counting object model that allows you to easily construct JSON objects in C, output them as JSON formatted strings and parse JSON formatted strings back into the C representation of JSON objects.
LICENSE  = MIT

GNU_CONFIGURE = 1

INSTALL_TARGET = myInstall
CONFIGURE_ARGS =  --disable-static

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	@$(RUN) $(MAKE) -j1 install DESTDIR=$(INSTALL_DIR)

