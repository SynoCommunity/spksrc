PKG_NAME = uamqp
PKG_VERS = 1.6.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/u/uamqp
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl3 cross/cffi

HOMEPAGE = https://github.com/Azure/azure-uamqp-python
COMMENT  = AMQP 1.0 client library for Python.
LICENSE  = MIT

POST_PATCH_TARGET = uamqp_post_patch

include ../../mk/spksrc.python-wheel.mk

.PHONY: uamqp_post_patch
# https://github.com/Azure/azure-uamqp-python/issues/276#issuecomment-924890556
uamqp_post_patch:
	@$(MSG) "Patch CMakeLists.txt files to avoid (deprecation) warnings as errors."
	@$(RUN) ; grep -rl "\-Werror" . | xargs sed -i 's/-Werror//'
