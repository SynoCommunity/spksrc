TC_NAME = syno-$(TC_ARCH)

TC_ARCH = comcerto2k
TC_VERS = 6.0.2
TC_FIRMWARE = 6.0.2-8451

TC_DIST = comcerto2k-gcc493_glibc220_hard-GPL
TC_EXT = txz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%206.0.2%20Tool%20Chains/Mindspeed%20Comcerto%202000%20Linux%203.2.40

TC_PREFIX = arm-unknown-linux-gnueabi

TC_CFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/usr/include -mcpu=cortex-a9 -march=armv7-a -mfpu=neon -mfloat-abi=hard -mthumb
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/usr/include -mcpu=cortex-a9 -march=armv7-a -mfpu=neon -mfloat-abi=hard -mthumb
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/usr/include -mcpu=cortex-a9 -march=armv7-a -mfpu=neon -mfloat-abi=hard -mthumb
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_PREFIX)/$(TC_PREFIX)/sysroot/lib -mfloat-abi=hard -mtune=cortex-a15 -mfpu=neon-vfpv4 -mthumb

TC_SYSROOT = $(TC_PREFIX)/sysroot

include ../../mk/spksrc.tc.mk
