TC_ARCH = monaco
TC_VERS = 7.1
TC_KERNEL = 3.10.108
TC_GLIBC = 2.26

TC_DIST = monaco-gcc850_glibc226_hard-GPL
TC_DIST_SITE_PATH = STMicroelectronics%20Monaco%20Linux%203.10.108

TC_TARGET = arm-unknown-linux-gnueabi
TC_SYSROOT = $(TC_TARGET)/sysroot
TC_EXTRA_CFLAGS = -mcpu=cortex-a9 -march=armv7-a -mfpu=neon -mfloat-abi=hard -mtune=cortex-a9

include ../../mk/spksrc.tc.mk
