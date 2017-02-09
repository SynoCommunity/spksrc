PKG_NAME = syncthing-inotify
PKG_VERS = 0.8.5
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/syncthing/syncthing-inotify/archive
PKG_DIST_FILE = $(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)

DEPENDS = native/go

HOMEPAGE = https://github.com/syncthing/syncthing-inotify
COMMENT  = File watcher intended for use with Syncthing. Syncthing uses a rescan interval to detect changes in folders. Syncthing-inotify uses OS primitives to detect changes as soon as they happen. Therefore, near real-time synchronisation can be achieved.
LICENSE  = MPL-2.0

CONFIGURE_TARGET = nope
COMPILE_TARGET = myComp
INSTALL_TARGET = myInstall

GOOS = linux
CGO_ENABLED=0

# set this to 1 to create static linked binaries
STATIC_BINARIES = 0

# Define SYNCTHING_INOTIFY_ARCH as per Syncthing standards
ifeq ($(findstring $(ARCH),88f5281 88f6281 alpine armada370 armada375 armada38x armadaxp comcerto2k monaco),$(ARCH))
SYNCTHING_INOTIFY_ARCH = arm
ENV += GOARM=5
endif
ifeq ($(findstring $(ARCH),evansport),$(ARCH))
SYNCTHING_INOTIFY_ARCH = 386
ENV += GO386=387
endif
ifeq ($(findstring $(ARCH),avoton braswell bromolow cedarview x86 x64),$(ARCH))
SYNCTHING_INOTIFY_ARCH = amd64
endif
ifeq ($(SYNCTHING_INOTIFY_ARCH),)
$(error Unsupported ARCH $(ARCH))
endif

SYNCTHING_INOTIFY_DIR = $(WORK_DIR)/src/github.com/$(PKG_NAME)/$(PKG_NAME)-$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/src/github.com/$(PKG_NAME)

include ../../mk/spksrc.cross-cc.mk

# use workdir as gopath
ENV += GOPATH=$(WORK_DIR)
ENV += CGO_ENABLED=$(CGO_ENABLED)
ENV += PATH=$(WORK_DIR)/../../../native/go/work-native/go/bin/:$$PATH
ENV += GOOS=$(GOOS) GOARCH=$(SYNCTHING_INOTIFY_ARCH)

LDFLAGS = -w -X main.Version=v$(PKG_VERS)

myComp:
	cd $(SYNCTHING_INOTIFY_DIR) && env $(ENV) go get && env $(ENV) go build -ldflags '$(LDFLAGS)'

myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(SYNCTHING_INOTIFY_DIR)/$(PKG_NAME)-$(PKG_VERS) $(STAGING_INSTALL_PREFIX)/bin/$(PKG_NAME)
