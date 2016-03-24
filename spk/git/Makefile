SPK_NAME = git
SPK_VERS = 2.7.4
SPK_REV = 8
SPK_ICON = src/git.png

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = Diaoul
DESCRIPTION = Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.
DESCRIPTION_FRE = Git est un logiciel de gestion de version décentralisée gratuit et open source destiné à gérer aussi bien les petits que les très gros projets avec vitesse et efficacité.
STARTABLE = no
DISPLAY_NAME = Git
CHANGELOG = "1. Correct error in some powerpc compiles (e.g., DS413) <br> 2. Update Git to 2.7.4"

HOMEPAGE = http://git-scm.com
LICENSE  = GPLv2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

BUSYBOX_CONFIG = tr
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk
