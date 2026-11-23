PKG_NAME = dsvideo-passthrough
PKG_VERS = 0.1.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/holg/ds-video-hevc/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = ds-video-hevc-$(PKG_VERS)

DEPENDS =

# rust edition 2024
MIN_RUSTC_VERSION = 1.85

HOMEPAGE = https://github.com/holg/ds-video-hevc
COMMENT  = Proxy in front of Synology Video Station that lets DS Video play HEVC files via raw passthrough.
LICENSE  = MIT

CARGO_BUILD_ARGS = --locked --bin dsvideo-passthrough

include ../../mk/spksrc.cross-rust.mk
