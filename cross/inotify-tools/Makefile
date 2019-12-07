PKG_NAME = inotify-tools
PKG_VERS = 3.20.1patch1
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = 501a806c9fa2cccb90ee55b7d36c00a78fac5527
PKG_DIST_SITE = https://github.com/rvoicilas/$(PKG_NAME).git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS = 
HOMEPAGE = https://github.com/rvoicilas/inotify-tools
COMMENT  = inotify-tools is a C library and a set of command-line programs for Linux providing a simple interface to inotify. 
LICENSE  = GPLv2

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = inotify_pre_configure
CONFIGURE_ARGS = 

include ../../mk/spksrc.cross-cc.mk

inotify_pre_configure:
	$(RUN) ; ./autogen.sh 

