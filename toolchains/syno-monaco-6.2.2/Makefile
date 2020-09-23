TC_ARCH = monaco
TC_VERS = 6.2.2
TC_KERNEL = 3.10.105+

TC_DIST = monaco-gcc493_glibc220_hard-GPL
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%206.2.2%20Tool%20Chains/STMicroelectronics%20Monaco%20Linux%203.10.105

TC_PREFIX = arm-unknown-linux-gnueabi
TC_SYSROOT = $(TC_PREFIX)/sysroot
TC_EXTRA_CFLAGS = -mcpu=cortex-a9 -march=armv7-a -mfpu=neon -mfloat-abi=hard -mtune=cortex-a9

include ../../mk/spksrc.tc.mk
