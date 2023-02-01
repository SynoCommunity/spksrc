PKG_NAME = omx-realtek-include
PKG_VERS = DSM-6.1
PKG_EXT = tgz
PKG_DIST_NAME = VideoStation-rtd1296.$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Packages/DSM%206.1%20Package%20Release
PKG_DIR = gst-omx-virtual-video-station

DEPENDS =

HOMEPAGE = https://archive.synology.com/download
COMMENT  = Realtek OMX hardware acceleration libraries for use with ARMv8 (aarch64) Synology NAS
LICENSE  = unknown

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7_ARCHS) $(ARMv7L_ARCHS) $(x64_ARCHS) $(i686_ARCHS)

INSTALL_TARGET = omx-realtek_install

include ../../mk/spksrc.install-resources.mk

.PHONY: omx-realtek_install
omx-realtek_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/include/omx/khronos
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR)/omx/khronos . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/include/omx/khronos
	chmod 644 $(STAGING_INSTALL_PREFIX)/include/omx/khronos/*.h
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/omx/realtek_omx.h $(STAGING_INSTALL_PREFIX)/include/omx
