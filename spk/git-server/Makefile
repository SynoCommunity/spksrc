SPK_NAME = git-server
SPK_VERS = 1.8.2
SPK_REV = 5
SPK_ICON = src/git-server.png
DSM_UI_DIR = app

DEBUG = true

DEPENDS = cross/dropbear-git-server
SPK_DEPENDS = "git>1.8.2"

MAINTAINER = SynoCommunity
DESCRIPTION = Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.
DESCRIPTION_FRE = Git est un logiciel de gestion de version décentralisée gratuit et open source destiné à gérer aussi bien les petits que les très gros projets avec vitesse et efficacité.
DISPLAY_NAME = Git Server

RELOAD_UI = yes
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
	install -m 755 -d $(STAGING_DIR)/tmp
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 755 -d $(STAGING_DIR)/var/run
	install -m 755 -d $(STAGING_DIR)/var/log
	install -m 755 -d $(STAGING_DIR)/var/repositories
	install -m 755 -d $(STAGING_DIR)/share
	install -m 755 -d $(STAGING_DIR)/share/gitweb
	install -m 644 src/gitweb.apache2.conf $(STAGING_DIR)/etc/
	install -m 644 src/gitweb_config.perl $(STAGING_DIR)/share/gitweb/
	git clone https://github.com/kogakure/gitweb-theme.git $(STAGING_DIR)/share/gitweb/static
	#cp src/gitweb-theme/git* $(STAGING_DIR)/share/gitweb/static/
	rm $(STAGING_DIR)/share/gitweb/static/.gitignore
	rm -rf $(STAGING_DIR)/share/gitweb/static/.git/
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	#install -m 755 src/app/git-server.cgi.pl $(STAGING_DIR)/app/git-server.cgi
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 ; \
	do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		$(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
