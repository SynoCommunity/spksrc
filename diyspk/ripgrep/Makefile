SPK_NAME = ripgrep
SPK_VERS = 11.0.2
SPK_REV = 1
SPK_ICON = src/ripgrep.png

DEPENDS = cross/$(SPK_NAME)

# armv7 without hardfloat is not supported
UNSUPPORTED_ARCHS = hi3535
# powerpc archs (except qoriq) are not supported
UNSUPPORTED_ARCHS += powerpc ppc824x ppc853x ppc854x 

GENERIC_ARCHS = ARM7

MAINTAINER = Hylen
DESCRIPTION = ripgrep is a line-oriented search tool that recursively searches your current directory for a regex pattern.
STARTABLE = no
RELOAD_UI = no
DISPLAY_NAME = ripgrep

SPK_COMMANDS = bin/rg

HOMEPAGE = https://github.com/BurntSushi/ripgrep
LICENSE  = MIT/UNLICENSE

include ../../mk/spksrc.spk.mk
