PKG_NAME = bottom
PKG_VERS = 0.11.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ClementTsang/bottom/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# cargo cannot even parse a dependency's manifest below 1.85:
#   failed to parse manifest at .../ratatui-crossterm-0.1.0-beta.0/Cargo.toml
#   feature `edition2024` is required ... not stabilized in this version of Cargo
MIN_RUSTC_VERSION = 1.85

HOMEPAGE = https://clementtsang.github.io/bottom
COMMENT  = A customizable cross-platform graphical process/system monitor for the terminal.
LICENSE  = MIT

CARGO_BUILD_ARGS = --locked

include ../../mk/spksrc.cross-rust.mk
