SPK_NAME = google-authenticator-libpam
SPK_VERS = 1.09
SPK_REV = 1
SPK_ICON = src/google-authenticator.png

DEPENDS = cross/google-authenticator-libpam

MAINTAINER = Soraxas
DESCRIPTION = google-authenticator PAM module for two-factor authentication for logging into servers via SSH, etc. To activate this module you have to manually configure the pam module and related configurations. Please follow the instructions on the SynoCommunity Wiki page.
DISPLAY_NAME = Google Authenticator for libpam
STARTABLE = no
CHANGELOG = "Initial package release."

HOMEPAGE = https://github.com/google/google-authenticator-libpam
SUPPORTURL = https://github.com/SynoCommunity/spksrc/wiki/Google-Authenticator-PAM
LICENSE = Apache-2.0
LICENSE_FILE = $(WORK_DIR)/$(SPK_NAME)-$(SPK_VERS)/LICENSE

SPK_COMMANDS = bin/google-authenticator

include ../../mk/spksrc.spk.mk
