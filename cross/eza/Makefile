PKG_NAME = eza
PKG_VERS = 0.23.4
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/eza-community/eza/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

# linker error:  undefined reference to `pthread_setname_np'
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)
# eza >= 0.20.19 requires RUST_TOOLCHAIN >= 1.78
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS)

HOMEPAGE = https://eza.rocks/
COMMENT  = A modern replacement for 'ls'.
LICENSE  = MIT

CARGO_BUILD_ARGS = --locked

include ../../mk/spksrc.cross-rust.mk
