SPK_NAME = synocli-file
SPK_VERS = 4.0.3
SPK_REV = 32
SPK_ICON = src/synocli-file.png

# cross/libblkid must be built before cross/e2fsprogs or cross/libext2fs
# otherwise rmlint does not use libblkid and is missing the "Optimize non-rotational disks" feature.
# - cross/mc depends on cross/libext2fs and when built before cross/libblkid the e2fsprogs source builds 
#   it's own libblkid and rmlint cannot find the working library of cross/libblkid.
BUILD_DEPENDS = cross/libblkid

DEPENDS  = cross/less cross/tree cross/jdupes cross/nano cross/file
DEPENDS += cross/mc cross/pcre2 cross/fdupes cross/zstd
DEPENDS += cross/detox
DEPENDS += cross/lzip cross/plzip
DEPENDS += cross/pixz
DEPENDS += cross/pigz
DEPENDS += cross/mg
DEPENDS += cross/jupp
DEPENDS += cross/libiconv
DEPENDS += cross/dos2unix
DEPENDS += cross/patch
DEPENDS += cross/rhash
DEPENDS += cross/eza cross/sd cross/lsd

MAINTAINER = hgy59
DISPLAY_NAME = SynoCli File Tools

OPTIONAL_DESC =

include ../../mk/spksrc.common.mk

# Each taken where its own floors admit the arch; descriptions follow spksrc.spk.mk.
$(call depend,cross/nnn,nop)
$(call depend,cross/rmlint,nop)
$(call depend,cross/micro,nop)
$(call depend,cross/fzf,nop)
$(call depend,cross/bat,nop)
$(call depend,cross/fd,nop)
$(call depend,cross/ripgrep,nop)
$(call depend,cross/ms-edit,nop)
$(call depend,cross/xstow,nop)
$(call depend,cross/rnm,nop)

# activate additional features for pcre2grep and pcre2test
PCRE2_CLI_FULL = 1
export PCRE2_CLI_FULL


HOMEPAGE = https://docs.synocommunity.com/packages/synocli-file/
LICENSE = Each tool is licensed under it's respective license.

DOCS_URL = "\<a target=\"_blank\" href=\"$(HOMEPAGE)\"\>SynoCli File Tools\</a\>"

# Remarks: html in DESCRIPTION is not supported
DESCRIPTION = "SynoCli File Tools provide a set of small command-line utilities: \
    less, tree, jdupes, fdupes, rhash, \
    mc \(midnight commander\), \
    mg \(emacs-like text editor\), nano, \
    jupp \(based on JOE - Joe\'s Own Editor 3.1\), \
    file, detox, pcre2, zstd, lzip, plzip, \
    pixz, \
    pigz, \
    detox, iconv, dos2unix tools, \
    eza, sd \(sed alternative\), lsd, \
    patch$(OPTIONAL_DESC)."
STARTABLE = no

CHANGELOG  = "1. Add extra encodings to iconv. <br/>"
CHANGELOG += "2. Update pcre2 from v10.46 to v10.48. <br/>"
CHANGELOG += "3. Update fd from v10.4.2 to v10.5.0; brings fd back to NVR and VS models (ARMv7L). <br/>"
CHANGELOG += "4. Update fzf from v0.74.2 to v0.74.3. <br/>"
CHANGELOG += "5. Update jdupes from v1.31.1 to v1.31.2. <br/>"
CHANGELOG += "<br/>For package details and specific licences see $(DOCS_URL)".

SERVICE_SETUP = src/service-setup.sh

SPK_COMMANDS  = bin/less bin/lesskey
SPK_USR_LOCAL_LINKS = bin:libexec/lessecho
SPK_COMMANDS += bin/tree
SPK_COMMANDS += bin/jdupes
SPK_COMMANDS += bin/mc bin/mcdiff bin/mcview bin/mcedit
SPK_COMMANDS += bin/nano bin/rnano
SPK_COMMANDS += bin/file
SPK_COMMANDS += bin/detox
SPK_COMMANDS += bin/pcre2grep bin/pcre2test
SPK_COMMANDS += bin/rmlint
SPK_COMMANDS += bin/zstd bin/unzstd bin/zstdcat bin/zstdmt bin/zstdgrep bin/zstdless
SPK_COMMANDS += bin/lzip bin/plzip
SPK_COMMANDS += bin/pixz
SPK_COMMANDS += bin/pigz bin/unpigz
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
SPK_COMMANDS += bin/edit
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

SPK_COMMANDS += bin/xstow bin/merge-info
SPK_COMMANDS += bin/patch

PLIST_TRANSFORM = sed -e '/^rsc:include\/rhash\.h$$/d'

include ../../mk/spksrc.spk.mk

# The optional tools taken above, in the description.
ifneq ($(filter cross/nnn,$(DEPENDS)),)
OPTIONAL_DESC := $(OPTIONAL_DESC)", nnn (n³)"
endif

ifneq ($(filter cross/rmlint,$(DEPENDS)),)
OPTIONAL_DESC := $(OPTIONAL_DESC)", rmlint"
endif

ifneq ($(filter cross/micro,$(DEPENDS)),)
OPTIONAL_DESC := $(OPTIONAL_DESC)", micro (editor)"
endif

ifneq ($(filter cross/fzf,$(DEPENDS)),)
OPTIONAL_DESC := $(OPTIONAL_DESC)", fzf (fuzzy finder)"
endif

ifneq ($(filter cross/bat,$(DEPENDS)),)
OPTIONAL_DESC := $(OPTIONAL_DESC)", bat"
endif

ifneq ($(filter cross/fd,$(DEPENDS)),)
OPTIONAL_DESC := $(OPTIONAL_DESC)", fd (fd-find)"
endif

ifneq ($(filter cross/ripgrep,$(DEPENDS)),)
OPTIONAL_DESC := $(OPTIONAL_DESC)", rg (ripgrep)"
endif

ifneq ($(filter cross/ms-edit,$(DEPENDS)),)
OPTIONAL_DESC := $(OPTIONAL_DESC)", edit (MS Editor)"
endif

ifneq ($(filter cross/xstow,$(DEPENDS)),)
OPTIONAL_DESC := $(OPTIONAL_DESC)", xstow"
endif

ifneq ($(filter cross/rnm,$(DEPENDS)),)
OPTIONAL_DESC := $(OPTIONAL_DESC)", rnm"
SPK_COMMANDS += bin/rnm
endif
