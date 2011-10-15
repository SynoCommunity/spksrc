

PKG_NAME = Cheetah
PKG_VERS = 2.4.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://pypi.python.org/packages/source/C/$(PKG_NAME)/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

MAINTAINER = superzebulon@superzebulon.org
HOMEPAGE   = http://www.cheetahtemplate.org/
COMMENT    = Cheetah is a template engine and code generation tool.	
LICENSE    = MIT License

ADDITIONAL_CFLAGS =
CONFIGURE_ARGS = 

CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

# Fetch python definition (provides HOSTPYTHON)
include $(WORK_DIR)/python-cc.mk

myConfigure:
	@$(RUN) grep -v 'from tempfile import mktemp' < cheetah/FileUtils.py > FileUtils.py
	@$(RUN) sed -i.orig SetupTools.py \
	            -e 's/from cheetah.FileUtils import findFiles/from FileUtils import findFiles/'

myCompile:
	@$(RUN) $(HOSTPYTHON) setup.py build

myInstall:
	@$(RUN) $(HOSTPYTHON) setup.py install --root $(INSTALL_DIR)
