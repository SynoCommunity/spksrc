PKG_NAME = libexpat
PKG_VERS = 2.7.5
PKG_EXT = tar.gz
PKG_DIST_NAME = R_$(subst .,_,$(PKG_VERS)).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libexpat/libexpat/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-R_$(subst .,_,$(PKG_VERS))/expat

DEPENDS =

HOMEPAGE = https://libexpat.github.io/
COMMENT  = Expat is an XML parser library written in C. It is a stream-oriented parser in which an application registers handlers for things the parser might find in the XML document (like start tags).
LICENSE  = MIT

CMAKE_ARGS  = -DEXPAT_BUILD_TESTS=OFF
CMAKE_ARGS += -DEXPAT_BUILD_EXAMPLES=OFF
CMAKE_ARGS += -DEXPAT_BUILD_TOOLS=OFF
CMAKE_ARGS += -DEXPAT_SHARED_LIBS=ON

# TODO check "getrandom" syscall availability for each arch/DSM version
ADDITIONAL_CFLAGS += -DXML_POOR_ENTROPY

include ../../mk/spksrc.cross-cmake.mk
