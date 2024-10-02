###
### Reuse videodriver libraries
###

# Set videodriver package name
ifeq ($(strip $(VIDEODRV_PACKAGE)),)
export VIDEODRV_PACKAGE = synocli-videodriver
endif

# set default spk/synocli-videodriver path to use
VIDEODRV_PACKAGE_ROOT = $(realpath $(CURDIR)/../../spk/$(VIDEODRV_PACKAGE)/work-$(ARCH)-$(TCVERSION))

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))

# Set videodriver installtion prefix directory variables
ifeq ($(strip $(VIDEODRV_STAGING_PREFIX)),)
export VIDEODRV_PREFIX = /var/packages/$(VIDEODRV_PACKAGE)/target
export VIDEODRV_STAGING_PREFIX = $(realpath $(VIDEODRV_PACKAGE_ROOT)/install/$(VIDEODRV_PREFIX))
endif

# set build flags including ld to rewrite for the library path
# used to access videodrv package provide libraries at destination
ifneq ($(strip $(VIDEODRV_STAGING_PREFIX)),)
export ADDITIONAL_CFLAGS   += -I$(VIDEODRV_STAGING_PREFIX)/include
export ADDITIONAL_CPPFLAGS += -I$(VIDEODRV_STAGING_PREFIX)/include
export ADDITIONAL_CXXFLAGS += -I$(VIDEODRV_STAGING_PREFIX)/include
export ADDITIONAL_LDFLAGS  += -L$(VIDEODRV_STAGING_PREFIX)/lib
export ADDITIONAL_LDFLAGS  += -Wl,--rpath-link,$(VIDEODRV_STAGING_PREFIX)/lib -Wl,--rpath,$(VIDEODRV_PREFIX)/lib

# videodrv library to share with other packages
VIDEODRV_PKGCFG  = igc-opencl.pc
VIDEODRV_PKGCFG += igdgmm.pc
VIDEODRV_PKGCFG += igfxcmrt.pc
VIDEODRV_PKGCFG += level-zero.pc
VIDEODRV_PKGCFG += libdrm_amdgpu.pc
VIDEODRV_PKGCFG += libdrm_intel.pc
VIDEODRV_PKGCFG += libdrm.pc
VIDEODRV_PKGCFG += libdrm_radeon.pc
VIDEODRV_PKGCFG += libmfxhw64.pc
VIDEODRV_PKGCFG += libmfx.pc
VIDEODRV_PKGCFG += libva-drm.pc
VIDEODRV_PKGCFG += libva.pc
VIDEODRV_PKGCFG += libze_loader.pc
VIDEODRV_PKGCFG += mfx.pc
VIDEODRV_PKGCFG += ocl-icd.pc
VIDEODRV_PKGCFG += OpenCL.pc
VIDEODRV_PKGCFG += pciaccess.pc
VIDEODRV_PKGCFG += SPIRV-Tools.pc
VIDEODRV_PKGCFG += SPIRV-Tools-shared.pc
VIDEODRV_PKGCFG += vpl.pc

# Re-use a default subset of videodrv mandatory libraries
# This avoids sharing other built-in such as zlib and al
# To share everything: $(wildcard $(VIDEODRV_STAGING_PREFIX)/lib/pkgconfig/*.pc)
VIDEODRV_LIBS := $(wildcard $(patsubst %.pc,$(VIDEODRV_STAGING_PREFIX)/lib/pkgconfig/%.pc, $(VIDEODRV_PKGCFG)))
endif

# call-up pre-depend to prepare the shared videodrv build environment
ifeq ($(strip $(PRE_DEPEND_TARGET)),)
PRE_DEPEND_TARGET = videodrv_pre_depend
endif

# end ifeq $(x64_ARCHS)
endif

include ../../mk/spksrc.spk.mk

.PHONY: videodrv_pre_depend
videodrv_pre_depend:
	@$(MSG) "*****************************************************"
	@$(MSG) "*** Use existing shared objects from videodrv $(VIDEODRV_VERSION)"
	@$(MSG) "*** PATH: $(VIDEODRV_PACKAGE_ROOT)"
	@$(MSG) "*****************************************************"
	@mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
	$(MSG) VIDEODRV_LIBS: $(VIDEODRV_LIBS)
	@$(foreach lib,$(VIDEODRV_LIBS),ln -sf $(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)
