SPK_NAME = vim
SPK_VERS = 9.0
SPK_REV = 6
SPK_ICON = src/vim.png

DEPENDS = cross/$(SPK_NAME)
PYTHON_PACKAGE = python311
SPK_DEPENDS = "python311>=3.11.5-8"
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

MAINTAINER = SynoCommunity
DESCRIPTION = Vim is a highly configurable text editor built to enable efficient text editing. It is an improved version of the vi editor distributed with most UNIX systems.
DESCRIPTION_CSY = Vim je pokročilý textový editor, který usiluje o to poskytnout sílu de-facto Unixového editoru Vi, s komplexnější sadou vlastností.
DESCRIPTION_FRE = Vim est un éditeur de texte avancé basé sur Vi \(unix\) avec des fonctions plus complètes.
DISPLAY_NAME = Vim
STARTABLE = no

CHANGELOG = "Update vim to v9.0<br/>2. Migrate to Python 3.11"

HOMEPAGE = https://www.vim.org/
LICENSE  = Charityware

SPK_COMMANDS = bin/vim bin/vim$(subst .,,$(SPK_VERS)) bin/view bin/vimdiff bin/rvim bin/rview bin/vimtutor

include ../../mk/spksrc.python.mk
