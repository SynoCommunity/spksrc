TC_ARCH = qoriq
TC_VERS = 6.2.2
TC_KERNEL = 2.6.32.12+

TC_DIST = qoriq-gcc493_glibc220_hard_qoriq-GPL
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%206.2.2%20Tool%20Chains/PowerPC%20QorIQ%20Linux%202.6.32

TC_PREFIX = powerpc-e500v2-linux-gnuspe
TC_SYSROOT = $(TC_PREFIX)/sysroot
TC_EXTRA_CFLAGS = -mcpu=8548 -mhard-float -mfloat-gprs=double

include ../../mk/spksrc.tc.mk
