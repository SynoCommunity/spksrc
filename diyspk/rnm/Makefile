SPK_NAME = rnm
SPK_VERS = 4.0.9
SPK_REV = 1

DEPENDS = cross/rnm

MAINTAINER = SynoCommunity
DESCRIPTION = rnm renames files/directories in bulk. Naming scheme \(Name String\) can be applied or regex replace can be performed to modify file names on the fly. It uses PCRE2 \(revised version of PCRE\) regex to provide search \(and replace\) functionality.
STARTABLE = no

HOMEPAGE = https://neurobin.org/projects/softwares/unix/rnm/
LICENSE = GPL v3.0

SPK_COMMANDS = bin/rnm

include ../../mk/spksrc.spk.mk

ifeq ($(call version_lt, $(TC_GCC), 4.8.1),1)
UNSUPPORTED_ARCHS = $(ARCH)
endif
