SPK_NAME = pcre2
SPK_VERS = 10.48
SPK_REV = 1

DEPENDS = cross/pcre2

MAINTAINER = SynoCommunity
DESCRIPTION = The PCRE2 library is a set of C functions that implement regular expression pattern matching.
DISPLAY_NAME = PCRE2
STARTABLE = no

HOMEPAGE = https://pcre2project.github.io/pcre2/
LICENSE = BSD

# activate additional features for pcre2grep and pcre2test
PCRE2_CLI_FULL = 1
export PCRE2_CLI_FULL

SPK_COMMANDS = bin/pcre2grep bin/pcre2test

include ../../mk/spksrc.spk.mk
