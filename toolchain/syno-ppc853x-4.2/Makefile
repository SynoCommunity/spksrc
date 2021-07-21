TC_ARCH = ppc853x
TC_VERS = 4.2
TC_FIRMWARE = 3.1-1594
TC_KERNEL = 2.6.32
TC_GCC = 3.4.3
TC_GLIBC = 2.3.4

TC_DIST = gcc343_glibc234_ppc853x-GPL
TC_EXT = tgz
TC_DIST_SITE_PATH = PowerPC%20853x%20Linux%202.6.32

TC_TARGET = powerpc-linux-gnuspe
TC_SYSROOT = $(TC_TARGET)
TC_INCLUDE = $(TC_SYSROOT)/include
TC_EXTRA_CFLAGS = -mcpu=8548 -mhard-float -mfloat-gprs=double

include ../../mk/spksrc.tc.mk
