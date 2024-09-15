###
### Reuse videodriver libraries
###

# Set videodriver package name
ifeq ($(strip $(VIDEODRV_PACKAGE)),)
VIDEODRV_PACKAGE = synocli-videodriver
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
export ADDITIONAL_CFLAGS   += -I$(VIDEODRV_STAGING_PREFIX)/include
export ADDITIONAL_CPPFLAGS += -I$(VIDEODRV_STAGING_PREFIX)/include
export ADDITIONAL_CXXFLAGS += -I$(VIDEODRV_STAGING_PREFIX)/include
export ADDITIONAL_LDFLAGS  += -L$(VIDEODRV_STAGING_PREFIX)/lib
export ADDITIONAL_LDFLAGS  += -Wl,--rpath-link,$(VIDEODRV_STAGING_PREFIX)/lib -Wl,--rpath,$(VIDEODRV_PREFIX)/lib

# Re-use all default videodrv mandatory libraries
VIDEODRV_LIBS := $(wildcard $(VIDEODRV_STAGING_PREFIX)/lib/pkgconfig/*.pc)

# Re-use all videodrv dependencies and mark as already done
VIDEODRV_DEPENDS := $(foreach cross,$(foreach pkg_name,$(shell $(MAKE) dependency-list -C $(realpath $(VIDEODRV_PACKAGE_ROOT)/../) 2>/dev/null | grep ^$(VIDEODRV_PACKAGE) | cut -f2 -d:),$(shell sed -n 's/^PKG_NAME = \(.*\)/\1/p' $(realpath $(CURDIR)/../../$(pkg_name)/Makefile))),$(wildcard $(VIDEODRV_PACKAGE_ROOT)/.$(cross)-*_done))

# call-up pre-depend to prepare the shared videodrv build environment
PRE_DEPEND_TARGET = videodrv_pre_depend

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
	@$(foreach lib,$(VIDEODRV_LIBS),ln -sf $(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)
	@$(foreach _done,$(VIDEODRV_DEPENDS), ln -sf $(_done) $(WORK_DIR) ;)
