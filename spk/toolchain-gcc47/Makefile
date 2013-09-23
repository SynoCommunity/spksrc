GCC_VER = 47
SPK_NAME = toolchain-gcc$(GCC_VER)
SPK_VERS = 4.7.3
SPK_REV = 1
SPK_ICON = src/toolchain.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity \(Ximi1970\)
DESCRIPTION = Gcc 4.7 / Glibc 2.18 toolchain.
RELOAD_UI = no
DISPLAY_NAME = Gcc 4.7 / Glibc 2.18 toolchain. 
STARTABLE = no

HOMEPAGE   = https://github.com/SynoCommunity/spksrc
LICENSE    = GNU GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS = 

INSTALL_PREFIX = /usr/local/$(SPK_NAME)


PRE_DEPEND_TARGET = myPreDepend


%-gcc47:
	@echo "Recursive build. Exiting."
	@exit 1


include ../../mk/spksrc.spk.mk


clean-%:
	@export CLEANUP=$@ ; \
	export CLEANUP=$${CLEANUP:6} ; \
	if 	[ "$$CLEANUP" == "bromolow" ] || \
		[ "$$CLEANUP" == "cedarview" ] || \
		[ "$$CLEANUP" == "x86" ] || \
		[ "$$CLEANUP" == "88f6281" ] || \
		[ "$$CLEANUP" == "88f5281" ] || \
		[ "$$CLEANUP" == "armada370" ] || \
		[ "$$CLEANUP" == "powerpc" ] || \
		[ "$$CLEANUP" == "ppc824x" ] || \
		[ "$$CLEANUP" == "ppc853x" ] || \
		[ "$$CLEANUP" == "ppc854x" ] || \
		[ "$$CLEANUP" == "qoriq" ] ; then \
		echo "Cleaning" $$CLEANUP ; \
		rm -rf work-$$CLEANUP ; \
		rm -rf ../../native/$(SPK_NAME)/work-native/work-$$CLEANUP ; \
		rm -rf ../../native/$(SPK_NAME)/work-native/.*$$CLEANUP*_done ; \
		rm -rf ../../native/binutils/work-native/work-$$CLEANUP-gcc$(GCC_VER) ; \
		rm -rf ../../native/binutils/work-native/.*$$CLEANUP-gcc$(GCC_VER)*_done ; \
		rm -rf ../../native/gcc$(GCC_VER)-bootstrap/work-native/work-$$CLEANUP ; \
		rm -rf ../../native/gcc$(GCC_VER)-bootstrap/work-native/.*$$CLEANUP*_done ; \
		rm -rf ../../native/gcc$(GCC_VER)/work-native/work-$$CLEANUP ; \
		rm -rf ../../native/gcc$(GCC_VER)/work-native/.*$$CLEANUP*_done ; \
		rm -rf ../../native/eglibc/work-native/work-$$CLEANUP-gcc$(GCC_VER) ; \
		rm -rf ../../native/eglibc/work-native/install-$$CLEANUP-gcc$(GCC_VER) ; \
		rm -rf ../../native/eglibc/work-native/.*$$CLEANUP-gcc$(GCC_VER)*_done ; \
		rm -rf ../../native/glibc/work-native/work-$$CLEANUP-gcc$(GCC_VER) ; \
		rm -rf ../../native/glibc/work-native/install-$$CLEANUP-gcc$(GCC_VER) ; \
		rm -rf ../../native/glibc/work-native/.*$$CLEANUP-gcc$(GCC_VER)*_done ; \
		rm -rf ../../toolchains/syno-$$CLEANUP-gcc$(GCC_VER) ; \
	else \
		echo "Unknown architecture" ; \
	fi

clean-all-arch:
	@echo "Cleaning all toolchains" ; \
	rm -rf work-* ; \
	rm -rf ../../native/$(SPK_NAME)/work-native ; \
	rm -rf ../../native/binutils/work-native ; \
	rm -rf ../../native/gcc$(GCC_VER)-bootstrap/work-native ; \
	rm -rf ../../native/gcc$(GCC_VER)/work-native ; \
	rm -rf ../../native/eglibc/work-native ; \
	rm -rf ../../native/glibc/work-native ; \
	rm -rf ../../toolchains/syno-*-gcc$(GCC_VER)

.PHONY: myPreDepend
myPreDepend:
	@if [ "$(ARCH)" == "" ] ; then \
		echo "Architecture not set. Please run: make arch-<arch>." ; \
		exit 1 ; \
	fi ; \
	if [ ! -f ../../local.mk ] ; then \
		echo "local.mk not found. Please run in the spksrc root directory: make setup" ; \
		exit 1 ; \
	fi ; \
	if [ "$(ARCH)" == "bromolow" ] || [ "$(ARCH)" == "cedarview" ] ||  [ "$(ARCH)" == "x86" ] ; then \
		export TARGET=x86_64-linux-gnu ; \
	elif  [ "$(ARCH)" == "88f6281" ] ; then \
		export TARGET=arm-unknown-linux-gnueabi ; \
	else \
		echo "Unsupported architecture." ; \
		exit 1 ; \
	fi ; \
	export FOUND=`cat ../../local.mk | grep "^MAKE_TOOLCHAIN_ARCH="` ; \
	if [ "$$FOUND" == "" ] ; then \
		echo >> ../../local.mk ; \
		echo "MAKE_TOOLCHAIN_ARCH=$(ARCH)" >> ../../local.mk ; \
	else \
		sed -i "s/^MAKE_TOOLCHAIN_ARCH=.*/MAKE_TOOLCHAIN_ARCH=$(ARCH)/" ../../local.mk ; \
	fi ; \
	export FOUND=`cat ../../local.mk | grep "^MAKE_TOOLCHAIN_TARGET="` ; \
	if [ "$$FOUND" == "" ] ; then \
		echo "MAKE_TOOLCHAIN_TARGET=$$TARGET" >> ../../local.mk ; \
	else \
		sed -i "s/^MAKE_TOOLCHAIN_TARGET=.*/MAKE_TOOLCHAIN_TARGET=$$TARGET/" ../../local.mk ; \
	fi ; \
	export FOUND=`cat ../../local.mk | grep "^MAKE_TOOLCHAIN_GCC_VER="` ; \
	if [ "$$FOUND" == "" ] ; then \
		echo "MAKE_TOOLCHAIN_GCC_VER=$(GCC_VER)" >> ../../local.mk ; \
	else \
		sed -i "s/^MAKE_TOOLCHAIN_GCC_VER.*/MAKE_TOOLCHAIN_GCC_VER=$(GCC_VER)/" ../../local.mk ; \
	fi ; \
	mkdir -p ../../toolchains/syno-$(ARCH)-gcc$(GCC_VER) ; \
	pushd ../../toolchains/syno-$(ARCH)-gcc$(GCC_VER) ; \
	rm -f Makefile ; \
	echo "TC_NAME = syno-$(ARCH)-gcc$(GCC_VER)" > Makefile ; \
	echo >> Makefile ; \
	echo "TC_DIST_NAME = toolchain-gcc$(GCC_VER)-1.0.0.zip" >> Makefile ; \
	echo >> Makefile ; \
	echo "TC_EXT = zip" >> Makefile ; \
	echo "TC_DIST_SITE = https://github.com/Ximi1970/spksrc-toolchain/archive" >> Makefile ; \
	echo >> Makefile ; \
	echo "TC_BASE_DIR = $$TARGET" >> Makefile ; \
	echo "TC_PREFIX = $$TARGET" >> Makefile ; \
	echo "TC_TARGET = $$TARGET" >> Makefile ; \
	echo >> Makefile ; \
	echo "TC_CFLAGS =" >> Makefile ; \
	echo "TC_CPPFLAGS =" >> Makefile ; \
	echo "TC_CXXFLAGS =" >> Makefile ; \
	echo "TC_LDFLAGS =" >> Makefile ; \
	echo >> Makefile ; \
	echo "include ../../mk/spksrc.tc.mk" >> Makefile ; \
	popd
