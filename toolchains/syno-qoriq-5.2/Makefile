TC_NAME = syno-$(TC_ARCH)

TC_ARCH = qoriq
TC_VERS = 5.2
TC_KERNEL = 2.6.32.12+

TC_DIST = qoriq-gcc4374_eglibc2874_qoriq-GPL
TC_EXT = txz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%205.2%20Tool%20Chains/PowerPC%20QorIQ%20Linux%202.6.32

TC_PREFIX = powerpc-none-linux-gnuspe
TC_SYSROOT = $(TC_PREFIX)
TC_INCLUDE = $(TC_SYSROOT)/include
TC_EXTRA_CFLAGS = -mcpu=8548 -mhard-float -mfloat-gprs=double

include ../../mk/spksrc.tc.mk
