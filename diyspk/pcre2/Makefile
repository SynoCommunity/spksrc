SPK_NAME = pcre2
SPK_VERS = 10.44
SPK_REV = 1

DEPENDS = cross/pcre2

MAINTAINER = SynoCommunity
DESCRIPTION = The PCRE library is a set of functions that implement regular expression pattern matching using the same syntax and semantics as Perl 5. PCRE has its own native API, as well as a set of wrapper functions that correspond to the POSIX regular expression API.
DISPLAY_NAME = PCRE2
STARTABLE = no

HOMEPAGE = https://www.pcre.org
LICENSE = BSD

# activate additional features for pcre2grep and pcre2test
PCRE2_CLI_FULL = 1
export PCRE2_CLI_FULL

SPK_COMMANDS = bin/pcre2grep bin/pcre2test

include ../../mk/spksrc.spk.mk
