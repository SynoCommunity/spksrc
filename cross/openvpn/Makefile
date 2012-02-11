
PKG_NAME = openvpn
PKG_VERS = 2.2.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://swupdate.openvpn.org/community/releases/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/lzo cross/openssl

MAINTAINER	=	packages@packages.nas-forum.com
HOMEPAGE	=	http://openvpn.net/
COMMENT		=	OpenVPN
LICENSE		=	OpenVPN support a license under GPLv2 along with a commercial license where appropriate without the restrictions of GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-password-save

include ../../mk/spksrc.cross-cc.mk
