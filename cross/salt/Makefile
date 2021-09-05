PKG_NAME = salt
# on DSM6 with Python2 last supported version of salt is 3000.9
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
PKG_VERS = 3003.2
else
PKG_VERS = 3000.9
endif
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/s/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = https://pypi.python.org/pypi/salt
COMMENT  = Salt, a new approach to infrastructure management, is easy enough to get running in minutes, scalable enough to manage tens of thousands of servers, and fast enough to communicate with tho$
LICENSE  = Apache

PRE_INSTALL_TARGET = pre_install_into_cross_env

include ../../mk/spksrc.python-wheel.mk

#ifeq ($(PYTHON_LIB_NATIVE),$(PYTHON_LIB_CROSS))
#LD_LIBRARY_PATH := $(INSTALL_DIR)$(INSTALL_PREFIX)/lib:$(LD_LIBRARY_PATH)
#export LD_LIBRARY_PATH
#endif

.PHONY: pre_install_into_cross_env
pre_install_into_cross_env:
ifeq ($(strip $(CROSSENV)),)
	$(RUN) $(PIP) install "markupsafe"
	$(RUN) $(PIP) install "Cython"
else
	@. $(CROSSENV) && $(RUN) build-pip install "markupsafe"  --no-build-isolation
	@. $(CROSSENV) && $(RUN) pip install "markupsafe"  --no-build-isolation
	@. $(CROSSENV) && $(RUN) build-pip install "Cython" --no-build-isolation
	@. $(CROSSENV) && $(RUN) pip install "Cython" --no-build-isolation
endif
