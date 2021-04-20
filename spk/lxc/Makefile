SPK_NAME = lxc
SPK_VERS = 4.0.6
SPK_REV = 1
BETA = 1
SPK_ICON = src/containers.png

include ../../mk/spksrc.archs.mk
include ../../cross/libapparmor/apparmor.info.mk

DEPENDS = cross/$(SPK_NAME)

ifneq ($(findstring $(ARCH),$(AA_UNSUPPORTED_ARCHS)),$(ARCH))
# We need an up-to-date apparmor_parser that can understand the LXC
# AppArmor profile.
DEPENDS += cross/apparmor-parser
endif

MAINTAINER = rbrownwsws
DESCRIPTION = LXC is the well-known and heavily tested low-level Linux container runtime
DISPLAY_NAME = LXC
CHANGELOG = "Initial version"

HOMEPAGE = https://linuxcontainers.org/lxc/
LICENSE  = GPLv2/LGPLv2.1

CONF_DIR = src/conf
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE = yes
SSS_SCRIPT = src/dsm-control.sh
ADDITIONAL_SCRIPTS = src/aa-profiles.sh

SPK_COMMANDS = bin/lxc-attach \
	bin/lxc-autostart \
	bin/lxc-cgroup \
	bin/lxc-checkconfig \
	bin/lxc-checkpoint \
	bin/lxc-config \
	bin/lxc-console \
	bin/lxc-copy \
	bin/lxc-create \
	bin/lxc-destroy \
	bin/lxc-device \
	bin/lxc-execute \
	bin/lxc-freeze \
	bin/lxc-info \
	bin/lxc-ls \
	bin/lxc-monitor \
	bin/lxc-snapshot \
	bin/lxc-start \
	bin/lxc-stop \
	bin/lxc-top \
	bin/lxc-unfreeze \
	bin/lxc-unshare \
	bin/lxc-update-config \
	bin/lxc-usernsexec \
	bin/lxc-wait

POST_STRIP_TARGET = lxc_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: lxc_extra_install
lxc_extra_install:
	install -m 755 -d $(STAGING_DIR)/var/lock
	install -m 755 -d $(STAGING_DIR)/var/lib/misc
	install -m 755 -d $(STAGING_DIR)/etc/apparmor.d/tunables
	install -m 755 -d $(STAGING_DIR)/etc/apparmor
	echo "Include $(INSTALL_PREFIX)/etc/apparmor.d/" > $(STAGING_DIR)/etc/apparmor/parser.conf
