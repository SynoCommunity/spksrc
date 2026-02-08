TC_ARCH = comcerto2k
TC_VERS = 6.2.4
TC_KERNEL = 3.2.40
TC_GLIBC = 2.20

TC_DIST = comcerto2k-gcc493_glibc220_hard-GPL
TC_DIST_SITE_PATH = toolchains%2Fdsm6.2.4

TC_TARGET = arm-unknown-linux-gnueabi
TC_SYSROOT = $(TC_TARGET)/sysroot
TC_EXTRA_CFLAGS = -mfloat-abi=hard -mtune=cortex-a15 -mfpu=neon-vfpv4 -mthumb

include ../../mk/spksrc.toolchain.mk
