# -------------------------------------------------------------------
# spksrc.spk-meta.mk
# Meta-SPK wrapper for optional package inclusions (ffmpeg, videodriver, python)
# -------------------------------------------------------------------

# Common makefiles
include ../../mk/spksrc.common.mk

ifneq ($(ARCH),)
ARCH_SUFFIX = -$(ARCH)-$(TCVERSION)
endif

include ../../mk/spksrc.directories.mk

ifneq ($(filter spk-stage2,$(MAKECMDGOALS)),)
  include ../../mk/spksrc.spk/base.mk

  ifdef FFMPEG_PACKAGE
    include ../../mk/spksrc.spk/ffmpeg.mk

    # Videodriver only for x64 architectures
    ifneq ($(findstring $(ARCH),$(x64_ARCHS)),)
      include ../../mk/spksrc.spk/videodriver.mk
    endif
  endif

  ifdef PYTHON_PACKAGE
    include ../../mk/spksrc.spk/python.mk
  endif

endif # ifeq stage2

# -------------------------------------------------------------------
# Include main SPK rules in all cases
# -------------------------------------------------------------------
include ../../mk/spksrc.spk.mk
