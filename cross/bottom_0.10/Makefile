PKG_NAME = bottom
PKG_VERS = 0.10.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ClementTsang/bottom/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# this is the last release that builds with rust < 1.81
# rust's std for this target links against glibc 2.9 wrappers the 2.8 sysroot lacks:
#   undefined reference to `epoll_create1', undefined reference to `pipe2'
MIN_GLIBC_VERSION = 2.9

HOMEPAGE = https://clementtsang.github.io/bottom
COMMENT  = A customizable cross-platform graphical process/system monitor for the terminal.
LICENSE  = MIT

CARGO_BUILD_ARGS = --locked

include ../../mk/spksrc.cross-rust.mk
