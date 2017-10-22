SPK_NAME = gitolite
SPK_VERS = 3.6.3
SPK_REV = 1
SPK_ICON = src/gitolite.png

DEPENDS = cross/dropbear cross/mktemp cross/busybox
SPK_DEPENDS = "git>1.8.2"

MAINTAINER = SynoCommunity
DESCRIPTION = Gitolite
DISPLAY_NAME = Gitolite
BETA = 1

RELOAD_UI = yes
HOMEPAGE = http://gitolite.com/
LICENSE  =

WIZARDS_DIR = src/wizard

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET =  git_server_extra_install

DROPBEAR_DEFAULT_PATH="/usr/local/git/bin:$(INSTALL_PREFIX)/bin:$(INSTALL_PREFIX)/bin/gitolite:/usr/syno/bin/:/usr/bin:/bin"
BUSYBOX_CONFIG = usrmng
ENV += DROPBEAR_DEFAULT_PATH=$(DROPBEAR_DEFAULT_PATH) BUSYBOX_CONFIG=$(BUSYBOX_CONFIG)

include ../../mk/spksrc.spk.mk

.PHONY: git_server_extra_install
git_server_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 755 -d $(STAGING_DIR)/var/repositories
	install -m 755 -d $(STAGING_DIR)/share
	git clone https://github.com/sitaramc/gitolite.git $(STAGING_DIR)/share/gitolite
	git -C $(STAGING_DIR)/share/gitolite reset --hard 5d24ae666bfd2fa9093d67c840eb8d686992083f
	rm -rf $(STAGING_DIR)/share/gitolite/.git*
