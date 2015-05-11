PKG_NAME = ntopng
PKG_VERS = 1.2.1
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/ntop/files/ntopng
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/sqlite cross/libpcap cross/geoip cross/rrdtool cross/zeromq cross/json-c

HOMEPAGE = http://www.ntop.org/
COMMENT  = ntopng is the next generation version of the original ntop, a network traffic probe that shows the network usage, similar to what the popular top Unix command does.
LICENSE  =

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = myConfig
PRE_COMPILE_TARGET = myPreComp
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

DOWNLOAD_LIB = 0

ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
	DOWNLOAD_LIB = 1
else
	DEPENDS += cross/luajit
endif

myConfig:
	$(RUN) ./autogen.sh

myPreComp:
	sed -i 's|GPP=g++|GPP=$(TC_PATH)/$(TC_PREFIX)g++|g' $(WORK_DIR)/$(PKG_DIR)/Makefile
	if [ $(DOWNLOAD_LIB) -eq 1 ]; then cd $(WORK_DIR)/$(PKG_DIR)/third-party/ && rm -rf LuaJIT-2.0.3 && wget http://cytec.us/syno/LuaJIT-2.0.3x64.tgz && tar -xzf LuaJIT-2.0.3x64.tgz ;fi

myInstall:
	$(RUN) make geoip
	$(RUN) make install prefix=$(STAGING_INSTALL_PREFIX) INSTALL_DIR=$(STAGING_INSTALL_PREFIX) MAN_DIR=$(STAGING_INSTALL_PREFIX)
