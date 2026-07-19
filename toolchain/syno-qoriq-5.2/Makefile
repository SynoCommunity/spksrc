TC_ARCH = qoriq
TC_VERS = 5.2
TC_KERNEL = 2.6.32
TC_GLIBC = 2.8

TC_DIST = qoriq-gcc4374_eglibc2874_qoriq-GPL
TC_DIST_SITE_PATH = PowerPC%20QorIQ%20Linux%202.6.32

TC_TARGET = powerpc-none-linux-gnuspe
TC_SYSROOT = $(TC_TARGET)
TC_INCLUDE = $(TC_SYSROOT)/include
TC_EXTRA_CFLAGS = -mcpu=8548 -mhard-float -mfloat-gprs=double

# glibc 2.8 predates clock_gettime in libc (2.17); the target has no native 64-bit atomics.
# -latomic is dropped automatically when the gcc does not ship it.
TC_EXTRA_LDFLAGS = -lrt -latomic

include ../../mk/spksrc.toolchain.mk
