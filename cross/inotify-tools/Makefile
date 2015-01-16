PKG_NAME = inotify-tools
PKG_VERS = 3.14
PKG_EXT = tar.gz
PKG_DIST_NAME = inotify-tools-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://github.com/downloads/rvoicilas/inotify-tools
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 
HOMEPAGE = https://github.com/rvoicilas/inotify-tools
COMMENT  = inotify-tools is a C library and a set of command-line programs for Linux providing a simple interface to inotify. 
LICENSE  = GNU General Public License version 2.0 (GPLv2)

GNU_CONFIGURE = 1
CONFIGURE_ARGS = 
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX)

