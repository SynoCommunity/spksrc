
PKG_NAME = sphinxbase
PKG_VERS = 0.7
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/cmusphinx/$(PKG_NAME)/$(PKG_VERS)

DEPENDS = cross/bison

MAINTAINER=	http://packages.nas-forum.com/
HOMEPAGE=	http://cmusphinx.sourceforge.net/
COMMENT=	Support library required by Pocketsphinx
LICENSE=	CMU Sphinx

GNU_CONFIGURE = 1

POST_INSTALL_TARGET = myPostInstall

include ../../mk/spksrc.cross-cc.mk

# Fix bad dependency reference
#TODO: Put that in the libtool correction rule at install time
.PHONY: myPostInstall
myPostInstall:
	@for la_file in $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/*.la ; \
	do \
		$(MSG) "Fixing libtool file $${la_file}" ; \
		sed -i -e 's#/usr/local/lib/libsphinxbase.la#$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/libsphinxbase.la#g' $${la_file} ; \
	done

