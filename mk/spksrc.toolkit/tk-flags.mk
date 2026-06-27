###############################################################################
# spksrc.toolkit/tk-flags.mk
#
# Defines default toolkit path variables derived from the sysroot.
#
# This file:
#  - derives missing toolkit paths (binary, include, library) from TK_SYSROOT
#
# Variables:
#  TK_PATH         : Toolkit binary directory (relative to sysroot)
#  TK_INCLUDE      : Toolkit include directory (relative to sysroot)
#  TK_LIBRARY      : Toolkit library directory (relative to sysroot)
#
###############################################################################

ifeq ($(strip $(TK_PATH)),)
TK_PATH = $(TK_SYSROOT)/usr/bin
endif

ifeq ($(strip $(TK_INCLUDE)),)
TK_INCLUDE = $(TK_SYSROOT)/usr/include
endif

ifeq ($(strip $(TK_LIBRARY)),)
TK_LIBRARY = $(TK_SYSROOT)/usr/lib
endif
