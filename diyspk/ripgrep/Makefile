SPK_NAME = ripgrep
SPK_VERS = 13.0.0
SPK_REV = 1
SPK_ICON = src/ripgrep.png

DEPENDS = cross/$(SPK_NAME)

# powerpc archs (except qoriq) are not supported
UNSUPPORTED_ARCHS += $(OLD_PPC_ARCHS)

MAINTAINER = Hylen
DESCRIPTION = ripgrep is a line-oriented search tool that recursively searches your current directory for a regex pattern.
DISPLAY_NAME = ripgrep
STARTABLE = no

SPK_COMMANDS = bin/rg

HOMEPAGE = https://github.com/BurntSushi/ripgrep
LICENSE  = public domain/Unlicense

include ../../mk/spksrc.spk.mk
