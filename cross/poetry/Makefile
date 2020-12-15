PKG_NAME = poetry
PKG_VERS = 1.1.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/p/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/cffi

HOMEPAGE = https://python-poetry.org/
COMMENT  = Poetry helps you declare, manage and install dependencies of Python projects, ensuring you have the right stack everywhere.
LICENSE  = MIT

POST_INSTALL_TARGET = install_into_cross_env

include ../../mk/spksrc.python-module.mk

.PHONY: install_into_cross_env
install_into_cross_env: 
ifneq ($(strip $(CROSSENV)),)
	@. $(CROSSENV) $(RUN) build-pip install "$(PKG_NAME)==$(PKG_VERS)" --no-build-isolation 
	@. $(CROSSENV) $(RUN) pip install "$(PKG_NAME)==$(PKG_VERS)" --no-build-isolation 
endif
