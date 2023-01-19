TC_NAME = syno-armv7

# generic toolchain for arm7hf DSM (armada370, armada357 and armadaxp are not supported with DSM >=7.2)
TC_ARCH = alpine alpine4k armada38x monaco
TC_VERS = 7.2
TC_KERNEL = 3.10.108
TC_GLIBC = 2.36

TC_DIST = armada38x-gcc1220_glibc236_hard-GPL
TC_DIST_SITE_PATH = Marvell%20Armada%2038x%20Linux%203.10.108

TC_TARGET = arm-unknown-linux-gnueabi
TC_SYSROOT = $(TC_TARGET)/sysroot

# ensure gnu/hard-float.h is used
TC_EXTRA_CFLAGS = -D__ARM_PCS_VFP=1

include ../../mk/spksrc.tc.mk
