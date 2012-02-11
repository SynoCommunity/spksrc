
PKG_NAME = busybox
PKG_VERS = 1.19.4
PKG_EXT = tar.bz2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://busybox.net/downloads

DEPENDS = 

MAINTAINER=	superzebulon@superzebulon.org
HOMEPAGE=	http://busybox.net/
COMMENT=	Fairly comprehensive set of programs needed to run a Linux system
LICENSE=	GPL

CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

ifeq ($(strip $(BUSYBOX_CONFIG)),)
BUSYBOX_CONFIG_FILE = src/usermng_defconfig
else
BUSYBOX_CONFIG_FILES = $(WORK_DIR)/../$(BUSYBOX_CONFIG) src/$(BUSYBOX_CONFIG) $(BUSYBOX_CONFIG) 
BUSYBOX_CONFIG_FILE = $(word 1,$(wildcard $(BUSYBOX_CONFIG_FILES)))
ifeq ($(strip $(BUSYBOX_CONFIG_FILE)),)
$(error Busybox configuration file '$(BUSYBOX_CONFIG)' not found) 
endif
endif

CROSS_COMPILE=$(shell echo $(ENV) | sed 's/ /\n/g' | sed -n -e 's/CC=\(.*-\)gcc/\1/p')

myConfigure:
	cp $(BUSYBOX_CONFIG_FILE) $(WORK_DIR)/$(PKG_DIR)/configs
	$(RUN) CROSS_COMPILE=$(CROSS_COMPILE) $(MAKE) $(notdir $(BUSYBOX_CONFIG_FILE))

myCompile:
	$(RUN) CROSS_COMPILE=$(CROSS_COMPILE) $(MAKE) busybox

myInstall:
	install -m 755 -d $(INSTALL_DIR)/$(INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/busybox $(INSTALL_DIR)/$(INSTALL_PREFIX)/bin
