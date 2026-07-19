###############################################################################
# spksrc.rules/pre-check.mk
#
# Common requirement checks
#
# Variables:
#  BUILD_UNSUPPORTED_FILE  Set by github build action to collect
#                          and suppress errors for unsupported packages.
#  REQUIRED_MIN_DSM        Set to define minimal supported DSM version for a package.
#  REQUIRED_MAX_DSM        Set to define maximal supported DSM version for a package.
#  REQUIRED_MIN_SRM        Set to define minimal supported SRM version for a package.
#  INSTALLER_SCRIPT        Used before introduction of generic installer. Not recommended anymore,
#                          use SERVICE_SETUP instead, this includes support for DSM >= 7.
#
###############################################################################

# disable checks for dependency targets
ifneq ($(DEPENDENCY_WALK),1)

# SPK_FOLDER    
# name of the spk package folder
# github status check does not rely on the (SPK) NAME but uses the folder name
# required for packages that have folder name different to SPK_NAME (sonarr -> nzbget, mono_58 -> mono)
SPK_FOLDER = $(notdir $(CURDIR))

# A package is disabled by dropping a BROKEN or DISABLED file in its folder
# (both are treated identically).
ifneq ($(strip $(wildcard BROKEN) $(wildcard DISABLED)),)
  ifneq ($(BUILD_UNSUPPORTED_FILE),)
    $(shell echo $(date --date=now +"%Y.%m.%d %H:%M:%S") - $(SPK_FOLDER): Broken package >> $(BUILD_UNSUPPORTED_FILE))
  endif
  @$(error $(NAME): Broken package)
endif

# Check for build for generic archs, these are not supporting by default 'require kernel'.
# Unless building kernel modules where a package will contain multiple kernel sub-architectures and versions.
ifneq ($(REQUIRE_KERNEL),)
  ifeq ($(REQUIRE_KERNEL_MODULE),)
    ifneq (,$(findstring $(ARCH),$(GENERIC_ARCHS)))
      ifneq ($(BUILD_UNSUPPORTED_FILE),)
        $(shell echo $(date --date=now +"%Y.%m.%d %H:%M:%S") - $(SPK_FOLDER): Generic arch '$(ARCH)' cannot be used when REQUIRE_KERNEL is set unless using REQUIRE_KERNEL_MODULE >> $(BUILD_UNSUPPORTED_FILE))
      endif
      @$(error Generic arch '$(ARCH)' cannot be used when REQUIRE_KERNEL is set unless using REQUIRE_KERNEL_MODULE)
    endif
  endif
endif

# Refuse an arch whose toolchain cannot meet MIN_GCC_VERSION / MIN_GLIBC_VERSION
# (see spksrc.common/tc-capability.mk). Says why, not just where.
ifneq ($(strip $(TC_CAPABILITY_UNSUPPORTED)),)
  ifneq (,$(BUILD_UNSUPPORTED_FILE))
    $(shell echo $(date --date=now +"%Y.%m.%d %H:%M:%S") - $(SPK_FOLDER): Arch '$(ARCH)-$(TCVERSION)' unsupported: $(TC_CAPABILITY_UNSUPPORTED) >> $(BUILD_UNSUPPORTED_FILE))
  endif
  @$(error Arch '$(ARCH)-$(TCVERSION)' is not supported by $(SPK_NAME)$(PKG_NAME): $(TC_CAPABILITY_UNSUPPORTED))
endif

# Check whether package supports ARCH
ifneq ($(UNSUPPORTED_ARCHS),)
  ifneq (,$(findstring $(ARCH),$(UNSUPPORTED_ARCHS)))
    ifneq (,$(BUILD_UNSUPPORTED_FILE))
      $(shell echo $(date --date=now +"%Y.%m.%d %H:%M:%S") - $(SPK_FOLDER): Arch '$(ARCH)' is not a supported architecture >> $(BUILD_UNSUPPORTED_FILE))
    endif
    @$(error Arch '$(ARCH)' is not a supported architecture)
  endif
endif

# Refuse a 32-bit arch for a package that requires 64-bit (REQUIRE_64BIT = 1).
# A capability-style declaration -- the package states it needs a 64-bit target
# rather than enumerating the 32-bit archs it cannot run on.
#
# Guarded on a non-empty ARCH: an empty ARCH is not in $(64bit_ARCHS) either, so
# without this the arch-less passes (the source download step, which fetches the
# arch-independent tarball) would abort here. UNSUPPORTED_ARCHS is immune by
# construction -- findstring of an empty needle never matches -- so match it.
ifeq ($(strip $(REQUIRE_64BIT)),1)
  ifneq ($(strip $(ARCH)),)
  ifeq (,$(findstring $(ARCH),$(64bit_ARCHS)))
    ifneq (,$(BUILD_UNSUPPORTED_FILE))
      $(shell echo $(date --date=now +"%Y.%m.%d %H:%M:%S") - $(SPK_FOLDER): Arch '$(ARCH)' requires a 64-bit architecture >> $(BUILD_UNSUPPORTED_FILE))
    endif
    @$(error Arch '$(ARCH)' is not supported by $(SPK_NAME)$(PKG_NAME): requires a 64-bit architecture)
  endif
  endif
endif

ifneq ($(TCVERSION),)

ifneq ($(UNSUPPORTED_ARCHS_TCVERSION),)
  ifneq (,$(findstring $(ARCH)-$(TCVERSION),$(UNSUPPORTED_ARCHS_TCVERSION)))
    ifneq (,$(BUILD_UNSUPPORTED_FILE))
      $(shell echo $(date --date=now +"%Y.%m.%d %H:%M:%S") - $(SPK_FOLDER): Arch '$(ARCH)-$(TCVERSION)' is not a supported architecture >> $(BUILD_UNSUPPORTED_FILE))
    endif
    @$(error Arch '$(ARCH)-$(TCVERSION)' is not a supported architecture)
  endif
endif

ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
  ifneq ($(strip $(INSTALLER_SCRIPT)),)
    ifneq ($(BUILD_UNSUPPORTED_FILE),)
      $(shell echo $(date --date=now +"%Y.%m.%d %H:%M:%S") - $(SPK_FOLDER): INSTALLER_SCRIPT '$(INSTALLER_SCRIPT)' cannot be used for DSM ${TCVERSION} >> $(BUILD_UNSUPPORTED_FILE))
    endif
    @$(error INSTALLER_SCRIPT '$(INSTALLER_SCRIPT)' cannot be used for DSM ${TCVERSION})
  endif
endif

# Check maximal DSM requirements of package
ifneq ($(REQUIRED_MAX_DSM),)
  ifeq ($(call version_ge, ${TCVERSION}, 3.0),1)
    ifneq ($(TCVERSION),$(firstword $(sort $(TCVERSION) $(REQUIRED_MAX_DSM))))
      ifneq (,$(BUILD_UNSUPPORTED_FILE))
        $(shell echo $(date --date=now +"%Y.%m.%d %H:%M:%S") - $(SPK_FOLDER): DSM Toolchain $(TCVERSION) is higher than $(REQUIRED_MAX_DSM) >> $(BUILD_UNSUPPORTED_FILE))
      endif
      @$(error DSM Toolchain $(TCVERSION) is higher than $(REQUIRED_MAX_DSM))
    endif
  endif
endif

# Check minimum DSM requirements of package
ifneq ($(REQUIRED_MIN_DSM),)
  ifeq ($(call version_ge, ${TCVERSION}, 3.0),1)
    ifneq ($(REQUIRED_MIN_DSM),$(firstword $(sort $(TCVERSION) $(REQUIRED_MIN_DSM))))
      ifneq (,$(BUILD_UNSUPPORTED_FILE))
        $(shell echo $(date --date=now +"%Y.%m.%d %H:%M:%S") - $(SPK_FOLDER): DSM Toolchain $(TCVERSION) is lower than $(REQUIRED_MIN_DSM) >> $(BUILD_UNSUPPORTED_FILE))
      endif
      @$(error DSM Toolchain $(TCVERSION) is lower than $(REQUIRED_MIN_DSM))
    endif
  endif
endif

# Check minimum SRM requirements of package
ifneq ($(REQUIRED_MIN_SRM),)
  ifeq ($(call version_lt, ${TCVERSION}, 3.0),1)
    ifneq ($(REQUIRED_MIN_SRM),$(firstword $(sort $(TCVERSION) $(REQUIRED_MIN_SRM))))
      ifneq (,$(BUILD_UNSUPPORTED_FILE))
        $(shell echo $(date --date=now +"%Y.%m.%d %H:%M:%S") - $(SPK_FOLDER): SRM Toolchain $(TCVERSION) is lower than $(REQUIRED_MIN_SRM) >> $(BUILD_UNSUPPORTED_FILE))
      endif
      @$(error SRM Toolchain $(TCVERSION) is lower than $(REQUIRED_MIN_SRM))
    endif
  endif
endif

endif # ifneq ($(TCVERSION),)

endif # ifneq ($(DEPENDENCY_WALK),1)
