TC_NAME = syno-$(TC_ARCH)

TC_ARCH = ppc853x
TC_VERS = 5.1
TC_FIRMWARE = 5.0-4458

TC_DIST = gcc4374_eglibc2874_qoriq-GPL
TC_EXT = tgz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%205.1%20Tool%20Chains/PowerPC%20853x%20Linux%202.6.32

TC_PREFIX = powerpc-none-linux-gnuspe
TC_SYSROOT = $(TC_PREFIX)
TC_INCLUDE = $(TC_SYSROOT)/include
TC_EXTRA_CFLAGS = -mcpu=8548 -mhard-float -mfloat-gprs=double

include ../../mk/spksrc.tc.mk
