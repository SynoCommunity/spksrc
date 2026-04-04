# -------------------------------------------------------------------
# spksrc.spk-meta.mk
# Meta-SPK wrapper for optional package inclusions (ffmpeg, videodriver, python)
# -------------------------------------------------------------------

# Common makefiles
include ../../mk/spksrc.common.mk

ifneq ($(filter spk-stage2,$(MAKECMDGOALS)),)
  include ../../mk/spksrc.spk/base.mk
endif

ifdef FFMPEG_PACKAGE
  include ../../mk/spksrc.spk/ffmpeg.mk
endif

ifdef PYTHON_PACKAGE
  include ../../mk/spksrc.spk/python.mk
endif

ifdef VIDEODRV_PACKAGE
  include ../../mk/spksrc.spk/videodriver.mk
endif

# -------------------------------------------------------------------
# Include main SPK rules in all cases
# -------------------------------------------------------------------
include ../../mk/spksrc.spk.mk
