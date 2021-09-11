PKG_NAME = salt
PKG_VERS = 3003.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/s/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = https://pypi.python.org/pypi/salt
COMMENT  = Salt, a new approach to infrastructure management, is easy enough to get running in minutes, scalable enough to manage tens of thousands of servers, and fast enough to communicate with those servers in seconds.
LICENSE  = Apache

PRE_INSTALL_TARGET = salt_pre_install

include ../../mk/spksrc.python-wheel.mk

.PHONY: salt_pre_install
salt_pre_install:
ifeq ($(strip $(CROSSENV)),)
	$(RUN) $(PIP) install "markupsafe"
else
	@. $(CROSSENV) && $(RUN) build-pip install "markupsafe"  --no-build-isolation
	@. $(CROSSENV) && $(RUN) pip install "markupsafe"  --no-build-isolation
endif
