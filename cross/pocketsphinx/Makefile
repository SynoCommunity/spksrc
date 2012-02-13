PKG_NAME = pocketsphinx
PKG_VERS = 0.7
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
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall
include ../../mk/spksrc.python-module.mk
endif

.PHONY: myCompile
myCompile: configure_target compile_target install_target
	@if [ ! -d $(PYTHON_LIB_CROSS).bak ]; then \
		mv $(PYTHON_LIB_CROSS) $(PYTHON_LIB_CROSS).bak; \
	fi
	@cp -R $(HOSTPYTHON_LIB_NATIVE) $(PYTHON_LIB_CROSS)
	@cd $(WORK_DIR)/$(PKG_DIR)/python && env $(ENV) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) setup.py build
	@mv $(PYTHON_LIB_CROSS).bak $(PYTHON_LIB_CROSS)

.PHONY: myInstall
myInstall:
	@cd $(WORK_DIR)/$(PKG_DIR)/python && env $(ENV) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) setup.py install --root $(INSTALL_DIR)

