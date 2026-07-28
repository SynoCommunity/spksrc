SPK_NAME = proxmoxbackupclient
SPK_VERS = 1.1.3
SPK_REV = 1
SPK_ICON = src/proxmox.png

DEPENDS = cross/proxmoxbackupclient_go

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS)

MAINTAINER = hgy59
DISPLAY_NAME = Proxmox Backup Client
DESCRIPTION = Proxmox backup client written in golang \(under development\).
CHANGELOG = "Initial package release."

HOMEPAGE = https://github.com/tizbac/proxmoxbackupclient_go/
LICENSE  = GPLv3

STARTABLE = no

SPK_COMMANDS = bin/proxmoxbackupgo

include ../../mk/spksrc.spk.mk
