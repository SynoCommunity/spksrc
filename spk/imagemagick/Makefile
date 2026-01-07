SPK_NAME = imagemagick
SPK_VERS = 7.1.2
SPK_REV = 14
SPK_ICON = src/imagemagick.png

# WARNING: pngquant will fail when built after cross/zlib (i.e. cross/libpng)
DEPENDS  = cross/pngquant
DEPENDS += cross/imagemagick
# additional tools for image compression:
DEPENDS += cross/jpegoptim cross/pngcrush cross/optipng

MAINTAINER = hgy59
DESCRIPTION = ImageMagick is a software suite to create, edit, compose, or convert bitmap images.  This package includes some tools for image compression, that are not part of imagemagick: jpegoptim, a utility to optimize/compress JPEG files; OptiPNG is a PNG optimizer that recompresses image files to a smaller size, without losing any information; pngcrush an optimizer for png files; pngquant for lossy compression of PNG images.
DISPLAY_NAME = ImageMagick
CHANGELOG = "1. Update ImageMagick to v7.1.2-7. <br/>2. Update libheif to support HEIC format of iOS 18+. <br/>3. Add optiPNG png optimizer. "

STARTABLE = no

HOMEPAGE = https://www.imagemagick.org/
LICENSE  = Apache 2.0

POST_STRIP_TARGET = imagemagick_extra_install

SPK_COMMANDS  = bin/magick bin/magick-script bin/animate bin/compare bin/composite bin/conjure
SPK_COMMANDS += bin/convert bin/display bin/identify bin/import bin/mogrify bin/montage bin/stream
# additional tools:
SPK_COMMANDS += bin/jpegoptim
SPK_COMMANDS += bin/optipng
SPK_COMMANDS += bin/pngcrush
SPK_COMMANDS += bin/pngquant

include ../../mk/spksrc.spk.mk

.PHONY: imagemagick_patch_rpath
# some binaries and libraries contain the full installation path in RPATH (.../spk/imagemagick/...)
# this might be caused by incomplete implementation of install_correct_lib_files target in spksrc.install.mk
# or false paths in generated pkgconfig files
imagemagick_patch_rpath:
	@$(MSG) "Patching binaries and libraries of $(SPK_NAME) (some have bad library rpath)."
	@cat $(INSTALL_PLIST) | sed 's/:/ /' | while read type file ; \
	do \
	  case $${type} in \
	    lib|bin) \
	      if [ "$$(objdump -p $(STAGING_DIR)/$${file} 2>/dev/null | grep RPATH | grep spk/$(SPK_NAME))" ]; then \
	         echo -n "Patch rpath in $${file}... " ; \
	         patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/$${file} &> /dev/null && echo "ok." || echo "failed!" ; \
	      fi \
	      ;; \
	  esac ; \
	done

.PHONY: imagemagick_extra_install
imagemagick_extra_install: imagemagick_patch_rpath
	@$(MSG) Install type files for included fonts.
	@install -m 644 src/type-dejavu.xml $(STAGING_DIR)/etc/ImageMagick-7/
	@install -m 644 src/type-windows.xml $(STAGING_DIR)/etc/ImageMagick-7/
	@install -m 644 src/type-urw-base35.xml $(STAGING_DIR)/etc/ImageMagick-7/
	@$(MSG) "Adjust included libtool files (remove $(INSTALL_DIR) in paths)"
	@for la_file in $(wildcard $(STAGING_DIR)/lib/ImageMagick-${SPK_VERS}/modules-Q16HDRI/*/*.la) ; do \
	  sed -e 's#$(INSTALL_DIR)//#/#g' -i $${la_file} ; \
	  sed -e 's#$(INSTALL_DIR)##g' -i $${la_file} ; \
	done
