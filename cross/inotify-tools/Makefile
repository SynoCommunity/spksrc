PKG_NAME = inotify-tools
PKG_VERS = 3.20.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/rvoicilas/inotify-tools/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 
HOMEPAGE = https://github.com/rvoicilas/inotify-tools
COMMENT  = inotify-tools is a C library and a set of command-line programs for Linux providing a simple interface to inotify. 
LICENSE  = GNU General Public License version 2.0 (GPLv2)

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = inotify_pre_configure
CONFIGURE_ARGS = 
INSTALL_TARGET = inotify_extra_install

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH), $(ARM_ARCHES)),$(ARCH))
inotify_pre_configure:
	$(RUN) ; ./autogen.sh --host=arm-linux
else
inotify_pre_configure:
	$(RUN) ; ./autogen.sh
endif
	
inotify_extra_install:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)

