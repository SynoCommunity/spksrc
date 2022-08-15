PKG_NAME = libexpat
PKG_VERS = 2.4.8
PKG_EXT = tar.xz
PKG_DIST_NAME = expat-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libexpat/libexpat/releases/download/R_$(subst .,_,$(PKG_VERS))
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = expat-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://libexpat.github.io/
COMMENT  = Expat is an XML parser library written in C. It is a stream-oriented parser in which an application registers handlers for things the parser might find in the XML document (like start tags).
LICENSE  = MIT

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --without-xmlwf
CONFIGURE_ARGS += --without-examples
CONFIGURE_ARGS += --without-tests
# TODO check "getrandom" syscall availability for each arch/DSM versions
CONFIGURE_ARGS += CFLAGS=-DXML_POOR_ENTROPY

ADDITIONAL_CPPFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
