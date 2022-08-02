include ../../cross/libapparmor/apparmor.info.mk

SPK_NAME = apparmor
SPK_VERS = $(AA_PKG_VERS)
SPK_REV = 1
SPK_ICON = src/apparmor-icon.png
BETA = 1

MAINTAINER = rbrownwsws
DESCRIPTION = Tools for interacting with the AppArmor linux kernel security module
STARTABLE = no
DISPLAY_NAME = AppArmor
CHANGELOG = "Initial version"

LICENSE  = GPLv2

UNSUPPORTED_ARCHS = $(AA_UNSUPPORTED_ARCHS)

# We need the libapparmor python binding
ENV += AA_BINDING_PYTHON=y

# Explicitly depend on python and libapparmor first to make sure do not
# accidentally build without the python binding when twiddling with deps later.
DEPENDS  = $(AA_PYTHON_PKG)
DEPENDS += cross/libapparmor

DEPENDS += cross/apparmor-utils
DEPENDS += cross/apparmor-binutils
DEPENDS += cross/apparmor-parser
DEPENDS += cross/apparmor-profiles

AA_BINUTILS_COMMANDS = bin/aa-enabled \
	bin/aa-exec \
	bin/aa-features-abi

AA_PARSER_COMMANDS = sbin/apparmor_parser

AA_UTILS_COMMANDS = bin/aa-easyprof \
	sbin/aa-audit \
	sbin/aa-autodep \
	sbin/aa-cleanprof \
	sbin/aa-complain \
	sbin/aa-decode \
	sbin/aa-disable \
	sbin/aa-enforce \
	sbin/aa-exec \
	sbin/aa-genprof \
	sbin/aa-logprof \
	sbin/aa-mergeprof \
	sbin/aa-notify \
	sbin/aa-remove-unknown \
	sbin/aa-status \
	sbin/aa-unconfined \
	sbin/apparmor_status

SPK_COMMANDS = $(AA_BINUTILS_COMMANDS) $(AA_PARSER_COMMANDS) $(AA_UTILS_COMMANDS) 

include ../../mk/spksrc.spk.mk

.PHONY: aa-clean
aa-clean: spkclean
	rm -rf $(PWD)/work*/apparmor*
	rm -f $(PWD)/work*/.libapparmor*
	rm -f $(PWD)/work*/.apparmor*
