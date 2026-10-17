PKG_NAME = json-c
PKG_VERS = 0.17-20230812
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/json-c/json-c/archive
PKG_DIR = $(PKG_NAME)-$(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

# gcc 4.3.7 rejects json-c's 64-bit literals:
#   tests/test_set_value.c:29: integer constant is too large for 'unsigned long' type
MIN_GCC_VERSION = 4.6

HOMEPAGE = https://github.com/json-c/json-c
COMMENT  = JSON-C implements a reference counting object model that allows you to easily construct JSON objects in C, output them as JSON formatted strings and parse JSON formatted strings back into the C representation of JSON objects. It aims to conform to RFC 7159.
LICENSE  = freeware

include ../../mk/spksrc.cross-cmake.mk
