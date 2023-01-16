PKG_NAME = fd
# Version 8.4.0 fails to build for ARMv5 (https://github.com/sharkdp/fd/issues/1049#issue-1283491635)
PKG_VERS = 8.3.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/sharkdp/fd/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# powerpc archs (except qoriq) are not supported
# undefined reference to `pipe2'
UNSUPPORTED_ARCHS += $(OLD_PPC_ARCHS)

HOMEPAGE = https://github.com/sharkdp/fd
COMMENT  = fd is a program to find entries in your filesystem. It is a simple, fast and user-friendly alternative to find. While it does not aim to support all of find's powerful functionality, it provides sensible (opinionated) defaults for a majority of use cases.
LICENSE  = Apache 2.0 / MIT

include ../../mk/spksrc.cross-rust.mk
