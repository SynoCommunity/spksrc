SPK_NAME = openvpn
SPK_VERS = 2.2.1
SPK_REV = 1
SPK_ICON = src/openvpn.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = botho
COMMENT    = "OpenVPN $(SPK_VERS) (client mode)"
RELOAD_UI  = no
DISPLAY_NAME = OpenVPN

HOMEPAGE   = http://openvpn.net/
LICENSE    = OpenVPN support a license under GPLv2 along with a commercial license where appropriate without the restrictions of GPLv2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)
PRE_COPY_TARGET = install-openvpn

include ../../mk/spksrc.spk.mk

.PHONY: install-openvpn
install-openvpn:
	@$(MSG) "=========== PACKAGING OPENVPN ===================="
	install -m 755 -d $(STAGING_DIR)/etc/openvpn
	install -m 644 src/etc/openvpn/* $(STAGING_DIR)/etc/openvpn

