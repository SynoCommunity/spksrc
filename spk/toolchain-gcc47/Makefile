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

ARCHITECTURES = bromolow cedarview evansport x86 88f6281


PRE_DEPEND_TARGET = myPreDepend
PRE_STRIP_TARGET = myPreStrip


define \n


endef
ifneq ($(findstring $(ARCH),88f5281 armada370 powerpc ppc824x ppc853x ppc854x qoriq ),)
$(error ${\n}${\n}Architecture not supported.${\n}${\n})
endif


%-gcc47:
	@echo "Recursive build. Exiting."
	@exit 1

clean: clean-all-arch


include ../../mk/spksrc.spk.mk


ifneq ($(findstring $(ARCH), bromolow cedarview x86),)
$(info Found $(ARCH))
MAIN_MAKE_TOOLCHAIN_TARGET = x86_64-linux-gnu
MAKE_TOOLCHAIN_TARGET = x86_64-linux-gnu
endif
ifneq ($(findstring $(ARCH), evansport),)
$(info Found $(ARCH))
MAIN_MAKE_TOOLCHAIN_TARGET = i686-pc-linux-gnu
MAKE_TOOLCHAIN_TARGET = i686-pc-linux-gnu
endif
ifneq ($(findstring $(ARCH), 88f6281),)
$(info Found $(ARCH))
MAIN_MAKE_TOOLCHAIN_TARGET = arm-unknown-linux-gnueabi
endif
MAIN_MAKE_TOOLCHAIN_GCC_VER = $(GCC_VER)


MAKE = make MAKE_TOOLCHAIN_TARGET=$(MAIN_MAKE_TOOLCHAIN_TARGET) MAKE_TOOLCHAIN_GCC_VER=$(MAIN_MAKE_TOOLCHAIN_GCC_VER) 


DELETE_COOKIES = $(shell rm -f work-*/.depend_done)
ifeq ($(DELETE_COOKIES),)
endif

clean-%:
	@/bin/bash -c '\
	export CLEANUP=$@ ; \
	export CLEANUP=$${CLEANUP:6} ; \
	if 	[ "$$CLEANUP" == "bromolow" ] || \
		[ "$$CLEANUP" == "cedarview" ] || \
		[ "$$CLEANUP" == "evansport" ] || \
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
		rm -f ../../native/$(SPK_NAME)/work-native/.*$$CLEANUP*_done ; \
		rm -rf ../../native/binutils/work-native/work-$$CLEANUP-gcc$(GCC_VER) ; \
		rm -f ../../native/binutils/work-native/.*$$CLEANUP-gcc$(GCC_VER)*_done ; \
		rm -rf ../../native/gcc$(GCC_VER)-bootstrap/work-native/work-$$CLEANUP ; \
		rm -f ../../native/gcc$(GCC_VER)-bootstrap/work-native/.*$$CLEANUP*_done ; \
		rm -rf ../../native/gcc$(GCC_VER)/work-native/work-$$CLEANUP ; \
		rm -f ../../native/gcc$(GCC_VER)/work-native/.*$$CLEANUP*_done ; \
		rm -rf ../../native/eglibc/work-native/work-$$CLEANUP-gcc$(GCC_VER) ; \
		rm -rf ../../native/eglibc/work-native/install-$$CLEANUP-gcc$(GCC_VER) ; \
		rm -f ../../native/eglibc/work-native/.*$$CLEANUP-gcc$(GCC_VER)*_done ; \
		rm -rf ../../native/glibc/work-native/work-$$CLEANUP-gcc$(GCC_VER) ; \
		rm -rf ../../native/glibc/work-native/install-$$CLEANUP-gcc$(GCC_VER) ; \
		rm -f ../../native/glibc/work-native/.*$$CLEANUP-gcc$(GCC_VER)*_done ; \
		rm -rf ../../toolchains/syno-$$CLEANUP-gcc$(GCC_VER) ; \
	else \
		echo "Unknown architecture" ; \
	fi'

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
	@/bin/bash -c '\
	if [ "$(ARCH)" == "" ] ; then \
		echo "Architecture not set. Please run: make arch-<arch>." ; \
		exit 1 ; \
	fi ; \
	if [ "$(MAIN_MAKE_TOOLCHAIN_TARGET)" == "" ] ; then \
		echo ; \
		echo "Architecture not supported. Supported architectures: $(ARCHITECTURES)" ; \
		echo ; \
		exit 1 ; \
	fi ; \
	echo "Building toolchain for:" ; \
	echo "Architecture:" $(ARCH) ; \
	echo "Target:" $(MAIN_MAKE_TOOLCHAIN_TARGET) ; \
	echo "Gcc:" $(MAIN_MAKE_TOOLCHAIN_GCC_VER) ; \
	if [ ! -d  ../../toolchains/syno-$(ARCH)-gcc$(GCC_VER) ] ; then \
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
		echo "TC_BASE_DIR = $(MAIN_MAKE_TOOLCHAIN_TARGET)" >> Makefile ; \
		echo "TC_PREFIX = $(MAIN_MAKE_TOOLCHAIN_TARGET)" >> Makefile ; \
		echo "TC_TARGET = $(MAIN_MAKE_TOOLCHAIN_TARGET)" >> Makefile ; \
		echo >> Makefile ; \
		echo "TC_CFLAGS =" >> Makefile ; \
		echo "TC_CPPFLAGS =" >> Makefile ; \
		echo "TC_CXXFLAGS =" >> Makefile ; \
		echo "TC_LDFLAGS =" >> Makefile ; \
		echo >> Makefile ; \
		echo "include ../../mk/spksrc.tc.mk" >> Makefile ; \
		popd ; \
	fi'

.PHONY: myPreStrip
myPreStrip:
	$(eval STRIP := ../../toolchains/syno-$(ARCH)-gcc$(GCC_VER)/work/$(MAIN_MAKE_TOOLCHAIN_TARGET)/bin/$(MAIN_MAKE_TOOLCHAIN_TARGET)-strip)
