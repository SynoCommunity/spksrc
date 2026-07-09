###############################################################################
# spksrc.spk-meta.mk
#
# Meta-consumer SPK entry point: sets up the optional ffmpeg / python /
# videodriver meta(s) for the package, then includes spksrc.spk.mk.
###############################################################################

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
  # Only an indirect dependency when pulled in through the ffmpeg rpath
  # (consumer did not declare VIDEODRV_PACKAGE itself): share the build
  # objects but don't register it in install_dep_packages — the ffmpeg
  # meta already carries the version-pinned videodriver dependency.
  ifeq ($(strip $(VIDEODRV_PACKAGE)),)
    VIDEODRV_INDIRECT_DEPENDS = 1
  endif
  include ../../mk/spksrc.spk-meta/videodriver.mk
endif

# -------------------------------------------------------------------
# Include main SPK rules in all cases
# -------------------------------------------------------------------
include ../../mk/spksrc.spk.mk
