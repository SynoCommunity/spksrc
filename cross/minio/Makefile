PKG_NAME = minio
PKG_VERS = 2019-08-21T19-40-07Z
PKG_EXT = tar.gz
PKG_DIST_PREFIX = RELEASE.$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIST_PREFIX).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_DIST_NAME)
PKG_DIST_SITE = https://github.com/minio/minio/archive
PKG_DIR = $(PKG_NAME)-$(PKG_DIST_PREFIX)

DEPENDS = native/go

HOMEPAGE = https://min.io/
COMMENT  = The 100% Open Source, Enterprise-Grade, Amazon S3 Compatible Object Storage.
LICENSE  = Apache License 2.0

CONFIGURE_TARGET = minio_configure
COMPILE_TARGET = minio_compile
INSTALL_TARGET = minio_install

GOOS = linux
CGO_ENABLED = 0

# set this to 1 to create static linked binaries
STATIC_BINARIES = 0

include ../../mk/spksrc.cross-cc.mk

UNSUPPORTED_ARCHS = $(PPC_ARCHES)

# Define GO_ARCH for go compiler
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
# Go has no ppc32 support for qoriq https://github.com/golang/go/issues/22885
#ifeq ($(findstring $(ARCH),$(PPC_ARCHES)),$(ARCH))
#GO_ARCH = ppc32
#endif
ifeq ($(GO_ARCH),)
$(error Unsupported ARCH $(ARCH))
endif

EXTRACT_PATH = $(WORK_DIR)/src/github.com/$(PKG_NAME)
MINIO_DIR = $(EXTRACT_PATH)/minio
MINIO_BIN = $(MINIO_DIR)/minio

# use distrib folder 'go' as GOPATH to download dependencies only once
ENV += GOPATH=$(DISTRIB_DIR)/go
ENV += CGO_ENABLED=$(CGO_ENABLED)
ENV += PATH=$(WORK_DIR)/../../../native/go/work-native/go/bin/:$$PATH

ENV += GOOS=$(GOOS)
ENV += GOARCH=$(GO_ARCH)
ENV += GO111MODULE=on

ifeq ($(strip $(STATIC_BINARIES)),1)
CONF_ARGS += -no-upgrade
endif

GO_LDFLAGS +=-s -w
GO_LDFLAGS += -X github.com/minio/minio/cmd.Version=$(PKG_VERS)
GO_LDFLAGS += -X github.com/minio/minio/cmd.ReleaseTag=$(PKG_VERS)

minio_configure:
	# rename extracted folder to make imports work when used as GOPATH
	cd $(EXTRACT_PATH) && [ -d $(PKG_DIR) ] && \
		mv $(PKG_DIR) $(PKG_NAME)

minio_compile:
	cd $(MINIO_DIR) && \
	env $(ENV) go build -tags kqueue -ldflags "$(GO_LDFLAGS)" \
	  -o $(MINIO_BIN)

minio_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(MINIO_BIN) $(STAGING_INSTALL_PREFIX)/bin/
