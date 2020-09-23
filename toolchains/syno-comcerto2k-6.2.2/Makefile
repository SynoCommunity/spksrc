TC_ARCH = comcerto2k
TC_VERS = 6.2.2
TC_KERNEL = 3.2.40+

TC_DIST = comcerto2k-gcc493_glibc220_hard-GPL
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%206.2.2%20Tool%20Chains/Mindspeed%20Comcerto%202000%20Linux%203.2.40

TC_PREFIX = arm-unknown-linux-gnueabi
TC_SYSROOT = $(TC_PREFIX)/sysroot
TC_EXTRA_CFLAGS = -mfloat-abi=hard -mtune=cortex-a15 -mfpu=neon-vfpv4 -mthumb

include ../../mk/spksrc.tc.mk
