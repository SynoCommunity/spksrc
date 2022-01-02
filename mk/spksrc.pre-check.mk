# Common requirement checks

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

ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
  ifneq ($(strip $(INSTALLER_SCRIPT)),)
    ifneq ($(BUILD_UNSUPPORTED_FILE),)
      $(shell echo $(date --date=now +"%Y.%m.%d %H:%M:%S") - $(SPK_FOLDER): INSTALLER_SCRIPT '$(INSTALLER_SCRIPT)' cannot be used with DSM7+ >> $(BUILD_UNSUPPORTED_FILE))
    endif
    @$(error INSTALLER_SCRIPT '$(INSTALLER_SCRIPT)' cannot be used for DSM7+ packages)
  endif
endif

# Check for build for generic archs, these are not supporting `require kernel`.
ifneq ($(REQUIRE_KERNEL),)
  ifneq (,$(findstring $(ARCH),x64 aarch64 armv7))
    ifneq ($(BUILD_UNSUPPORTED_FILE),)
      $(shell echo $(date --date=now +"%Y.%m.%d %H:%M:%S") - $(SPK_FOLDER): Arch '$(ARCH)' cannot be used when REQUIRE_KERNEL is set >> $(BUILD_UNSUPPORTED_FILE))
    endif
    @$(error Arch '$(ARCH)' cannot be used when REQUIRE_KERNEL is set)
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

# Check minimum DSM requirements of package
ifneq ($(REQUIRED_DSM),)
  ifeq (,$(findstring $(ARCH),$(SRM_ARCHS)))
    ifneq ($(REQUIRED_DSM),$(firstword $(sort $(TCVERSION) $(REQUIRED_DSM))))
      ifneq (,$(BUILD_UNSUPPORTED_FILE))
        $(shell echo $(date --date=now +"%Y.%m.%d %H:%M:%S") - $(SPK_FOLDER): DSM Toolchain $(TCVERSION) is lower than required version $(REQUIRED_DSM) >> $(BUILD_UNSUPPORTED_FILE))
      endif
      @$(error DSM Toolchain $(TCVERSION) is lower than required version in Makefile $(REQUIRED_DSM))
    endif
  endif
endif

# Check minimum SRM requirements of package
ifneq ($(REQUIRED_SRM),)
  ifeq ($(ARCH),$(findstring $(ARCH),$(SRM_ARCHS)))
    ifneq ($(REQUIRED_SRM),$(firstword $(sort $(TCVERSION) $(REQUIRED_SRM))))
      ifneq (,$(BUILD_UNSUPPORTED_FILE))
        $(shell echo $(date --date=now +"%Y.%m.%d %H:%M:%S") - $(SPK_FOLDER): SRM Toolchain $(TCVERSION) is lower than required version $(REQUIRED_SRM) >> $(BUILD_UNSUPPORTED_FILE))
      endif
      @$(error SRM Toolchain $(TCVERSION) is lower than required version in Makefile $(REQUIRED_SRM))
    endif
  endif
endif
