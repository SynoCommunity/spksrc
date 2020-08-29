TC_NAME = syno-$(TC_ARCH)

TC_ARCH = dakota
TC_VERS = 1.2
TC_KERNEL = 4.4.60+

TC_DIST = gcc493_glibc220_hard-GPL
TC_EXT = tgz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/SRM%201.2%20Tool%20Chains/QUALCOMM%20IPQ4019%20dakota%20Linux%204.4.60
TC_DIST_FILE = $(TC_ARCH)-$(TC_DIST_NAME)

TC_PREFIX = arm-unknown-linux-gnueabi
TC_SYSROOT = $(TC_PREFIX)/sysroot
TC_FLAGS = -mfloat-abi=hard -mtune=cortex-a15 -mfpu=neon-vfpv4 -mthumb

include ../../mk/spksrc.tc.mk
