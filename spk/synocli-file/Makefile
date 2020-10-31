SPK_NAME = synocli-file
SPK_VERS = 1.2
SPK_REV = 4
SPK_ICON = src/synocli-file.png

include ../../mk/spksrc.common.mk

DEPENDS = cross/less cross/tree cross/ncdu cross/jdupes cross/rhash cross/mc cross/nano cross/file
DEPENDS += cross/detox cross/pcre2
OPTIONAL_DEPENDS = cross/rmlint cross/rnm

MAINTAINER = SynoCommunity
DISPLAY_NAME = SynoCli File Tools

OPTIONAL_DESC =

# PPC_ARCHES except QorIQ
ifneq ($(findstring $(ARCH), powerpc ppc824x ppc853x ppc854x),$(ARCH))
DEPENDS += cross/rmlint
OPTIONAL_DESC := $(OPTIONAL_DESC)", rmlint"
endif

ifneq ($(findstring $(ARCH), powerpc ppc824x ppc853x ppc854x $(ARM5_ARCHES)),$(ARCH))
# to build rnm, GCC >= 4.8 is required, but not contained in older toolchains.
DEPENDS += cross/rnm
OPTIONAL_DESC := $(OPTIONAL_DESC)", rnm"
endif

# activate additional features for pcre2grep and pcre2test
ENV += PCRE2_CLI_FULL=1

DESCRIPTION = "SynoCli File Tools provides a set of small command-line utilities: less, tree, ncdu, jdupes, rhash, mc \(midnight commander\), nano, file, detox, pcre2$(OPTIONAL_DESC)."
STARTABLE = no
CHANGELOG = "1. Update Midnight Commander to 4.2.25<br/>2. Update openssl to 1.1 (mc).<br/>3. Add links to pcre2grep and pcre2test.<br/>4. Update jdupes to 1.19.0<br/>5. Update less to v563.<br/>6. Update nano to 4.9<br/>7. Update ncdu to 1.15.1<br/>8. Update RHash to 1.4.0<br/>9. Update rnm to 4.0.9"

HOMEPAGE = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliFile
LICENSE  = Each tool is licensed under it\'s respective license.

SPK_COMMANDS  = bin/less bin/lessecho bin/lesskey
SPK_COMMANDS += bin/tree
SPK_COMMANDS += bin/ncdu
SPK_COMMANDS += bin/jdupes
SPK_COMMANDS += bin/mc bin/mcdiff bin/mcview bin/mcedit
SPK_COMMANDS += bin/nano bin/rnano
SPK_COMMANDS += bin/file
SPK_COMMANDS += bin/detox
SPK_COMMANDS += bin/pcre2grep bin/pcre2test
SPK_COMMANDS += bin/rmlint
SPK_COMMANDS += bin/rnm

SPK_COMMANDS += bin/rhash
SPK_LINKS  = /usr/local/bin/ed2k-link:bin/rhash 
SPK_LINKS += /usr/local/bin/edonr256-hash:bin/rhash 
SPK_LINKS += /usr/local/bin/edonr512-hash:bin/rhash 
SPK_LINKS += /usr/local/bin/gost-hash:bin/rhash 
SPK_LINKS += /usr/local/bin/has160-hash:bin/rhash 
SPK_LINKS += /usr/local/bin/magnet-link:bin/rhash 
SPK_LINKS += /usr/local/bin/sfv-hash:bin/rhash 
SPK_LINKS += /usr/local/bin/tiger-hash:bin/rhash 
SPK_LINKS += /usr/local/bin/tth-hash:bin/rhash 
SPK_LINKS += /usr/local/bin/whirlpool-hash:bin/rhash 


include ../../mk/spksrc.spk.mk
