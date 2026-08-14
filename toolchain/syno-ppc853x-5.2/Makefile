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
# e500 SPE FP for f32+f64 (efs*/efd*), matching the C toolchain's SPE ABI. NOT +efpu2
# (empirically flips f64 to soft-float -- the qoriq/ppc SIGILL, #7119/#7304).
TC_EXTRA_RUSTFLAGS = -Ctarget-cpu=e500 -Ctarget-feature=+spe

# Custom-rust arch (the rust consumer dir below is the marker). The rust-<id>.txz is built by
# native/rustc-1.82 (arch-ppc853x-5.2) and downloaded via the consumer DEPENDS below.
RUST_POSTFIX_ALIASES = powerpc-linux-gnuspe powerpc-unknown-linux-gnuspe

# ppc853x's stock 2008 ld 2.18 mishandles Rust's TLS/PIE relocs, so the Rust link goes
# through the binutils 2.30 overlay (RUST_LINK_VIA_BINUTILS, default ON; see
# overlay-binutils.mk). C keeps the stock gcc+ld. Keep the default TLS model.

# glibc 2.8: no clock_gettime in libc (<2.17), no native 64-bit atomics. -latomic auto-dropped.
TC_EXTRA_LDFLAGS = -lrt -latomic

include ../../mk/spksrc.toolchain.mk

# Download the published rust .txz (consumer dir carries gcc<ver> so variants coexist).
# Skipped during a native-toolchain extract (NATIVE_TOOLCHAIN_EXTRACT=1) to avoid a
# bootstrap cycle (the consumer would download the archive being produced).
ifneq ($(NATIVE_TOOLCHAIN_EXTRACT),1)
DEPENDS = toolchain/syno-$(TC_ARCH)-$(TC_VERS)-rust-gcc$(TC_GCC)
endif
