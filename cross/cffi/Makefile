PKG_NAME = cffi
PKG_VERS = 1.15.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/c/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/pycparser cross/libffi

HOMEPAGE = https://cffi.readthedocs.org
COMMENT  = Foreign Function Interface for Python calling C code
LICENSE  = MIT

PLIST_TRANSFORM = sed -e 's%@PYTHON_SITE_PACKAGES@%$(PYTHON_LIB_DIR)/site-packages%' -e 's%@PYTHON_VERSION@%$(SPK_SHORT_VERS)%'

PRE_INSTALL_TARGET = pre_install_into_cross_env

include ../../mk/spksrc.python-module.mk

.PHONY: pre_install_into_cross_env
pre_install_into_cross_env: 
ifeq ($(strip $(CROSSENV)),)
	$(RUN) $(PIP) install "$(PKG_NAME)==$(PKG_VERS)"
else
	@. $(CROSSENV) && $(RUN) build-pip install "$(PKG_NAME)==$(PKG_VERS)"  --no-build-isolation
	@. $(CROSSENV) && $(RUN) pip install "$(PKG_NAME)==$(PKG_VERS)"  --no-build-isolation
endif
