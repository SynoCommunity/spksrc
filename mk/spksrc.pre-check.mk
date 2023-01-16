# Common requirement checks
# Variables:
#  BUILD_UNSUPPORTED_FILE  Set by github build action to collect 
#                          and suppress errors for unsupported packages.
#  REQUIRED_MIN_DSM        Set to define minimal supported DSM version for a package.
#  REQUIRED_MAX_DSM        Set to define maximal supported DSM version for a package.
#  REQUIRED_MIN_SRM        Set to define minimal supported SRM version for a package.
#  INSTALLER_SCRIPT        Used before introduction of generic installer. Not recommended anymore,
#                          use SERVICE_SETUP instead, this includes support for DSM >= 7.
#

# SPK_FOLDER    
# name of the spk package folder
# github status check does not rely on the (SPK) NAME but uses the folder name
# required for packages that have folder name different to SPK_NAME (sonarr -> nzbget, mono_58 -> mono)
SPK_FOLDER = $(notdir $(CURDIR))

ifneq ($(wildcard BROKEN),)
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

# Check whether package supports ARCH
ifneq ($(UNSUPPORTED_ARCHS),)
  ifneq (,$(findstring $(ARCH),$(UNSUPPORTED_ARCHS)))
    ifneq (,$(BUILD_UNSUPPORTED_FILE))
      $(shell echo $(date --date=now +"%Y.%m.%d %H:%M:%S") - $(SPK_FOLDER): Arch '$(ARCH)' is not a supported architecture >> $(BUILD_UNSUPPORTED_FILE))
    endif
    @$(error Arch '$(ARCH)' is not a supported architecture)
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
  ifeq (,$(findstring $(ARCH),$(SRM_ARCHS)))
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
  ifeq (,$(findstring $(ARCH),$(SRM_ARCHS)))
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
  ifeq ($(ARCH),$(findstring $(ARCH),$(SRM_ARCHS)))
    ifneq ($(REQUIRED_MIN_SRM),$(firstword $(sort $(TCVERSION) $(REQUIRED_MIN_SRM))))
      ifneq (,$(BUILD_UNSUPPORTED_FILE))
        $(shell echo $(date --date=now +"%Y.%m.%d %H:%M:%S") - $(SPK_FOLDER): SRM Toolchain $(TCVERSION) is lower than $(REQUIRED_MIN_SRM) >> $(BUILD_UNSUPPORTED_FILE))
      endif
      @$(error SRM Toolchain $(TCVERSION) is lower than $(REQUIRED_MIN_SRM))
    endif
  endif
endif

endif
