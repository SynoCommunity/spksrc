PKG_NAME = dav1d
PKG_VERS = 1.0.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.videolan.org/pub/videolan/dav1d/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.videolan.org/projects/dav1d.html
COMMENT  = dav1d is a new AV1 cross-platform decoder, open-source, and focused on speed, size and correctness.
LICENSE  = BSD 2-Clause "Simplified" License

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

BUILD_DEPENDS = native/nasm
NASM_PATH = $(realpath $(WORK_DIR)/../../../native/nasm/work-native/install/usr/local/bin)
ENV += PATH=$(NASM_PATH):$$PATH
ENV += AS=$(NASM_PATH)/nasm

CONFIGURE_ARGS += -Denable_tests=false
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-meson.mk
