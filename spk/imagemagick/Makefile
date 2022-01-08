SPK_NAME = imagemagick
SPK_VERS = 7.1.0
SPK_REV = 7
SPK_ICON = src/imagemagick.png

DEPENDS = cross/imagemagick cross/jpegoptim

MAINTAINER = SynoCommunity
DESCRIPTION = ImageMagick is a software suite to create, edit, compose, or convert bitmap images. This package includes jpegoptim, a utility to optimize/compress JPEG files, that is not part of imagemagick.
DISPLAY_NAME = ImageMagick
CHANGELOG = "1. Update ImageMagick to v7.1.0-19.<br/>2. Add jemalloc memory allocation library.<br/>3. Add webp image format for ARM64 packages."

STARTABLE = no

HOMEPAGE = https://www.imagemagick.org/
LICENSE  = Apache 2.0


POST_STRIP_TARGET = imagemagick_extra_install

SPK_COMMANDS  = bin/magick bin/magick-script bin/animate bin/compare bin/composite bin/conjure
SPK_COMMANDS += bin/convert bin/display bin/identify bin/import bin/mogrify bin/montage bin/stream
# additional tools:
SPK_COMMANDS += bin/jpegoptim

include ../../mk/spksrc.spk.mk

.PHONY: imagemagick_extra_install
# install type files for included fonts
imagemagick_extra_install:
	@install -m 644 src/type-windows.xml $(STAGING_DIR)/etc/ImageMagick-7/
	@install -m 644 src/type-urw-base35.xml $(STAGING_DIR)/etc/ImageMagick-7/
