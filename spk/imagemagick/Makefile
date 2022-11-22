SPK_NAME = imagemagick
SPK_VERS = 7.1.0
SPK_REV = 9
SPK_ICON = src/imagemagick.png

DEPENDS = cross/imagemagick cross/jpegoptim

MAINTAINER = SynoCommunity
DESCRIPTION = ImageMagick is a software suite to create, edit, compose, or convert bitmap images. This package includes jpegoptim, a utility to optimize/compress JPEG files, that is not part of imagemagick.
DISPLAY_NAME = ImageMagick
CHANGELOG = "1. Update ImageMagick to v7.1.0-52 and jpegoptim to v1.5.0.<br/>2. Add DejaVu fonts.<br/>3. Update OpenJPEG library to v2.5.0.<br/>4. Add libraries to support additional image formats: Raw, OpenEXR, SVG."

STARTABLE = no

HOMEPAGE = https://www.imagemagick.org/
LICENSE  = Apache 2.0

POST_STRIP_TARGET = imagemagick_extra_install

SPK_COMMANDS  = bin/magick bin/magick-script bin/animate bin/compare bin/composite bin/conjure
SPK_COMMANDS += bin/convert bin/display bin/identify bin/import bin/mogrify bin/montage bin/stream
# additional tools:
SPK_COMMANDS += bin/jpegoptim

include ../../mk/spksrc.spk.mk

SUPPORT_CPP11 = 1
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
SUPPORT_CPP11 = 0
endif
ifeq ($(call version_lt, $(TCVERSION), 6.0)$(call version_ge, $(TCVERSION), 3.0),11)
SUPPORT_CPP11 = 0
endif

.PHONY: imagemagick_extra_install
imagemagick_extra_install:
	@$(MSG) Install type files for included fonts.
	@install -m 644 src/type-dejavu.xml $(STAGING_DIR)/etc/ImageMagick-7/
	@install -m 644 src/type-windows.xml $(STAGING_DIR)/etc/ImageMagick-7/
	@install -m 644 src/type-urw-base35.xml $(STAGING_DIR)/etc/ImageMagick-7/
	@$(MSG) Adjust included libtool files
	@for la_file in $(wildcard $(STAGING_DIR)/lib/ImageMagick-7.1.0/modules-Q16HDRI/*/*.la) ; do \
	  sed -i -e 's#$(INSTALL_DIR)##g' $${la_file} ; \
	done
	@$(MSG) "Set library runpath in lib and bin files with bad library rpath."
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/cwebp
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/dwebp
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/fc-cache
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/fc-cat
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/fc-conflist
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/fc-list
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/fc-match
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/fc-pattern
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/fc-query
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/fc-scan
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/fc-validate
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/magick
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/wmf2eps
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/wmf2fig
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/wmf2gd
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/wmf2svg
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/xmlcatalog
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/xmllint
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/lib/libMagickCore-7.Q16HDRI.so.10.0.0
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/lib/libMagickWand-7.Q16HDRI.so.10.0.0
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/lib/libdjvulibre.so.21.7.0
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/lib/libfontconfig.so.1.12.0
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/lib/libfreetype.so.6.18.3
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/lib/libwmf-0.2.so.7.1.0
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/lib/libxml2.so.2.9.12
ifeq ($(SUPPORT_CPP11),1)
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/pango-view
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/rsvg-convert
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/lib/libIlmImf-2_5.so.26.0.0
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/lib/libIlmImfUtil-2_5.so.26.0.0
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/lib/libcairo-gobject.so.2.11600.0
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/lib/libcairo-script-interpreter.so.2.11600.0
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/lib/libcairo.so.2.11600.0
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/lib/libcroco-0.6.so.3.0.1
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/lib/libheif.so.1.12.0
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/lib/libjasper.so.6.0.0
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/lib/libpangocairo-1.0.so.0.3800.1
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/lib/libpangoft2-1.0.so.0.3800.1
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/lib/libraqm.so.0.700.0
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/lib/libraw_r.so.20.0.0
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/lib/librsvg-2.so.2.40.21
endif
