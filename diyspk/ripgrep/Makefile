SPK_NAME = ripgrep
SPK_VERS = 15.1.0
SPK_REV = 1
SPK_ICON = src/ripgrep.png

# powerpc archs (except qoriq) are not supported
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

DEPENDS = cross/ripgrep

include ../../mk/spksrc.common.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
SPK_VERS = 14.1.1
else ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
ifeq ($(call version_le, $(TC_GCC), 5.0),1)
SPK_VERS = 14.1.1
endif
endif

MAINTAINER = Hylen
DESCRIPTION = ripgrep is a line-oriented search tool that recursively searches your current directory for a regex pattern.
DISPLAY_NAME = ripgrep
STARTABLE = no

HOMEPAGE = https://github.com/BurntSushi/ripgrep
LICENSE  = public domain/Unlicense

SPK_COMMANDS = bin/rg

include ../../mk/spksrc.spk.mk
