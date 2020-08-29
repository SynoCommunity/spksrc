TC_NAME = syno-alpine

TC_ARCH = alpine alpine4k
TC_VERS = 5.2
TC_FIRMWARE = 5.2-5644
TC_KERNEL = 3.2.40+

TC_DIST = alpine-gcc464_glibc217_alpine-GPL
TC_EXT = txz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%205.2%20Tool%20Chains/Annapurna%20Alpine%20Linux%203.2.40

TC_PREFIX = arm-cortex_a15-linux-gnueabi
TC_TARGET = arm-cortex_a15-linux-gnueabi

TC_CFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/usr/include -mfloat-abi=hard -mtune=cortex-a15 -mfpu=neon-vfpv4 -mthumb
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/usr/include -mfloat-abi=hard -mtune=cortex-a15 -mfpu=neon-vfpv4 -mthumb
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/usr/include -mfloat-abi=hard -mtune=cortex-a15 -mfpu=neon-vfpv4 -mthumb
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/lib -mfloat-abi=hard -mtune=cortex-a15 -mfpu=neon-vfpv4 -mthumb

TC_SYSROOT = $(TC_PREFIX)

include ../../mk/spksrc.tc.mk
