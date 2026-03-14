
# Set default ffmpeg package name
ifeq ($(strip $(FFMPEG_PACKAGE)),)
  FFMPEG_PACKAGE = ffmpeg7
endif

# set default spk/ffmpeg* path to use
FFMPEG_PACKAGE_DIR = $(realpath $(CURDIR)/../../spk/$(FFMPEG_PACKAGE))
FFMPEG_PACKAGE_WORK_DIR = $(FFMPEG_PACKAGE_DIR)/work-$(ARCH)-$(TCVERSION)

FFMPEG_DEPENDS += cross/$(FFMPEG_PACKAGE)
META_DEPENDS += $(FFMPEG_DEPENDS)

# Re-use all default ffmpeg mandatory libraries
FFMPEG_PC  = libavcodec.pc
FFMPEG_PC += libavfilter.pc
FFMPEG_PC += libavformat.pc
FFMPEG_PC += libavutil.pc
FFMPEG_PC += libpostproc.pc
FFMPEG_PC += libswresample.pc
FFMPEG_PC += libswscale.pc

# Always export these variables - they use deferred expansion so
# they will resolve correctly at recipe execution time even when
# FFMPEG_PACKAGE is set conditionally after include.
export FFMPEG_PACKAGE
export FFMPEG_PACKAGE_DIR
export FFMPEG_PACKAGE_WORK_DIR
export FFMPEG_DEPENDS
export FFMPEG_LIBS

# Create symbolic links against:
#    - any other pkg_config files defined using $(MEDIA_LIBS) - see cross/tvheadend
.PHONY: FFMPEG_meta
FFMPEG_meta:
	@$(MSG) =====================================================
	@$(MSG) ffmpeg_pre_depend
	@$(MSG) =====================================================
	@# EXCEPTION: Some package links against other manually speficied media libraries provided by ffmpeg (i.e. tvheadend)
	@$(foreach lib,$(MEDIA_LIBS),ln -sf $(FFMPEG_STAGING_INSTALL_PREFIX)/lib/pkgconfig/$(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)

$(eval $(call SPK_BASE_TEMPLATE,FFMPEG))
