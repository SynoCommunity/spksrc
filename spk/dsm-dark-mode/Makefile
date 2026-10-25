SPK_NAME = dsm-dark-mode
SPK_VERS = 1.0.1
SPK_REV = 1
SPK_ICON = src/dsm-dark-mode.png

DEPENDS = cross/dsm-dark-mode

# Python and shell scripts only (python3 and curl from DSM)
override ARCH = noarch

REQUIRED_MIN_DSM = 7.0
# Not for SRM: the package themes the DSM desktop.
REQUIRED_MIN_SRM = 3.0

MAINTAINER = SoulInfernoDE
DISPLAY_NAME = Dark Mode for DSM
# DESCRIPTION_<LANG> is passed to an unquoted echo: ' ( ) need a backslash.
DESCRIPTION = Dark theme for the DSM 7 desktop: login page, desktop, Control Panel, Package Center, File Station, Storage Manager, Resource Monitor and other built-in apps. Follows the dark mode of your operating system or can be set per user from the taskbar. The theme is generated on the NAS from DSM's own stylesheets, so it adapts to DSM and package updates by itself. Runs without root.
DESCRIPTION_GER = Dunkles Design für den DSM-7-Desktop: Anmeldeseite, Desktop, Systemsteuerung, Paket-Zentrum, File Station, Speicher-Manager, Ressourcen-Monitor und weitere integrierte Apps. Folgt dem Dunkelmodus Ihres Betriebssystems oder lässt sich pro Benutzer über die Taskleiste einstellen. Das Design wird auf dem NAS aus den Stylesheets von DSM erzeugt und passt sich so DSM- und Paket-Updates selbst an. Läuft ohne Root.
CHANGELOG = "Initial SynoCommunity release (Dark Mode for DSM 1.0.1)."
BETA = 1

HOMEPAGE = https://github.com/SoulInfernoDE/synology-dsm-dark-mode
LICENSE  = GPL-3.0
LICENSE_FILE = $(WORK_DIR)/synology-dsm-dark-mode-$(SPK_VERS)/LICENSE

# No daemon: src/service-start-stop.sh rebuilds the theme in the background on
# start and keeps the package state in a flag file. DSM starts the desktop part
# only while the package runs.
SSS_SCRIPT = src/service-start-stop.sh
SERVICE_USER = auto

# DSM desktop integration: ui/config declares a hidden app that DSM starts
# after login (taskbar button), ui/style.css is linked into every page.
DSM_UI_DIR = ui
DSM_APP_NAME = SYNO.SDS.DarkMode.Instance

# The package from the GitHub releases (package name DarkMode) themes the same
# pages; only one of them may be installed.
SPK_CONFLICT = DarkMode

include ../../mk/spksrc.spk.mk
