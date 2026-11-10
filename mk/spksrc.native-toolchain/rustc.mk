###############################################################################
# spksrc.native-toolchain/rustc.mk
#
# Rust component for spksrc.native-toolchain.mk (PKG_NAME = rustc). Builds
# a custom Rust toolchain FROM SOURCE (rustc + cargo + host/target std, LLVM from
# the bundled source) against the (arch, DSM) toolchain's gcc + sysroot, for
# targets rustup ships no usable prebuilt rust-std for (Tier-3 PowerPC e500:
# qoriq, ppc853x; or a Tier-2 whose prebuilt std targets a newer glibc than the
# DSM toolchain: ARMv5 88f6281).
#
# The generic front-end provides TC_DIR / _tc_get / TC_TARGET / TC_GCC / TC_GLIBC /
# WORK_DIR / tc-install / TOOLCHAIN_BINUTILS_* and includes spksrc.native-cc.mk after this
# file. Only the
# x.py-specific steps are custom targets; the source pipeline (download/extract/
# patch) is the framework's, so patches live in native/rustc-<vers>/patches.
#
# Read from toolchain/syno-<arch>-<vers>/Makefile: TC_EXTRA_CFLAGS, TC_EXTRA_RUSTFLAGS. The
# triple and tool aliases derive from the arch map, RUST_MAX_ATOMIC_WIDTH from the
# libatomic probe.
#
# Provides (consumed by native/rustc-<vers>/Makefile):
#   _RUST_TC_ID     shared rustup toolchain id, also the archive base name
#   RUST_STAGE_DIR  x.py stage output = the toolchain to archive (ARCHIVE_DIR)
###############################################################################

# Synology-vendored triple (uniform marker in ids/archive names, and it sidesteps the
# host==target collision on x86). Base triple from the central arch map (keyed on TC_ARCH
# since ARCH is empty here) -- the same source the consumer uses -- then unknown -> synology.
# The arch groups it reads come with spksrc.common.mk, which the front-end includes first.
include ../../mk/spksrc.cross/env-rust.mk
RUST_TARGET_JSON_BASE := $(RUST_TARGET)
RUST_TARGET           := $(subst -unknown-,-synology-,$(RUST_TARGET_JSON_BASE))
# <triple>-<tool> symlink prefixes the built rustc may invoke by name: both forms of our
# own triple. Derived, not declared -- no other spelling was ever reached.
RUST_POSTFIX_ALIASES  := $(RUST_TARGET_JSON_BASE) $(RUST_TARGET)

# RUST_LINK_VIA_BINUTILS: build the from-source std with a modern binutils 2.30 ld (the same
# ld the consumer's package link uses), narrow to the Rust link -- C stays on vendor gcc+ld.
# ppc853x needs it: its 2008 ld 2.18 leaves std's TLS TPREL16 relocs dynamic and glibc-2.8
# mis-applies them. ON for every custom-rustc arch; RUST_LINK_VIA_BINUTILS=0 on the command
# line opts out. The binutils is the front-end's TOOLCHAIN_BINUTILS_*.
RUST_LINK_VIA_BINUTILS := 1
ifeq ($(RUST_LINK_VIA_BINUTILS),1)
# Build-time: link the target through the co-built ld (so std's own dynamic objects use
# the modern ld). A gcc -B wrapper, since gcc < 4.8 has no -fuse-ld.
RUST_BINUTILS_SHIM = $(WORK_DIR)/binutils-shim
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
	@$(if $(RUST_MAX_ATOMIC_WIDTH),$(MSG) "native-rust: gcc ships libatomic -- widening max-atomic-width to $(RUST_MAX_ATOMIC_WIDTH) (AtomicU64 via __atomic_*_8 libcalls)",:)
	RUSTC_BOOTSTRAP=1 \
	  $(HOST_RUSTC) -Zunstable-options --print target-spec-json --target $(RUST_TARGET_JSON_BASE) \
	  | RUST_TARGET_JSON_BASE="$(RUST_TARGET_JSON_BASE)" TC_EXTRA_RUSTFLAGS="$(TC_EXTRA_RUSTFLAGS)" RUST_MAX_ATOMIC_WIDTH="$(RUST_MAX_ATOMIC_WIDTH)" python3 -c 'import os,json,sys,re; d=json.load(sys.stdin); d["vendor"]="synology"; d.pop("is-builtin",None); xf=os.environ.get("TC_EXTRA_RUSTFLAGS","").strip(); mc=re.search(r"-Ctarget-cpu=(\S+)",xf); d.update({"cpu":mc.group(1)} if mc else {}); mf=re.search(r"-Ctarget-feature=(\S+)",xf); d.update({"features":mf.group(1)} if mf else {}); desc="SynoCommunity custom rustc toolchain (from %s)"%os.environ["RUST_TARGET_JSON_BASE"]; desc+="; cpu/features baked into the spec: %s"%xf if xf else ""; maw=os.environ.get("RUST_MAX_ATOMIC_WIDTH","").strip(); d.update({"max-atomic-width":int(maw)} if maw else {}); d["metadata"]={"description":desc,"tier":3,"std":True,"host_tools":False}; json.dump(d,sys.stdout,indent=2)' > $@
# Reuse the exact flags the toolchain declares (qoriq/ppc853x SPE), instead of
# repeating them here.
TC_EXTRA_CFLAGS    := $(call _tc_get,TC_EXTRA_CFLAGS)
TC_EXTRA_RUSTFLAGS := $(call _tc_get,TC_EXTRA_RUSTFLAGS)
# Widen the spec to 64 wherever the gcc ships libatomic: 64-bit atomics then lower to
# __atomic_*_8 libcalls, exposing AtomicU64 on a 32-bit arch. Derived, not declared -- the
# same probe gates the -latomic link flag (spksrc.toolchain/overlay/rustc.mk). Lazy: it
# runs the cross gcc.
RUST_MAX_ATOMIC_WIDTH = $(if $(TC_HAS_LIBATOMIC),64)

# The rust version is the native package's own PKG_VERS.
TC_RUSTC        = $(PKG_VERS)
# Build through stage 2 (the truly-current compiler); overridable.
# https://rustc-dev-guide.rust-lang.org/building/bootstrapping.html
TC_RUSTC_STAGE ?= 2
RUST_BUILD_HOST ?= $(RUST_BUILD_TRIPLE)

# The extracted rust source (framework sets PKG_DIR = rustc-<vers>-src).
RUST_SRC        = $(WORK_DIR)/$(PKG_DIR)
RUST_BUILD_ROOT = $(RUST_SRC)/build
RUST_STAGE_DIR  = $(RUST_BUILD_ROOT)/host/stage$(TC_RUSTC_STAGE)
# x.py drops host tools (cargo, ...) here, a sibling of the stage dir -- NOT in
# stage<N>/bin/. cargo is copied over at the end of the stage2 step.
RUST_TOOLS_BIN  = $(RUST_BUILD_ROOT)/host/stage$(TC_RUSTC_STAGE)-tools-bin

# The target gcc this rustc is built with: the stock one, or the gcc overlay when it is
# active. TC_GCC_SUFFIX and TC_OVERLAY_GCC_PATH both come from overlay.mk, which now
# resolves here because native-toolchain.mk declares TC_ARCH_SUFFIX.
#
# gcc and g++ only: the overlay archive ships no binutils, so ar and ranlib keep coming
# from the toolchain that has them.
TC_GCC_SUFFIX ?= $(if $(_OVERLAY_GCC_ON),-$(OVERLAY_GCC_VERSION))
_RUST_GCC_BIN  = $(if $(_OVERLAY_GCC_ON),$(_OVERLAY_GCC_DIR)/work/install/usr/local/bin/,$(TC_EXTRACT_DIR)/bin/)
RUST_TOOL_BIN  = $(TC_EXTRACT_DIR)/bin/$(TC_TARGET)-
RUST_CC       ?= $(_RUST_GCC_BIN)$(TC_TARGET)-gcc$(TC_GCC_SUFFIX)
RUST_CXX      ?= $(_RUST_GCC_BIN)$(TC_TARGET)-g++$(TC_GCC_SUFFIX)
RUST_AR       ?= $(RUST_TOOL_BIN)ar
RUST_RANLIB   ?= $(RUST_TOOL_BIN)ranlib
# The link driver: the co-built binutils wrapper when the Rust link is routed through the
# overlay ld, otherwise plain gcc (which calls its own binutils ld).
RUST_LINKER   ?= $(if $(filter 1,$(RUST_LINK_VIA_BINUTILS)),$(WORK_DIR)/binutils-cc,$(RUST_CC))

# The overlay directories this component's consumers carry: all-<vers> builds for them
# (spksrc.native-toolchain.mk).
TOOLCHAIN_CONSUMER       = rust-$(basename $(PKG_VERS))_gcc-*
TOOLCHAIN_CONSUMER_EXACT = rust-$(basename $(PKG_VERS))_gcc-$(_RUST_GCC)

# Profile-guided, both halves of the compiler a cargo build runs: rustc through x.py's own
# PGO, LLVM -- which does most of a release build's work -- through gcc's, like the gcc
# producer. The official dist trains LLVM with clang's IR instrumentation; with gcc it
# needs LLVM as a shared library, which gcc itself then links (llvm.link-shared). The
# instrumented pass builds the host's profiler runtime and links libgcov: the C++ shims
# rustc compiles against LLVM take its flags, -fprofile-generate included.
TOOLCHAIN_PGO       ?= 1
TOOLCHAIN_PGO_TRAIN  = rustc-pgo-train
_RUST_PGO_PROFRAW    = $(TOOLCHAIN_PGO_DIR)/rustc
_RUST_PGO_PROFDATA   = $(TOOLCHAIN_PGO_DIR)/rustc.profdata
_RUST_PGO_ARGS       = $(if $(filter gen,$(PGO_PHASE)),--rust-profile-generate=$(_RUST_PGO_PROFRAW)) \
                       $(if $(filter use,$(PGO_PHASE)),--rust-profile-use=$(_RUST_PGO_PROFDATA))
# Every x.py since before 1.82 reads it, unlike a [target] rustflags.
_RUST_PGO_ENV        = $(if $(filter gen,$(PGO_PHASE)),RUSTFLAGS_NOT_BOOTSTRAP="-Clink-arg=-lgcov")

# Shared toolchain id: <ver>-<target>-<arch>-<dsm>-gcc<gcc>. Also the archive base
# name. Must match the consumer (overlay/syno-<arch>-<vers>_rust-<vers>_gcc-<gcc>) and
# spksrc.toolchain/overlay/rustc.mk's _RUST_TC_ID on the package-build side.
_RUST_GCC   = $(if $(_OVERLAY_GCC_ON),$(OVERLAY_GCC_VERSION),$(or $(TC_GCC_VENDOR),$(TC_GCC)))
_RUST_TC_ID = $(TC_RUSTC)-$(RUST_TARGET)-$(TC_ARCH)-$(TC_VERS)-gcc$(_RUST_GCC)

# Per-step status line, matching the framework's NAME lines so the long x.py steps
# are trackable in status-build.log: NAME: native-rust-<step>.
rustc_status = $(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, ARCH: %s-%s, NAME: native-rust-%s\n" "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$(TC_ARCH)" "$(TC_VERS)" "$(1)") | tee --append $(STATUS_LOG)

# config.toml for ./x. The old-gcc knobs are emitted below gcc 4.7: the compiler-rt
# C in optimized-compiler-builtins is compiled by the `cc` crate with -gdwarf-4, an
# output level gcc predating 4.7 rejects. Below the floor we use the pure-Rust
# builtins (optimized-compiler-builtins = false) instead, which need no C at all.
#
# The dist profile, as the published rustup toolchains are built -- not "compiler", the
# profile for working ON rustc, whose debug assertions and logging made every package
# build 2.4x slower and shipped a std with its debug checks on. Then what the official
# x86_64 dist adds: jemalloc, ThinLTO over rustc_driver, one codegen unit for the compiler
# and std. extended and the bitcode linker, which dist turns on, build tools never shipped.
# The channel stays our version string, which rustc reports as `dev`: it takes -Z flags.

define RUST_CONFIG_TOML
profile = "dist"

[build]
build = "$(RUST_BUILD_HOST)"
host = ["$(RUST_BUILD_HOST)"]
target = ["$(RUST_BUILD_HOST)", "$(RUST_TARGET)"]
build-stage = $(TC_RUSTC_STAGE)
docs = false
compiler-docs = false
extended = false
$(if $(call version_lt,$(TC_GCC),4.7),optimized-compiler-builtins = false)

[rust]
channel = "$(TC_RUSTC)"
lto = "thin"
codegen-units = 1
codegen-units-std = 1
jemalloc = true
llvm-bitcode-linker = false
debuginfo-level = 0

[llvm]
download-ci-llvm = false
link-shared = true
cflags = "$(HOST_OPTFLAGS)"
cxxflags = "$(HOST_OPTFLAGS)"
ldflags = "$(HOST_OPTFLAGS)"

[target.$(RUST_BUILD_HOST)]
cc = "$(call native,gcc)"
cxx = "$(call native,g++)"
ar = "$(call native,ar)"
ranlib = "$(call native,ranlib)"
linker = "$(call native,gcc)"
$(if $(filter gen,$(PGO_PHASE)),profiler = true)

[target.$(RUST_TARGET)]
cc = "$(RUST_CC)"
cxx = "$(RUST_CXX)"
ar = "$(RUST_AR)"
ranlib = "$(RUST_RANLIB)"
linker = "$(RUST_LINKER)"
endef

# ./x wrapper: target CFLAGS + the selected CC/CXX. No -Ctarget-cpu/-feature: the JSON spec
# carries them (passing them again only triggers rustc's "unknown feature" warning).
_X = cd $(RUST_SRC) && \
     CFLAGS_$(RUST_TARGET_LENV)="$(TC_EXTRA_CFLAGS)" CC_$(RUST_TARGET_LENV)="$(RUST_CC)" CXX_$(RUST_TARGET_LENV)="$(RUST_CXX)" \
     RUST_TARGET_PATH="$(RUST_TARGET_JSON_DIR)" $(_RUST_PGO_ENV) \
     CARGO_TERM_PROGRESS_WHEN=never CARGO_TERM_COLOR=never RUST_BACKTRACE=full ./x.py $(_RUST_PGO_ARGS)

# ---------------------------------------------------------------------------
# Framework hooks: the source pipeline (download/extract/patch) is stock; only
# the x.py steps are custom. Restartability is preserved by cookie-guarding LLVM
# and each stage individually (LLVM is the long one) INSIDE the compile step.
# ---------------------------------------------------------------------------
RUSTC_LLVM_COOKIE   = $(WORK_DIR)/.$(COOKIE_PREFIX)rustc-llvm_done
RUSTC_STAGE1_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)rustc-stage1_done
RUSTC_STAGE2_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)rustc-stage2_done

# PRE_CONFIGURE: extract the gcc toolchain (tc-install, generic) and create the
# <alias>-<tool> symlinks rustc invokes the target tools by (triple name). When
# RUST_LINK_VIA_BINUTILS, also co-build the modern binutils and its build wrapper first.
PRE_CONFIGURE_TARGET = rustc_prepare
.PHONY: rustc_prepare
rustc_prepare: tc-install rustc_gcc_overlay $(if $(filter 1,$(RUST_LINK_VIA_BINUTILS)),rustc_binutils_cobuild)
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
# The cross gcc with ld/as redirected to the co-built binutils $(TOOLCHAIN_BINUTILS_VERSION)
# via -B. Used as the [target.*] linker for the from-source build.
exec "$(RUST_CC)" -B"$(RUST_BINUTILS_SHIM)" "$$@"
endef

# The gcc overlay is a consumer toolchain like any other: its drivers only exist once it
# is extracted, and RUST_CC names them. Extracted here per-arch rather than declared as a
# DEPENDS, for the same reason binutils is co-built below.
.PHONY: rustc_gcc_overlay
# Unconditional prerequisite, tested in the recipe: prerequisites expand when the rule is
# READ, and _OVERLAY_GCC_ON comes from overlay.mk, which native-cc.mk includes after this
# file. Testing it above would read empty and silently skip the extraction.
rustc_gcc_overlay:
	@if [ -n "$(_OVERLAY_GCC_ON)" ]; then \
	  $(call rustc_status,gcc-overlay) ; \
	  $(MSG) "*** Extracting gcc overlay $(OVERLAY_GCC_VERSION) for $(TC_ARCH)-$(TC_VERS)" ; \
	  $(MSG) "*** PATH: $(_OVERLAY_GCC_DIR)" ; \
	  MAKEFLAGS= $(MAKE) --no-print-directory -C $(_OVERLAY_GCC_DIR) ; \
	fi

.PHONY: rustc_binutils_cobuild
rustc_binutils_cobuild:
	@$(call rustc_status,binutils-cobuild)
	@$(MSG) "*********************************************************************"
	@$(MSG) "*** Co-building binutils $(TOOLCHAIN_BINUTILS_VERSION) for $(TC_ARCH)-$(TC_VERS) (the Rust link overlay)"
	@$(MSG) "*** Auto-built here per-arch (RUST_LINK_VIA_BINUTILS); NOT a DEPENDS"
	@$(MSG) "*** PATH: $(TOOLCHAIN_BINUTILS_WORK)"
	@$(MSG) "*********************************************************************"
	$(TOOLCHAIN_BINUTILS_MAKE)
	@mkdir -p $(RUST_BINUTILS_SHIM)
	@ln -sf $(TOOLCHAIN_BINUTILS_BIN)/$(TC_TARGET)-ld $(RUST_BINUTILS_SHIM)/ld
	@ln -sf $(TOOLCHAIN_BINUTILS_BIN)/$(TC_TARGET)-as $(RUST_BINUTILS_SHIM)/as
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

##############################################################################
# PGO training: the instrumented stage2 toolchain over the crates the official dist trains
# on -- rustc-perf's compile benchmarks, shipped in the source tarball, the same for every
# arch. Recent ones carry their dependencies; older ones (1.82) fetch them from crates.io,
# at the versions their Cargo.lock pins, so no --offline. The lists are read from this
# version's own build_helper (src/tools/build_helper in older ones); each crate is built
# check, debug and release for this arch's target, which also runs the host backend on its
# build scripts and proc macros. A crate
# that cannot cross-compile (a C library it needs for the target) is built for the host.
# The counters the bootstrap itself wrote are dropped first: the profile describes
# compiling packages, not compiling rustc.
##############################################################################
_RUST_PGO_BENCH   = $(RUST_SRC)/src/tools/rustc-perf/collector/compile-benchmarks
_RUST_PGO_CRATES  = $(sort $(shell sed -n '/PGO_CRATES: &\[&str\] = &\[/,/\];/s/^ *"\([^"]*\)",.*/\1/p' \
                      $(wildcard $(RUST_SRC)/src/build_helper/src/lib.rs $(RUST_SRC)/src/tools/build_helper/src/lib.rs)))
_RUST_PGO_PROFDATA_TOOL = $(RUST_BUILD_ROOT)/$(RUST_BUILD_HOST)/llvm/bin/llvm-profdata
_RUST_PGO_CARGO = cd $(_RUST_PGO_BENCH)/$$c && \
  CARGO_HOME=$(WORK_DIR)/pgo-cargo-home CARGO_TARGET_DIR=$(WORK_DIR)/pgo-target \
  RUSTC=$(RUST_STAGE_DIR)/bin/rustc RUST_TARGET_PATH=$(RUST_TARGET_JSON_DIR) \
  CARGO_TARGET_$(RUST_TARGET_UENV)_LINKER=$(RUST_LINKER) \
  CARGO_TARGET_$(RUST_TARGET_UENV)_RUSTFLAGS="-Zunstable-options" \
  CC_$(RUST_TARGET_LENV)="$(RUST_CC)" CXX_$(RUST_TARGET_LENV)="$(RUST_CXX)" AR_$(RUST_TARGET_LENV)="$(RUST_AR)" \
  CFLAGS_$(RUST_TARGET_LENV)="$(TC_EXTRA_CFLAGS)" CARGO_TERM_PROGRESS_WHEN=never \
  $(RUST_STAGE_DIR)/bin/cargo

.PHONY: rustc-pgo-train
rustc-pgo-train:
	@$(call rustc_status,pgo-train)
	@test -n "$(_RUST_PGO_CRATES)" || { $(MSG) "*** PGO: no training crate list in $(RUST_SRC)/src/build_helper" ; exit 1 ; }
	@$(MSG) "*** PGO: training on $(words $(_RUST_PGO_CRATES)) rustc-perf crates: $(_RUST_PGO_CRATES)"
	@find $(TOOLCHAIN_PGO_DIR) -name '*.gcda' -delete 2>/dev/null ; rm -rf $(_RUST_PGO_PROFRAW)
	@for c in $(_RUST_PGO_CRATES) ; do \
	  for mode in check build "build --release" ; do \
	    rm -rf $(WORK_DIR)/pgo-target ; \
	    if ( $(_RUST_PGO_CARGO) $$mode -q --target $(RUST_TARGET) ) >/dev/null 2>&1 ; then where=$(RUST_TARGET) ; \
	    elif ( $(_RUST_PGO_CARGO) $$mode -q ) >/dev/null 2>&1 ; then where=host ; \
	    else where=FAILED ; fi ; \
	    $(MSG) "*** PGO: $$c $$mode: $$where" ; \
	  done ; \
	done
	@rm -rf $(WORK_DIR)/pgo-target
	@$(_RUST_PGO_PROFDATA_TOOL) merge -o $(_RUST_PGO_PROFDATA) $(_RUST_PGO_PROFRAW)
	@$(MSG) "*** PGO: $$(find $(TOOLCHAIN_PGO_DIR) -name '*.gcda' | wc -l) LLVM counter files, rustc profile $$(du -h $(_RUST_PGO_PROFDATA) | cut -f1)"
