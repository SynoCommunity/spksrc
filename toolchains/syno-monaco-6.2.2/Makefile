TC_NAME = syno-monaco

TC_ARCH = monaco
TC_VERS = 6.2.2
TC_OS_MIN_VER = 6.2.2-24922
TC_KERNEL = 3.10.105+

TC_DIST = monaco-gcc493_glibc220_hard-GPL
TC_EXT = txz
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
TC_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Tool%20Chain/DSM%206.2.2%20Tool%20Chains/STMicroelectronics%20Monaco%20Linux%203.10.105

TC_BASE_DIR = arm-unknown-linux-gnueabi
TC_PREFIX = arm-unknown-linux-gnueabi
TC_TARGET = arm-unknown-linux-gnueabi

TC_CFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sysroot/usr/include -mcpu=cortex-a9 -march=armv7-a -mfpu=neon -mfloat-abi=hard -mtune=cortex-a9
TC_CPPFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sysroot/usr/include -mcpu=cortex-a9 -march=armv7-a -mfpu=neon -mfloat-abi=hard -mtune=cortex-a9
TC_CXXFLAGS = -I$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sysroot/usr/include -mcpu=cortex-a9 -march=armv7-a -mfpu=neon -mfloat-abi=hard -mtune=cortex-a9
TC_LDFLAGS = -L$(WORK_DIR)/$(TC_BASE_DIR)/$(TC_BASE_DIR)/sysroot/lib -mcpu=cortex-a9 -march=armv7-a -mfpu=neon -mfloat-abi=hard -mtune=cortex-a9

TC_SYSROOT = $(TC_BASE_DIR)/sysroot

include ../../mk/spksrc.tc.mk
