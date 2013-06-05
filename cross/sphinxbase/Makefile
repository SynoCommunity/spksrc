PKG_NAME = sphinxbase
PKG_VERS = 0.8
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/cmusphinx/$(PKG_NAME)/$(PKG_VERS)

DEPENDS = cross/bison

HOMEPAGE = http://cmusphinx.sourceforge.net/
COMMENT  = Support library required by Pocketsphinx
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
	rm $(WORK_DIR)/$(PKG_DIR)/python/sphinxbase.c
	cython -o $(WORK_DIR)/$(PKG_DIR)/python/sphinxbase.c $(WORK_DIR)/$(PKG_DIR)/python/sphinxbase.pyx

.PHONY: myConfigure
myConfigure: configure_target compile_target install_target install_correct_lib_files

.PHONY: myCompile
myCompile:
	@cd $(WORK_DIR)/$(PKG_DIR)/python && env $(ENV) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) setup.py build $(BUILD_ARGS)

.PHONY: myInstall
myInstall:
	@cd $(WORK_DIR)/$(PKG_DIR)/python && env $(ENV) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) setup.py install --root $(INSTALL_DIR) --prefix $(INSTALL_PREFIX) $(INSTALL_ARGS)
