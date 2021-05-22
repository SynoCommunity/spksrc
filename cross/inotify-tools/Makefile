PKG_NAME = inotify-tools
PKG_VERS = 3.20.11.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/inotify-tools/inotify-tools/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/inotify-tools/inotify-tools
COMMENT  = inotify-tools is a C library and a set of command-line programs for Linux providing a simple interface to inotify. 
LICENSE  = GPLv2

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = inotify_pre_configure

include ../../mk/spksrc.cross-cc.mk

inotify_pre_configure:
	$(RUN) ./autogen.sh 
