SPK_NAME = zsh-static
SPK_CONFLICT = zsh
SPK_REV = 5

export ZSH_STATIC_MODULES = true

# Reuse targets from zsh.
include ../zsh/Makefile

# Expand these with additional text.
DISPLAY_NAME += \(with modules\)

DESCRIPTION += This variant comes with statically linked zsh modules like zsh/regex to ease the consumption of existing scripts relying on such modules. It has a slightly larger memory footprint compared to the package without modules which may not be desirable for lower-end devices with less RAM.
DESCRIPTION_FRE += Cette variante vient avec les modules zsh liés statiquement comme zsh/regex pour facilité l\'exécution de scripts utilisant de tels modules. Il a une empreinte mémoire légèrement plus important que le package sans modules, ce qui pourrait ne pas convenir à des systèmes disposant de moins de RAM.
