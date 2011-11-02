

PKG_NAME = tornado
PKG_VERS = 2.1.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://github.com/downloads/facebook/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

MAINTAINER = superzebulon@superzebulon.org
HOMEPAGE   = http://www.tornadoweb.org/
COMMENT    = Open source scalable, non-blocking web server and tools.	
LICENSE    = http://www.apache.org/licenses/LICENSE-2.0.html

ADDITIONAL_CFLAGS =
CONFIGURE_ARGS = 

CONFIGURE_TARGET = nop
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
