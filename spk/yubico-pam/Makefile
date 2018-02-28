SPK_NAME = yubico-pam
SPK_VERS = 2.19
SPK_REV = 1
SPK_ICON = src/YubiKey-Edge.jpg

MAINTAINER = Anaximelis
DESCRIPTION     = The Yubico PAM module provides an easy way to integrate the Yubikey into your existing user authentication infrastructure.
DESCRIPTION     += PAM is used by GNU/Linux, Solaris and Mac OS X for user authentication, and by other specialized applications such as NCSA MyProxy.
DESCRIPTION	    += Include: yubico-c, yubico-c-client, yubico-personalization, yubico-pam
DESCRIPTION	    += Please note. This package only install the needed files. Configuration have to be made via console telent/SSH
DESCRIPTION	    += For mor information to config read: https://developers.yubico.com/yubico-pam/
DESCRIPTION	    += This package ist experimental, do not use it on productiv systems.

DESCRIPTION_GER = Das Yubico-PAM-Modul bietet eine einfache Möglichkeit, um Yubikey in Ihre bestehende Benutzerauthentifizierung-Struktur zu integrieren. 
DESCRIPTION_GER	+= PAM wird in GNU/Linux, Solaris and Mac OS X zur Benutzerauthentifizierung eingesetzt.
DESCRIPTION_GER += Im Paket enthalten sind: yubico-c, yubico-c-client, yubico-personalization, yubico-pam
DESCRIPTION_GER += Bitte beachten sie, dass diese Paket nur die nötigen Dateien bereitstellt. Die Konfiguration muss via Console telenet/SSH vorgenommen werden.
DESCRIPTION_GER	+= Weitere Informationen zur Einrichtung finden sie auf: https://developers.yubico.com/yubico-pam/.
DESCRIPTION_GER	+= Das Paket ist experimentel und sollte nicht auf Produktivsystemen eingesetzt werden.

RELOAD_UI = no
DISPLAY_NAME = yubico-pam
STARTABLE = no
CHANGELOG = "Initial release"
BETA = 1
# PAM module is allways 32bit on x64 Arches. Compiling it on a x64 toolchain
# makes it unusable. (Wrong ELF header) 
# Use 'evansport' and overwrite arch with
# arch="x86 cedarview avoton bromolow evansport"
# in the finished INFO-file
UNSUPPORTED_ARCHS = $(x64_ARCHES)

DEPENDS = cross/$(SPK_NAME)   

HOMEPAGE = https://github.com/Yubico/yubico-pam
LICENSE  = BSD

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = yubico-pam_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: yubico-pam_extra_install
yubico-pam_extra_install:
	install -m 644 src/yubikey_mappings $(STAGING_DIR)/yubikey_mappings
	install -m 755 src/ykhelper.sh $(STAGING_DIR)/bin/ykhelper.sh
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72 ; do convert $(SPK_ICON) -thumbnail $${size}x$${size} $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; done

