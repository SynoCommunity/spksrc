PKG_NAME = dua
PKG_VERS = 2.30.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Byron/dua-cli/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-cli-$(PKG_VERS)

# dua v2.30.0 is the latest version that builds for ARMv5 with rust 1.77.2
DEPENDS =

# linker error: 
# unrecognised emulation mode: elf32ppclinux
# Supported emulations: elf_x86_64 elf32_x86_64 elf_i386 elf_iamcu i386pep i386pe
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

CARGO_BUILD_ARGS = --locked

HOMEPAGE = https://lib.rs/crates/dua-cli
COMMENT  = A tool to conveniently learn about the disk usage of directories, fast!
LICENSE  = MIT

include ../../mk/spksrc.cross-rust.mk
