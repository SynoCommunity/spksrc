PKG_NAME = lsd
PKG_VERS = 1.1.5
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/lsd-rs/lsd/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# even it compiles with native/rust-qoriq, the tool does not run
# on other PPC archs than qoriq (fails with "Segmentation fault (core dumped)")
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://github.com/lsd-rs/lsd
COMMENT  = The next gen ls command.
LICENSE  = Apache 2.0

include ../../mk/spksrc.cross-rust.mk
