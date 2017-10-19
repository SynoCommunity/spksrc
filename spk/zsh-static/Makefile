SPK_NAME = zsh-static
SPK_CONFLICT = zsh
SPK_REV = 1

export ZSH_STATIC_MODULES = true

# Reuse targets from zsh.
include ../zsh/Makefile

# Expand these with additional text.
DISPLAY_NAME += \(with modules\)

DESCRIPTION += This variant comes with statically linked zsh modules like zsh/regex to ease the consumption of existing scripts relying on such modules. It has a slightly larger memory footprint compared to the package without modules which may not be desirable for lower-end devices with less RAM.
