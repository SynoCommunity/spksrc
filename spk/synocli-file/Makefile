SPK_NAME = synocli-file
SPK_VERS = 2.1
SPK_REV = 7
SPK_ICON = src/synocli-file.png

DEPENDS = cross/less cross/tree cross/ncdu cross/jdupes cross/rhash cross/mc cross/nano cross/file
DEPENDS += cross/detox cross/pcre2
DEPENDS += cross/zstd
DEPENDS += cross/fdupes
OPTIONAL_DEPENDS = cross/rmlint cross/rnm

MAINTAINER = SynoCommunity
DISPLAY_NAME = SynoCli File Tools

OPTIONAL_DESC =

include ../../mk/spksrc.archs.mk

# PPC archs except QorIQ
ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS += cross/rmlint
OPTIONAL_DESC := $(OPTIONAL_DESC)", rmlint"
endif

ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS) $(ARMv5_ARCHS)),$(ARCH))
# to build rnm, GCC >= 4.8 is required, but not contained in older toolchains.
DEPENDS += cross/rnm
OPTIONAL_DESC := $(OPTIONAL_DESC)", rnm"
endif

# activate additional features for pcre2grep and pcre2test
PCRE2_CLI_FULL=1
export PCRE2_CLI_FULL

DESCRIPTION = "SynoCli File Tools provides a set of small command-line utilities: less, tree, ncdu, jdupes, fdupes, rhash, mc \(midnight commander\), nano, file, detox, pcre2, zstd$(OPTIONAL_DESC)."
STARTABLE = no
CHANGELOG = "Fix fdupes and pcre2 tools"

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
SPK_COMMANDS += bin/zstd bin/unzstd bin/zstdcat bin/zstdmt bin/zstdgrep bin/zstdless
SPK_COMMANDS += bin/fdupes

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
