PKG_NAME = intel-gmmlib-main

HOMEPAGE = https://github.com/intel/gmmlib
COMMENT  = Intel Graphics Memory Management Library provides device specific and buffer management for the Intel Graphics Compute Runtime for OpenCL and the Intel Media Driver for VAAPI.
LICENSE  = MIT

DOWNLOAD_TARGET = nop
CHECKSUM_TARGET = nop
EXTRACT_TARGET = nop
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = nop

OPTIONAL_DEPENDS  = cross/intel-gmmlib-latest
OPTIONAL_DEPENDS += cross/intel-gmmlib-22.3

include ../../mk/spksrc.install-resources.mk

ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
DEPENDS = cross/intel-gmmlib-latest
else
DEPENDS = cross/intel-gmmlib-22.3
endif
