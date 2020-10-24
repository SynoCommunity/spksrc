PKG_NAME = libtasn1
PKG_VERS = 4.16.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.gnu.org/software/libtasn1/
COMMENT  = ASN.1 library used by GnuTLS, p11-kit and some other packages.
LICENSE  = LGPLv2.1

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-gcc-warnings --disable-static
ADDITIONAL_CPPFLAGS = -std=c99

include ../../mk/spksrc.cross-cc.mk
