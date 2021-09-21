TC_NAME = syno-armv7

# generic toolchain for arm7hf DSM
TC_ARCH = armada370 armada375 armada38x alpine alpine4k armadaxp comcerto2k monaco
TC_VERS = 7.0
TC_KERNEL = 3.2.101
TC_GCC = 4.9.3
TC_GLIBC = 2.20

TC_DIST = comcerto2k-gcc493_glibc220_hard-GPL
TC_DIST_SITE_PATH = Mindspeed%20Comcerto%202000%20Linux%203.2.101

TC_TARGET = arm-unknown-linux-gnueabi
TC_SYSROOT = $(TC_TARGET)/sysroot

# ensure gnu/hard-float.h is used
TC_EXTRA_CFLAGS = -D__ARM_PCS_VFP=1

include ../../mk/spksrc.tc.mk
