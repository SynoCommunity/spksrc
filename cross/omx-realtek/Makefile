PKG_NAME = omx-realtek
PKG_VERS = 2.5.0-1656
PKG_EXT = spk
PKG_DIST_NAME = VideoStation-rtd1296-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://global.download.synology.com/download/Package/spk/VideoStation/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/omx-realtek-include cross/omx-realtek-libs

HOMEPAGE = https://archive.synology.com/download
COMMENT  = Realtek OMX hardware acceleration libraries for use with ARMv8 (aarch64) Synology NAS
LICENSE  = unknown

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7_ARCHS) $(ARMv7L_ARCHS) $(x64_ARCHS) $(i686_ARCHS)

EXTRACT_TARGET = nop
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = nop

include ../../mk/spksrc.install-resources.mk
