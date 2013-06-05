PKG_NAME = pocketsphinx
PKG_VERS = 0.8
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/cmusphinx/$(PKG_NAME)/$(PKG_VERS)

DEPENDS = cross/sphinxbase

HOMEPAGE = http://cmusphinx.sourceforge.net/
COMMENT  = Recognizer library
LICENSE  = CMU Sphinx

GNU_CONFIGURE = 1

# Standard build or build the python module if being built as python dependency
ifeq ($(wildcard $(WORK_DIR)/python-cc.mk),)
include ../../mk/spksrc.cross-cc.mk
else
PRE_CONFIGURE_TARGET = myPreConfigure
CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall
include ../../mk/spksrc.python-module.mk
endif

.PHONY: myPreConfigure
myPreConfigure:
	rm $(WORK_DIR)/$(PKG_DIR)/python/pocketsphinx.c
	cython -o $(WORK_DIR)/$(PKG_DIR)/python/pocketsphinx.c $(WORK_DIR)/$(PKG_DIR)/python/pocketsphinx.pyx -I$(WORK_DIR)/sphinxbase-$(PKG_VERS)/python

.PHONY: myConfigure
myConfigure: configure_target compile_target install_target install_correct_lib_files

.PHONY: myCompile
myCompile:
	@cd $(WORK_DIR)/$(PKG_DIR)/python && env $(ENV) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) setup.py build $(BUILD_ARGS)

.PHONY: myInstall
myInstall:
	@cd $(WORK_DIR)/$(PKG_DIR)/python && env $(ENV) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) setup.py install --root $(INSTALL_DIR) --prefix $(INSTALL_PREFIX) $(INSTALL_ARGS)
