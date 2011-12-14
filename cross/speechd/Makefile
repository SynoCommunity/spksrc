
PKG_NAME = speechd
PKG_FULL_NAME = speech-dispatcher
PKG_VERS = 0.7.1
PKG_EXT = tar.gz
PKG_DIR = $(PKG_FULL_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://devel.freebsoft.org/pub/projects/$(PKG_NAME)
PYTHON_SHORT_VERS = 27
PYTHON_VERS = 2.7.2

DEPENDS = cross/dotconf cross/glib cross/espeak cross/flite native/python$(PYTHON_SHORT_VERS)

MAINTAINER = http://packages.nas-forum.com
HOMEPAGE   = http://devel.freebsoft.org/speechd
COMMENT    = Common interface to speech synthesis
LICENSE    = 

GNU_CONFIGURE = 1

CONFIGURE_ARGS = PYTHON=$(WORK_DIR)/../../../native/python$(PYTHON_SHORT_VERS)/work-native/Python-$(PYTHON_VERS)/python
 
include ../../mk/spksrc.cross-cc.mk
