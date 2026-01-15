TC_ARCH = ppc853x
TC_VERS = 5.2
TC_KERNEL = 2.6.32
TC_GLIBC = 2.8

TC_DIST = 853x-gcc4374_eglibc2874_qoriq-GPL
TC_DIST_SITE_URL = https://github.com/SynoCommunity/spksrc/releases/download/
TC_DIST_SITE_PATH = toolchains%2Fdsm5.2

TC_TARGET = powerpc-none-linux-gnuspe
TC_SYSROOT = $(TC_TARGET)
TC_INCLUDE = $(TC_SYSROOT)/include
TC_EXTRA_CFLAGS = -mcpu=8548 -mhard-float -mfloat-gprs=double

include ../../mk/spksrc.tc.mk
