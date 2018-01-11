PKG_NAME = PyYAML
PKG_VERS = 3.12
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/P/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libyaml

HOMEPAGE = http://pyyaml.org/
COMMENT  = PyYAML is a YAML parser and emitter for the Python programming language
LICENSE  = MIT

POST_EXTRACT_TARGET = myPostExtract

include ../../mk/spksrc.python-wheel.mk

.PHONY: myPostExtract
myPostExtract:
	# Cannot provide path to setup.py via command-line for bdist_wheel
	# So have to supply a config-file with the correct lib path
	sed -e 's#@STAGING_INSTALL_PREFIX@#$(STAGING_INSTALL_PREFIX)#' -i setup.cfg
	cp setup.cfg $(WORK_DIR)/$(PKG_DIR)/
