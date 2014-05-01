SPK_NAME = octoprint
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/octoprint.png
DSM_UI_DIR = app
BETA = 1

DEPENDS  = 
WHEELS = src/requirements.txt
SPK_DEPENDS = "python>2.7.3-3:git"

MAINTAINER = SynoCommunity
DESCRIPTION = OctoPrint is a so called host software for 3D printers that controls your 3D printer and sends it the actual commands to do its job.
ADMIN_PORT = 8088
RELOAD_UI = yes
DISPLAY_NAME = OctoPrint

HOMEPAGE   = http://octoprint.org/
LICENSE    = GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = octoprint_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: octoprint_extra_install
octoprint_extra_install: $(STAGING_DIR)/share/OctoPrint
	install -m 755 -d ${STAGING_DIR}/share/wheelhouse
	install -m 644 ${WORK_DIR}/wheelhouse/* ${STAGING_DIR}/share/wheelhouse/
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d ${STAGING_DIR}/var/.octoprint
	install -m 600 src/config.yaml ${STAGING_DIR}/var/.octoprint/config.yaml
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/OctoPrint:
	install -m 755 -d $(STAGING_DIR)/share
	# cd $(STAGING_DIR)/share && git clone https://github.com/foosel/OctoPrint.git OctoPrint
	cd $(STAGING_DIR)/share && cp -r ~/OctoPrint OctoPrint
