SPK_NAME = tcl
SPK_VERS = 8.6.14
SPK_MAIN_VERS=$(word 1,$(subst ., ,$(SPK_VERS))).$(word 2,$(subst ., ,$(SPK_VERS)))
SPK_REV = 8
SPK_ICON = src/tcl.png

DEPENDS = cross/tcl

MAINTAINER      = Tcl developer Xchange
MAINTAINER_URL  = https://www.tcl.tk/
DISTRIBUTOR     = SynoCommunity
DISTRIBUTOR_URL = https://synocommunity.com/
HELPURL         = https://www.tcl.tk/doc/

DESCRIPTION = "Tcl \(Tool Command Language\) is a very powerful but easy to learn dynamic programming language, suitable for a very wide range of uses, including web and desktop applications, networking, administration, testing and many more. Open source and business-friendly, Tcl is a mature yet evolving language that is truly cross platform, easily deployed and highly extensible."
DISPLAY_NAME = Tcl
STARTABLE = no
CHANGELOG = "Update tcl to 8.6.14 released 2024-02-28."

HOMEPAGE = https://www.tcl.tk
LICENSE = Tcl/Tk License

SPK_COMMANDS = bin/tclsh bin/tclsh$(SPK_MAIN_VERS)

include ../../mk/spksrc.spk.mk
