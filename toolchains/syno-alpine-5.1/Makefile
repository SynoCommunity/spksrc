TC_NAME = syno-$(TC_ARCH)

TC_ARCH = alpine
TC_VERS = 5.1
TC_FIRMWARE = 5.1-5004

TC_DIST = gcc464_glibc217_alpine-GPL
TC_EXT = tgz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%205.1%20Tool%20Chains/Annapurna%20Alpine%20Linux%203.2.40

TC_PREFIX = arm-cortex_a15-linux-gnueabi

TC_CFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/usr/include -mfloat-abi=hard -mtune=cortex-a15 -mfpu=neon-vfpv4 -mthumb
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/usr/include -mfloat-abi=hard -mtune=cortex-a15 -mfpu=neon-vfpv4 -mthumb
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/usr/include -mfloat-abi=hard -mtune=cortex-a15 -mfpu=neon-vfpv4 -mthumb
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/lib -mfloat-abi=hard -mtune=cortex-a15 -mfpu=neon-vfpv4 -mthumb

TC_SYSROOT = $(TC_PREFIX)

include ../../mk/spksrc.tc.mk
