TC_ARCH = qoriq
TC_VERS = 6.2.4
TC_KERNEL = 2.6.32
TC_GLIBC = 2.20
TC_GCC = 4.9.3

TC_DIST = qoriq-gcc493_glibc220_hard_qoriq-GPL
TC_DIST_SITE_PATH = toolchains%2Fdsm6.2.4

TC_TARGET = powerpc-e500v2-linux-gnuspe
TC_SYSROOT = $(TC_TARGET)/sysroot
TC_EXTRA_BUILD_FLAGS = -mcpu=8548 -mhard-float -mfloat-gprs=double
# e500 SPE FP for f32+f64 (efs*/efd*), matching the C toolchain's SPE ABI. NOT +efpu2
# (empirically flips f64 to soft-float -- the qoriq bat/lsd SIGILL, #7304/#7119).
TC_EXTRA_RUSTFLAGS = -Ctarget-cpu=e500 -Ctarget-feature=+spe

# Custom-rust arch (the rust consumer dir below is the marker). The rust-<id>.txz is built by
# native/rustc-1.82 (arch-qoriq-6.2.4) and downloaded via the rust consumer dir.
RUST_POSTFIX_ALIASES = powerpc-linux-gnuspe powerpc-unknown-linux-gnuspe

# no native 64-bit atomics; -latomic is auto-dropped when the gcc does not ship it.
TC_EXTRA_LDFLAGS = -latomic

include ../../mk/spksrc.toolchain.mk
