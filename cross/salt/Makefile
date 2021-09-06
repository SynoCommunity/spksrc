PKG_NAME = salt
PKG_VERS = 3003.3
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

.PHONY: pre_install_into_cross_env
pre_install_into_cross_env:
ifeq ($(strip $(CROSSENV)),)
	$(RUN) $(PIP) install "markupsafe"
else
	@. $(CROSSENV) && $(RUN) build-pip install "markupsafe"  --no-build-isolation
	@. $(CROSSENV) && $(RUN) pip install "markupsafe"  --no-build-isolation
endif
