PKG_NAME = greenlet
PKG_VERS = 2.0.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/g/${PKG_NAME}
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/python-greenlet/greenlet
COMMENT  = Lightweight in-process concurrent programming
LICENSE  = MIT

ifeq ($(call version_lt, ${TC_GCC}, 5.0),1)
ADDITIONAL_CXXFLAGS += -std=c++11
endif

include ../../mk/spksrc.python-wheel.mk

