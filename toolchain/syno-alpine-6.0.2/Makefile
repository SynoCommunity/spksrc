TC_NAME = syno-alpine

TC_ARCH = alpine alpine4k
TC_VERS = 6.0.2
TC_KERNEL = 3.10.77
TC_GCC = 4.9.3
TC_GLIBC = 2.20

TC_DIST = alpine4k-gcc493_glibc220_hard-GPL
TC_DIST_SITE_PATH = Annapurna%20Alpine%20Linux%203.10.77

TC_TARGET = arm-unknown-linux-gnueabi
TC_SYSROOT = $(TC_TARGET)/sysroot
TC_EXTRA_CFLAGS = -mfloat-abi=hard -mtune=cortex-a15 -mfpu=neon-vfpv4 -mthumb

include ../../mk/spksrc.tc.mk
