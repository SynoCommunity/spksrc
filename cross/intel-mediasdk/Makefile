PKG_NAME = intel-mediasdk-main

HOMEPAGE = http://mediasdk.intel.com
COMMENT  = Intel Media SDK provides a plain C API to access hardware-accelerated video decode, encode and filtering on Intel® Gen graphics hardware platforms. Implementation written in C++ 11 with parts in C-for-Media (CM).
LICENSE  = MIT

DOWNLOAD_TARGET = nop
CHECKSUM_TARGET = nop
EXTRACT_TARGET = nop
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = nop

OPTIONAL_DEPENDS  = cross/intel-mediasdk-latest
OPTIONAL_DEPENDS += cross/intel-mediasdk-22.5

include ../../mk/spksrc.install-resources.mk

ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
DEPENDS = cross/intel-mediasdk-latest
else
DEPENDS = cross/intel-mediasdk-22.5
endif
