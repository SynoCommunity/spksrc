PKG_NAME = dnscrypt-proxy
PKG_VERS = 2.0.9b2
PKG_EXT = tar.gz
PKG_DIST_SITE = https://github.com/jedisct1/dnscrypt-proxy/archive
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIR =  $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/jedisct1/dnscrypt-proxy
COMMENT  = A flexible DNS proxy, with support for modern encrypted DNS protocols such as DNSCrypt v2 and DNS-over-HTTP/2.
LICENSE  = ISC License

DEPENDS = native/go

CONFIGURE_TARGET = nope
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARM5_ARCHES)),$(ARCH))
SYNCTHING_ARCH = arm
export GOARM=5
endif
ifeq ($(findstring $(ARCH),$(ARM7_ARCHES)),$(ARCH))
SYNCTHING_ARCH = arm
export GOARM=7
endif
ifeq ($(findstring $(ARCH),$(ARM8_ARCHES)),$(ARCH))
SYNCTHING_ARCH = arm
export GOARM=7
endif
ifeq ($(findstring $(ARCH),$(x86_ARCHES)),$(ARCH))
SYNCTHING_ARCH = 386
endif
ifeq ($(findstring $(ARCH),$(x64_ARCHES)),$(ARCH))
SYNCTHING_ARCH = amd64
endif
ifeq ($(findstring $(ARCH),$(PPC_ARCHES)),$(ARCH))
SYNCTHING_ARCH = ppc64
endif
ifeq ($(SYNCTHING_ARCH),)
$(error Unsupported ARCH $(ARCH))
endif

SYNCTHING_DIR = $(WORK_DIR)/src/github.com/$(PKG_NAME)/$(PKG_NAME)-$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/src/github.com/$(PKG_NAME)
SYNCTHING_BIN = $(WORK_DIR)/src/github.com/$(PKG_NAME)/$(PKG_NAME)-$(PKG_VERS)/$(PKG_NAME)/$(PKG_NAME)

CONF_ARGS = -ldflags="-s -w"
export GOPATH = $(WORK_DIR)
export PATH := $(WORK_DIR)/../../../native/go/work-native/go/bin/:$(WORK_DIR)/bin:$(PATH)
export GOOS = linux
export GOARCH = $(SYNCTHING_ARCH)
export CGO_ENABLED=0

.PHONY: myCompile
myCompile:
	mkdir -p $(GOPATH)/bin
	curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
	cd $(SYNCTHING_DIR) && dep ensure
	cd $(SYNCTHING_DIR)/$(PKG_NAME) && go build $(CONF_ARGS)
.PHONY: myInstall
myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/bin $(STAGING_INSTALL_PREFIX)/etc
	install -m 755 $(SYNCTHING_BIN) $(STAGING_INSTALL_PREFIX)/bin
	install -m 644 $(SYNCTHING_DIR)/$(PKG_NAME)/example-* $(STAGING_INSTALL_PREFIX)/etc
