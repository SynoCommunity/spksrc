SPK_NAME = tcl
SPK_VERS = 8.6.10
SPK_MAIN_VERS=$(word 1,$(subst ., ,$(SPK_VERS))).$(word 2,$(subst ., ,$(SPK_VERS)))
SPK_REV = 5
SPK_ICON = src/tcl.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER      = Tcl developer Xchange
MAINTAINER_URL  = https://www.tcl.tk/
DISTRIBUTOR     = SynoCommunity
DISTRIBUTOR_URL = https://synocommunity.com/
HELPURL         = https://www.tcl.tk/doc/

DESCRIPTION = "Tcl \(Tool Command Language\) is a very powerful but easy to learn dynamic programming language, suitable for a very wide range of uses, including web and desktop applications, networking, administration, testing and many more. Open source and business-friendly, Tcl is a mature yet evolving language that is truly cross platform, easily deployed and highly extensible."
RELOAD_UI = no
DISPLAY_NAME = Tcl
STARTABLE = no
CHANGELOG = "1. 64-bit support for x64 archs added.<br/>2. zlib compression fixed."

HOMEPAGE = https://www.tcl.tk
LICENSE = Tcl/Tk License

SPK_LINKS = /usr/local/bin/tclsh:bin/tclsh$(SPK_MAIN_VERS)

include ../../mk/spksrc.spk.mk
