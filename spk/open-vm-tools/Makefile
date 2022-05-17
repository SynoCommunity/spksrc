SPK_NAME = open-vm-tools
SPK_VERS = 11.3.5
SPK_REV = 1
SPK_ICON = src/open-vm-tools.png

DEPENDS = cross/$(SPK_NAME)

# even some archs might sucessfully build, only x86_64 does support VMware virtualization.
UNSUPPORTED_ARCHS = $(i686_ARCHS) $(PPC_ARCHS) $(ARM_ARCHS)

MAINTAINER = SynoCommunity
DESCRIPTION = open-vm-tools is a set of services and modules that enable several features in VMware products for better management of, and seamless user interactions with, guests.
DISPLAY_NAME = VMware Tools
CHANGELOG = "Initial package release (v11.3.5-18557794)."

HOMEPAGE = https://github.com/vmware/open-vm-tools
LICENSE  = GPLv2/LGPLv2.1

# 'auto' reserved value grabs SPK_NAME
SERVICE_USER  = auto
# SERVICE_COMMAND is defined in service-setup script
STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh

include ../../mk/spksrc.spk.mk
