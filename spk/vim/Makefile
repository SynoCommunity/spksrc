SPK_NAME = vim
SPK_VERS = 9.1
SPK_REV = 8
SPK_ICON = src/vim.png

DEPENDS = cross/vim

MAINTAINER = SynoCommunity
DESCRIPTION = Vim is a highly configurable text editor built to enable efficient text editing. It is an improved version of the vi editor distributed with most UNIX systems.
DESCRIPTION_CSY = Vim je pokročilý textový editor, který usiluje o to poskytnout sílu de-facto Unixového editoru Vi, s komplexnější sadou vlastností.
DESCRIPTION_FRE = Vim est un éditeur de texte avancé basé sur Vi \(unix\) avec des fonctions plus complètes.
DISPLAY_NAME = Vim
STARTABLE = no

CHANGELOG = "1. Update vim to v9.1. <br/>2. Finally remove python feature."

HOMEPAGE = https://www.vim.org/
LICENSE  = Charityware

SPK_COMMANDS = bin/vim bin/vim$(firstword $(subst ., ,$(SPK_VERS)))
SPK_COMMANDS += bin/view bin/vimdiff bin/rvim bin/rview bin/vimtutor

include ../../mk/spksrc.spk.mk
