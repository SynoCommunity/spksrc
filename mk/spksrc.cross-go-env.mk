# Configuration for go build
# 

UNSUPPORTED_ARCHS += $(PPC_ARCHS)

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

ifeq ($(strip $(GO_STATIC_BINARIES)),1)
  GO_BUILD_ARGS += -no-upgrade
endif

ifeq ($(strip $(GOPATH)),)
  # default use distrib folder 'go' as GOPATH to download dependencies only once
  # For errors like "cannot find package <....> in any of:" you have to 
  # provide GOPATH within $(WORK_DIR)
  GOPATH=$(DISTRIB_DIR)/go
endif

ENV += GOPATH=$(GOPATH)
ENV += CGO_ENABLED=$(CGO_ENABLED)
ENV += PATH=$(WORK_DIR)/../../../native/go/work-native/go/bin/:$$PATH
ENV += GOARCH=$(GO_ARCH)
ENV += GOOS=$(GOOS)

ifneq ($(strip $(GO_BIN_DIR)),)
  GO_BUILD_ARGS := -o $(GO_BIN_DIR) $(GO_BUILD_ARGS)
endif

ifneq ($(strip $(GO_LDFLAGS)),)
  GO_BUILD_ARGS += -ldflags "$(GO_LDFLAGS)"
endif
