TC_ARCH = dakota
TC_VERS = 1.2
TC_TYPE = SRM
TC_KERNEL = 4.4.60
TC_GCC = 4.9.3
TC_GLIBC = 2.20

TC_DIST = gcc493_glibc220_hard-GPL
TC_EXT = tgz
TC_DIST_SITE_PATH = QUALCOMM%20IPQ4019%20dakota%20Linux%204.4.60
TC_DIST_FILE = $(TC_ARCH)-$(TC_DIST_NAME)

TC_TARGET = arm-unknown-linux-gnueabi
TC_SYSROOT = $(TC_TARGET)/sysroot
TC_EXTRA_CFLAGS = -mfloat-abi=hard -mtune=cortex-a15 -mfpu=neon-vfpv4 -mthumb

include ../../mk/spksrc.tc.mk
