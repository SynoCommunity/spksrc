SPK_NAME = git
SPK_VERS = 2.3.7
SPK_REV = 4
SPK_ICON = src/git.png

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.
DESCRIPTION_FRE = Git est un logiciel de gestion de version décentralisée gratuit et open source destiné à gérer aussi bien les petits que les très gros projets avec vitesse et efficacité.
STARTABLE = no
DISPLAY_NAME = Git
CHANGELOG = Update Git to 2.3.7

HOMEPAGE = http://git-scm.com/
LICENSE  =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

BUSYBOX_CONFIG = tr
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk
