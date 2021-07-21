TC_ARCH = qoriq
TC_VERS = 6.2
TC_KERNEL = 2.6.32
TC_GCC = 4.9.3
TC_GLIBC = 2.20

TC_DIST = qoriq-gcc493_glibc220_hard_qoriq-GPL
TC_DIST_SITE_PATH = PowerPC%20QorIQ%20Linux%202.6.32

TC_TARGET = powerpc-e500v2-linux-gnuspe
TC_SYSROOT = $(TC_TARGET)/sysroot
TC_EXTRA_CFLAGS = -mcpu=8548 -mhard-float -mfloat-gprs=double

include ../../mk/spksrc.tc.mk
