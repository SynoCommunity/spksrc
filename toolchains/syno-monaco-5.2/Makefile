TC_NAME = syno-monaco

TC_ARCH = monaco
TC_VERS = 5.2
TC_KERNEL = 3.10.35+

TC_DIST = monaco-gcc483_glibc219_hard-GPL
TC_EXT = txz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%205.2%20Tool%20Chains/STMicroelectronics%20Monaco%20Linux%203.10.35

TC_PREFIX = arm-cortexa9hf-linux-gnueabi
TC_SYSROOT = $(TC_PREFIX)/sysroot
TC_EXTRA_CFLAGS = -mcpu=cortex-a9 -march=armv7-a -mfpu=neon -mfloat-abi=hard -mtune=cortex-a9

include ../../mk/spksrc.tc.mk
