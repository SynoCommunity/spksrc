PKG_NAME = par2cmdline
PKG_VERS = 0.8.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Parchive/par2cmdline/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
DEPENDS =

HOMEPAGE = https://github.com/Parchive/par2cmdline
COMMENT  = par2cmdline is a PAR 2.0 compatible file verification and repair tool.
LICENSE  = GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS =
ADDITIONAL_LDFLAGS =-static

POST_INSTALL_TARGET = myPostInstall
PRE_CONFIGURE_TARGET = myPreConfigure

include ../../mk/spksrc.cross-cc.mk

PAR2_TOOLS = par2create par2repair par2verify

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) ./automake.sh


myPostInstall:
	(cd $(INSTALL_DIR)/$(INSTALL_PREFIX)/bin ; \
	for tool in $(PAR2_TOOLS); \
	do \
		rm $${tool} ; \
		ln -sf par2 $${tool} ; \
	done \
	)

