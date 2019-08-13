SPK_NAME = dnscrypt-proxy
SPK_VERS = 2.0.25
SPK_REV = 2
SPK_ICON = src/dnscrypt-proxy.png

DEPENDS = cross/$(SPK_NAME)
SPK_CONFLICT = DNSServer
UNSUPPORTED_ARCHES = $(PPC_ARCHES)

MAINTAINER = publicarray
DESCRIPTION = A flexible DNS proxy, with support for modern encrypted DNS protocols such as DNSCrypt v2 and DNS-over-HTTPS. https://github.com/jedisct1/dnscrypt-proxy
DISPLAY_NAME = dnscrypt-proxy
HELPURL = https://github.com/jedisct1/dnscrypt-proxy/wiki
LICENSE = ISC
CHANGELOG = "Update to 2.0.25"

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
STARTSTOP_RESTART_SERVICE = cron
SERVICE_TYPE = legacy
SERVICE_URL = /webman/3rdparty/dnscrypt-proxy/index.cgi

PRE_COPY_TARGET = dnscrypt_extra_install

include ../../mk/spksrc.spk.mk

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

CONF_ARGS = -ldflags="-s -w"
ENV += GOPATH="$(WORK_DIR)" \
	GOOS=linux \
	GOARCH="$(GO_ARCH)" \
	CGO_ENABLED=0 \
	PATH=$(WORK_DIR)/../../../native/go/work-native/go/bin/:$$PATH

.PHONY: dnscrypt_extra_install
dnscrypt_extra_install: copy_msg
	@echo "===> Copying files"
	mkdir -p $(STAGING_DIR)/offline-cache/ $(STAGING_DIR)/blocklist/
	cp -rf $(CURDIR)/src/offline-cache/* $(STAGING_DIR)/offline-cache/
	install -m 755 $(CURDIR)/src/update-blocklist.sh $(STAGING_DIR)/blocklist/update-blocklist.sh
	@echo "===> UI - Copying files"
	mkdir -p $(STAGING_DIR)/$(DSM_UI_DIR)/
	cp -rf $(CURDIR)/src/$(DSM_UI_DIR)/* $(STAGING_DIR)/$(DSM_UI_DIR)/
	@echo "===> UI - Compiling cgi"
	env $(ENV) go build $(CONF_ARGS) -o $(STAGING_DIR)/$(DSM_UI_DIR)/index.cgi $(CURDIR)/src/$(DSM_UI_DIR)/cgi.go
