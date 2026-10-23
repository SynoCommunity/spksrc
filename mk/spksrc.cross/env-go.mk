###############################################################################
# spksrc.cross/env-go.mk
#
# Configuration for go build
#
###############################################################################

# Go has no upstream toolchain for 32-bit PowerPC: GOARCH covers ppc64 and ppc64le only.
UNSUPPORTED_ARCHS += $(PPC_ARCHS)
# The reason is given on PPC only: an arch a package refuses for its own cause keeps its own.
ifneq ($(filter $(ARCH),$(PPC_ARCHS)),)
UNSUPPORTED_ARCHS_REASON := $(call comma_append,$(UNSUPPORTED_ARCHS_REASON),go has no 32-bit PowerPC target)
endif

GOOS = linux
ifeq ($(strip $(CGO_ENABLED)),)
  CGO_ENABLED = 0
endif

# to create static linked binaries set GO_STATIC_BINARIES = 1
ifeq ($(strip $(GO_STATIC_BINARIES)),)
  GO_STATIC_BINARIES = 0
endif

# Define GO_ARCH for go compiler
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
  GO_ARCH = arm
  ENV += GOARM=5
endif
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
  GO_ARCH = arm
  ENV += GOARM=7
endif
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
  GO_ARCH = arm64
endif
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
  GO_ARCH = 386
endif
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
  GO_ARCH = amd64
endif
ifeq ($(GO_ARCH),)
  # don't report error to use regular UNSUPPORTED_ARCHS logging
  $(warning Unsupported ARCH $(ARCH))
endif

# Use -buildvcs=false to disable VCS stamping.
GO_BUILD_ARGS += -buildvcs=false

ifeq ($(strip $(GO_STATIC_BINARIES)),1)
  GO_BUILD_ARGS += -no-upgrade
endif

ifeq ($(strip $(GOPATH)),)
  # default use distrib folder 'go' as GOPATH to download dependencies only once
  # For errors like "cannot find package <....> in any of:" you have to 
  # provide GOPATH within $(WORK_DIR)
  GOPATH=$(DISTRIB_DIR)/go
endif

# A kernel older than 3.2 gets go 1.23, unless MIN_GO_VERSION asks for more: such a package is
# refused there (spksrc.cross-go.mk) or, clearing MIN_KERNEL_VERSION, built with the latest go.
ifeq ($(strip $(NATIVE_GO)),)
ifneq ($(and $(TC_KERNEL),$(call version_lt,$(TC_KERNEL),3.2)),)
ifeq ($(strip $(GO_NEEDS_LINUX_3_2)),)
NATIVE_GO = native/go-1.23
endif
endif
endif
ifeq ($(strip $(NATIVE_GO)),)
NATIVE_GO = native/go-latest
endif
BUILD_DEPENDS += $(NATIVE_GO)
# Without an arch, go 1.23 is listed too wherever a package can use it.
ifeq ($(strip $(GO_NEEDS_LINUX_3_2)),)
OPTIONAL_DEPENDS += native/go-1.23
endif
# The selected go's bin directory, as PYTHON_NATIVE_PATH is python's
GO_NATIVE_PATH = $(abspath $(WORK_DIR)/../../../$(NATIVE_GO)/work-native/go/bin)
ENV += PATH=$(GO_NATIVE_PATH):$$PATH

ENV += GOPATH=$(GOPATH)
ENV += CGO_ENABLED=$(CGO_ENABLED)
ENV += GOARCH=$(GO_ARCH)
ENV += GOOS=$(GOOS)

# Ensure downloaded mod are u+rw
ENV += GOFLAGS=-modcacherw
# A go.mod asking for more than NATIVE_GO fails the build instead of fetching a newer go.
ENV += GOTOOLCHAIN=local

ifneq ($(strip $(GO_BIN_DIR)),)
  GO_BUILD_ARGS := -o $(GO_BIN_DIR) $(GO_BUILD_ARGS)
endif

ifneq ($(strip $(GO_LDFLAGS)),)
  GO_BUILD_ARGS += -ldflags "$(GO_LDFLAGS)"
endif
