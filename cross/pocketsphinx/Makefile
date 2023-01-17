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

PRE_CONFIGURE_TARGET = myPreConfigure
CONFIGURE_TARGET = configure_target
COMPILE_TARGET = compile_target myCompile
INSTALL_TARGET = install_target install_python_wheel

include ../../mk/spksrc.python-wheel.mk

.PHONY: myPreConfigure
myPreConfigure:
	rm $(WORK_DIR)/$(PKG_DIR)/python/pocketsphinx.c
	cython -o $(WORK_DIR)/$(PKG_DIR)/python/pocketsphinx.c $(WORK_DIR)/$(PKG_DIR)/python/pocketsphinx.pyx -I$(WORK_DIR)/sphinxbase-$(PKG_VERS)/python

.PHONY: myCompile
myCompile:
	@cd $(WORK_DIR)/$(PKG_DIR)/python && env $(ENV) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) -c "import setuptools;__file__='setup.py';exec(compile(open(__file__).read().replace('\r\n', '\n'), __file__, 'exec'))" bdist_wheel -b $(WORK_DIR)/wheelbuild -d $(WORK_DIR)/wheelhouse
