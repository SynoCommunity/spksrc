PKG_NAME = sphinxbase
PKG_VERS = 0.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/project/cmusphinx/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/bison

HOMEPAGE = http://cmusphinx.sourceforge.net/
COMMENT  = Support library required by Pocketsphinx
LICENSE  = CMU Sphinx

GNU_CONFIGURE = 1

# configure_target, compile_target, install_target and install_python_wheel
# are framework targets of spksrc.configure.mk and spksrc.python-wheel.mk
PRE_CONFIGURE_TARGET = sphinxbase_pre_configure
CONFIGURE_TARGET = configure_target
COMPILE_TARGET = compile_target sphinxbase_compile
INSTALL_TARGET = install_target install_python_wheel

include ../../mk/spksrc.python-wheel.mk

.PHONY: sphinxbase_pre_configure
sphinxbase_pre_configure:
	rm $(WORK_DIR)/$(PKG_DIR)/python/sphinxbase.c
	cython -o $(WORK_DIR)/$(PKG_DIR)/python/sphinxbase.c $(WORK_DIR)/$(PKG_DIR)/python/sphinxbase.pyx

.PHONY: sphinxbase_compile
sphinxbase_compile:
	@cd $(WORK_DIR)/$(PKG_DIR)/python && env $(ENV) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) -c "import setuptools;__file__='setup.py';exec(compile(open(__file__).read().replace('\r\n', '\n'), __file__, 'exec'))" bdist_wheel -b $(WORK_DIR)/wheelbuild -d $(WORK_DIR)/wheelhouse
