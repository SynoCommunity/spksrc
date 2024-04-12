# Allow overriding the name, used by spk/zsh-static.
SPK_NAME ?= zsh
SPK_VERS = 5.9
SPK_CONFLICT ?= zsh-static
# Allow overriding the revision, used by spk/zsh-static.
# If you rev here, please also rev spk/zsh-static.
SPK_REV ?= 14
SPK_ICON = ../zsh/src/zsh.png

DEPENDS = cross/zsh

MAINTAINER = SynoCommunity
DESCRIPTION = The Z shell \(Zsh\) is a Unix shell that can be used as an interactive login shell and as a command interpreter for shell scripting. Zsh is an extended Bourne shell with many improvements, including some features of Bash, ksh, and tcsh.
DESCRIPTION_FRE = Le Z shell ou zsh est un shell Unix qui peut être utilisé de façon interactive, à l\'ouverture de la session ou en tant que puissant interpréteur de commande. zsh peut être vu comme un «Bourne shell» étendu avec beaucoup d\'améliorations. Il reprend en plus la plupart des fonctions les plus pratiques de bash, ksh et tcsh.
DESCRIPTION_GER = Die Z shell \(zsh\) ist eine Unix-Shell, die sowohl als interaktive Login-Shell, als auch als ein mächtiger Kommandozeileninterpreter für Shellskripte verwendet werden kann. Die zsh wird oft als erweiterte Bourne-Shell angesehen, welche viele Verbesserungen und Eigenschaften von bash, ksh und tcsh vereint.
DESCRIPTION_ITA = La Z shell \(zsh\) è una shell che può essere utilizzata come linea di comando interattiva e come un potente interprete per script di shell. Zsh può essere vista come un\'estensione della Bourne shell dotata di numerose migliorie, fra le quali alcune caratteristiche mutuate da bash, ksh e tcsh.
DISPLAY_NAME = Z shell
STARTABLE = no
CHANGELOG = "1. Update to v5.9. For incompatiblities with former version please read the <a target=\"_blank\" href=\"https://zsh.sourceforge.io/releases.html\">release notes</a>.<br/>2. Include pcre library.<br/>3. Include cap (linux capabilities) library for supported archs."

HOMEPAGE = https://www.zsh.org
LICENSE = Custom

SPK_COMMANDS = bin/zsh

include ../../mk/spksrc.spk.mk
