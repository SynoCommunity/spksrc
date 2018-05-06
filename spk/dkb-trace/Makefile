SPK_NAME = dkb-trace
SPK_VERS = 2.2
SPK_REV = 0
SPK_ICON = src/dkb-trace.png
DSM_UI_DIR = app
BETA = 1

DEPENDS  = cross/$(SPK_NAME)

MAINTAINER = DigitalBox
MAINTAINER_URL = "https://digitalboxweb.wordpress.com/"

DESCRIPTION = "DKB-Trace RayTracer is a raytracing tool written by David K. Buck. This is the ancestor of POV-Ray and was written completely in C. It is a photo-realistic 3-D object rendering shader, suitable for realizing the output of CAD programs or generally wasting LOTS of CPU time drawing pretty pictures.  It features a command-line interface and reads plain text input files in an easy to use and understand structured scene description language.  It writes output files in several popular 24-bit image formats, including DKB/QRT Raw and Truevision Targa-24 formats. Original website : ftp://ftp.ccs.carleton.ca/pub/dkbtrace/dkb2.12/ . Synology port : https://digitalboxweb.wordpress.com/"
DISPLAY_NAME = DKB_Trace
CHANGELOG = Version 2.2 with web access

HOMEPAGE   = https://digitalboxweb.wordpress.com/
LICENSE    = 

WIZARDS_DIR = src/wizard/

ADMIN_URL = "dkb-trace"

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk

