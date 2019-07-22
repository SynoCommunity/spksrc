PKG_NAME = fritzctl
PKG_ORG = bpicode
PKG_IMPORT_PATH = github.com/$(PKG_ORG)/$(PKG_NAME)
PKG_VERS = 1.4.23
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://$(PKG_IMPORT_PATH)/archive
PKG_DIR = $(PKG_NAME)

DEPENDS = native/go

HOMEPAGE = https://$(PKG_IMPORT_PATH)
COMMENT  = fritzctl is a command line client for the AVM FRITZ!Box primarily focused on the AVM Home Automation HTTP Interface.
LICENSE  = MIT

CONFIGURE_TARGET = fritzctl_configure
COMPILE_TARGET = fritzctl_compile
INSTALL_TARGET = fritzctl_install

GOOS = linux
CGO_ENABLED = 0

# set this to 1 to create static linked binaries
STATIC_BINARIES = 0

include ../../mk/spksrc.cross-cc.mk

# Define GO_ARCH as per golang standards
ifeq ($(findstring $(ARCH),$(ARM5_ARCHES)),$(ARCH))
GO_ARCH = arm
ENV += GOARM=5
endif
ifeq ($(findstring $(ARCH),$(ARM7_ARCHES)),$(ARCH))
GO_ARCH = arm
ENV += GOARM=7
endif
ifeq ($(findstring $(ARCH),$(ARM8_ARCHES)),$(ARCH))
GO_ARCH = arm64
endif
ifeq ($(findstring $(ARCH),$(x86_ARCHES)),$(ARCH))
GO_ARCH = 386
endif
ifeq ($(findstring $(ARCH),$(x64_ARCHES)),$(ARCH))
GO_ARCH = amd64
endif

ifeq ($(GO_ARCH),)
$(error Unsupported ARCH $(ARCH))
endif
ENV += GOARCH=$(GO_ARCH)

EXTRACT_PATH = $(WORK_DIR)/src/github.com/$(PKG_ORG)
SRC_DIR = $(EXTRACT_PATH)/$(PKG_NAME)
BIN_PATH = $(SRC_DIR)/$(PKG_NAME)

# use workdir as gopath
ENV += GOPATH=$(WORK_DIR)
ENV += CGO_ENABLED=$(CGO_ENABLED)
ENV += PATH=$(WORK_DIR)/../../../native/go/work-native/go/bin/:$$PATH

BUILD_ARGS = -ldflags="-s -w -X github.com/bpicode/fritzctl/config.Version=$(PKG_VERS)"

fritzctl_configure:
	mv $(EXTRACT_PATH)/$(PKG_NAME)-$(PKG_VERS) $(SRC_DIR)

fritzctl_compile:
	cd $(SRC_DIR) && env $(ENV) go build -o $(BIN_PATH) $(BUILD_ARGS)

fritzctl_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(BIN_PATH) $(STAGING_INSTALL_PREFIX)/bin/
