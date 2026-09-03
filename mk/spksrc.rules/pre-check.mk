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

# Report a fatal pre-check, then stop. Three destinations, because each has a different
# reader: the console, this package's own build log, and -- when CI sets it -- the
# collected list of unsupported packages.
#
# The build log needs saying explicitly. $(error) fires at PARSE time, so no recipe ever
# runs, and LOG_WRAPPED does its teeing from inside one: the log was left holding the
# single "BUILDING package" line that build-arch-% writes before descending (#7393).
#
# The timestamp is $$(date), escaped, so the SHELL expands it. Written as $(date ...) it
# was make expanding an undefined variable, and every collected line began with " - ".
# Only when nobody above is teeing: through arch-% the real make error, line number and
# all, already reaches the log. Synthesised in make's own shape rather than the "===>"
# house style so the two are not confused -- minus the ":<line>", which make does not
# expose to a makefile.
define precheck_fatal
$(if $(LOGGING_ENABLED),,$(shell echo "$(lastword $(MAKEFILE_LIST)): *** $(1).  Stop." >> $(DEFAULT_LOG)))
$(if $(BUILD_UNSUPPORTED_FILE),$(shell echo "$$(date +'%Y.%m.%d %H:%M:%S') - $(SPK_FOLDER): $(1)" >> $(BUILD_UNSUPPORTED_FILE)))
$(error $(1))
endef

# A package is disabled by dropping a BROKEN or DISABLED file in its folder
# (both are treated identically).
ifneq ($(strip $(wildcard BROKEN) $(wildcard DISABLED)),)
  $(call precheck_fatal,$(NAME): Broken package)
endif

# Check for build for generic archs, these are not supporting by default 'require kernel'.
# Unless building kernel modules where a package will contain multiple kernel sub-architectures and versions.
ifneq ($(REQUIRE_KERNEL),)
  ifeq ($(REQUIRE_KERNEL_MODULE),)
    ifneq (,$(findstring $(ARCH),$(GENERIC_ARCHS)))
      $(call precheck_fatal,Generic arch '$(ARCH)' cannot be used when REQUIRE_KERNEL is set unless using REQUIRE_KERNEL_MODULE)
    endif
  endif
endif

# Refuse an arch whose toolchain cannot meet MIN_GCC_VERSION / MIN_GLIBC_VERSION
# (see spksrc.common/tc-capability.mk). Says why, not just where.
ifneq ($(strip $(TC_CAPABILITY_UNSUPPORTED)),)
  $(call precheck_fatal,Arch '$(ARCH)-$(TCVERSION)' is not supported by $(SPK_NAME)$(PKG_NAME): $(TC_CAPABILITY_UNSUPPORTED))
endif

# Check whether package supports ARCH
ifneq ($(UNSUPPORTED_ARCHS),)
  ifneq (,$(findstring $(ARCH),$(UNSUPPORTED_ARCHS)))
    $(call precheck_fatal,Arch '$(ARCH)' is not a supported architecture)
  endif
endif

ifneq ($(TCVERSION),)

ifneq ($(UNSUPPORTED_ARCHS_TCVERSION),)
  ifneq (,$(findstring $(ARCH)-$(TCVERSION),$(UNSUPPORTED_ARCHS_TCVERSION)))
    $(call precheck_fatal,Arch '$(ARCH)-$(TCVERSION)' is not a supported architecture)
  endif
endif

ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
  ifneq ($(strip $(INSTALLER_SCRIPT)),)
    $(call precheck_fatal,INSTALLER_SCRIPT '$(INSTALLER_SCRIPT)' cannot be used for DSM ${TCVERSION})
  endif
endif

# Check maximal DSM requirements of package
ifneq ($(REQUIRED_MAX_DSM),)
  ifeq ($(call version_ge, ${TCVERSION}, 3.0),1)
    ifneq ($(TCVERSION),$(firstword $(sort $(TCVERSION) $(REQUIRED_MAX_DSM))))
      $(call precheck_fatal,DSM Toolchain $(TCVERSION) is higher than $(REQUIRED_MAX_DSM))
    endif
  endif
endif

# Check minimum DSM requirements of package
ifneq ($(REQUIRED_MIN_DSM),)
  ifeq ($(call version_ge, ${TCVERSION}, 3.0),1)
    ifneq ($(REQUIRED_MIN_DSM),$(firstword $(sort $(TCVERSION) $(REQUIRED_MIN_DSM))))
      $(call precheck_fatal,DSM Toolchain $(TCVERSION) is lower than $(REQUIRED_MIN_DSM))
    endif
  endif
endif

# Check minimum SRM requirements of package
ifneq ($(REQUIRED_MIN_SRM),)
  ifeq ($(call version_lt, ${TCVERSION}, 3.0),1)
    ifneq ($(REQUIRED_MIN_SRM),$(firstword $(sort $(TCVERSION) $(REQUIRED_MIN_SRM))))
      $(call precheck_fatal,SRM Toolchain $(TCVERSION) is lower than $(REQUIRED_MIN_SRM))
    endif
  endif
endif

endif # ifneq ($(TCVERSION),)

endif # ifneq ($(DEPENDENCY_WALK),1)
