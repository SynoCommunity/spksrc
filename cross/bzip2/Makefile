
PKG_NAME = bzip2
PKG_VERS = 1.0.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://bzip.org/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

MAINTAINER = http://packages.nas-forum.com
HOMEPAGE   = http://bzip.org/
COMMENT    = High-quality data compressor
LICENSE    = http://www.gnu.org/licenses/old-licenses/gpl-2.0.html

CONFIGURE_TARGET = nop
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myCompile
myCompile:
	$(RUN) $(MAKE) libbz2.a bzip2 bzip2recover PREFIX=$(STAGING_INSTALL_PREFIX) $(TC_ENV)
	
.PHONY: myInstall
myInstall:
	@$(RUN) $(MAKE) PREFIX=$(STAGING_INSTALL_PREFIX) install
