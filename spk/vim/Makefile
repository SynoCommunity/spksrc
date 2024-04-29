SPK_NAME = vim
SPK_VERS = 9.0
SPK_REV = 6
SPK_ICON = src/vim.png

DEPENDS = cross/$(SPK_NAME)
PYTHON_PACKAGE = python311

MAINTAINER = SynoCommunity
DESCRIPTION = Vim is a highly configurable text editor built to enable efficient text editing. It is an improved version of the vi editor distributed with most UNIX systems.
DESCRIPTION_CSY = Vim je pokročilý textový editor, který usiluje o to poskytnout sílu de-facto Unixového editoru Vi, s komplexnější sadou vlastností.
DESCRIPTION_FRE = Vim est un éditeur de texte avancé basé sur Vi \(unix\) avec des fonctions plus complètes.
DISPLAY_NAME = Vim
STARTABLE = no

CHANGELOG = "1. Update vim to v9.0"

HOMEPAGE = https://www.vim.org/
LICENSE  = Charityware

include ../../mk/spksrc.archs.mk

ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
CHANGELOG += "<br/>2. Migrate to Python 3.11"
DESCRIPTION += "NOTE: You need to install Python 3.11 package to enable Python support."
else
CHANGELOG += "<br/>2. Remove  python support"
DESCRIPTION += "NOTE: This package is built without Python support."
endif
SPK_COMMANDS = bin/vim bin/vim$(subst .,,$(SPK_VERS)) bin/view bin/vimdiff bin/rvim bin/rview bin/vimtutor

include ../../mk/spksrc.python.mk
