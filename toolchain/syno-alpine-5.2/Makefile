TC_NAME = syno-alpine

TC_ARCH = alpine alpine4k
TC_VERS = 5.2
TC_KERNEL = 3.2.40
TC_GCC = 4.6.4
TC_GLIBC = 2.17

TC_DIST = alpine-gcc464_glibc217_alpine-GPL
TC_DIST_SITE_PATH = Annapurna%20Alpine%20Linux%203.2.40

TC_TARGET = arm-cortex_a15-linux-gnueabi
TC_SYSROOT = $(TC_TARGET)/sysroot
TC_EXTRA_CFLAGS = -mfloat-abi=hard -mtune=cortex-a15 -mfpu=neon-vfpv4 -mthumb

include ../../mk/spksrc.tc.mk
