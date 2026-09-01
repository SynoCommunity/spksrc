SPK_NAME = gickup
SPK_VERS = 0.10.45
SPK_REV = 1
SPK_ICON = src/gickup.png

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS)

DEPENDS = cross/gickup

SPK_DEPENDS = git

MAINTAINER = hgy59
DESCRIPTION = Backup Git repositories with ease. Gickup is a tool that allows you to clone/mirror repositories from one host to another. This is useful if you want to have a backup of your repositories on another host or on a local server.
DISPLAY_NAME = gickup
STARTABLE = no
CHANGELOG = "Initial package release."

LICENSE = Apache 2.0
HOMEPAGE = https://gickup.dev/

POST_STRIP_TARGET = gickup_extra_install

SPK_COMMANDS = bin/gickup

include ../../mk/spksrc.spk.mk

.PHONY: gickup_extra_install
gickup_extra_install:
	@$(MSG) Install example config file
	@install -m 755 -d $(STAGING_DIR)/var
	@install -m 644 src/conf.example.yml $(STAGING_DIR)/var/
