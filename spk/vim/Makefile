SPK_NAME = vim
SPK_VERS = 7.4
SPK_REV = 2
SPK_ICON = src/vim.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Vim is an advanced text editor that seeks to provide the power of the de-facto Unix editor Vi, with a more complete feature set.
DESCRIPTION_CSY = Vim je pokročilý textový editor, který usiluje o to poskytnout sílu de-facto Unixového editoru Vi, s komplexnější sadou vlastností.
DESCRIPTION_FRE = Vim est un éditeur de texte avancé basé sur Vi \(unix\) avec des fonctions plus complètes.
RELOAD_UI = no
DISPLAY_NAME = Vim
STARTABLE = no
BETA = 1
CHANGELOG = "1. Support UTF8 by default"

HOMEPAGE   = http://www.vim.org/
LICENSE    = Charityware

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = vim_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: vim_extra_install
vim_extra_install:
	install -m 755 src/vim-utf8 $(STAGING_DIR)/bin/vim-utf8
