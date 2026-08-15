###############################################################################
# spksrc.native/toolchain-rust.mk
#
# Rust component for spksrc.native-toolchain.mk (NATIVE_TOOLCHAIN = rust). Builds
# a custom Rust toolchain FROM SOURCE (rustc + cargo + host/target std, LLVM from
# the bundled source) against the (arch, DSM) toolchain's gcc + sysroot, for
# targets rustup ships no usable prebuilt rust-std for (Tier-3 PowerPC e500:
# qoriq, ppc853x; or a Tier-2 whose prebuilt std targets a newer glibc than the
# DSM toolchain: ARMv5 88f6281).
#
# The generic front-end provides TC_DIR / _tc_get / TC_TARGET / TC_GCC / TC_GLIBC /
# WORK_DIR / tc-extract and includes spksrc.native-cc.mk after this file. Only the
# x.py-specific steps are custom targets; the source pipeline (download/extract/
# patch) is the framework's, so patches live in native/rustc-<vers>/patches.
#
# Read from toolchain/syno-<arch>-<vers>/Makefile: RUST_POSTFIX_ALIASES, TC_EXTRA_CFLAGS,
# TC_EXTRA_RUSTFLAGS (the base triple comes from the arch map).
#
# Provides (consumed by native/rustc-<vers>/Makefile):
#   _RUST_TC_ID     shared rustup toolchain id, also the archive base name
#   RUST_STAGE_DIR  x.py stage output = the toolchain to archive (ARCHIVE_DIR)
###############################################################################

# Synology-vendored triple (uniform marker in ids/archive names, and it sidesteps the
# host==target collision on x86). Base triple from the central arch map (keyed on TC_ARCH
# since ARCH is empty here) -- the same source the consumer uses -- then unknown -> synology.
include ../../mk/spksrc.common/archs.mk
include ../../mk/spksrc.cross/env-rust.mk
RUST_TARGET_JSON_BASE := $(RUST_TARGET)
RUST_TARGET           := $(subst -unknown-,-synology-,$(RUST_TARGET_JSON_BASE))
RUST_POSTFIX_ALIASES  := $(call _tc_get,RUST_POSTFIX_ALIASES)

# RUST_LINK_VIA_BINUTILS: build the from-source std with a modern binutils 2.30 ld (the same
# ld the consumer's package link uses), narrow to the Rust link -- C stays on vendor gcc+ld.
# ppc853x needs it: its 2008 ld 2.18 leaves std's TLS TPREL16 relocs dynamic and glibc-2.8
# mis-applies them. Default ON for every custom-rustc arch; set =0 to opt out.
RUST_LINK_VIA_BINUTILS := $(or $(call _tc_get,RUST_LINK_VIA_BINUTILS),1)
RUST_BINUTILS_VERS     := $(or $(call _tc_get,OVERLAY_BINUTILS_VERS),2.30)
RUST_BINUTILS_DIR       = $(abspath $(CURDIR)/../binutils-$(RUST_BINUTILS_VERS))
RUST_BINUTILS_BIN       = $(RUST_BINUTILS_DIR)/work-$(TC_ARCH)-$(TC_VERS)/install/usr/local/bin
ifeq ($(RUST_LINK_VIA_BINUTILS),1)
# Build-time: link the target through the co-built ld (so std's own dynamic objects use
# the modern ld). A gcc -B wrapper, since gcc < 4.8 has no -fuse-ld.
RUST_BINUTILS_SHIM = $(WORK_DIR)/binutils-shim
RUST_LINKER        = $(WORK_DIR)/binutils-cc
endif

RUST_TARGET_JSON_DIR = $(WORK_DIR)/target-spec
RUST_TARGET_JSON     = $(RUST_TARGET_JSON_DIR)/$(RUST_TARGET).json
# The stock host rustc BINARY that emits the base spec -- NOT the distrib/cargo/bin rustup
# proxy, which rejects `--target <t>` for a t whose std is not installed (even for --print
# target-spec-json, which needs no std). tc-rust.mk installs this toolchain host-side.
HOST_RUSTC          ?= $(abspath $(BASE_DISTRIB_DIR)/rustup/toolchains/$(TC_RUSTC)-$(RUST_BUILD_HOST)/bin/rustc)

# Emit <RUST_TARGET>.json from the built-in base spec before the build (rustc_prepare depends
# on it); RUST_TARGET_PATH then lets x.py resolve it by name. Tweaks: vendor -> synology, drop
# is-builtin, bake cpu/features from TC_EXTRA_RUSTFLAGS's -Ctarget-cpu/-feature, rewrite metadata
# (tier 3). cpu/features MUST live in the spec (not just CARGO_TARGET_<triple>_RUSTFLAGS): x.py
# does NOT honor those when building the STD, so -Ctarget-cpu=e500 was silently dropped and the
# std got generic-PowerPC sync/lwsync (e500 traps as illegal instruction, LLVM D76614). The spec
# is read by both x.py and cargo and maturin can't clobber it. Linker/ar stay out (non-relocatable,
# via CARGO_TARGET_<triple>_* in tc_vars.rust.mk).
rustc_prepare: $(RUST_TARGET_JSON)
$(RUST_TARGET_JSON):
	@mkdir -p $(@D)
	@$(MSG) "native-rust: generating target-spec $@ (base $(RUST_TARGET_JSON_BASE) -> vendor synology)"
	RUSTC_BOOTSTRAP=1 \
	  $(HOST_RUSTC) -Zunstable-options --print target-spec-json --target $(RUST_TARGET_JSON_BASE) \
	  | RUST_TARGET_JSON_BASE="$(RUST_TARGET_JSON_BASE)" TC_EXTRA_RUSTFLAGS="$(TC_EXTRA_RUSTFLAGS)" python3 -c 'import os,json,sys,re; d=json.load(sys.stdin); d["vendor"]="synology"; d.pop("is-builtin",None); xf=os.environ.get("TC_EXTRA_RUSTFLAGS","").strip(); mc=re.search(r"-Ctarget-cpu=(\S+)",xf); d.update({"cpu":mc.group(1)} if mc else {}); mf=re.search(r"-Ctarget-feature=(\S+)",xf); d.update({"features":mf.group(1)} if mf else {}); desc="SynoCommunity custom rustc toolchain (from %s)"%os.environ["RUST_TARGET_JSON_BASE"]; desc+="; cpu/features baked into the spec: %s"%xf if xf else ""; d["metadata"]={"description":desc,"tier":3,"std":True,"host_tools":False}; json.dump(d,sys.stdout,indent=2)' > $@
# Reuse the exact flags the toolchain declares (qoriq/ppc853x SPE), instead of
# repeating them here.
TC_EXTRA_CFLAGS    := $(call _tc_get,TC_EXTRA_CFLAGS)
TC_EXTRA_RUSTFLAGS := $(call _tc_get,TC_EXTRA_RUSTFLAGS)

# RUST_ARCHIVE_REV is set by the native producer Makefile (RUST_ARCHIVE_REV ?= v1,
# CLI-overridable), mirroring native/binutils-2.30's BINUTILS_ARCHIVE_REV.

# The rust version is the native package's own PKG_VERS.
TC_RUSTC        = $(PKG_VERS)
# Build through stage 2 (the truly-current compiler); overridable.
# https://rustc-dev-guide.rust-lang.org/building/bootstrapping.html
TC_RUSTC_STAGE ?= 2
RUST_BUILD_HOST ?= x86_64-unknown-linux-gnu

# The extracted rust source (framework sets PKG_DIR = rustc-<vers>-src).
RUST_SRC        = $(WORK_DIR)/$(PKG_DIR)
RUST_BUILD_ROOT = $(RUST_SRC)/build
RUST_STAGE_DIR  = $(RUST_BUILD_ROOT)/host/stage$(TC_RUSTC_STAGE)
# x.py drops host tools (cargo, ...) here, a sibling of the stage dir -- NOT in
# stage<N>/bin/. cargo is copied over at the end of the stage2 step.
RUST_TOOLS_BIN  = $(RUST_BUILD_ROOT)/host/stage$(TC_RUSTC_STAGE)-tools-bin

# The target gcc this rustc is built with. TC_GCC_SUFFIX is empty for the stock gcc;
# a future gcc-overlay variant would set it so both coexist under distinct ids/archives.
TC_GCC_SUFFIX ?=
RUST_TOOL_BIN  = $(TC_EXTRACT_DIR)/bin/$(TC_TARGET)-
RUST_CC       ?= $(RUST_TOOL_BIN)gcc$(TC_GCC_SUFFIX)
RUST_CXX      ?= $(RUST_TOOL_BIN)g++$(TC_GCC_SUFFIX)
RUST_AR       ?= $(RUST_TOOL_BIN)ar
RUST_RANLIB   ?= $(RUST_TOOL_BIN)ranlib
# The link driver: gcc (which calls its binutils ld).
RUST_LINKER   ?= $(RUST_CC)

_RUST_TARGET_ENV  = $(subst -,_,$(RUST_TARGET))
_RUST_TARGET_UENV = $(shell echo $(RUST_TARGET) | tr 'a-z-' 'A-Z_')

# Shared toolchain id: <ver>-<target>-<arch>-<dsm>-gcc<gcc>. Also the archive base
# name. Must match the consumer (toolchain/syno-<arch>-<vers>-rust-gcc<gcc>) and
# overlay-rustc.mk's _RUST_TC_ID on the package-build side.
_RUST_TC_ID = $(TC_RUSTC)-$(RUST_TARGET)-$(TC_ARCH)-$(TC_VERS)-gcc$(TC_GCC)

# Per-step status line, matching the framework's NAME lines so the long x.py steps
# are trackable in status-build.log: NAME: native-rust-<step>.
rustc_status = $(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, ARCH: %s-%s, NAME: native-rust-%s\n" "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$(TC_ARCH)" "$(TC_VERS)" "$(1)") | tee --append $(STATUS_LOG)

# config.toml for ./x. The old-gcc knobs are emitted below gcc 4.7: the compiler-rt
# C in optimized-compiler-builtins is compiled by the `cc` crate with -gdwarf-4, an
# output level gcc predating 4.7 rejects. Below the floor we use the pure-Rust
# builtins (optimized-compiler-builtins = false) instead, which need no C at all.

define RUST_CONFIG_TOML
profile = "compiler"

[build]
build = "$(RUST_BUILD_HOST)"
host = ["$(RUST_BUILD_HOST)"]
target = ["$(RUST_BUILD_HOST)", "$(RUST_TARGET)"]
build-stage = $(TC_RUSTC_STAGE)
docs = false
compiler-docs = false
$(if $(call version_lt,$(TC_GCC),4.7),optimized-compiler-builtins = false)

[rust]
channel = "$(TC_RUSTC)"
lto = "off"
debuginfo-level = 0

[llvm]
download-ci-llvm = false

[target.$(RUST_BUILD_HOST)]
cc = "$(shell which gcc)"
cxx = "$(shell which g++)"
ar = "$(shell which ar)"
ranlib = "$(shell which ranlib)"
linker = "$(shell which gcc)"

[target.$(RUST_TARGET)]
cc = "$(RUST_CC)"
cxx = "$(RUST_CXX)"
ar = "$(RUST_AR)"
ranlib = "$(RUST_RANLIB)"
linker = "$(RUST_LINKER)"
endef

# ./x wrapper: target CFLAGS/RUSTFLAGS + the selected CC/CXX for the target.
_X = cd $(RUST_SRC) && \
     LC_ALL=C \
     CFLAGS_$(_RUST_TARGET_ENV)="$(TC_EXTRA_CFLAGS)" CC_$(_RUST_TARGET_ENV)="$(RUST_CC)" CXX_$(_RUST_TARGET_ENV)="$(RUST_CXX)" \
     CARGO_TARGET_$(_RUST_TARGET_UENV)_RUSTFLAGS="$(TC_EXTRA_RUSTFLAGS)" \
     RUST_TARGET_PATH="$(RUST_TARGET_JSON_DIR)" \
     CARGO_TERM_PROGRESS_WHEN=never CARGO_TERM_COLOR=never RUST_BACKTRACE=full ./x.py

# ---------------------------------------------------------------------------
# Framework hooks: the source pipeline (download/extract/patch) is stock; only
# the x.py steps are custom. Restartability is preserved by cookie-guarding LLVM
# and each stage individually (LLVM is the long one) INSIDE the compile step.
# ---------------------------------------------------------------------------
RUSTC_LLVM_COOKIE   = $(WORK_DIR)/.$(COOKIE_PREFIX)rustc-llvm_done
RUSTC_STAGE1_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)rustc-stage1_done
RUSTC_STAGE2_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)rustc-stage2_done

# PRE_CONFIGURE: extract the gcc toolchain (tc-extract, generic) and create the
# <alias>-<tool> symlinks rustc invokes the target tools by (triple name). When
# RUST_LINK_VIA_BINUTILS, also co-build the modern binutils and its build wrapper first.
PRE_CONFIGURE_TARGET = rustc_prepare
.PHONY: rustc_prepare
rustc_prepare: tc-extract $(if $(filter 1,$(RUST_LINK_VIA_BINUTILS)),rustc_binutils_cobuild)
	@$(call rustc_status,prepare)
	@cd $(TC_EXTRACT_DIR)/bin ; \
	for gnutool in $$(ls -1) ; do \
	  for alias in $(RUST_POSTFIX_ALIASES) ; do \
	    [ ! -L "$${alias}-$${gnutool##*-}" ] && ln -sf $${gnutool} "$${alias}-$${gnutool##*-}" || true ; \
	  done ; \
	done

# Co-build the modern binutils cross-ld for this (arch, DSM) and emit the build-time
# gcc wrapper ($(RUST_LINKER)) that routes the target link through it via -B. The wrapper
# is a plain passthrough (GNU ld accepts -Qy, so no arg filtering is needed).
define RUST_BINUTILS_CC_SCRIPT
#!/bin/sh
# The cross gcc with ld/as redirected to the co-built binutils $(RUST_BINUTILS_VERS)
# via -B. Used as the [target.*] linker for the from-source build.
exec "$(RUST_CC)" -B"$(RUST_BINUTILS_SHIM)" "$$@"
endef

.PHONY: rustc_binutils_cobuild
rustc_binutils_cobuild:
	@$(call rustc_status,binutils-cobuild)
	@$(MSG) "*********************************************************************"
	@$(MSG) "*** Co-building binutils $(RUST_BINUTILS_VERS) for $(TC_ARCH)-$(TC_VERS) (the Rust link overlay)"
	@$(MSG) "*** Auto-built here per-arch (RUST_LINK_VIA_BINUTILS); NOT a DEPENDS"
	@$(MSG) "*** PATH: $(RUST_BINUTILS_DIR)/work-$(TC_ARCH)-$(TC_VERS)"
	@$(MSG) "*********************************************************************"
	@# ARCH= TCVERSION= : disable native/binutils' stage0 (see overlay-binutils.mk) so it
	@# cannot re-bootstrap a toolchain and recurse.
	$(MAKE) --no-print-directory -C $(RUST_BINUTILS_DIR) ARCH= TCVERSION= TC_ARCH=$(TC_ARCH) TC_VERS=$(TC_VERS)
	@mkdir -p $(RUST_BINUTILS_SHIM)
	@ln -sf $(RUST_BINUTILS_BIN)/$(TC_TARGET)-ld $(RUST_BINUTILS_SHIM)/ld
	@ln -sf $(RUST_BINUTILS_BIN)/$(TC_TARGET)-as $(RUST_BINUTILS_SHIM)/as
	$(file >$(RUST_LINKER),$(RUST_BINUTILS_CC_SCRIPT))
	@chmod +x $(RUST_LINKER)

# CONFIGURE: write config.toml (regenerated each run -- cheap, always current).
CONFIGURE_TARGET = rustc_configure
.PHONY: rustc_configure
rustc_configure:
	@$(call rustc_status,config)
	$(file >$(RUST_SRC)/config.toml,$(RUST_CONFIG_TOML))

# COMPILE: LLVM, then stage1, then stage2 (rustc + cargo + host/target std).
COMPILE_TARGET = rustc_compile
.PHONY: rustc_compile
rustc_compile: $(RUSTC_LLVM_COOKIE) $(RUSTC_STAGE1_COOKIE) $(RUSTC_STAGE2_COOKIE)

$(RUSTC_LLVM_COOKIE):
	@$(call rustc_status,llvm)
	@rm -rf $(RUST_BUILD_ROOT)/*/llvm
	$(_X) build src/llvm-project
	@touch -f $@

$(RUSTC_STAGE1_COOKIE): $(RUSTC_LLVM_COOKIE)
	@$(call rustc_status,stage1)
	@(cd $(RUST_SRC) && ./x.py clean --stage 1) || true
	$(_X) build --stage 1 compiler/rustc
	@touch -f $@

$(RUSTC_STAGE2_COOKIE): $(RUSTC_STAGE1_COOKIE)
	@$(call rustc_status,stage$(TC_RUSTC_STAGE))
	@(cd $(RUST_SRC) && ./x.py clean --stage $(TC_RUSTC_STAGE)) || true
	$(_X) build --stage $(TC_RUSTC_STAGE)
	@# ORDER MATTERS -- every `./x build` re-stages the sysroot (bin/ + rustlib/),
	@# keeping only what that invocation produces:
	@#  1. cargo FIRST: `./x build cargo` re-stages rustlib host-only, so running it
	@#     after the target std would WIPE that std. x.py drops the binary in
	@#     stage<N>-tools-bin (not stage<N>/bin).
	$(_X) build --stage $(TC_RUSTC_STAGE) cargo
	@#  2. std for BOTH host and target as the LAST sysroot build, so both survive:
	@#     cargo needs the host std (build scripts/proc-macros) AND the target std to
	@#     cross-compile ("can't find crate for core/std" otherwise).
	$(_X) build --stage $(TC_RUSTC_STAGE) library --target $(RUST_BUILD_HOST),$(RUST_TARGET)
	@#  3. copy cargo in LAST -- step 2 re-staged bin/ and dropped it.
	@cp -f $(RUST_TOOLS_BIN)/cargo $(RUST_STAGE_DIR)/bin/cargo
	@touch -f $@

# INSTALL: nothing to stage into a prefix -- the stage2 dir IS the toolchain and is
# archived directly (ARCHIVE_DIR = RUST_STAGE_DIR in the package Makefile).
INSTALL_TARGET = rustc_install
.PHONY: rustc_install
rustc_install:
	@$(MSG) "native-rust: $(_RUST_TC_ID) staged in $(RUST_STAGE_DIR)"
	@# Ship the custom target-spec INSIDE the toolchain (archived with it) so a rust
	@# PACKAGE build can resolve the synology triple by name: the consumer extract puts
	@# it at <toolchain>/target-spec/<triple>.json, and tc_vars points RUST_TARGET_PATH
	@# there.
	@mkdir -p $(RUST_STAGE_DIR)/target-spec
	@cp -f $(RUST_TARGET_JSON) $(RUST_STAGE_DIR)/target-spec/
