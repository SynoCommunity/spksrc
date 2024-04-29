# Configuration for dotnet build
#

# NOTE: 32bit (x86) is not supported:
# https://github.com/dotnet/core/issues/5403
# https://github.com/dotnet/core/issues/4595
UNSUPPORTED_ARCHS += $(PPC_ARCHS) $(ARMv5_ARCHS) $(i686_ARCHS) $(ARMv7L_ARCHS)

DOTNET_OS = linux
DOTNET_DEFAULT_VERSION = 3.1

ifeq ($(strip $(DOTNET_VERSION)),)
	DOTNET_VERSION = $(DOTNET_DEFAULT_VERSION)
endif

ifeq ($(strip $(DOTNET_FRAMEWORK)),)
	DOTNET_FRAMEWORK = net$(DOTNET_VERSION)
	ifeq ($(call version_lt, $(DOTNET_VERSION), 5.0),1)
		DOTNET_FRAMEWORK = netcoreapp$(DOTNET_VERSION)
	endif
endif
DOTNET_BUILD_ARGS += -f $(DOTNET_FRAMEWORK)

# Define DOTNET_ARCH for compiler
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
	DOTNET_ARCH = arm
endif
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
	DOTNET_ARCH = arm64
endif
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
	DOTNET_ARCH = x86
endif
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
	DOTNET_ARCH = x64
endif
ifeq ($(DOTNET_ARCH),)
	# don't report error to use regular UNSUPPORTED_ARCHS logging
	$(error Unsupported ARCH $(ARCH))
endif

ifeq ($(strip $(DOTNET_ROOT)),)
	# dotnet sdk path
	DOTNET_ROOT = $(WORK_DIR)/../../../native/dotnet-sdk-$(DOTNET_VERSION)/work-native
endif

ifeq ($(strip $(DOTNET_ROOT_X86)),)
	# dotnet sdk-32bit path
	DOTNET_ROOT_X86 = ""
	# DOTNET_ROOT_X86 = $(WORK_DIR)/../../../native/dotnet-x86-sdk-$(DOTNET_VERSION)/work-native
endif


ifeq ($(strip $(NUGET_PACKAGES)),)
	# cache nuget packages
	# https://github.com/dotnet/sdk/commit/e5a9249418f8387602ee8a26fef0f1604acf5911
	NUGET_PACKAGES = $(DISTRIB_DIR)/nuget/packages
endif

ifneq ($(strip $(DOTNET_NOT_RELEASE)),1)
	DOTNET_BUILD_ARGS += --configuration Release
endif
ifneq ($(strip $(DOTNET_SHARED_FRAMEWORK)),1)
	# Include .NET Core into package unless DOTNET_SHARED_FRAMEWORK is set to 1
	# https://docs.microsoft.com/en-us/dotnet/core/deploying/#publish-self-contained
	DOTNET_BUILD_ARGS += --self-contained
	DOTNET_BUILD_PROPERTIES += -p:UseAppHost=true
endif

ifeq ($(strip $(DOTNET_SINGLE_FILE)),1)
	# package all dlls into a single binary
	DOTNET_BUILD_PROPERTIES += -p:PublishSingleFile=true
endif

DOTNET_BUILD_ARGS += --runtime $(DOTNET_OS)-$(DOTNET_ARCH)
DOTNET_BUILD_ARGS += --output="$(STAGING_INSTALL_PREFIX)/$(DOTNET_OUTPUT_PATH)"

ifeq ($(strip $(DOTNET_OPTIMIZE)),1)
# PublishReadyToRun improves the startup time of your .NET Core application
#       by compiling your application assemblies as ReadyToRun (R2R) format.
#       R2R is a form of ahead-of-time (AOT) compilation.
#       But this almost doubles the size of the binary files.
    DOTNET_BUILD_PROPERTIES += -p:PublishReadyToRun=true -p:PublishReadyToRunShowWarnings=true
# DebugSymbols and DebugType
#       omit the creation of pdb files
    DOTNET_BUILD_PROPERTIES += -p:DebugSymbols=false -p:DebugType=none
endif

DOTNET_BUILD_ARGS += $(DOTNET_BUILD_PROPERTIES)

# https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet#environment-variables
# https://github.com/dotnet/docs/blob/master/docs/core/tools/dotnet.md#environment-variables
ENV += DOTNET_PACKAGE_NAME=$(DOTNET_PACKAGE_NAME)
ENV += DOTNET_ROOT=$(DOTNET_ROOT)
ENV += DOTNET_ROOT\(x86\)=$(DOTNET_ROOT_X86)
ENV += NUGET_PACKAGES=$(NUGET_PACKAGES)
ENV += PATH=$(DOTNET_ROOT)/:$$PATH
ENV += DOTNET_ARCH=$(DOTNET_ARCH)
ENV += DOTNET_OS=$(DOTNET_OS)
ENV += DOTNET_CLI_TELEMETRY_OPTOUT=1
