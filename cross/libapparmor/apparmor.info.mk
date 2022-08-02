AA_PKG_VERS = 3.0.1
AA_PKG_EXT = tar.bz2
AA_PKG_DIST_NAME = apparmor-v$(AA_PKG_VERS).$(AA_PKG_EXT)
AA_PKG_DIST_SITE = https://gitlab.com/apparmor/apparmor/-/archive/v$(AA_PKG_VERS)
AA_PKG_DIR = apparmor-v$(AA_PKG_VERS)

AA_HOMEPAGE = https://apparmor.net/

AA_PYTHON_PKG = cross/python38

include ../../mk/spksrc.archs.mk
# We want kernel headers
AA_UNSUPPORTED_ARCHS = $(GENERIC_ARCHS)

# Kernel missing required capabilities (older kernel?)
# (Might be able to fix with arch-specific patching of `parser/base_cap_names.h`)

## CAP_AUDIT_READ, CAP_BLOCK_SUSPEND (pre Linux 3.16?)
AA_UNSUPPORTED_ARCHS += hi3535
AA_UNSUPPORTED_ARCHS += evansport

## CAP_AUDIT_READ, CAP_BLOCK_SUSPEND, CAP_SYSLOG, CAP_WAKE_ALARM (pre Linux 2.6.37?)
## May need kernel module. AppArmor was added to the upstream kernel as of 2.6.36.
AA_UNSUPPORTED_ARCHS += qoriq

# Toolchain too old
AA_UNSUPPORTED_ARCHS += $(ARMv5_ARCHS)

# Too old in general
AA_UNSUPPORTED_ARCHS += $(DEPRECATED_ARCHS)
