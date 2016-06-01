PKG_NAME = git
PKG_VERS = 2.8.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.kernel.org/pub/software/scm/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/expat cross/zlib cross/openssl cross/curl

HOMEPAGE = http://git-scm.com
COMMENT  = Git is a free & open source, distributed version control system designed to handle everything from small to very large projects with speed and efficiency.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --without-tcltk --without-python ac_cv_fread_reads_directories=yes ac_cv_snprintf_returns_bogus=no

PRE_CONFIGURE_TARGET = myPreConfigure
INSTALL_TARGET = myInstall
POST_INSTALL_TARGET = myPostInstall
ENV += TC_TARGET="$(TC_TARGET)"

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) autoconf

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX) NO_INSTALL_HARDLINKS=1

.PHONY: myPostInstall
myPostInstall:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/etc
	install -m 644 src/gitconfig $(STAGING_INSTALL_PREFIX)/etc/gitconfig
