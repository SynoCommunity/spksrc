PKG_NAME = gogs
PKG_GO_NAME = github.com/gogits/gogs
PKG_VERS = 0.9.97
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://$(PKG_GO_NAME)/archive

GLIDE_FILE_SHA256 = 87f94d80768e8d59b3191b23993e5d748e026df4b856b86b1d3c12b4f7ed7210

HOMEPAGE = https://gogs.io/
COMMENT  = Gogs - Go Git Service. A painless self-hosted Git service.
LICENSE  = MIT

BUILD_DEPENDS = native/go

PRE_DOWNLOAD_TARGET = check-prepare-urls
EXTRACT_TARGET = goPkgExtract
CONFIGURE_TARGET = nope
COMPILE_TARGET = goBuild
INSTALL_TARGET = myInstall


# include mk files 
include ../../mk/spksrc.cross-cc.mk
include prepare-glide.mk

# Define files to download
URLS = $(PREPARED_URLS)
DIST_FILES = $(PREPARED_DIST_FILES)
DIST_EXTRACT_PATH=$(PREPARED_EXTRACT_PATH)

# Go compilation variables
GOOS = linux
CGO_ENABLED = 0
STATIC_BINARIES = 0
GOBUILD_ARGS = -tags "cert"

# Define GOGS_ARCH as per GO standards
ifeq ($(findstring $(ARCH),88f5281 88f6281 alpine armada370 armada375 armada38x armadaxp comcerto2k monaco),$(ARCH))
GOARCH = arm
ENV += GOARM=5
endif
ifeq ($(findstring $(ARCH),evansport),$(ARCH))
GOARCH = 386
endif
ifeq ($(findstring $(ARCH),avoton braswell bromolow cedarview x86 x64),$(ARCH))
GOARCH = amd64
endif
ifeq ($(GOARCH),)
$(error Unsupported ARCH $(ARCH))
endif

# Define gobuild args
GOBUILD_ARGS +=  -v


# Go source location
GOSRC_PATH=$(WORK_DIR)/src

# Define package directories
PKG_DIR = src/$(PKG_GO_NAME)
DISTRIB_DIR=$(PWD)/../../distrib/$(PKG_NAME)-$(PKG_VERS)

# Define enviroment variables
ENV += GOPATH=$(WORK_DIR)
ENV += CGO_ENABLED=$(CGO_ENABLED)
ENV += PATH=$(WORK_DIR)/../../../native/go/work-native/go/bin/:$(WORK_DIR)/bin:$$PATH
ENV += GOARCH=$(GOARCH)


# Targets

.PHONY: goPkgExtract $(DIST_FILES)
goPkgExtract: check-prepare-distfiles $(DIST_FILES)

$(DIST_FILES): 
	@PKG_DIST_FILE=$@ EXTRACT_PATH=$(GOSRC_PATH)/$(DIST_EXTRACT_PATH) $(MAKE) extract_target
	@cd $(GOSRC_PATH)/$(DIST_EXTRACT_PATH) && \
	  DIST_PKG_VERS=`echo $@ | sed "s/\.$(PKG_EXT)$$//" |sed "s/^v//"`; \
	  mv --backup=nil *-$$DIST_PKG_VERS/* . ; 


.PHONY: goBuild
goBuild:
	$(RUN) go build $(GOBUILD_ARGS)



.PHONY: myInstall
myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/$(PKG_NAME)
	$(RUN) cp -r gogs LICENSE README.md README_ZH.md templates public scripts $(STAGING_INSTALL_PREFIX)/$(PKG_NAME)
	rm -rf $(STAGING_INSTALL_PREFIX)/$(PKG_NAME)/public/config.codekit $(STAGING_INSTALL_PREFIX)/$(PKG_NAME)/public/less



