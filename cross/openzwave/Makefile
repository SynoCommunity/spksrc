PKG_NAME = openzwave
PKG_VERS = $(PKG_SVN_REV)
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = svn
PKG_SVN_REV = 1009
PKG_DIST_NAME = trunk
PKG_DIST_SITE = http://open-zwave.googlecode.com/svn
PKG_DIST_FILE = $(PKG_NAME)-r$(PKG_SVN_REV).$(PKG_EXT)
PKG_DIR = open-zwave-read-only

DEPENDS = 

HOMEPAGE = http://www.openzwave.com/
COMMENT  = A Open Source implementation of the ZWave Serial API
LICENSE  = GPL

ENV += CROSS_COMPILE=$(TC_PATH)$(TC_PREFIX)

DOWNLOAD_TARGET = myDownload
CONFIGURE_TARGET = nope
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myDownload
myDownload:$
	@mkdir -p $(DISTRIB_DIR)
	@cd $(DISTRIB_DIR) ; \
        if [ ! -f $(PKG_DIST_FILE) ]; then \
	  echo "svn co -r $(PKG_SVN_REV) $(PKG_DIST_SITE)/$(PKG_DIST_NAME) $(PKG_DIR)" ; \
	  svn co -q -r $(PKG_SVN_REV) $(PKG_DIST_SITE)/$(PKG_DIST_NAME) $(PKG_DIR) ; \
	  tar -czf $(PKG_DIST_FILE) $(PKG_DIR) ; \
	  rm -fr $(PKG_DIR) ; \
	else \
	  $(MSG) "  FILE $(PKG_DIST_FILE) already downloaded" ; \
	fi ; \

.PHONY: myInstall
myInstall:
	$(RUN) make install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)
