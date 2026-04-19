
# Set default ffmpeg package name
ifeq ($(strip $(FFMPEG_PACKAGE)),)
  FFMPEG_PACKAGE = ffmpeg7
endif

# set default spk/ffmpeg* path to use
FFMPEG_PACKAGE_DIR = $(abspath $(CURDIR)/../../spk/$(FFMPEG_PACKAGE))
FFMPEG_PACKAGE_WORK_DIR = $(FFMPEG_PACKAGE_DIR)/work-$(ARCH)-$(TCVERSION)

FFMPEG_DEPENDS += cross/$(FFMPEG_PACKAGE)
META_DEPENDS += $(FFMPEG_DEPENDS)
OPTIONAL_DEPENDS += $(FFMPEG_DEPENDS)

# Re-use all default ffmpeg mandatory libraries
FFMPEG_PC  = libavcodec.pc
FFMPEG_PC += libavfilter.pc
FFMPEG_PC += libavformat.pc
FFMPEG_PC += libavutil.pc
FFMPEG_PC += libpostproc.pc
FFMPEG_PC += libswresample.pc
FFMPEG_PC += libswscale.pc
# Also include openssl
FFMPEG_PC += libssl.pc
FFMPEG_PC += openssl.pc

# Create symbolic links against:
#    - any other pkg_config files defined using $(MEDIA_LIBS) - see cross/tvheadend
.PHONY: FFMPEG_meta
ifneq ($(wildcard $(FFMPEG_PACKAGE_WORK_DIR)),)
FFMPEG_meta:
	@mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
	@$(foreach lib,$(addprefix $(FFMPEG_STAGING_INSTALL_PREFIX)/lib/pkgconfig/,$(MEDIA_LIBS)),ln -sf $(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)
else
FFMPEG_meta: ;
endif

ifneq ($(and $(wildcard $(FFMPEG_PACKAGE_WORK_DIR)),$(filter spk-stage2,$(MAKECMDGOALS))),)
  export FFMPEG_PACKAGE
  export FFMPEG_PACKAGE_DIR
  export FFMPEG_PACKAGE_WORK_DIR
  export FFMPEG_DEPENDS
  export FFMPEG_LIBS
  $(eval $(call SPK_BASE_TEMPLATE,FFMPEG))
else
  DEPENDS += $(FFMPEG_DEPENDS)
endif
