PKG_NAME = dnscrypt
PKG_VERS = 1.9.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-proxy-$(PKG_VERS).$(PKG_EXT)
# jedisct1 does not host version 1.9.5 anymore
# PKG_DIST_SITE = https://github.com/jedisct1/dnscrypt-proxy/releases/download/$(PKG_VERS)
PKG_DIST_SITE = https://fossies.org/linux/misc/dns/legacy
PKG_DIR = $(PKG_NAME)-proxy-$(PKG_VERS)

DEPENDS = cross/libsodium

#HOMEPAGE = https://dnscrypt.org/ domain out of order
COMMENT  = DNSCrypt is a protocol that authenticates communications between a DNS client and a DNS resolver. It prevents DNS spoofing.
LICENSE  =

UNSUPPORTED_ARCHS = powerpc ppc824x

GNU_CONFIGURE = 1

CONFIGURE_ARGS =

include ../../mk/spksrc.cross-cc.mk
