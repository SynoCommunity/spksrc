PKG_NAME = HandBrake
PKG_VERS = 1.3.1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-source.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/HandBrake/HandBrake/releases/download/1.3.1
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS)-source.$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/HandBrake/HandBrake
COMMENT  = HandBrake is an open-source video transcoder available for Linux, Mac, and Windows
LICENSE  =

PATCHES_LEVEL=1

export HANDBRAKE = "YES"

PATCHES = $(sort $(wildcard patches/0*.patch))

DEPENDS = cross/bzip2 native/nasm cross/libxml2
DEPENDS += cross/harfbuzz cross/jansson cross/xz 
DEPENDS += cross/ffmpeg cross/libvorbis
DEPENDS += cross/libsamplerate cross/libtheora
DEPENDS += native/python3 native/python cross/x264
DEPENDS += cross/libbluray cross/libdvdnav cross/libass
DEPENDS += cross/libdvdread cross/x265 


NASM_PATH = $(WORK_DIR)/../../../native/nasm/work-native/install/usr/local/bin
PYTHON_PATH = $(WORK_DIR)/../../../native/python/work-native/install/usr/local/bin
PYTHON3_PATH = $(WORK_DIR)/../../../native/python3/work-native/install/usr/local/bin
ENV += AS=$(NASM_PATH)/nanm
ENV += PATH=$(NASM_PATH):$(PYTHON_PATH):$(PYTHON3_PATH):$$PATH
ENV += LIBVA_DRIVER_NAME=iHD
ENV += LIBVA_DRIVERS_PATH="$(INSTALL_PREFIX)/lib/dri"
ENV += MFX_PLUGINS_DIR="$(INSTALL_PREFIX)/lib/mfx"
ENV += LIBXML2_LIBS="-L$(INSTALL_DIR)$(INSTALL_PREFIX)/lib -lxml2 -liconv -lz -lpthread -lm -ldl"
ENV += LIBXML2_CFLAGS="-I/$(INSTALL_DIR)$(INSTALL_PREFIX)/include/libxml2"


GNU_CONFIGURE = 1

CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall


BUILD_DIR = build

CONFIGURE_ARGS += --ar $(TC_PATH)$(TC_PREFIX)ar --cc $(TC_PATH)$(TC_PREFIX)gcc --ranlib $(TC_PATH)$(TC_PREFIX)ranlib
CONFIGURE_ARGS += --strip $(TC_PATH)$(TC_PREFIX)strip --arch x86_64 --prefix "$(INSTALL_PREFIX)"
CONFIGURE_ARGS += --disable-gtk --disable-nvenc --enable-x265 --enable-qsv --arch x86_64 
CONFIGURE_ARGS += --disable-gst  

# fdk-acc is not compatible with (L)GPL.
# It can be --enabled for personal use, but not for freely distributed packages.
# compile with variable ENABLE_FDK_AAC=YES if you want to enable it.
ifeq ($(ENABLE_FDK_AAC),YES) 
DEPENDS += cross/fdk-aac
PATCHES += $(sort $(wildcard patches/201-*.patch))
CONFIGURE_ARGS += --enable-fdk-aac
endif



CONFIGURE_ARGS += --launch-jobs $(NCPUS) --launch --force --python $(PYTHON3_PATH)/python3
CONFIGURE_ARGS += --asm $(NASM_PATH)/nasm  
#ADDITIONAL_CFLAGS += -m64 -fPIC --optimize
#ADDITIONAL_LDFLAGS += -L$(TC_PATH)../x86_64-pc-linux-gnu/sys-root/usr/lib -static-libgcc -static-libstdc++ -lm -ldl -lpthread -Bstatic
#ADDITIONAL_LDFLAGS += -L$(INSTALL_DIR)$(INSTALL_PREFIX)/lib -llzma -lz -lbz2 -lfreetype -lpng16 -lx265 -lnuma -lva -lva-drm -lmfx -ldrm -lfontconfig -Bstatic
#ADDITIONAL_LDFLAGS += -Wl,--rpath-link,$(INSTALL_DIR)$(INSTALL_PREFIX)/lib -Wl,--rpath,$(INSTALL_PREFIX)/lib -Bstatic
#ADDITIONAL_LDFLAGS += -Bstatic
#ADDITIONAL_CXXFLAGS += -m64 -fPIC --optimize
#ADDITIONAL_LDFLAGS += -static-libgcc -static-libstdc++ -lpthread -lm -ldl -llzma -lz -lbz2 -lfreetype -lpng16 -lx265 -lnuma -lva -lva-drm -lmfx -ldrm -lfontconfig

include ../../mk/spksrc.cross-cc.mk

export HANDBRAKE = "YES"
#export ADDITIONAL_LDFLAGS = -static-libgcc -static-libstdc++ -lm -ldl -lpthread -Bstatic


.PHONY: myConfigure
myConfigure:


.PHONY: myCompile
myCompile:
	$(RUN) DESTDIR=$(INSTALL_DIR) ./configure $(CONFIGURE_ARGS)

.PHONY: myInstall
myInstall:
	$(RUN) make --directory=$(BUILD_DIR) install DESTDIR=$(INSTALL_DIR)
	echo '#!/bin/sh\nDIRNAME=`dirname $$0`\nHB_HOME=`cd "$${DIRNAME}"/..; pwd`\nLD_LIBRARY_PATH="$${HB_HOME}/lib:$${HB_HOME}/lib/mfx"\nLIBVA_DRIVERS_PATH="$${HB_HOME}/lib/dri"\nLIBVA_DRIVER_NAME=iHD\n$${DIRNAME}/HandBrakeCLI $$@' > $(INSTALL_DIR)$(INSTALL_PREFIX)/bin/handbrake
	chmod 775 $(INSTALL_DIR)$(INSTALL_PREFIX)/bin/handbrake

