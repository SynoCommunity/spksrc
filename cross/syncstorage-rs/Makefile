PKG_NAME = syncstorage-rs
PKG_VERS = 0.14.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mozilla-services/$(PKG_NAME)/archive/${PKG_VERS}
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# powerpc archs (except qoriq) are not supported
UNSUPPORTED_ARCHS += $(OLD_PPC_ARCHS)

HOMEPAGE = https://github.com/mozilla-services/syncstorage-rs/
COMMENT  = Mozilla Sync Storage built with Rust.
LICENSE  = https://github.com/mozilla-services/syncstorage-rs/blob/master/LICENSE

include ../../mk/spksrc.cross-rust.mk
