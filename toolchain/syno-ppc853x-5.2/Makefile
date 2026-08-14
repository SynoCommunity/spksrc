TC_ARCH = ppc853x
TC_VERS = 5.2
TC_KERNEL = 2.6.32
TC_GLIBC = 2.8
TC_GCC = 4.3.7

TC_DIST = 853x-gcc4374_eglibc2874_qoriq-GPL
TC_DIST_SITE_URL = https://github.com/SynoCommunity/spksrc/releases/download/
TC_DIST_SITE_PATH = toolchains%2Fdsm5.2

TC_TARGET = powerpc-none-linux-gnuspe
TC_SYSROOT = $(TC_TARGET)
TC_INCLUDE = $(TC_SYSROOT)/include
TC_EXTRA_BUILD_FLAGS = -mcpu=8548 -mhard-float -mfloat-gprs=double
# +spe gives LLVM the SPE FP path for BOTH f32 (efs*) and f64 (efd*), matching the C
# toolchain's -mfloat-gprs=double SPE ABI. NB: +efpu2 must NOT be added -- empirically
# it flips f64 back to soft-float (__muldf3), the exact ABI mismatch behind the qoriq/
# ppc SIGILL (#7119). -Ctarget-cpu=e500 alone already implies SPE; +spe is explicit.
TC_EXTRA_RUSTFLAGS = -Ctarget-cpu=e500 -Ctarget-feature=+spe

# Declares this as a custom-rust arch (enters spksrc.toolchain/rustc.mk). The
# prebuilt rust-<id>-<rev>.txz is built by the host-native package
# native/rustc-$(TC_RUSTC) (make -C native/rustc-1.82 arch-ppc853x-5.2) and
# downloaded via the consumer DEPENDS below.
RUST_BUILD_TOOLCHAIN = 0


# Versions available: https://releases.rs/docs/
TC_RUSTC = 1.82.0

# Rust target triple to build std for (declared here so env-rust.mk's arch map is
# not consulted -- single source of truth for the from-source toolchain).
RUST_TARGET = powerpc-unknown-linux-gnuspe

# Route ONLY the Rust package link through a modern binutils (2.30) ld -- the C toolchain
# keeps the stock vendor gcc 4.3.7 + ld 2.18 (which builds C fine here; only Rust's output
# breaks it). Both of ppc853x's linkers mangle Rust, confirmed on-device (SynoCommunity#7353):
#  - the 2008 GNU ld 2.18 leaves Rust std's TLS TPREL16 relocs DYNAMIC (.rela.dyn), which the
#    glibc-2.8 loader mis-applies -> SIGSEGV on a TLS store in main; it also segfaults
#    outright linking modern Rust cdylibs;
#  - LLVM lld links, but leaves a PIE relative relocation unapplied (10974 vs 10975
#    R_PPC_RELATIVE) -> SIGSEGV jumping through an unrelocated pointer at startup.
# binutils 2.30 resolves the TLS relocs at link AND emits the full relative-reloc set -> a
# clean binary. gcc 4.3.7 uses standard -mcpu=8548 flags a modern ld accepts, so this narrow
# rust-link overlay is safe. NOT the GLOBAL OVERLAY_BINUTILS (that redirects ALL C compilation
# and is only valid under a matched gcc-8.5 overlay -- see overlay-binutils.mk).
# RUST_LINK_VIA_BINUTILS now defaults ON for every custom-rust arch (overlay-binutils.mk),
# so it is not set explicitly here; the rationale above is why it must stay on for ppc853x.

# <triple>-<tool> symlink prefixes the built rustc expects (rustc.mk creates them)
RUST_POSTFIX_ALIASES = powerpc-linux-gnuspe powerpc-unknown-linux-gnuspe

# TLS model: DO NOT set -Ztls-model=initial-exec here. It was tried as a workaround for the
# old glibc-2.8 + ld-2.18 dynamic-TPREL problem, but it forces every #[thread_local] access
# through the GOT via the PPC32 "bl .+8; mflr" GOT-base getter. At -O0 (any non-LTO build)
# LLVM emits that getter WITHOUT saving the incoming LR, so a thread-local accessor such as
# std's stack_overflow::GUARD call_once returns into its own embedded GOT .long word ->
# "Illegal instruction" at std::rt::init on every rust binary (SynoCommunity#7353; release+LTO
# only survives because the accessor gets inlined away). The default (general-dynamic, what
# qoriq uses and what runs cleanly on this e500v2 silicon) emits DTPREL16/GOT_TLSGD16 with no
# GOT-base getter, and binutils 2.30 (the RUST_LINK_VIA_BINUTILS overlay) resolves it correctly.
# So: keep the default TLS model (no build-time -Ztls-model override).

# glibc 2.8 predates clock_gettime in libc (2.17); the target has no native 64-bit atomics.
# -latomic is dropped automatically when the gcc does not ship it.
TC_EXTRA_LDFLAGS = -lrt -latomic

include ../../mk/spksrc.toolchain.mk

# Download the published prebuilt rustc .txz. The consumer dir carries gcc<ver> so
# a future gcc-8.5 overlay variant coexists. Skipped while a native toolchain
# producer extracts this gcc toolchain to BUILD the .txz (tc-extract passes
# NATIVE_TOOLCHAIN_EXTRACT=1), so the consumer does not try to download the very
# archive being produced (bootstrap cycle).
ifneq ($(NATIVE_TOOLCHAIN_EXTRACT),1)
DEPENDS = toolchain/syno-$(TC_ARCH)-$(TC_VERS)-rust-gcc$(TC_GCC)
endif
