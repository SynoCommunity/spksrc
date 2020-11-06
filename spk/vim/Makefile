SPK_NAME = vim
SPK_VERS = 8.2
SPK_REV = 3
SPK_ICON = src/vim.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Vim is a highly configurable text editor built to enable efficient text editing. It is an improved version of the vi editor distributed with most UNIX systems.
DESCRIPTION_CSY = Vim je pokročilý textový editor, který usiluje o to poskytnout sílu de-facto Unixového editoru Vi, s komplexnější sadou vlastností.
DESCRIPTION_FRE = Vim est un éditeur de texte avancé basé sur Vi \(unix\) avec des fonctions plus complètes.
RELOAD_UI = no
DISPLAY_NAME = Vim
STARTABLE = no

CHANGELOG = "1. Update to vim 8.2<br>2. Enable Python 3 support if Python >= 3.6.1 is installed."

HOMEPAGE = https://www.vim.org/
LICENSE  = Charityware

POST_STRIP_TARGET = vim_extra_install

SPK_COMMANDS = bin/view bin/vimdiff bin/rvim bin/rview bin/vimtutor
SPK_LINKS  = /usr/local/bin/vim:bin/vim-utf8
SPK_LINKS += /usr/local/bin/vim$(subst .,,$(SPK_VERS)):bin/vim-utf8

include ../../mk/spksrc.spk.mk

.PHONY: vim_extra_install
vim_extra_install:
	install -m 755 src/vim-utf8 $(STAGING_DIR)/bin/vim-utf8
