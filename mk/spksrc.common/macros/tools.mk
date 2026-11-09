###############################################################################
# spksrc.common/macros/tools.mk
#
# Locating tools, and reading what a Makefile declares.
###############################################################################

# Macro: read a variable a Makefile declares
#
#   $(call read_makefile_var,$(TC_DIR)/Makefile,TC_TARGET)
#
# The value of VAR as the file assigns it (VAR = value, VAR := value, VAR ?= value), as
# raw text: a reference inside it is not expanded. Empty when the file or the line is absent.
read_makefile_var = $(shell sed -n 's/^$(2)[[:space:]]*[:?]*=[[:space:]]*//p' $(1) 2>/dev/null)

# Macro: locate a toolchain tool
#
#   $(call tc,gcc)   $(call tc,ar)   $(call tc,g++)
#
# Absolute path of a cross tool, honouring whichever overlay provides it. A package must
# not build that path itself: an overlay lives somewhere else entirely
# (<consumer>/work/install/usr/local/bin against the toolchain's <work>/<target>/bin) and
# the gcc family carries a version suffix there, so $(TC_PATH)$(TC_PREFIX)gcc silently
# resolves to the vendor compiler whenever an overlay is active.
#
# Falls back to TC_PATH, so the call is correct with no overlay and stays correct when one
# is grafted on -- nothing to revisit in the packages. TC_OVERLAY_<c>_PATH is set wherever the
# arch ships that overlay (spksrc.toolchain/tc_vars.mk), and taken only when it is ON.
#
# Needed by any build system that ignores CC/AR from the environment: ffmpeg takes its
# compilers from --cross-prefix, and a handful of packages pass CC=/AR= on a make line.
_tc_gcc_tools      = gcc g++ c++ cpp gfortran
_tc_binutils_tools = ld as ar nm ranlib strip objdump objcopy readelf

define tc
$(strip \
  $(if $(filter $(1),$(_tc_gcc_tools)),\
    $(or $(if $(_OVERLAY_GCC_ON),$(TC_OVERLAY_GCC_PATH)),$(TC_PATH))$(TC_PREFIX)$(1)$(TC_GCC_SUFFIX),\
  $(if $(filter $(1),$(_tc_binutils_tools)),\
    $(or $(if $(_OVERLAY_BINUTILS_ON),$(TC_OVERLAY_BINUTILS_PATH)),$(TC_PATH))$(TC_PREFIX)$(1),\
    $(TC_PATH)$(TC_PREFIX)$(1))))
endef

# Macro: locate a host tool -- the native counterpart of tc above
#
#   $(call native,gcc)   $(call native,ar)
#
# Absolute path of a tool on the BUILD host, or the bare name when it is absent, so a
# missing tool fails by its own name instead of as an empty command. command -v, not
# which: the former is a POSIX shell builtin, the latter an external binary.
native = $(or $(shell command -v $(1) 2>/dev/null),$(1))
