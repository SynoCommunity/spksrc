TC_NAME = syno-alpine

TC_ARCH = alpine alpine4k
TC_VERS = 5.2
TC_KERNEL = 3.2.40+

TC_DIST = alpine-gcc464_glibc217_alpine-GPL
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%205.2%20Tool%20Chains/Annapurna%20Alpine%20Linux%203.2.40

TC_PREFIX = arm-cortex_a15-linux-gnueabi
TC_SYSROOT = $(TC_PREFIX)/sysroot
TC_EXTRA_CFLAGS = -mfloat-abi=hard -mtune=cortex-a15 -mfpu=neon-vfpv4 -mthumb

include ../../mk/spksrc.tc.mk
