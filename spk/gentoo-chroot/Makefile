SPK_NAME = gentoo-chroot
SPK_VERS = 13.0
SPK_REV = 1
SPK_ICON = src/gentoo.png
DSM_UI_DIR = app

DEPENDS =
WHEELS = pyextdirect==0.3.1 flask Werkzeug Jinja2 itsdangerous
SPK_DEPENDS = "python>=2.7.6-8"

MAINTAINER = SynoCommunity
DESCRIPTION = Gentoo is a free operating system based on either Linux or FreeBSD that can be automatically optimized and customized for just about any application or need. Gentoo Chroot allows you to install the Gentoo OS inside your DiskStation, alongside DSM. This package is intended for advanced users only.
RELOAD_UI = yes
DISPLAY_NAME = Gentoo Chroot
CHANGELOG =

HOMEPAGE   = http://www.gentoo.org/
LICENSE    =
HELPURL    = 3rdparty/gentoo-chroot/help/enu/index.html
SUPPORTURL = http://www.gentoo.org/main/en/support.xml

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = gentoo-chroot_extra_install

GENTOO_ARCH =
ifeq ($(findstring $(ARCH),88f6281),$(ARCH))
GENTOO_CPU = arm
GENTOO_ARCH = armv5tel
endif
ifeq ($(findstring $(ARCH),alpine armada370 armada375 armada38x armadaxp monaco),$(ARCH))
GENTOO_CPU = arm
GENTOO_ARCH = armv7a_hardfp
endif
ifeq ($(findstring $(ARCH),braswell bromolow cedarview evansport x86 avoton x64),$(ARCH))
GENTOO_CPU = x86
GENTOO_ARCH = i686
endif
ifeq ($(findstring $(ARCH),qoriq),$(ARCH))
GENTOO_CPU = ppc
GENTOO_ARCH = ppc
endif
ifeq ($(strip $(GENTOO_ARCH)),)
$(error Arch $(ARCH) not supported)
endif

GENTOO_STAGE3 := $(shell curl -s http://distfiles.gentoo.org/releases/$(GENTOO_CPU)/autobuilds/latest-stage3-$(GENTOO_ARCH).txt | sed '/^\#/d' | awk '{print $$1}')
GENTOO_STAGE3_URL := http://distfiles.gentoo.org/releases/$(GENTOO_CPU)/autobuilds/$(GENTOO_STAGE3)
GENTOO_STAGE3_FILE := $(shell basename $(GENTOO_STAGE3))

include ../../mk/spksrc.spk.mk

.PHONY: gentoo-chroot_extra_install
gentoo-chroot_extra_install:
	wget -nv -c -O $(WORK_DIR)/$(GENTOO_STAGE3_FILE) $(GENTOO_STAGE3_URL)
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/chroottarget
	tar xjpf $(WORK_DIR)/$(GENTOO_STAGE3_FILE) -C $(STAGING_DIR)/var/chroottarget --exclude './dev/*'
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 644 src/mounts $(STAGING_DIR)/etc/mounts
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/app/help
	install -m 755 -d $(STAGING_DIR)/app/help/enu
	install -m 644 src/app/help/enu/index.html $(STAGING_DIR)/app/help/enu/index.html
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 644 src/app/style.css $(STAGING_DIR)/app/style.css
	install -m 644 src/app/gentoo-chroot.js $(STAGING_DIR)/app/gentoo-chroot.js
	install -m 755 src/app/setup.py $(STAGING_DIR)/app/setup.py
	install -m 755 src/app/start.py $(STAGING_DIR)/app/start.py
	install -m 755 src/app/stop.py $(STAGING_DIR)/app/stop.py
	install -m 755 src/app/gentoo-chroot.cgi.py $(STAGING_DIR)/app/gentoo-chroot.cgi
	install -m 755 -d $(STAGING_DIR)/app/application
	install -m 644 src/app/application/* $(STAGING_DIR)/app/application/
	install -m 755 -d $(STAGING_DIR)/app/texts
	for language in enu; do \
		install -m 755 -d $(STAGING_DIR)/app/texts/$${language}; \
		install -m 644 src/app/texts/$${language}/strings $(STAGING_DIR)/app/texts/$${language}/strings; \
	done
