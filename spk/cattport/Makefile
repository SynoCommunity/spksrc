SPK_NAME = cattport
SPK_VERS = 1.0.0
SPK_REV = 1
SPK_ICON = src/cattport.png

DEPENDS = cross/cattport

# Python scripts and a web UI only
override ARCH = noarch

MAINTAINER = morcatt-labs
DESCRIPTION = All your Docker services and links as tiles in the DSM main menu, in one place. It never changes Docker or your services.
DISPLAY_NAME = Cattport
CHANGELOG = "Initial package release."

HOMEPAGE = https://github.com/morcatt-labs/cattport
SUPPORTURL = https://github.com/morcatt-labs/cattport/issues
LICENSE = GPLv3

# uses /usr/bin/python3 of DSM and the DSM 7 package UI
REQUIRED_MIN_DSM = 7.0
# SRM has no Docker
REQUIRED_MIN_SRM = 3.0

# the upstream spk is named Cattport and publishes the same DSM menu entries
SPK_CONFLICT = Cattport

SERVICE_USER = auto
# no daemon: start publishes the tiles to the DSM menu, stop only clears the running flag
SSS_SCRIPT = src/start-stop-status.sh
WIZARDS_DIR = src/wizard

DSM_UI_DIR = ui
DSM_APP_NAME = labs.morcatt.cattport.Instance

POST_STRIP_TARGET = cattport_post_strip

include ../../mk/spksrc.spk.mk

CATTPORT_ICON_SIZES = 16 24 32 48 64 72 256

.PHONY: cattport_post_strip
cattport_post_strip:
	@$(MSG) "Set version $(SPK_VERS)-$(SPK_REV) and create the UI icons"
	find $(STAGING_DIR)/ui -type f \( -name "*.html" -o -name "*.js" \) -exec sed -i -e "s|__VERSION__|$(SPK_VERS)-$(SPK_REV)|g" {} +
	printf "%s" "$(SPK_VERS)-$(SPK_REV)" > $(STAGING_DIR)/lib/version
	install -m 755 -d $(STAGING_DIR)/ui/images
	for size in $(CATTPORT_ICON_SIZES); do \
	  convert $(SPK_ICON) -resize $${size}x$${size} -strip $(STAGING_DIR)/ui/images/cattport_$${size}.png ; \
	done
