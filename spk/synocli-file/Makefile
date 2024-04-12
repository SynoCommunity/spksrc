SPK_NAME = synocli-file
SPK_VERS = 3.3
SPK_REV = 23
SPK_ICON = src/synocli-file.png

# cross/libblkid must be built before cross/e2fsprogs or cross/libext2fs
# otherwise rmlint does not use libblkid and is missing the "Optimize non-rotational disks" feature.
# - cross/mc depends on cross/libext2fs and when built before cross/libblkid the e2fsprogs source builds 
#   it's own libblkid and rmlint cannot find the working library of cross/libblkid.
BUILD_DEPENDS = cross/libblkid

DEPENDS  = cross/less cross/tree cross/ncdu cross/jdupes cross/rhash cross/nano cross/file
DEPENDS += cross/mc cross/pcre2 cross/fdupes cross/zstd
DEPENDS += cross/detox
DEPENDS += cross/lzip cross/plzip
DEPENDS += cross/mg
DEPENDS += cross/jupp
DEPENDS += cross/iconv
DEPENDS += cross/dos2unix
DEPENDS += cross/patch

OPTIONAL_DEPENDS  = cross/rmlint
OPTIONAL_DEPENDS += cross/rnm
OPTIONAL_DEPENDS += cross/micro
OPTIONAL_DEPENDS += cross/fzf
OPTIONAL_DEPENDS += cross/ripgrep
OPTIONAL_DEPENDS += cross/fd cross/fd_8.7.0
OPTIONAL_DEPENDS += cross/sd
OPTIONAL_DEPENDS += cross/bat
OPTIONAL_DEPENDS += cross/eza
OPTIONAL_DEPENDS += cross/nnn cross/nnn_4.0
OPTIONAL_DEPENDS += cross/lsd
OPTIONAL_DEPENDS += cross/xstow

MAINTAINER = hgy59
DISPLAY_NAME = SynoCli File Tools

POST_STRIP_TARGET = synocli-file_extra_install

OPTIONAL_DESC =

include ../../mk/spksrc.common.mk

ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
OPTIONAL_DESC := $(OPTIONAL_DESC)", nnn (n³)"
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
ifneq ($(findstring $(ARCH),comcerto2k),$(ARCH))
DEPENDS += cross/nnn
else
# comcerto2k for DSM>=7
DEPENDS += cross/nnn_4.0
endif
else ifneq ($(findstring $(ARCH),$(32bit_ARCHS)),$(ARCH))
DEPENDS += cross/nnn
else
# 32-bit archs for DSM<7
DEPENDS += cross/nnn_4.0
endif
endif

# PPC archs except QorIQ
ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS += cross/rmlint
OPTIONAL_DESC := $(OPTIONAL_DESC)", rmlint"
endif

# PPC archs are not supported with golang
ifneq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
DEPENDS += cross/micro cross/fzf
OPTIONAL_DESC := $(OPTIONAL_DESC)", micro (editor), fzf (fuzzy finder)"
endif

# OLD_PPC archs are not supported with rust
ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS += cross/bat cross/eza
OPTIONAL_DESC := $(OPTIONAL_DESC)", bat, eza"
DEPENDS += cross/ripgrep
OPTIONAL_DESC := $(OPTIONAL_DESC)", rg (ripgrep)"
ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
DEPENDS += cross/fd_8.7.0
else
DEPENDS += cross/fd
endif
OPTIONAL_DESC := $(OPTIONAL_DESC)", fd (fd-find)"
DEPENDS += cross/sd
OPTIONAL_DESC := $(OPTIONAL_DESC)", sd (sed alternative)"
DEPENDS += cross/lsd
OPTIONAL_DESC := $(OPTIONAL_DESC)", lsd"
endif

ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS += cross/xstow
OPTIONAL_DESC := $(OPTIONAL_DESC)", xstow"
endif

# activate additional features for pcre2grep and pcre2test
PCRE2_CLI_FULL = 1
export PCRE2_CLI_FULL

DESCRIPTION = "SynoCli File Tools provide a set of small command-line utilities: less, tree, ncdu, jdupes, fdupes, rhash, mc \(midnight commander\), mg \(emacs-like text editor\), nano, jupp \(based on JOE - Joe\'s Own Editor 3.1\), file, detox, pcre2, zstd, lzip, plzip, detox, iconv, dos2unix tools, patch$(OPTIONAL_DESC)."
STARTABLE = no
CHANGELOG = "1. Add xstow.<br/>2. Add patch.<br/>3. Update dos2unix to v7.5.2.<br/>4. Update eza v0.18.6.<br/>5. Update fd to v9.0.0.<br/>6. Update fzf to v0.46.1.<br/>7. Update mc to v4.8.31.<br/>8. Update lzip to v1.24 and plzip to v1.11.<br/>9. Update ripgrep to v14.1.0."

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
SPK_COMMANDS += bin/zstd bin/unzstd bin/zstdcat bin/zstdmt bin/zstdgrep bin/zstdless
SPK_COMMANDS += bin/lzip bin/plzip
SPK_COMMANDS += bin/fdupes
SPK_COMMANDS += bin/micro
SPK_COMMANDS += bin/fzf
SPK_COMMANDS += bin/rg
SPK_COMMANDS += bin/fd
SPK_COMMANDS += bin/sd
SPK_COMMANDS += bin/mg
SPK_COMMANDS += bin/bat
SPK_COMMANDS += bin/eza
SPK_COMMANDS += bin/lsd
SPK_COMMANDS += bin/jmacs bin/joe bin/jpico bin/jstar bin/jupp bin/rjoe
SPK_COMMANDS += bin/nnn
SPK_COMMANDS += bin/iconv
SPK_COMMANDS += bin/dos2unix bin/unix2dos bin/mac2unix bin/unix2mac

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

SPK_COMMANDS += bin/xstow bin/xstow-static bin/merge-info
SPK_COMMANDS += bin/patch

include ../../mk/spksrc.spk.mk

ifeq ($(call version_ge, $(TC_GCC), 4.8.1),1)
# A compiler with support for C++11 language features is required.
DEPENDS += cross/rnm
OPTIONAL_DESC := $(OPTIONAL_DESC)", rnm"
SPK_COMMANDS += bin/rnm
endif

.PHONY: synocli-file_extra_install
synocli-file_extra_install:
	@$(MSG) "Set library runpath in rhash executable."
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/bin/rhash
