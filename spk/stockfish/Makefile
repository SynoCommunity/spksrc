SPK_NAME = stockfish
SPK_VERS = 11
SPK_REV = 1
SPK_ICON= src/stockfish.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = mayweed
DESCRIPTION = Strong open source chess engine. Stockfish is one of the strongest chess engines in the world. It is also much stronger than the best human chess grandmasters.
CHANGELOG = "Initial package version."

DISPLAY_NAME = Stockfish
STARTABLE = no
HOMEPAGE = https://stockfishchess.org/
LICENSE  = GPLv2/GPLv3

include ../../mk/spksrc.common.mk

# Toolchains lacking c++11 compiler ar not supported
UNSUPPORTED_ARCHS = $(ARM5_ARCHES) powerpc ppc824x ppc853x ppc854x

SPK_COMMANDS = "bin/stockfish"

include ../../mk/spksrc.spk.mk
