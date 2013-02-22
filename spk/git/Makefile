SPK_NAME = git
SPK_VERS = 1.8.14
SPK_REV = 0.1
SPK_ICON = src/logo.png
DSM_UI_DIR = app

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = Denia - Denia.jenkins@gmail.com
DESCRIPTION = Git is a free and open source, distributed version control system designed to handle everything from small to very large projects with speed and efficiency.
DESCRIPTION_FRE = Git est un logiciel de gestion de versions décentralisé libre et gratuit. Il à été conçu pour gérer de petits comme de trés grand projet avec efficacité.
RELOAD_UI = yes
DISPLAY_NAME = Git

HOMEPAGE = http://git-scm.com/
LICENSE  = GPLv2

#WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)


BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk


