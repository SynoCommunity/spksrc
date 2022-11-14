SPK_NAME = aria2
SPK_VERS = 1.36.0
SPK_REV = 1
SPK_ICON = src/aria2.png

DEPENDS = cross/aria2

# archs with too old c++ compiler (c++ 11 is required)
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt,${TCVERSION},6.0)$(call version_gt,${TCVERSION},2.0),11)
# compiler too old
UNSUPPORTED_ARCHS += $(ARCH)
endif

MAINTAINER = cnrat
DESCRIPTION = aria2 is a lightweight multi-protocol and multi-source command-line download utility.
DESCRIPTION_CHS = Aria2是一个命令行下运行、多协议、多来源下载工具（HTTP/HTTPS、FTP、BitTorrent、Metalink）。
STARTABLE = yes
DISPLAY_NAME = Aria2
CHANGELOG = "Initial package release."

LICENSE  = GPLv2/GPLv3
HOMEPAGE = http://aria2.github.io
BETA = 1

WIZARDS_DIR = src/wizard

# 'auto' reserved value grabs SPK_NAME
SERVICE_USER         = auto
SERVICE_WIZARD_GROUP = wizard_group
SERVICE_WIZARD_SHARE = wizard_download_dir
SERVICE_SETUP        = src/service-setup.sh

# Service configuration
SERVICE_PORT = 6800
SERVICE_PORT_TITLE = Aria2 RPC

# Admin link
ADMIN_PORT = $(SERVICE_PORT)

PRE_COPY_TARGET = aria2_service_install
POST_STRIP_TARGET = aria2_post_install

include ../../mk/spksrc.spk.mk

.PHONY: aria2_service_install
aria2_service_install:
	rm -fr $(STAGING_DIR)
	mkdir $(STAGING_DIR)
	mkdir --parents $(STAGING_INSTALL_PREFIX)

.PHONY: aria2_post_install
aria2_post_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/aria2.conf $(STAGING_DIR)/var/aria2.conf
	install -m 644 src/aria2.dht $(STAGING_DIR)/var/aria2.dht
	install -m 644 src/aria2.session $(STAGING_DIR)/var/aria2.session
	install -m 644 src/aria2.log $(STAGING_DIR)/var/aria2.log
