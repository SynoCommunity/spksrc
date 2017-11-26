PKG_NAME = libpthread-stubs
PKG_VERS = 0.4
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.intel.com
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.intel.com
COMMENT  = 
LICENSE  = GPL

GNU_CONFIGURE = 1

YASM_PATH = $(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin

CONFIGURE_ARGS += CPP="/root/spksrc/toolchains/syno-apollolake-6.1/work/x86_64-pc-linux-gnu/bin/x86_64-pc-linux-gnu-cpp"
CONFIGURE_ARGS += NM="/root/spksrc/toolchains/syno-apollolake-6.1/work/x86_64-pc-linux-gnu/bin/x86_64-pc-linux-gnu-nm"
CONFIGURE_ARGS += CC="/root/spksrc/toolchains/syno-apollolake-6.1/work/x86_64-pc-linux-gnu/bin/x86_64-pc-linux-gnu-gcc"
CONFIGURE_ARGS += AS="/root/spksrc/toolchains/syno-apollolake-6.1/work/x86_64-pc-linux-gnu/bin/x86_64-pc-linux-gnu-as"
CONFIGURE_ARGS += RANLIB="/root/spksrc/toolchains/syno-apollolake-6.1/work/x86_64-pc-linux-gnu/bin/x86_64-pc-linux-gnu-ranlib"
CONFIGURE_ARGS += CXX="/root/spksrc/toolchains/syno-apollolake-6.1/work/x86_64-pc-linux-gnu/bin/x86_64-pc-linux-gnu-g++"
CONFIGURE_ARGS += AR="/root/spksrc/toolchains/syno-apollolake-6.1/work/x86_64-pc-linux-gnu/bin/x86_64-pc-linux-gnu-ar"
CONFIGURE_ARGS += STRIP="/root/spksrc/toolchains/syno-apollolake-6.1/work/x86_64-pc-linux-gnu/bin/x86_64-pc-linux-gnu-strip"
CONFIGURE_ARGS += OBJDUMP="/root/spksrc/toolchains/syno-apollolake-6.1/work/x86_64-pc-linux-gnu/bin/x86_64-pc-linux-gnu-objdump" 
CONFIGURE_ARGS += READELF="/root/spksrc/toolchains/syno-apollolake-6.1/work/x86_64-pc-linux-gnu/bin/x86_64-pc-linux-gnu-readelf"
CONFIGURE_ARGS += PKG_CONFIG_PATH="/usr/lib/pkgconfig"

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(x64_ARCHES)),$(ARCH))
	DEPENDS += native/yasm
ENV += PATH=$(YASM_PATH):$$PATH
endif



