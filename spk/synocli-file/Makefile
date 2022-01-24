SPK_NAME = synocli-file
SPK_VERS = 2.5
SPK_REV = 13
SPK_ICON = src/synocli-file.png

# packages depending on cross/zlib must be defined later, see below
DEPENDS = cross/less cross/tree cross/ncdu cross/jdupes cross/rhash cross/nano cross/file
DEPENDS += cross/detox
DEPENDS += cross/lzip cross/plzip
DEPENDS += cross/mg
DEPENDS += cross/jupp

OPTIONAL_DEPENDS  = cross/rmlint cross/rnm cross/micro cross/fzf cross/ripgrep cross/fd
OPTIONAL_DEPENDS += cross/bat cross/exa
OPTIONAL_DEPENDS += cross/nnn

MAINTAINER = SynoCommunity
DISPLAY_NAME = SynoCli File Tools

OPTIONAL_DESC =

include ../../mk/spksrc.common.mk

# build rust tools before packages depending on cross/zlib
# These tools must use cross/zlib-ng instead of cross/zlib, otherwise will fail to find zlib (x64 only)
ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS) $(ARMv5_ARCHS)),$(ARCH))
DEPENDS += cross/bat cross/exa
OPTIONAL_DESC := $(OPTIONAL_DESC)", bat, exa"
endif

# packages depending on cross/zlib
DEPENDS += cross/mc cross/pcre2 cross/fdupes cross/zstd


# PPC archs except QorIQ
ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS += cross/rmlint
OPTIONAL_DESC := $(OPTIONAL_DESC)", rmlint"
endif

TC_HAS_STDC11 = 0
ifeq ($(call version_ge, ${TCVERSION}, 6.0),1)
TC_HAS_STDC11 = 1
endif
ifeq ($(call version_lt, ${TCVERSION}, 3.0),1)
TC_HAS_STDC11 = 1
endif

ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS) $(ARMv5_ARCHS)),$(ARCH))
ifeq ($(TC_HAS_STDC11),1)
# to build rnm, GCC >= 4.8 is required, but not contained in older toolchains.
DEPENDS += cross/rnm
OPTIONAL_DESC := $(OPTIONAL_DESC)", rnm"
# to build nnn -std=c11 is required
DEPENDS += cross/nnn
OPTIONAL_DESC := $(OPTIONAL_DESC)", nnn (n³)"
endif
endif

# PPC archs are not supported with golang
ifneq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
DEPENDS += cross/micro cross/fzf
OPTIONAL_DESC := $(OPTIONAL_DESC)", micro (editor), fzf (fuzzy finder)"
endif

ifneq ($(findstring $(ARCH), $(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS += cross/ripgrep
OPTIONAL_DESC := $(OPTIONAL_DESC)", rg (ripgrep)"
DEPENDS += cross/fd
OPTIONAL_DESC := $(OPTIONAL_DESC)", fd (fd-find)"
endif


# activate additional features for pcre2grep and pcre2test
PCRE2_CLI_FULL = 1
export PCRE2_CLI_FULL

DESCRIPTION = "SynoCli File Tools provides a set of small command-line utilities: less, tree, ncdu, jdupes, fdupes, rhash, mc \(midnight commander\), mg \(emacs-like text editor\), nano, jupp \(based on JOE - Joe\'s Own Editor 3.1\), file, detox, pcre2, zstd, lzip, plzip, detox$(OPTIONAL_DESC)."
STARTABLE = no
CHANGELOG = "1. Add jupp editor.<br/>2. Add nnn (n³) file manager."

SERVICE_SETUP = src/service-setup.sh

HOMEPAGE = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliFile
LICENSE  = Each tool is licensed under it's respective license.

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
SPK_COMMANDS += bin/lzip bin/plzip
SPK_COMMANDS += bin/fdupes
SPK_COMMANDS += bin/micro
SPK_COMMANDS += bin/fzf
SPK_COMMANDS += bin/rg
SPK_COMMANDS += bin/fd
SPK_COMMANDS += bin/mg
SPK_COMMANDS += bin/bat
SPK_COMMANDS += bin/exa
SPK_COMMANDS += bin/jmacs bin/joe bin/jpico bin/jstar bin/jupp bin/rjoe
SPK_COMMANDS += bin/nnn

SPK_COMMANDS += bin/rhash
SPK_COMMANDS += bin/ed2k-link
SPK_COMMANDS += bin/edonr256-hash
SPK_COMMANDS += bin/edonr512-hash
SPK_COMMANDS += bin/gost12-256-hash
SPK_COMMANDS += bin/gost12-512-hash
SPK_COMMANDS += bin/has160-hash
SPK_COMMANDS += bin/magnet-link
SPK_COMMANDS += bin/sfv-hash
SPK_COMMANDS += bin/tiger-hash
SPK_COMMANDS += bin/tth-hash
SPK_COMMANDS += bin/whirlpool-hash

include ../../mk/spksrc.spk.mk
