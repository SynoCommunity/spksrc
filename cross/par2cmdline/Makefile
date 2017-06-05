PKG_NAME = par2cmdline
PKG_VERS = 0.6.14-mt1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/jkansanen/par2cmdline-mt/archive
PKG_DIR = $(PKG_NAME)-mt-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/jkansanen/par2cmdline-mt
COMMENT  = par2cmdline-mt is a multithreaded (OpenMP) PAR 2.0 compatible file verification and repair tool.
LICENSE  = GPL

GNU_CONFIGURE = 1

POST_INSTALL_TARGET = myPostInstall
PRE_CONFIGURE_TARGET = myPreConfigure

include ../../mk/spksrc.cross-cc.mk

PAR2_TOOLS = par2create par2repair par2verify

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) aclocal
	$(RUN) automake --add-missing
	$(RUN) autoconf
	
	
myPostInstall:
	(cd $(INSTALL_DIR)/$(INSTALL_PREFIX)/bin ; \
	  for tool in $(PAR2_TOOLS); \
	  do \
	    rm $${tool} ; \
	    ln -sf par2 $${tool} ; \
	   done \
	 )

