SPK_NAME = git-server
SPK_VERS = 1.8.2
SPK_REV = 3
SPK_ICON = src/git-server.png

DEPENDS = cross/git

MAINTAINER = SynoCommunity
DESCRIPTION = Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.
DESCRIPTION_FRE = Git est un logiciel de gestion de version décentralisée gratuit et open source destiné à gérer aussi bien les petits que les très gros projets avec vitesse et efficacité.
DISPLAY_NAME = Git Server

HOMEPAGE = http://git-scm.com/
LICENSE  =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET =  git_server_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: git_server_extra_install
git_server_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/run
	install -m 755 -d $(STAGING_DIR)/var/log
	install -m 755 -d $(STAGING_DIR)/var/repositories
