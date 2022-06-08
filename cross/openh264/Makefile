PKG_NAME = openh264
PKG_VERS = 2.3.0
PKG_EXT = tar.gz
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
#PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
#PKG_DIST_SITE = https://github.com/cisco/openh264/archive/refs/tags
#PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
# git hash from June 5th 2022 - preparation for 2.3 tag
PKG_GIT_HASH = 8fe55e3f4accac7fd1af4262bcd6eff5d008396d
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_GIT_HASH)
PKG_DIST_SITE = https://github.com/cisco/openh264/archive

DEPENDS = 

HOMEPAGE = http://www.openh264.org/
COMMENT  = OpenH264 is a codec library which supports H.264 encoding and decoding. It is suitable for use in real time applications such as WebRTC.
LICENSE  = BSD

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

CONFIGURE_ARGS += -Dtests=disabled

POST_INSTALL_TARGET = openh264_post-install

BUILD_DEPENDS = native/nasm
NASM_PATH = $(realpath $(WORK_DIR)/../../../native/nasm/work-native/install/usr/local/bin)
ENV += PATH=$(NASM_PATH):$$PATH
ENV += AS=$(NASM_PATH)/nasm

include ../../mk/spksrc.cross-meson.mk

.PHONY: openh264_post-install
openh264_post-install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/builddir/codec/console/dec/h264dec $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/builddir/codec/console/enc/h264enc $(STAGING_INSTALL_PREFIX)/bin
