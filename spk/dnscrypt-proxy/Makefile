SPK_NAME = dnscrypt-proxy
SPK_VERS = 2.0.44
SPK_REV = 5
SPK_ICON = src/dnscrypt-proxy.png

DEPENDS = cross/$(SPK_NAME)
SPK_CONFLICT = DNSServer
UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = publicarray
DESCRIPTION = A flexible DNS proxy, with support for modern encrypted DNS protocols such as DNSCrypt v2 and DNS-over-HTTPS. https://github.com/jedisct1/dnscrypt-proxy
DISPLAY_NAME = dnscrypt-proxy
HELPURL = https://github.com/jedisct1/dnscrypt-proxy/wiki
LICENSE = ISC
CHANGELOG = "Update to 2.0.44"

STARTABLE = yes

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

GO_LDFLAGS = -s -w
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.cross-go-env.mk

include ../../mk/spksrc.spk.mk


.PHONY: dnscrypt_extra_install
dnscrypt_extra_install: copy_msg
	@$(MSG) "Copying files"
	install -m 755 -d $(STAGING_DIR)/offline-cache/
	install -m 755 -d $(STAGING_DIR)/blocklist/
	cp -rf $(CURDIR)/src/offline-cache/* $(STAGING_DIR)/offline-cache/
	install -m 755 $(CURDIR)/src/update-blocklist.sh $(STAGING_DIR)/blocklist/update-blocklist.sh
	@$(MSG) "UI - Copying files"
	install -m 755 -d $(STAGING_DIR)/$(DSM_UI_DIR)/
	cp -rf $(CURDIR)/src/$(DSM_UI_DIR)/* $(STAGING_DIR)/$(DSM_UI_DIR)/
	@$(MSG) "UI - Compiling cgi"
	env $(ENV) go build $(GO_BUILD_ARGS) -o $(STAGING_DIR)/$(DSM_UI_DIR)/index.cgi $(CURDIR)/src/$(DSM_UI_DIR)/cgi.go
