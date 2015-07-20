PKG_NAME = syncthing
PKG_VERS = 0.11.15
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-source-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/syncthing/syncthing/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)

DEPENDS = native/go

HOMEPAGE = http://www.syncthing.net/
COMMENT  = Syncthing replaces Dropbox and BitTorrent Sync with something open, trustworthy and decentralized. Your data is your data alone and you deserve to choose where it is stored, if it is shared with some third party and how ...
LICENSE  =

CONFIGURE_TARGET = nope
COMPILE_TARGET = myComp
INSTALL_TARGET = myInstall

GOOS = linux
CGO_ENABLED=1

# set this to 1 to create static linked binaries
STATIC_BINARIES = 0

# Define SYNCTHING_ARCH as per SyncThing standards
ifeq ($(findstring $(ARCH),armada370 armadaxp armada375 alpine 88f5281 88f6281 comcerto2k),$(ARCH))
SYNCTHING_ARCH = arm
CGO_ENABLED = 0
ENV += GOARM=5
endif
ifeq ($(findstring $(ARCH),evansport),$(ARCH))
SYNCTHING_ARCH = 386
endif
ifeq ($(findstring $(ARCH),avoton bromolow cedarview x86 x64),$(ARCH))
SYNCTHING_ARCH = amd64
endif
ifeq ($(SYNCTHING_ARCH),)
$(error Unsupported ARCH $(ARCH))
endif

ifeq ($(findstring $(SYNCTHING_ARCH),amd64),$(SYNCTHING_ARCH))
SYNCTHING_BIN = $(WORK_DIR)/$(PKG_DIR)/bin/linux_amd64/syncthing
endif

ifeq ($(findstring $(SYNCTHING_ARCH),386),$(SYNCTHING_ARCH))
SYNCTHING_BIN = $(WORK_DIR)/$(PKG_DIR)/bin/syncthing
endif

ifeq ($(findstring $(SYNCTHING_ARCH),arm),$(SYNCTHING_ARCH))
SYNCTHING_BIN = $(WORK_DIR)/$(PKG_DIR)/bin/linux_arm/syncthing
endif

include ../../mk/spksrc.cross-cc.mk

ENV += GOPATH=$(WORK_DIR)/../../../native/go/work-native/go/
ENV += CGO_ENABLED=$(CGO_ENABLED)
ENV += PATH=$(WORK_DIR)/../../../native/go/work-native/go/bin/:$$PATH

CONF_ARGS = -goos=$(GOOS) -goarch=$(SYNCTHING_ARCH) -version=v$(PKG_VERS)

ifeq ($(strip $(STATIC_BINARIES)),1)
CONF_ARGS += -no-upgrade
endif

myComp:
	#go is particular about file locations so we have to link it to the native directory to work!
	rm -rf $(WORK_DIR)/../../../native/go/work-native/go/src/github.com/syncthing
	mkdir -p $(WORK_DIR)/../../../native/go/work-native/go/src/github.com/syncthing
	ln -sf $(WORK_DIR)/$(PKG_DIR) $(WORK_DIR)/../../../native/go/work-native/go/src/github.com/syncthing/syncthing
	$(RUN) go run build.go $(CONF_ARGS)

myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(SYNCTHING_BIN) $(STAGING_INSTALL_PREFIX)/bin/


