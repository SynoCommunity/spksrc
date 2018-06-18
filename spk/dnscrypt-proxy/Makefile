SPK_NAME = dnscrypt-proxy
SPK_VERS = 2.0.15
SPK_REV = 0
SPK_ICON = src/dnscrypt-proxy.png

DEPENDS = cross/$(SPK_NAME)
SPK_CONFLICT = DNSServer

MAINTAINER = publicarray
DESCRIPTION = A flexible DNS proxy, with support for modern encrypted DNS protocols such as DNSCrypt v2 and DNS-over-HTTP/2. https://github.com/jedisct1/dnscrypt-proxy
DISPLAY_NAME = DNSCrypt-proxy
HELPURL = https://github.com/jedisct1/dnscrypt-proxy/wiki
LICENSE = ISC
CHANGELOG = "Added a GUI"

STARTABLE = yes
BETA = 1

WIZARDS_DIR = src/wizard/
DSM_UI_DIR = ui
CONF_DIR = src/conf
FWPORTS = src/${SPK_NAME}.sc
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 53
SERVICE_PORT_TITLE = DNS
NO_SERVICE_SHORTCUT = true
SERVICE_PORT_ALL_USERS = false
SERVICE_TYPE = legacy
SERVICE_URL = /webman/3rdparty/dnscrypt-proxy/index.cgi

PRE_COPY_TARGET = dnscrypt_extra_install

include ../../mk/spksrc.spk.mk

ifeq ($(findstring $(ARCH),$(ARM5_ARCHES)),$(ARCH))
DNSCRYPT_ARCH = arm
export GOARM=5
endif
ifeq ($(findstring $(ARCH),$(ARM7_ARCHES)),$(ARCH))
DNSCRYPT_ARCH = arm
export GOARM=7
endif
ifeq ($(findstring $(ARCH),$(ARM8_ARCHES)),$(ARCH))
DNSCRYPT_ARCH = arm64
endif
ifeq ($(findstring $(ARCH),$(x86_ARCHES)),$(ARCH))
DNSCRYPT_ARCH = 386
endif
ifeq ($(findstring $(ARCH),$(x64_ARCHES)),$(ARCH))
DNSCRYPT_ARCH = amd64
endif
ifeq ($(findstring $(ARCH),$(PPC_ARCHES)),$(ARCH))
DNSCRYPT_ARCH = ppc64
endif
ifeq ($(DNSCRYPT_ARCH),)
$(error Unsupported ARCH $(ARCH))
endif

export GOPATH = $(WORK_DIR)
export PATH := $(WORK_DIR)/../../../native/go/work-native/go/bin/:$(WORK_DIR)/bin:$(PATH)
export GOOS = linux
export GOARCH = $(DNSCRYPT_ARCH)
export CGO_ENABLED=0

.PHONY: dnscrypt_extra_install
dnscrypt_extra_install: copy_msg
	@echo "===> UI - Copying files"
	mkdir -p $(STAGING_DIR)/$(DSM_UI_DIR)/
	cp -rf $(CURDIR)/src/$(DSM_UI_DIR)/* $(STAGING_DIR)/$(DSM_UI_DIR)/
	@echo "===> UI - Compiling cgi"
	go build -ldflags "-s -w" -o $(STAGING_DIR)/$(DSM_UI_DIR)/index.cgi $(CURDIR)/src/$(DSM_UI_DIR)/cgi.go
## rm -f work-ipq806x-1.1/.copy_done && rm -f work-ipq806x-1.1/.icon_done && make arch-ipq806x-1.1
## synopkg uninstall dnscrypt-proxy
