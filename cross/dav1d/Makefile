PKG_NAME = dav1d
PKG_VERS = 1.4.3
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.videolan.org/pub/videolan/dav1d/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.videolan.org/projects/dav1d.html
COMMENT  = dav1d is a new AV1 cross-platform decoder, open-source, and focused on speed, size and correctness.
LICENSE  = BSD 2-Clause "Simplified" License

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

CONFIGURE_ARGS += -Denable_tests=false
CONFIGURE_ARGS += -Denable_examples=false
CONFIGURE_ARGS += -Denable_docs=false
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-meson.mk
