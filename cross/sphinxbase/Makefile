PKG_NAME = sphinxbase
PKG_VERS = 0.7
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/cmusphinx/$(PKG_NAME)/$(PKG_VERS)

DEPENDS = cross/bison

HOMEPAGE = http://cmusphinx.sourceforge.net/
COMMENT  = Support library required by Pocketsphinx
LICENSE  = CMU Sphinx

GNU_CONFIGURE = 1

POST_INSTALL_TARGET = myPostInstall

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

# Fix bad dependency reference
#TODO: Put that in the libtool correction rule at install time
.PHONY: myPostInstall
myPostInstall:
	@for la_file in $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/*.la ; \
	do \
		$(MSG) "Fixing libtool file $${la_file}" ; \
		sed -i -e 's# \([/0-9a-zA-Z]*\)libsphinxbase.la#$(INSTALL_DIR)/\1libsphinxbase.la#g' $${la_file} ; \
	done

