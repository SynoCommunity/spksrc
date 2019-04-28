PKG_NAME = dnscrypt-proxy
PKG_VERS = 2.0.25
PKG_EXT = tar.gz
PKG_DIST_SITE = https://github.com/jedisct1/dnscrypt-proxy/archive
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIR =  $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)

HOMEPAGE = https://github.com/jedisct1/dnscrypt-proxy
COMMENT  = A flexible DNS proxy, with support for modern encrypted DNS protocols such as DNSCrypt v2 and DNS-over-HTTP/2.
LICENSE  = ISC

DEPENDS = native/go

CONFIGURE_TARGET = nope
COMPILE_TARGET = dnscrypt_proxy_compile
INSTALL_TARGET = dnscrypt_proxy_install

include ../../mk/spksrc.cross-cc.mk

UNSUPPORTED_ARCHS = $(PPC_ARCHES)

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

DNSCRYPT_DIR = $(WORK_DIR)/src/github.com/$(PKG_NAME)/$(PKG_NAME)-$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/src/github.com/$(PKG_NAME)
DNSCRYPT_BIN = $(WORK_DIR)/src/github.com/$(PKG_NAME)/$(PKG_NAME)-$(PKG_VERS)/$(PKG_NAME)/$(PKG_NAME)

CONF_ARGS = -ldflags="-s -w"
ENV += GOPATH="$(WORK_DIR)" \
	GOOS=linux \
	GOARCH="$(GO_ARCH)" \
	CGO_ENABLED=0 \
	PATH=$(WORK_DIR)/../../../native/go/work-native/go/bin/:$$PATH \

.PHONY: dnscrypt_proxy_compile
dnscrypt_proxy_compile:
	mkdir -p $(GOPATH)/bin
	cd $(DNSCRYPT_DIR)/$(PKG_NAME) && env $(ENV) go build $(CONF_ARGS)
.PHONY: dnscrypt_proxy_install
dnscrypt_proxy_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/bin $(STAGING_INSTALL_PREFIX)/blocklist
	install -m 755 $(DNSCRYPT_BIN) $(STAGING_INSTALL_PREFIX)/bin
	install -m 644 $(DNSCRYPT_DIR)/$(PKG_NAME)/example-* $(STAGING_INSTALL_PREFIX)
	install -m 644 $(DNSCRYPT_DIR)/utils/generate-domains-blacklists/* $(STAGING_INSTALL_PREFIX)/blocklist
