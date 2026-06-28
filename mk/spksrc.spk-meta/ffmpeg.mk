
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

# Build the meta source spk/$(FFMPEG_PACKAGE) in spk-stage1 so its work dir
# exists for the stage2 SPK_BASE_TEMPLATE parse.
BUILD_DEPENDS := $(call uniq,spk/$(FFMPEG_PACKAGE) $(BUILD_DEPENDS))

# $(1)_meta hook required by base.mk; no extra action for this meta.
.PHONY: FFMPEG_meta
FFMPEG_meta: ;

# Export the meta package name (read by consumers / sub-makes).
export FFMPEG_PACKAGE

# Share the meta's libraries at spk-stage2 (its work dir is built by stage1).
ifneq ($(and $(wildcard $(FFMPEG_PACKAGE_WORK_DIR)),$(filter spk-stage2,$(MAKECMDGOALS))),)
  export FFMPEG_PACKAGE_WORK_DIR
  $(eval $(call SPK_BASE_TEMPLATE,FFMPEG))
endif
