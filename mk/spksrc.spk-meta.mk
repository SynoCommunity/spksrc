# -------------------------------------------------------------------
# spksrc.spk-meta.mk
# Meta-SPK wrapper for optional package inclusions (ffmpeg, videodriver, python)
# -------------------------------------------------------------------

# Common makefiles
include ../../mk/spksrc.common.mk

ifneq ($(filter spk-stage2,$(MAKECMDGOALS)),)
  include ../../mk/spksrc.spk-meta/base.mk
endif

##

ifdef PYTHON_PACKAGE
  include ../../mk/spksrc.spk-meta/python.mk
endif

ifdef FFMPEG_PACKAGE
  include ../../mk/spksrc.spk-meta/ffmpeg.mk
  FFMPEG_RPATH := $(shell readelf -d $(FFMPEG_STAGING_INSTALL_PREFIX)/bin/ffmpeg 2>/dev/null | grep -E 'RPATH|RUNPATH')
endif

ifneq ($(or $(findstring synocli-videodriver,$(FFMPEG_RPATH)),$(VIDEODRV_PACKAGE)),)
  include ../../mk/spksrc.spk-meta/videodriver.mk
endif

# -------------------------------------------------------------------
# Include main SPK rules in all cases
# -------------------------------------------------------------------
include ../../mk/spksrc.spk.mk
