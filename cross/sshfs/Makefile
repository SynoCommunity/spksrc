PKG_NAME = sshfs-virtual

OPTIONAL_DEPENDS  = cross/sshfs-latest
OPTIONAL_DEPENDS += cross/sshfs-2
OPTIONAL_DEPENDS += cross/sshfs-3.7.3

include ../../mk/spksrc.common.mk

ifeq ($(call version_lt,${TCVERSION},6.0)$(call version_ge,${TCVERSION},3.0),11)
# DSM 3.x - 5.x
DEPENDS = cross/sshfs-2
else ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
# qoriq DSM 6.x
DEPENDS = cross/sshfs-2
else ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
DEPENDS = cross/sshfs-3.7.3
else
DEPENDS = cross/sshfs-latest
endif

include ../../mk/spksrc.cross-virtual.mk
