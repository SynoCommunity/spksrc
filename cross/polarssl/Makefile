
PKG_NAME = polarssl
PKG_VERS = 1.0.0
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-gpl.$(PKG_EXT)
PKG_DIST_SITE = http://polarssl.org/code/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

MAINTAINER=
HOMEPAGE=	http://polarssl.org/
COMMENT=    Cryptography and SSL made easy
LICENSE=	http://www.gnu.org/licenses/old-licenses/gpl-2.0.html

CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure: ;

.PHONY: myCompile
myCompile:
	@$(RUN) $(MAKE) DESTDIR=$(STAGING_INSTALL_PREFIX)
	
.PHONY: myInstall
myInstall:
	@$(RUN) $(MAKE) DESTDIR=$(STAGING_INSTALL_PREFIX) install
