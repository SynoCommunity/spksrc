PKG_NAME = stunnel
PKG_VERS = 5.57
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.stunnel.org/downloads
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/tcp_wrappers cross/openssl

HOMEPAGE = https://www.stunnel.org/
COMMENT  = "Stunnel is a proxy designed to add TLS encryption functionality to existing clients and servers without any changes in the programs' code.<br/>This package is for advanced users. "
LICENSE  = GPLv2+

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-ssl=$(STAGING_INSTALL_PREFIX)
# needed for compilation to avoid warning "_FORTIFY_SOURCE requires compiling with optimization (-O)"
ADDITIONAL_CPPFLAGS = -O3

include ../../mk/spksrc.cross-cc.mk
