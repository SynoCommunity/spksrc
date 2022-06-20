TC_ARCH = alpine
TC_VERS = 7.1
TC_KERNEL = 3.10.108
TC_GLIBC = 2.36

TC_DIST = alpine-gcc850_glibc226_hard-GPL
TC_DIST_SITE_PATH = Annapurna%20Alpine%20Linux%203.10.108

TC_TARGET = arm-unknown-linux-gnueabi
TC_SYSROOT = $(TC_TARGET)/sysroot
TC_EXTRA_CFLAGS = -mfloat-abi=hard -mtune=cortex-a15 -mfpu=neon-vfpv4 -mthumb

include ../../mk/spksrc.tc.mk
