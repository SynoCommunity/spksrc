TC_ARCH = hawkeye
TC_VERS = 1.3
TC_TYPE = SRM
# TODO: validate kernel version
TC_KERNEL = 4.4.60
TC_GLIBC = 2.32

# REMARKS:
# This toolchain seems to be broken.
# 
# The toolchain is extracted from ds.hawkeye-1.3.env.tgz provided by Synology.
# Qualcomm Hawkeye IPQ8071A CPU is an ARM 64-bit cpu (4x ARM Cortex A53),
# but the toolchain is armv7 (32-bit) (binary the same as syno-dakota-1.3)
# 

TC_DIST = hawkeye-gcc1030_glibc232_srm-1.3
TC_EXT = tar.xz
TC_DIST_SITE_URL = https://github.com/SynoCommunity/spksrc/releases/download/
TC_DIST_SITE_PATH = toolchains%2Fsrm1.3

TC_TARGET = arm-unknown-linux-gnueabi
TC_SYSROOT = $(TC_TARGET)/sysroot

include ../../mk/spksrc.tc.mk
