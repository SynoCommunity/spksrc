SPK_NAME = inotify-tools
SPK_VERS = 1.0.0
SPK_REV = 1
SPK_ICON = src/inotifytools.png
DSM_UI_DIR = app


DEPENDS = cross/$(SPK_NAME)

MAINTAINER = cyc1ingsir
DESCRIPTION = inotify-tools is a C library and a set of command-line programs for Linux providing a simple interface to inotify. 
RELOAD_UI = no
DISPLAY_NAME = inotify-tools

HOMEPAGE = https://github.com/rvoicilas/inotify-tools/
LICENSE  = GNU General Public License version 2.0 (GPLv2)

CHANGELOG = "initial package"

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = inotifytools_extra_install


include ../../mk/spksrc.spk.mk

.PHONY: inotifytools_extra_install
inotifytools_extra_install:
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} \
	            $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

