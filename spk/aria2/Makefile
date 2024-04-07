SPK_NAME = aria2
SPK_VERS = 1.37.0
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
DISPLAY_NAME = Aria2
CHANGELOG = "Initial package release."

LICENSE  = GPLv2/GPLv3
HOMEPAGE = http://aria2.github.io

WIZARDS_DIR = src/wizard

STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh
SERVICE_USER = auto
SERVICE_WIZARD_SHARENAME = wizard_download_share

# Service configuration
SERVICE_PORT = 6800
FWPORTS = src/aria2.sc
NO_SERVICE_SHORTCUT = yes

POST_STRIP_TARGET = aria2_post_install

include ../../mk/spksrc.spk.mk

.PHONY: aria2_post_install
aria2_post_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/aria2.conf $(STAGING_DIR)/var/aria2.conf
