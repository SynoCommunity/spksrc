PKG_NAME = libthreadar
PKG_VERS = 1.3.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/libthreadar/files/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# archs without C++11 support are not supported:
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)
# other compiler problem
UNSUPPORTED_ARCHS += $(ARMv7L_ARCHS)

HOMEPAGE = http://libthreadar.sourceforge.net/
COMMENT  = Libthreadar is a C++ library providing a small set of C++ classes to manipulate threads in a very simple and efficient way from your C++ code.
LICENSE  = LGPLv3

GNU_CONFIGURE = 1
# avoid build of subdir "doc"
CONFIGURE_ARGS = ac_subdirs_all="src"

ADDITIONAL_CPPFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
