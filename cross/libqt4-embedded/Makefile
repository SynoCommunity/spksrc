PKG_NAME = qt-everywhere-opensource-src
PKG_VERS = 4.8.5
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://download.qt-project.org/official_releases/qt/4.8/$(PKG_VERS)

DEPENDS = cross/glib cross/openssl cross/libpng cross/libmng cross/libjpeg cross/libtiff cross/sqlite cross/libxml2 cross/freetype2

HOMEPAGE = http://qt-project.org
COMMENT  = Qt is a full development framework with tools designed to streamline the creation of applications and user interfaces for desktop, embedded and mobile platforms.
LICENSE  = LGPL


CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall


QT_ARCH = qws/linux-g++-syno_$(ARCH)


CONFIGURE_ARGS = -release -opensource -confirm-license -embedded -force-pkg-config -no-rpath
#CONFIGURE_ARGS += -xplatform $(QT_ARCH) -prefix $(INSTALL_PREFIX)/Qt-$(PKG_VERS) -libdir $(INSTALL_PREFIX)/Qt-$(PKG_VERS)/lib
CONFIGURE_ARGS += -xplatform $(QT_ARCH) -prefix $(INSTALL_PREFIX) -libdir $(INSTALL_PREFIX)/lib
CONFIGURE_ARGS += -plugin-gfx-vnc
CONFIGURE_ARGS += -system-zlib -system-libtiff -system-libpng -system-libmng -system-libjpeg -glib -openssl -system-sqlite -exceptions -xmlpatterns
CONFIGURE_ARGS += -webkit -javascript-jit -script -scripttools
CONFIGURE_ARGS += -nomake examples -nomake demos -nomake docs -nomake translations
CONFIGURE_ARGS += -I$(INSTALL_DIR)$(INSTALL_PREFIX)/include -I$(INSTALL_DIR)$(INSTALL_PREFIX)/include/glib-2.0 -I$(INSTALL_DIR)$(INSTALL_PREFIX)/lib/glib-2.0/include -L$(INSTALL_DIR)$(INSTALL_PREFIX)/lib


define \n


endef
ifneq ($(findstring $(ARCH),88f5281 88f6281 armada370 bromolow cedarview powerpc ppc824x ppc853x ppc854x qoriq x86 ),)
$(error ${\n}${\n}Toolchain not compatible.${\n}${\n}Please use:${\n}make arch-$(ARCH)-gcc47${\n}or${\n}make arch-$(ARCH)-gcc48${\n}${\n}You can create the toolchain by running: spk/toolchain-gcc<47|48> arch-$(ARCH)${\n}${\n})
endif


include ../../mk/spksrc.cross-cc.mk


.PHONY: myConfigure
myConfigure:
	$(RUN) CC= CXX= CPP= LD= CFLAGS= CPPFLAGS= LDFLAGS= RANLIB= PATH=`echo ${ENV} | sed -e 's?.*CC=\(.*\)/.*-gcc .*?\1?'`":${PATH}":${PATH} ./configure -v $(CONFIGURE_ARGS)

.PHONY: myCompile
myCompile:
	$(RUN) PATH=`echo ${ENV} | sed -e 's?.*CC=\(.*\)/.*-gcc .*?\1?'`":${PATH}":${PATH} make $(MAKE_OPT)

.PHONY: myInstall
myInstall:
	$(RUN) PATH=`echo ${ENV} | sed -e 's?.*CC=\(.*\)/.*-gcc .*?\1?'`":${PATH}":${PATH} make INSTALL_ROOT=$(INSTALL_DIR) install
