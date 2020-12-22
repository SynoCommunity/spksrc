TC_ARCH = monaco
TC_VERS = 6.1
TC_KERNEL = 3.10.102
TC_GCC = 4.9.3
TC_GLIBC = 2.20

TC_DIST = monaco-gcc493_glibc220_hard-GPL
TC_DIST_SITE_PATH = STMicroelectronics%20Monaco%20Linux%203.10.102

TC_TARGET = arm-unknown-linux-gnueabi
TC_SYSROOT = $(TC_TARGET)/sysroot
TC_EXTRA_CFLAGS = -mcpu=cortex-a9 -march=armv7-a -mfpu=neon -mfloat-abi=hard -mtune=cortex-a9

include ../../mk/spksrc.tc.mk
