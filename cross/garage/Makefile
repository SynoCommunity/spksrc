PKG_NAME = garage
PKG_VERS = 2.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://git.deuxfleurs.fr/Deuxfleurs/garage/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)

DEPENDS =

# TODO: check later
# linker error: undefined reference to `pthread_setname_np'
#UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://garagehq.deuxfleurs.fr/
COMMENT  = Garage is an S3-compatible distributed object storage service designed for self-hosting at a small-to-medium scale.
LICENSE  = AGPLv3.0

RUST_SRC_DIR = $(WORK_DIR)/garage/src/garage

include ../../mk/spksrc.cross-rust.mk