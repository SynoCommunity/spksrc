PKG_NAME = libexpat
PKG_VERS = 2.8.4
PKG_EXT = tar.gz
PKG_DIST_NAME = R_$(subst .,_,$(PKG_VERS)).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libexpat/libexpat/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-R_$(subst .,_,$(PKG_VERS))/expat

DEPENDS =

# frozen fallback line for pre-4.5 toolchains (last version before the
# message-form __deprecated__ attribute, and carries the 2.8.4 UAF fixes);
# selected by cross/libexpat, never bumped

HOMEPAGE = https://libexpat.github.io/
COMMENT  = Expat is an XML parser library written in C. It is a stream-oriented parser in which an application registers handlers for things the parser might find in the XML document (like start tags).
LICENSE  = MIT

CONFIGURE_ARGS  = -DEXPAT_BUILD_TESTS=OFF
CONFIGURE_ARGS += -DEXPAT_BUILD_EXAMPLES=OFF
CONFIGURE_ARGS += -DEXPAT_BUILD_TOOLS=OFF
CONFIGURE_ARGS += -DEXPAT_SHARED_LIBS=ON
# /dev/urandom exists on all DSM versions: real entropy for the hash
# secret where getrandom/getentropy are missing, not the weak fallback
CONFIGURE_ARGS += -DEXPAT_DEV_URANDOM=ON

include ../../mk/spksrc.cross-cmake.mk
