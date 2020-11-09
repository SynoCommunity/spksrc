PKG_NAME = pocketsphinx
PKG_VERS = 0.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/project/cmusphinx/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/sphinxbase

HOMEPAGE = http://cmusphinx.sourceforge.net/
COMMENT  = Recognizer library
LICENSE  = CMU Sphinx

GNU_CONFIGURE = 1

# configure_target, compile_target, install_target and install_python_wheel
# are framework targets of spksrc.configure.mk and spksrc.python-wheel.mk
PRE_CONFIGURE_TARGET = pocketsphinx_pre_configure
CONFIGURE_TARGET = configure_target
COMPILE_TARGET = compile_target pocketsphinx_compile
INSTALL_TARGET = install_target install_python_wheel

include ../../mk/spksrc.python-wheel.mk

.PHONY: pocketsphinx_pre_configure
pocketsphinx_pre_configure:
	rm $(WORK_DIR)/$(PKG_DIR)/python/pocketsphinx.c
	cython -o $(WORK_DIR)/$(PKG_DIR)/python/pocketsphinx.c $(WORK_DIR)/$(PKG_DIR)/python/pocketsphinx.pyx -I$(WORK_DIR)/sphinxbase-$(PKG_VERS)/python

.PHONY: pocketsphinx_compile
pocketsphinx_compile:
	@cd $(WORK_DIR)/$(PKG_DIR)/python && env $(ENV) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) -c "import setuptools;__file__='setup.py';exec(compile(open(__file__).read().replace('\r\n', '\n'), __file__, 'exec'))" bdist_wheel -b $(WORK_DIR)/wheelbuild -d $(WORK_DIR)/wheelhouse
