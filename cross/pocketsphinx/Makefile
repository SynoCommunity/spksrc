
PKG_NAME = pocketsphinx
PKG_VERS = 0.7
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/cmusphinx/$(PKG_NAME)/$(PKG_VERS)

DEPENDS = cross/sphinxbase

MAINTAINER=	http://packages.nas-forum.com/
HOMEPAGE=	http://cmusphinx.sourceforge.net/
COMMENT=	Recognizer library
LICENSE=	CMU Sphinx

GNU_CONFIGURE = 1

# Try to fetch python variables
-include $(WORK_DIR)/python-cc.mk

# Build the python module if being built as python dependency
ifdef HOSTPYTHON
PRE_COMPILE_PYTHON_MODULE = compile_target
include ../../mk/spksrc.python-module.mk
else
include ../../mk/spksrc.cross-cc.mk
endif
