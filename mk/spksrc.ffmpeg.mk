###
### Reuse videodriver libraries
###
# Variables:
#  FFMPEG_PACKAGE      Must be set to the ffmpeg spk folder (ffmpeg5, ffmpeg6, ...)

# Set videodriver package name
ifeq ($(strip $(FFMPEG_PACKAGE)),)
export FFMPEG_PACKAGE = ffmpeg6
endif

# set default spk/synocli-videodriver path to use
export FFMPEG_PACKAGE_ROOT = $(realpath $(CURDIR)/../../spk/$(FFMPEG_PACKAGE)/work-$(ARCH)-$(TCVERSION))

include ../../mk/spksrc.archs.mk

ifneq ($(wildcard $(FFMPEG_PACKAGE_ROOT)),)

# Set videodriver installtion prefix directory variables
ifeq ($(strip $(FFMPEG_STAGING_PREFIX)),)
export FFMPEG_PREFIX = /var/packages/$(FFMPEG_PACKAGE)/target
export FFMPEG_STAGING_PREFIX = $(realpath $(FFMPEG_PACKAGE_ROOT)/install/$(FFMPEG_PREFIX))
endif

# set build flags including ld to rewrite for the library path
# used to access ffmpeg package provide libraries at destination
ifneq ($(strip $(FFMPEG_STAGING_PREFIX)),)
export ADDITIONAL_CFLAGS   += -I$(FFMPEG_STAGING_PREFIX)/include
export ADDITIONAL_CPPFLAGS += -I$(FFMPEG_STAGING_PREFIX)/include
export ADDITIONAL_CXXFLAGS += -I$(FFMPEG_STAGING_PREFIX)/include
export ADDITIONAL_LDFLAGS  += -L$(FFMPEG_STAGING_PREFIX)/lib
export ADDITIONAL_LDFLAGS  += -Wl,--rpath-link,$(FFMPEG_STAGING_PREFIX)/lib -Wl,--rpath,$(FFMPEG_PREFIX)/lib

# Re-use all default ffmpeg mandatory libraries
FFMPEG_LIBS  = libavcodec.pc
FFMPEG_LIBS += libavfilter.pc
FFMPEG_LIBS += libavformat.pc
FFMPEG_LIBS += libpostproc.pc
FFMPEG_LIBS += libavutil.pc
FFMPEG_LIBS += libswresample.pc
FFMPEG_LIBS += libswscale.pc
endif

# call-up pre-depend to prepare the shared ffmpeg build environment
PRE_DEPEND_TARGET = ffmpeg_pre_depend

else
BUILD_DEPENDS += cross/$(FFMPEG_PACKAGE)
CMAKE_RPATH =
endif

include ../../mk/spksrc.videodriver.mk

.PHONY: ffmpeg_pre_depend

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
# Also call-up videodriver pre-depend for remaining dependencies
ffmpeg_pre_depend: videodrv_pre_depend
else
ffmpeg_pre_depend:
endif
	@$(MSG) "*****************************************************"
	@$(MSG) "*** Use existing shared objects from ffmpeg $(FFMPEG_VERSION)"
	@$(MSG) "*** PATH: $(FFMPEG_PACKAGE_ROOT)"
	@$(MSG) "*****************************************************"
	@mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
	@$(foreach lib,$(FFMPEG_LIBS),ln -sf $(FFMPEG_STAGING_PREFIX)/lib/pkgconfig/$(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)
	@$(foreach lib,$(MEDIA_LIBS),ln -sf $(FFMPEG_STAGING_PREFIX)/lib/pkgconfig/$(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)
