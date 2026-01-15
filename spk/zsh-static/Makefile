SPK_NAME = zsh-static
SPK_CONFLICT = zsh
SPK_REV = 10

export ZSH_STATIC_MODULES=true

# need to define dependencies for dependency-list creation by script
DEPENDS = cross/zsh

# Reuse targets from zsh.
include ../zsh/Makefile

# Expand these with additional text.
DISPLAY_NAME += "(with modules)"

DESCRIPTION     += This variant comes with statically linked zsh modules like zsh/regex to ease the consumption of existing scripts relying on such modules. It has a slightly larger memory footprint compared to the package without modules which may not be desirable for lower-end devices with less RAM.
DESCRIPTION_FRE += Cette variante vient avec les modules zsh liés statiquement comme zsh/regex pour facilité l\'exécution de scripts utilisant de tels modules. Il a une empreinte mémoire légèrement plus important que le package sans modules, ce qui pourrait ne pas convenir à des systèmes disposant de moins de RAM.
DESCRIPTION_GER += Diese Variante enthält statisch gelinkte zsh-Module wie zsh/regex, um die Verwendung vorhandener Skripte zu erleichtern, die auf solchen Modulen basieren. Es hat im Vergleich zum Paket ohne Module einen etwas größeren Speicherbedarf, was für Geräte der unteren Preisklasse mit weniger RAM möglicherweise nicht wünschenswert ist.
DESCRIPTION_ITA += Questa variante viene fornita con moduli zsh collegati staticamente come zsh/regex per facilitare il consumo di script esistenti che si basano su tali moduli. Ha un footprint di memoria leggermente maggiore rispetto al pacchetto senza moduli che potrebbe non essere desiderabile per dispositivi di fascia bassa con meno RAM.
