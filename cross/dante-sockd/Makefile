PKG_NAME = dante
PKG_VERS = 1.4.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.inet.no/dante/files
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.inet.no/dante/
COMMENT = Dante implements the socks standard and can function as a firewall between networks. Package contains sockd - socks proxyserver.
LICENSE = BSD/CMU

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-client --without-libwrap --without-bsdauth --without-gssapi --without-krb5 --without-upnp --without-pam

PRE_CONFIGURE_TARGET = dante_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: dante_pre_configure
dante_pre_configure:
	$(RUN) autoreconf -i -f -v
