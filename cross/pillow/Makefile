PKG_NAME = pillow
PKG_VERS = 11.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/p/pillow
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/freetype cross/libimagequant cross/libjpeg
DEPENDS += cross/libtiff cross/libwebp cross/zlib

HOMEPAGE = https://github.com/pyca/cryptography
COMMENT  = Provide cryptographic recipes and primitives to Python developers
LICENSE  = BSD/ASL2

WHEELS_BUILD_ARGS  = -C platform-guessing=disable
WHEELS_BUILD_ARGS += -C freetype=enable
WHEELS_BUILD_ARGS += -C imagequant=enable
WHEELS_BUILD_ARGS += -C jpeg=enable
WHEELS_BUILD_ARGS += -C tiff=enable
WHEELS_BUILD_ARGS += -C webp=enable
WHEELS_BUILD_ARGS += -C zlib=enable

#WHEELS_BUILD_ARGS += -C raqm=enable
#WHEELS_BUILD_ARGS += -C lcms=enable
#WHEELS_BUILD_ARGS += -C jpeg2000=enable
#WHEELS_BUILD_ARGS += -C xcb=enable

include ../../mk/spksrc.python-wheel.mk
