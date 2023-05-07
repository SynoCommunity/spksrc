PKG_NAME = libva-main

HOMEPAGE = https://01.org/vaapi
COMMENT  = Libva is an implementation for VA-API (Video Acceleration API).
LICENSE  = MIT

DOWNLOAD_TARGET = nop
CHECKSUM_TARGET = nop
EXTRACT_TARGET = nop
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = nop

OPTIONAL_DEPENDS  = cross/libva-latest
OPTIONAL_DEPENDS += cross/libva-2.17

include ../../mk/spksrc.install-resources.mk

ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
DEPENDS = cross/libva-latest
else
DEPENDS = cross/libva-2.17
endif
