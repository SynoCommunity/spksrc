# Common requirement checks

# Check for build for generic archs, these are not supporting `require kernel`.
ifneq ($(REQUIRE_KERNEL),)
  ifneq (,$(findstring $(ARCH),x64 aarch64 armv7))
    ifneq ($(BUILD_UNSUPPORTED_FILE),)
      $(shell echo $(date --date=now +"%Y.%m.%d %H:%M:%S") - $(NAME): Arch '$(ARCH)' cannot be used when REQUIRE_KERNEL is set >> $(BUILD_UNSUPPORTED_FILE))
    endif
    @$(error Arch '$(ARCH)' cannot be used when REQUIRE_KERNEL is set)
  endif
endif

# Check whether package supports ARCH
ifneq ($(UNSUPPORTED_ARCHS),)
  ifneq (,$(findstring $(ARCH),$(UNSUPPORTED_ARCHS)))
    ifneq (,$(BUILD_UNSUPPORTED_FILE))
      $(shell echo $(date --date=now +"%Y.%m.%d %H:%M:%S") - $(NAME): Arch '$(ARCH)' is not a supported architecture >> $(BUILD_UNSUPPORTED_FILE))
    endif
    @$(error Arch '$(ARCH)' is not a supported architecture)
  endif
endif

# Check minimum DSM requirements of package
ifneq ($(REQUIRED_DSM),)
  ifeq (,$(findstring $(ARCH),$(SRM_ARCHS)))
    ifneq ($(REQUIRED_DSM),$(firstword $(sort $(TCVERSION) $(REQUIRED_DSM))))
      ifneq (,$(BUILD_UNSUPPORTED_FILE))
        $(shell echo $(date --date=now +"%Y.%m.%d %H:%M:%S") - $(NAME): DSM Toolchain $(TCVERSION) is lower than required version $(REQUIRED_DSM) >> $(BUILD_UNSUPPORTED_FILE))
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
        $(shell echo $(date --date=now +"%Y.%m.%d %H:%M:%S") - $(NAME): SRM Toolchain $(TCVERSION) is lower than required version $(REQUIRED_SRM) >> $(BUILD_UNSUPPORTED_FILE))
      endif
      @$(error SRM Toolchain $(TCVERSION) is lower than required version in Makefile $(REQUIRED_SRM))
    endif
  endif
endif
