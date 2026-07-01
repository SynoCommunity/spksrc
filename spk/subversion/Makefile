SPK_NAME = subversion
SPK_VERS = 1.14.5
SPK_REV = 1
SPK_ICON = src/subversion.png

DEPENDS = cross/subversion

MAINTAINER = hgy59
DESCRIPTION = Subversion is an open source version control system.

DISPLAY_NAME = Subversion
CHANGELOG = "Initial SynoCommunity Package release."

HOMEPAGE = https://subversion.apache.org/
LICENSE  = Apache 2.0

include ../../mk/spksrc.common.mk

ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
SERVICE_PORT = 3690
else
SERVICE_PORT = 3691
DESCRIPTION += Port 3691 is used \(on DSM 6.x\) to avoid conflict with Subversion package of Synology.
endif

WIZARDS_DIR = src/wizard
SERVICE_WIZARD_SHARENAME = wizard_repo_directory

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
NO_SERVICE_SHORTCUT = yes

POST_STRIP_TARGET = subversion_extra_install

SPK_COMMANDS  = bin/svn
SPK_COMMANDS += bin/svnadmin
SPK_COMMANDS += bin/svnbench
SPK_COMMANDS += bin/svndumpfilter
SPK_COMMANDS += bin/svnfsfs
SPK_COMMANDS += bin/svnlook
SPK_COMMANDS += bin/svnmucc
SPK_COMMANDS += bin/svnrdump
SPK_COMMANDS += bin/svnserve
SPK_COMMANDS += bin/svnsync
SPK_COMMANDS += bin/svnversion

include ../../mk/spksrc.spk.mk

.PHONY: subversion_extra_install
subversion_extra_install:
	@$(MSG) Install template for service-variables
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/service-variables.template $(STAGING_DIR)/var/service-variables.template
