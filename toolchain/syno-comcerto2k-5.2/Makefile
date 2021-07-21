TC_ARCH = comcerto2k
TC_VERS = 5.2
TC_KERNEL = 3.2.40
TC_GCC = 4.6.4
TC_GLIBC = 2.17

TC_DIST = comcerto2k-gcc464_glibc217_neon_comcerto-GPL
TC_DIST_SITE_PATH = Mindspeed%20Comcerto%202000%20Linux%203.2.40

TC_TARGET = arm-cortexa9-linux-gnueabi
TC_SYSROOT = $(TC_TARGET)/sysroot
TC_EXTRA_CFLAGS = -mfloat-abi=hard -mtune=cortex-a15 -mfpu=neon-vfpv4 -mthumb

include ../../mk/spksrc.tc.mk
