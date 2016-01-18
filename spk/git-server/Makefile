SPK_NAME = git-server
SPK_VERS = 1.8.3
SPK_REV = 1
SPK_ICON = src/git-server.png
DSM_UI_DIR = app

DEPENDS = cross/dropbear cross/mktemp cross/busybox
SPK_DEPENDS = "git>1.8.2"

MAINTAINER = Diaoul
DESCRIPTION = Git Server turns your DiskStation into a powerfull server for the popular DSCM git. It supports git-daemon, a themed gitweb, gitolite and ssh through a dedicated daemon.
DESCRIPTION_FRE = Git Server transforme votre DiskStation en puissant serveur pour le DSCM populaire git. Il apporte git-daemon, gitweb avec un thème, gitolite et ssh à travers un daemon dédié.
DISPLAY_NAME = Git Server
BETA = 1

RELOAD_UI = yes
HOMEPAGE = http://git-scm.com/
LICENSE  =

WIZARDS_DIR = src/wizard

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_DEP_SERVICES = apache-web
START_DEP_SERVICES = apache-web
INSTUNINST_RESTART_SERVICES = apache-web

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET =  git_server_extra_install

DROPBEAR_DEFAULT_PATH="/usr/local/git/bin:$(INSTALL_PREFIX)/bin:$(INSTALL_PREFIX)/bin/gitolite:/usr/syno/bin/:/usr/bin:/bin"
BUSYBOX_CONFIG = usrmng
ENV += DROPBEAR_DEFAULT_PATH=$(DROPBEAR_DEFAULT_PATH) BUSYBOX_CONFIG=$(BUSYBOX_CONFIG)

include ../../mk/spksrc.spk.mk

.PHONY: git_server_extra_install
git_server_extra_install:
	install -m 755 -d $(STAGING_DIR)/tmp
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 755 -d $(STAGING_DIR)/var/repositories
	install -m 755 -d $(STAGING_DIR)/share
	install -m 755 -d $(STAGING_DIR)/share/gitweb
	install -m 644 src/gitweb.conf $(STAGING_DIR)/etc/
	install -m 644 src/gitweb_config.perl $(STAGING_DIR)/etc/
	git clone https://github.com/kogakure/gitweb-theme.git $(STAGING_DIR)/share/gitweb/static
	rm -rf $(STAGING_DIR)/share/gitweb/static/.git*
	git clone https://github.com/sitaramc/gitolite.git $(STAGING_DIR)/share/gitolite
	rm -rf $(STAGING_DIR)/share/gitolite/.git*
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72 ; \
	do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		$(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
