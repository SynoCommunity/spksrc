TC_ARCH = 88f6281
TC_VERS = 6.1
TC_KERNEL = 2.6.32
TC_GLIBC = 2.15

TC_DIST = 6281-gcc464_glibc215_88f6281-GPL
TC_DIST_SITE_PATH = Marvell%2088F628x%20Linux%202.6.32

TC_TARGET = arm-marvell-linux-gnueabi
TC_SYSROOT = $(TC_TARGET)/libc

# glibc 2.15 predates clock_gettime in libc (2.17); the target has no native 64-bit atomics.
# -latomic is dropped automatically when the gcc does not ship it.
TC_EXTRA_LDFLAGS = -lrt -latomic

include ../../mk/spksrc.toolchain.mk
