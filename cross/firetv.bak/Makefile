PKG_NAME = firetv
PKG_VERS = 1.0.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://pypi.python.org/packages/57/16/ed8fb43e013f5f95378707a968451b7fcd9121b5e36a1833b22e0d4281e2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/swig cross/libusb

HOMEPAGE = https://github.com/happyleavesaoc/python-firetv/
COMMENT  = Fire TV is a Python 2.x package that provides state information and some control of an Amazon Fire TV device over a network.
LICENSE  = MIT

include ../../mk/spksrc.python-wheel.mk
