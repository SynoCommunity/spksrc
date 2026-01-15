SPK_NAME = ddns-go
SPK_VERS = 6.13.3
SPK_REV = 1
SPK_ICON = src/ddns-go.png

DEPENDS = cross/ddns-go

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS)
# not supported by go:
UNSUPPORTED_ARCHS += $(PPC_ARCHS)

MAINTAINER = GrandDuke1106
DESCRIPTION = Automatically obtain your public IPv4 or IPv6 address and resolve it to the corresponding domain name service. Supported domain service providers are: Aliyun, Tencent, Dnspod, Cloudflare, Huawei, Callback, Baidu, Porkbun, GoDaddy, Namecheap, NameSilo, Dynadot, DNSLA, Nowcn, Eranet, Gcore.
DISPLAY_NAME = ddns-go
CHANGELOG = "Initial package release."

HOMEPAGE = https://github.com/jeessy2/ddns-go
LICENSE = MIT

SERVICE_SETUP = src/service-setup.sh

STARTABLE = yes
SERVICE_USER = auto
SERVICE_PORT = 9876
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_TEMPLATES_DIR = src/wizard_templates

POST_STRIP_TARGET = ddns_go_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: ddns_go_extra_install
ddns_go_extra_install:
	@install -d -m 755 $(STAGING_DIR)/var
	@install -m 644 src/environment-variables $(STAGING_DIR)/var/
